import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:new_jcvital/core/auth/auth_session.dart';
import 'package:new_jcvital/core/auth/auth_token_store.dart';
import 'package:new_jcvital/core/config/app_config.dart';
import 'package:new_jcvital/core/localization/app_locale_controller.dart';
import 'package:new_jcvital/core/network/api_client.dart';
import 'package:new_jcvital/core/network/api_endpoints.dart';

class _TokenStorage implements AccessTokenStorage {
  String? value;
  int deletions = 0;
  bool failWrites = false;
  @override
  Future<String?> read() async => value;
  @override
  Future<void> write(String token) async {
    if (failWrites) throw StateError('write failed');
    value = token;
  }

  @override
  Future<void> delete() async {
    value = null;
    deletions++;
  }
}

void main() {
  setUp(() => AuthTokenStore.instance.clear());
  tearDown(() => AuthTokenStore.instance.clear());
  test('恢复原令牌并在请求时使用当前令牌与语言', () async {
    expect(AuthStorageKeys.accessToken, 'auth.access_token');
    final storage = _TokenStorage()..value = 'existing-session';
    final session = AuthSession(storage: storage);
    final language = AppLocaleController();
    addTearDown(session.dispose);
    addTearDown(language.dispose);
    await session.restore();
    final tokens = <String>[], languages = <String>[], urls = <String>[];
    final client = ApiClient.configured(
      config: AppConfig.resolve(defines: {'ENABLE_NETWORK_LOGS': 'false'}),
      session: session,
      locale: language,
      client: MockClient((request) async {
        tokens.add(request.headers['Authorization']!);
        languages.add(request.headers['Accept-Language']!);
        urls.add(request.url.toString());
        return http.Response('{"code":200,"data":{}}', 200);
      }),
    );
    addTearDown(client.close);
    await client.request('GET', ApiEndpoints.deviceList);
    await session.setAccessToken(' updated-session ');
    language.value = AppLocaleController.resolve(
      'zh',
      const Locale('pt', 'BR'),
    );
    await client.request('GET', '/me/devices');
    expect(tokens, ['Bearer existing-session', 'Bearer updated-session']);
    expect(languages, ['pt-BR', 'zh-CN']);
    expect(urls.toSet(), {'https://api.byndhealth.com.br/api/v1/me/devices'});
    expect(storage.value, 'updated-session');
  });
  test('401 清除对应会话，不把令牌放进匿名登录请求', () async {
    final storage = _TokenStorage();
    final session = AuthSession(storage: storage);
    addTearDown(session.dispose);
    await session.setAccessToken('session');
    final client = ApiClient.configured(
      config: AppConfig.resolve(defines: {'ENABLE_NETWORK_LOGS': 'false'}),
      session: session,
      client: MockClient((request) async {
        if (request.url.path == ApiEndpoints.authEmailCode) {
          expect(request.headers.containsKey('Authorization'), isFalse);
        }
        return http.Response('{}', 401);
      }),
    );
    addTearDown(client.close);
    await expectLater(
      client.request('POST', ApiEndpoints.authEmailCode, requiresAuth: false),
      throwsA(isA<ApiException>()),
    );
    expect(session.accessToken, 'session');
    expect(storage.deletions, 0);
    await expectLater(
      client.request('GET', ApiEndpoints.deviceList),
      throwsA(
        isA<ApiException>().having(
          (error) => error.code,
          'code',
          'authentication_required',
        ),
      ),
    );
    expect(session.accessToken, isNull);
    expect(storage.value, isNull);
  });
  test('旧请求迟到的 401 不会清除刚登录的新会话', () async {
    final storage = _TokenStorage();
    final session = AuthSession(storage: storage);
    addTearDown(session.dispose);
    await session.setAccessToken('old-session');
    final sent = Completer<void>(), response = Completer<http.Response>();
    final client = ApiClient.configured(
      config: AppConfig.resolve(defines: {'ENABLE_NETWORK_LOGS': 'false'}),
      session: session,
      client: MockClient((request) {
        sent.complete();
        return response.future;
      }),
    );
    addTearDown(client.close);
    final pending = client.request('GET', ApiEndpoints.deviceList);
    final assertion = expectLater(pending, throwsA(isA<ApiException>()));
    await sent.future;
    await session.setAccessToken('new-session');
    response.complete(http.Response('{}', 401));
    await assertion;
    expect(session.accessToken, 'new-session');
    expect(storage.value, 'new-session');
    expect(storage.deletions, 0);
  });
  test('持久化失败不会发布一个无法恢复的新会话', () async {
    final storage = _TokenStorage();
    final session = AuthSession(storage: storage);
    addTearDown(session.dispose);
    await session.setAccessToken('previous');
    storage.failWrites = true;
    await expectLater(session.setAccessToken('not-saved'), throwsStateError);
    expect(session.accessToken, 'previous');
    expect(storage.value, 'previous');
  });
}
