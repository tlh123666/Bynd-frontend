import 'dart:convert';

/// 登录后拿到的凭据集合。
///
/// 字段与后端 `dto.LoginData` / `jwt.TokenPair` 一致。到期时间是**秒**级
/// Unix 时间戳（后端用 `time.Unix()` 生成），不是毫秒——按毫秒解析会得到
/// 一个几万年后才过期的 token，于是永远不刷新、也永远不提示重新登录。
class AuthTokens {
  const AuthTokens({
    required this.userId,
    required this.email,
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.accessTokenExpiresAt,
    required this.refreshTokenExpiresAt,
  });

  final String userId;
  final String email;
  final String accessToken;

  /// 后端会下发 refreshToken，但**没有对应的刷新接口**
  /// （`internal/module/auth/route/routes.go` 只有 email/code、email/login、google）。
  /// 先原样保存，等后端补上 /auth/refresh 再用；在那之前不要拿它做任何事。
  final String refreshToken;

  final String tokenType;

  /// 秒级 Unix 时间戳。
  final int accessTokenExpiresAt;

  /// 秒级 Unix 时间戳。
  final int refreshTokenExpiresAt;

  /// 提前量：临界点上的 token 发出去大概率已经过期，换来一次 401 与被登出。
  static const Duration expirySkew = Duration(seconds: 60);

  bool isAccessTokenExpired(DateTime now) {
    if (accessTokenExpiresAt <= 0 || accessTokenExpiresAt > 8640000000000) {
      return true;
    }
    final expiresAt = DateTime.fromMillisecondsSinceEpoch(
      accessTokenExpiresAt * 1000,
      isUtc: true,
    );
    return !now.toUtc().add(expirySkew).isBefore(expiresAt);
  }

  factory AuthTokens.fromLoginData(Map<String, dynamic> json) {
    return AuthTokens(
      userId: _requireString(json, 'userId'),
      email: _requireString(json, 'email'),
      accessToken: _requireString(json, 'accessToken'),
      refreshToken: _stringOrEmpty(json['refreshToken']),
      tokenType: _stringOrEmpty(json['tokenType'], fallback: 'Bearer'),
      accessTokenExpiresAt: _requireInt(json, 'accessTokenExpiresAt'),
      refreshTokenExpiresAt: _intOrZero(json['refreshTokenExpiresAt']),
    );
  }

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'email': email,
    'accessToken': accessToken,
    'refreshToken': refreshToken,
    'tokenType': tokenType,
    'accessTokenExpiresAt': accessTokenExpiresAt,
    'refreshTokenExpiresAt': refreshTokenExpiresAt,
  };

  factory AuthTokens.fromJson(Map<String, dynamic> json) => AuthTokens(
    userId: _requireString(json, 'userId'),
    email: _stringOrEmpty(json['email']),
    accessToken: _requireString(json, 'accessToken'),
    refreshToken: _stringOrEmpty(json['refreshToken']),
    tokenType: _stringOrEmpty(json['tokenType'], fallback: 'Bearer'),
    accessTokenExpiresAt: _requireInt(json, 'accessTokenExpiresAt'),
    refreshTokenExpiresAt: _intOrZero(json['refreshTokenExpiresAt']),
  );

  /// Legacy JCVital stores only the JWT and profile hints. Decoding these claims
  /// supplies routing metadata, never signature verification or authorization.
  static AuthTokens? fromLegacyToken(String token, {String email = ''}) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;
      final payload =
          jsonDecode(
                utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
              )
              as Map<String, dynamic>;
      final id = payload['uid'];
      final expiry = payload['exp'];
      if (id is! String ||
          id.isEmpty ||
          expiry is! int ||
          expiry <= 0 ||
          payload['typ'] != 'access' ||
          payload['sub'] != 'user:$id') {
        return null;
      }
      return AuthTokens(
        userId: id,
        email: email,
        accessToken: token,
        refreshToken: '',
        tokenType: 'Bearer',
        accessTokenExpiresAt: expiry,
        refreshTokenExpiresAt: 0,
      );
    } catch (_) {
      return null;
    }
  }

  static String _requireString(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is String && value.isNotEmpty) return value;
    throw FormatException('campo "$key" ausente ou vazio');
  }

  static int _requireInt(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is int) return value;
    if (value is num) return value.toInt();
    throw FormatException('campo "$key" ausente');
  }

  static String _stringOrEmpty(dynamic value, {String fallback = ''}) =>
      value is String && value.isNotEmpty ? value : fallback;

  static int _intOrZero(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return 0;
  }
}
