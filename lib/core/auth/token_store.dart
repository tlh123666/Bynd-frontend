import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'auth_tokens.dart';

/// 凭据的持久化。
///
/// 抽成接口而不是直接调 [FlutterSecureStorage]：单元测试跑在 Dart VM 上，
/// 没有 Keychain / Keystore，直接用插件会让所有会话相关测试必须起 widget 环境。
/// 测试里换成内存实现即可，生产实现只有一份。
abstract interface class TokenStore {
  Future<AuthTokens?> read();

  Future<void> write(AuthTokens tokens);

  Future<void> clear();
}

/// 写入系统安全存储（iOS Keychain / Android Keystore）。
///
/// 不用 shared_preferences：那是明文 XML/plist，root 或备份提取即可读到
/// 有效期 7 天的访问令牌。健康类应用拿它当存储方案过不了 LGPD 的数据安全要求。
class SecureTokenStore implements TokenStore {
  SecureTokenStore({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  /// 带应用前缀，避免与同设备上其它使用默认 keychain 的应用重名。
  static const String storageKey = 'br.com.byndhealth.auth.tokens';

  @override
  Future<AuthTokens?> read() async {
    final raw = await _storage.read(key: storageKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return null;
      return AuthTokens.fromJson(decoded.cast<String, dynamic>());
    } on FormatException {
      // 旧版本写入的结构可能缺字段。宁可当成未登录，也不要把半份凭据
      // 拿去发请求——那会得到一串 401，用户看到的是「莫名被登出」。
      await clear();
      return null;
    }
  }

  @override
  Future<void> write(AuthTokens tokens) {
    return _storage.write(key: storageKey, value: jsonEncode(tokens.toJson()));
  }

  @override
  Future<void> clear() => _storage.delete(key: storageKey);
}
