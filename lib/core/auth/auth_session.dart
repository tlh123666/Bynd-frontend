import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'auth_token_store.dart';

abstract interface class AccessTokenStorage {
  Future<String?> read();
  Future<void> write(String token);
  Future<void> delete();
}

class SecureAccessTokenStorage implements AccessTokenStorage {
  const SecureAccessTokenStorage({this.storage = const FlutterSecureStorage()});
  final FlutterSecureStorage storage;
  @override
  Future<String?> read() => storage.read(key: AuthStorageKeys.accessToken);
  @override
  Future<void> write(String token) =>
      storage.write(key: AuthStorageKeys.accessToken, value: token);
  @override
  Future<void> delete() => storage.delete(key: AuthStorageKeys.accessToken);
}

/// Serializes persistence so a late 401 cannot erase a newer login session.
class AuthSession extends ChangeNotifier {
  AuthSession({AccessTokenStorage? storage, AuthTokenStore? tokens})
    : _storage = storage ?? const SecureAccessTokenStorage(),
      _tokens = tokens ?? AuthTokenStore.instance;
  static final instance = AuthSession();
  final AccessTokenStorage _storage;
  final AuthTokenStore _tokens;
  Future<void> _pending = Future.value();
  String? get accessToken => _tokens.accessToken;
  bool get isAuthenticated => accessToken != null;

  Future<void> _mutate(Future<void> Function() action) {
    final result = _pending.then((_) => action());
    _pending = result.catchError((Object _) {});
    return result;
  }

  Future<void> restore() => _mutate(() async {
    _tokens.setAccessToken(await _storage.read());
    notifyListeners();
  });
  Future<void> setAccessToken(String token) => _mutate(() async {
    final normalized = token.trim();
    if (normalized.isEmpty) {
      throw ArgumentError('Access token must not be empty');
    }
    await _storage.write(normalized);
    _tokens.setAccessToken(normalized);
    notifyListeners();
  });
  Future<void> signOut() => _mutate(() async {
    _tokens.clear();
    notifyListeners();
    await _storage.delete();
  });
  Future<void> invalidate(String rejectedToken) => _mutate(() async {
    if (accessToken != rejectedToken) return;
    _tokens.clear();
    notifyListeners();
    await _storage.delete();
  });
}
