import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../core/auth/auth_controller.dart';
import '../../../core/network/api_client.dart';

enum LoginStep { email, code }

enum LoginFailure {
  email,
  code,
  expired,
  rejected,
  consent,
  connection,
  rateLimited,
  storage,
  google,
  server,
}

class LoginController extends ChangeNotifier {
  LoginController(this.auth, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;
  final AuthController auth;
  final DateTime Function() _clock;
  LoginStep step = LoginStep.email;
  String email = '';
  bool newUser = false, busy = false;
  LoginFailure? failure;
  final Map<String, DateTime> _resendDeadlines = {};
  DateTime? _expiry;
  Timer? _timer;
  bool _disposed = false;
  int _revision = 0;
  int get resendSeconds =>
      ((_resendDeadlines[email]?.difference(_clock()).inMilliseconds ?? 0) /
              1000)
          .ceil()
          .clamp(0, 3600);
  bool get codeExpired => _expiry != null && !_clock().isBefore(_expiry!);
  bool get supportsGoogle => auth.supportsGoogle;
  static bool validEmail(String value) =>
      value.trim().length <= 255 &&
      RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value.trim());
  static bool validCode(String value) => RegExp(r'^\d{6}$').hasMatch(value);
  void clearError() {
    if (failure != null) {
      failure = null;
      _emit();
    }
  }

  void editEmail() {
    if (busy) return;
    _revision++;
    step = LoginStep.email;
    failure = null;
    newUser = false;
    _expiry = null;
    _emit();
  }

  Future<bool> sendCode(String address) async {
    if (busy) return false;
    final normalized = address.trim().toLowerCase();
    if (!validEmail(normalized)) {
      failure = LoginFailure.email;
      _emit();
      return false;
    }
    email = normalized;
    if (resendSeconds > 0) {
      failure = LoginFailure.rateLimited;
      _emit();
      return false;
    }
    final revision = ++_revision;
    busy = true;
    failure = null;
    _emit();
    try {
      final result = await auth.requestEmailCode(email);
      if (!_current(revision)) return false;
      if (result.expiresIn <= 0) {
        throw const ApiException(
          'Invalid code expiry',
          code: 'invalid_response',
        );
      }
      newUser = result.newUser;
      step = LoginStep.code;
      _expiry = _clock().add(Duration(seconds: result.expiresIn));
      _resendDeadlines[email] = _clock().add(const Duration(seconds: 60));
      _startTimer();
      return true;
    } catch (error) {
      if (_current(revision)) {
        failure = _failure(error);
        if (failure == LoginFailure.rateLimited) {
          _resendDeadlines[email] = _clock().add(
            error is ApiException
                ? (error.retryAfter ?? const Duration(seconds: 60))
                : const Duration(seconds: 60),
          );
          _startTimer();
        }
      }
      return false;
    } finally {
      if (_current(revision)) {
        busy = false;
        _emit();
      }
    }
  }

  Future<void> verify(String code, {required bool consent}) async {
    if (busy || step != LoginStep.code) return;
    if (!validCode(code)) {
      failure = LoginFailure.code;
      _emit();
      return;
    }
    if (codeExpired) {
      failure = LoginFailure.expired;
      _emit();
      return;
    }
    if (newUser && !consent) {
      failure = LoginFailure.consent;
      _emit();
      return;
    }
    final revision = ++_revision;
    busy = true;
    failure = null;
    _emit();
    try {
      await auth.loginWithEmailCode(
        email: email,
        code: code,
        consent: newUser && consent,
      );
      _timer?.cancel();
    } catch (error) {
      if (_current(revision)) {
        failure = _failure(error, verifying: true);
      }
    } finally {
      if (_current(revision)) {
        busy = false;
        _emit();
      }
    }
  }

  Future<void> googleSignIn() async {
    if (busy) return;
    final revision = ++_revision;
    busy = true;
    failure = null;
    _emit();
    try {
      await auth.loginWithGoogle(consent: true);
    } catch (error) {
      if (_current(revision)) {
        failure = error is ApiException && error.code.startsWith('google_')
            ? LoginFailure.google
            : _failure(error);
      }
    } finally {
      if (_current(revision)) {
        busy = false;
        _emit();
      }
    }
  }

  LoginFailure _failure(Object error, {bool verifying = false}) {
    if (error is! ApiException) {
      return error is FormatException
          ? LoginFailure.server
          : LoginFailure.storage;
    }
    if (error.code == 'network_error' || error.code == 'request_timeout') {
      return LoginFailure.connection;
    }
    if (error.statusCode == 429) return LoginFailure.rateLimited;
    if (verifying && (error.statusCode == 400 || error.statusCode == 401)) {
      return LoginFailure.rejected;
    }
    return LoginFailure.server;
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_disposed) return;
      if (resendSeconds == 0 && (_expiry == null || codeExpired)) {
        _timer?.cancel();
      }
      _emit();
    });
  }

  bool _current(int revision) => !_disposed && revision == _revision;
  void _emit() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    if (_disposed) return;
    _disposed = true;
    _revision++;
    _timer?.cancel();
    super.dispose();
  }
}
