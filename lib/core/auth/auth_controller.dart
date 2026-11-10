import 'dart:async';
import 'package:flutter/foundation.dart';
import '../network/api_client.dart';
import 'auth_api.dart';
import 'auth_session.dart';
import 'auth_tokens.dart';
import 'token_store.dart';
import 'google_identity.dart';

enum AuthStatus { restoring, anonymous, authenticated }

enum AuthExitReason { none, signedOut, expired, unauthorized }

/// Owns session publication, secure persistence and navigation revision. A late
/// restore, login or rejected request cannot restore a signed-out account.
class AuthController extends ChangeNotifier {
  AuthController({
    required AuthApi api,
    required TokenStore store,
    AuthSession? session,
    DateTime Function()? clock,
    GoogleIdentity? google,
  }) : this._(
         api,
         store,
         session ?? AuthSession.instance,
         clock ?? DateTime.now,
         google,
       );

  AuthController._(
    this._api,
    this._store,
    this._session,
    this._clock,
    this.google,
  ) {
    _observedToken = _session.accessToken;
    _session.addListener(_sessionChanged);
  }
  final AuthApi _api;
  final TokenStore _store;
  final AuthSession _session;
  final DateTime Function() _clock;
  final GoogleIdentity? google;
  AuthTokens? _tokens;
  AuthStatus _status = AuthStatus.restoring;
  AuthExitReason exitReason = AuthExitReason.none;
  bool _disposed = false, _expectedClear = false;
  String? _observedToken, _expectedToken;
  int _epoch = 0, sessionRevision = 0;
  Timer? _expiryTimer;
  Future<void>? _restoring;
  Future<void> _pending = Future.value();
  AuthStatus get status => _status;
  AuthTokens? get tokens => _tokens;
  String? get email => _tokens?.email;
  String? get userId => _tokens?.userId;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get supportsGoogle => google?.supported ?? false;
  bool get didSignOut => exitReason != AuthExitReason.none;
  String? get accessToken =>
      _tokens == null || _tokens!.isAccessTokenExpired(_clock())
      ? null
      : _tokens!.accessToken;

  Future<void> _serialize(Future<void> Function() work) {
    final future = _pending.then((_) => work());
    _pending = future.catchError((Object _) {});
    return future;
  }

  bool _current(int epoch) => !_disposed && epoch == _epoch;
  Future<void> restore() => _restoring ??= _restore();
  Future<void> _restore() async {
    final epoch = _epoch;
    AuthTokens? stored;
    try {
      stored = await _store.read();
    } catch (_) {
      stored = null;
    }
    if (!_current(epoch)) return;
    if (stored == null || stored.isAccessTokenExpired(_clock())) {
      await _serialize(() async {
        if (!_current(epoch)) return;
        await _safeClear();
        await _clearSession();
      });
      if (_current(epoch)) {
        _tokens = null;
        _setStatus(AuthStatus.anonymous);
      }
      return;
    }
    try {
      await _commit(stored, epoch);
    } catch (_) {
      if (_current(epoch)) {
        _tokens = null;
        _setStatus(AuthStatus.anonymous);
      }
    }
  }

  Future<EmailCodeResult> requestEmailCode(String email) =>
      _api.requestEmailCode(email.trim().toLowerCase());
  Future<void> loginWithEmailCode({
    required String email,
    required String code,
    required bool consent,
  }) async {
    final epoch = ++_epoch;
    final result = await _api.loginWithEmailCode(
      email: email.trim().toLowerCase(),
      code: code.trim(),
      consent: consent,
    );
    if (!_current(epoch)) {
      throw const ApiException('Sign-in cancelled', code: 'request_cancelled');
    }
    await _commit(result, epoch);
  }

  Future<bool> loginWithGoogle({required bool consent}) async {
    if (!supportsGoogle) {
      throw const ApiException(
        'Google unavailable',
        code: 'google_unavailable',
      );
    }
    final epoch = ++_epoch;
    final idToken = await google!.getIdToken();
    if (idToken == null) return false;
    if (!_current(epoch)) {
      throw const ApiException('Sign-in cancelled', code: 'request_cancelled');
    }
    final result = await _api.loginWithGoogle(
      idToken: idToken,
      consent: consent,
    );
    if (!_current(epoch)) {
      throw const ApiException('Sign-in cancelled', code: 'request_cancelled');
    }
    await _commit(result, epoch);
    return true;
  }

  Future<void> _commit(AuthTokens tokens, int epoch) => _serialize(() async {
    if (!_current(epoch)) return;
    if (tokens.isAccessTokenExpired(_clock())) {
      throw const ApiException(
        'Expired login response',
        code: 'invalid_response',
      );
    }
    final previous = _tokens;
    try {
      await _store.write(tokens);
      if (!_current(epoch)) return;
      _expectedToken = tokens.accessToken;
      await _session.setAccessToken(tokens.accessToken);
      if (!_current(epoch)) return;
      _tokens = tokens;
      exitReason = AuthExitReason.none;
      _scheduleExpiry(tokens);
      _setStatus(AuthStatus.authenticated, force: true);
    } catch (_) {
      if (_current(epoch)) {
        try {
          if (previous != null) {
            await _store.write(previous);
          } else {
            await _safeClear();
          }
        } catch (_) {}
      }
      rethrow;
    } finally {
      _expectedToken = null;
    }
  });
  void _scheduleExpiry(AuthTokens tokens) {
    _expiryTimer?.cancel();
    final remaining = DateTime.fromMillisecondsSinceEpoch(
      tokens.accessTokenExpiresAt * 1000,
      isUtc: true,
    ).subtract(AuthTokens.expirySkew).difference(_clock().toUtc());
    _expiryTimer = Timer(remaining.isNegative ? Duration.zero : remaining, () {
      unawaited(_endSession(AuthExitReason.expired));
    });
  }

  Future<void> logout() => _endSession(AuthExitReason.signedOut);
  Future<void> _endSession(AuthExitReason reason) async {
    final epoch = ++_epoch;
    _expiryTimer?.cancel();
    _tokens = null;
    exitReason = reason;
    _setStatus(AuthStatus.anonymous, force: true);
    await _serialize(() async {
      if (!_current(epoch)) return;
      await _safeClear();
      await _clearSession();
    });
    try {
      if (_current(epoch)) await google?.signOut();
    } catch (_) {}
  }

  void _sessionChanged() {
    final token = _session.accessToken;
    final previous = _observedToken;
    _observedToken = token;
    if (token == previous ||
        (_expectedClear && token == null) ||
        (token != null && token == _expectedToken)) {
      return;
    }
    if ((_status == AuthStatus.authenticated &&
            token != _tokens?.accessToken) ||
        (previous != null && token == null)) {
      final epoch = ++_epoch;
      _tokens = null;
      _expiryTimer?.cancel();
      exitReason = AuthExitReason.unauthorized;
      _setStatus(AuthStatus.anonymous, force: true);
      unawaited(
        _serialize(() async {
          if (_current(epoch)) await _safeClear();
        }),
      );
    }
  }

  void handleUnauthorized() {
    if (_status == AuthStatus.restoring && _tokens == null) return;
    unawaited(_endSession(AuthExitReason.unauthorized));
  }

  Future<void> _clearSession() async {
    _expectedClear = true;
    try {
      await _session.signOut();
    } catch (_) {
      if (kDebugMode) debugPrint('BYND: secure session cleanup unavailable.');
    } finally {
      _expectedClear = false;
    }
  }

  Future<void> _safeClear() async {
    try {
      await _store.clear();
    } catch (_) {
      if (kDebugMode) debugPrint('BYND: secure session cleanup unavailable.');
    }
  }

  void _setStatus(AuthStatus value, {bool force = false}) {
    if (_disposed || (_status == value && !force)) return;
    _status = value;
    sessionRevision++;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _epoch++;
    _expiryTimer?.cancel();
    _session.removeListener(_sessionChanged);
    _api.close();
    super.dispose();
  }
}
