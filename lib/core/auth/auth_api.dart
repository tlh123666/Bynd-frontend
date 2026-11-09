import '../network/api_client.dart';
import '../network/api_endpoints.dart';
import 'auth_tokens.dart';

/// 请求验证码的结果。
class EmailCodeResult {
  const EmailCodeResult({required this.expiresIn, required this.newUser});

  /// 验证码有效期（秒）。
  final int expiresIn;

  /// 该邮箱还没有账户。
  ///
  /// 为 true 时界面必须先让用户勾选健康数据处理同意（LGPD），否则后端会拒掉
  /// 登录：`consent` 只在新账户创建时强制，且服务端不看默认值。
  final bool newUser;
}

/// 认证接口的薄封装：只负责 HTTP 与字段解析，不持有状态。
///
/// 令牌持久化统一走 [AuthSession]（与设备模块共用同一份 accessToken），
/// 状态在 AuthController。登录失败不会污染已登录会话，测试也能单独验接口层。
class AuthApi {
  AuthApi(this._client);

  final ApiClient _client;

  /// 两个登录入口都是公开接口，必须显式 `requiresAuth: false`：
  /// ApiClient 默认带令牌，登录时还没有令牌，否则会直接抛
  /// authentication_required。
  Future<EmailCodeResult> requestEmailCode(String email) async {
    final data = await _client.request(
      'POST',
      ApiEndpoints.authEmailCode,
      body: {'email': email},
      requiresAuth: false,
    );
    if (data.isEmpty) {
      throw const FormatException('email/code sem payload');
    }
    return EmailCodeResult(
      expiresIn: _asInt(data['expiresIn']) ?? 0,
      newUser: data['newUser'] == true,
    );
  }

  Future<AuthTokens> loginWithEmailCode({
    required String email,
    required String code,
    required bool consent,
  }) async {
    final data = await _client.request(
      'POST',
      ApiEndpoints.authEmailLogin,
      body: {
        'email': email,
        'code': code,
        // 必传：后端用 bool 零值判断，不传等同于「未同意」。
        // 已有账户不校验该字段，所以重复登录时传 true 也无副作用。
        'consent': consent,
      },
      requiresAuth: false,
    );
    if (data.isEmpty) {
      throw const FormatException('email/login sem payload');
    }
    return AuthTokens.fromLoginData(data);
  }

  static int? _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}
