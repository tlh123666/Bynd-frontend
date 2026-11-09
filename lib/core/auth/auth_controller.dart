import 'dart:async';

import 'package:flutter/foundation.dart';

import 'auth_api.dart';
import 'auth_session.dart';
import 'auth_tokens.dart';
import 'token_store.dart';

enum AuthStatus {
  /// 还没读完本地凭据。首屏在这一状态下发请求会拿不到令牌，
  /// 所以启动时应该等 [AuthController.restore] 完成再决定显示登录页还是主页。
  restoring,

  anonymous,
  authenticated,
}

/// 会话状态。
///
/// 令牌同时存在三个地方，职责不同：
/// - 内存里的 [_tokens]：会话元数据（email / userId / 过期判断），同步读；
/// - [TokenStore]：冷启动时恢复完整凭据；
/// - [AuthSession]：全应用共享的 accessToken（ApiClient 与设备模块都读它）。
///
/// [AuthSession] 必须同步：远端 ApiClient 只认它，只写 TokenStore 的话
/// 登录成功但所有请求仍然不带令牌，表现成「登录后立刻 401 被登出」。
///
/// 没有 refresh 流程可写：后端只签发不刷新（见 [AuthTokens.refreshToken] 注释）。
/// 令牌过期唯一的出路是让用户重新走一次邮箱验证码，因此 [handleUnauthorized]
/// 直接结束会话，而不是尝试续期。
class AuthController extends ChangeNotifier {
  /// 依赖保持私有：外部只该通过这个控制器读写会话，不该拿它内部的
  /// api 去发请求（那会绕开会话失效处理）。
  AuthController({
    required AuthApi api,
    required TokenStore store,
    AuthSession? session,
    DateTime Function()? clock,
  }) : this._(
         api,
         store,
         session ?? AuthSession.instance,
         clock ?? DateTime.now,
       );

  AuthController._(this._api, this._store, this._session, this._clock);

  final AuthApi _api;
  final TokenStore _store;
  final AuthSession _session;
  final DateTime Function() _clock;

  AuthTokens? _tokens;
  AuthStatus _status = AuthStatus.restoring;
  bool _disposed = false;

  AuthStatus get status => _status;
  AuthTokens? get tokens => _tokens;
  String? get email => _tokens?.email;
  String? get userId => _tokens?.userId;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  /// 供 [ApiClient] 的拦截器同步读取。未登录或已过期时返回 null——
  /// 过期后继续带旧令牌只会换来 401，不如不带头，让后端直接判未授权。
  String? get accessToken {
    final tokens = _tokens;
    if (tokens == null) return null;
    if (tokens.isAccessTokenExpired(_clock())) return null;
    return tokens.accessToken;
  }

  /// 从安全存储恢复会话。启动时调用一次。
  Future<void> restore() async {
    AuthTokens? stored;
    try {
      stored = await _store.read();
    } catch (error, stack) {
      // 钥匙串读不出来（设备无锁屏、系统升级后 keychain 失效等）不应该让
      // 应用起不来。降级为未登录，用户重新登录即可。
      _logRestoreFailure(error, stack);
      stored = null;
    }

    if (stored != null && stored.isAccessTokenExpired(_clock())) {
      // 已过期就直接清掉，别留一份用不了的凭据在设备上。
      await _safeClear();
      stored = null;
    }

    _tokens = stored;
    if (stored != null) {
      // 同步给 AuthSession：ApiClient 只读它。不写的话冷启动后第一个请求
      // 就不带 Authorization，用户会莫名被判未授权。
      await _session.setAccessToken(stored.accessToken);
    }
    _setStatus(
      stored == null ? AuthStatus.anonymous : AuthStatus.authenticated,
    );
  }

  Future<EmailCodeResult> requestEmailCode(String email) {
    return _api.requestEmailCode(email.trim());
  }

  /// 验证码登录。成功后立即写入内存与安全存储，并广播状态变化。
  ///
  /// 失败时抛出 `ApiException`，且**不改变当前会话**：登录页的错误提示
  /// 不该把已经登录的用户踢下线（例如设置页里重新验证邮箱的场景）。
  Future<void> loginWithEmailCode({
    required String email,
    required String code,
    required bool consent,
  }) async {
    final tokens = await _api.loginWithEmailCode(
      email: email.trim(),
      code: code.trim(),
      consent: consent,
    );
    _tokens = tokens;
    await _store.write(tokens);
    // 先落 AuthSession 再置状态：界面切到已登录后马上就会发请求，
    // 那时令牌必须已经可读。
    await _session.setAccessToken(tokens.accessToken);
    _setStatus(AuthStatus.authenticated);
  }

  Future<void> logout() async {
    _tokens = null;
    _setStatus(AuthStatus.anonymous);
    await _safeClear();
    await _session.signOut();
  }

  /// 收到 401 时的处理入口，由拦截器调用。
  ///
  /// 必须同步、幂等：一次首屏并发会同时收到多个 401，若每个都触发跳转，
  /// 用户会看到登录页被反复压栈。已经处于匿名状态时直接返回即可。
  void handleUnauthorized() {
    if (_status == AuthStatus.anonymous) return;
    // 启动恢复还没完成时收到的 401 不能算会话失效：那时还没有令牌，
    // 发出去的请求本来就不会带 Authorization 头。
    if (_status == AuthStatus.restoring && _tokens == null) return;

    _tokens = null;
    _setStatus(AuthStatus.anonymous);
    // 存储清理是异步的，但不该阻塞调用方（它在 ApiClient 的 401 分支里）。
    _safeClear();
    unawaited(_session.signOut());
  }

  void _setStatus(AuthStatus status) {
    if (_status == status) return;
    _status = status;
    if (!_disposed) notifyListeners();
  }

  Future<void> _safeClear() async {
    try {
      await _store.clear();
    } catch (error, stack) {
      _logRestoreFailure(error, stack);
    }
  }

  void _logRestoreFailure(Object error, StackTrace stack) {
    if (kDebugMode) {
      debugPrint('AuthController: falha ao acessar o armazenamento seguro: $error');
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
