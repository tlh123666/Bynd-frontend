/// Same in-memory token bridge used by the original JCVital API client.
class AuthTokenStore {
  AuthTokenStore._();
  static final instance = AuthTokenStore._();
  String? _accessToken;
  String? get accessToken => _accessToken;
  void setAccessToken(String? value) {
    final token = value?.trim();
    _accessToken = token == null || token.isEmpty ? null : token;
  }

  void clear() => _accessToken = null;
}

abstract final class AuthStorageKeys {
  static const accessToken = 'auth.access_token';
  static const userId = 'auth.user_id';
  static const userPhone = 'auth.user_phone';
  static const userEmail = 'auth.user_email';
  static const userNickname = 'auth.user_nickname';
  static const userAvatar = 'auth.user_avatar_url';
  static const locale = 'app_locale';
}
