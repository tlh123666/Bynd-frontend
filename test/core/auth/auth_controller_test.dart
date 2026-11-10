import 'dart:async';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:new_jcvital/core/auth/auth_controller.dart';
import 'package:new_jcvital/core/auth/auth_token_store.dart';
import 'package:new_jcvital/core/auth/auth_tokens.dart';
import 'package:new_jcvital/core/auth/token_store.dart';
import 'package:new_jcvital/core/network/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../support/auth_fakes.dart';

void main() {
  setUp(() {
    AuthTokenStore.instance.clear();
    SharedPreferences.setMockInitialValues({});
  });
  tearDown(() => AuthTokenStore.instance.clear());
  test(
    'email code and login use public endpoints and publish persisted session',
    () async {
      final h = AuthHarness();
      addTearDown(h.dispose);
      await h.auth.restore();
      await h.auth.requestEmailCode(' PERSON@Example.test ');
      await h.auth.loginWithEmailCode(
        email: ' PERSON@Example.test ',
        code: '123456',
        consent: true,
      );
      expect(h.requests.map((r) => r.url.path), [
        '/api/v1/auth/email/code',
        '/api/v1/auth/email/login',
      ]);
      expect(
        h.requests.every((r) => !r.headers.containsKey('Authorization')),
        isTrue,
      );
      expect(jsonDecode(h.requests.last.body), {
        'email': 'person@example.test',
        'code': '123456',
        'consent': true,
      });
      expect(h.auth.status, AuthStatus.authenticated);
      expect(h.store.value?.accessToken, 'access-a');
      expect(h.session.accessToken, 'access-a');
      expect(h.access.value, 'access-a');
    },
  );
  test('slow restoration cannot replace a more recent login', () async {
    final h = AuthHarness();
    addTearDown(h.dispose);
    h.store.reading = Completer<AuthTokens?>();
    final restoring = h.auth.restore();
    await h.auth.loginWithEmailCode(
      email: 'person@example.test',
      code: '123456',
      consent: false,
    );
    h.store.reading!.complete(loginTokens(token: 'old-session'));
    await restoring;
    expect(h.auth.accessToken, 'access-a');
    expect(h.store.value?.accessToken, 'access-a');
  });
  test(
    'logout prevents a delayed login response from restoring credentials',
    () async {
      final pending = Completer<http.Response>();
      final h = AuthHarness(handler: (_) => pending.future);
      addTearDown(h.dispose);
      await h.auth.restore();
      final loggingIn = h.auth.loginWithEmailCode(
        email: 'person@example.test',
        code: '123456',
        consent: false,
      );
      final rejected = expectLater(
        loggingIn,
        throwsA(
          isA<ApiException>().having(
            (e) => e.code,
            'code',
            'request_cancelled',
          ),
        ),
      );
      await h.auth.logout();
      pending.complete(response(loginTokens().toJson()));
      await rejected;
      expect(h.auth.isAuthenticated, isFalse);
      expect(h.store.value, isNull);
      expect(h.session.accessToken, isNull);
    },
  );
  test('secure write failure never publishes a successful login', () async {
    final h = AuthHarness();
    addTearDown(h.dispose);
    await h.auth.restore();
    h.access.failWrite = true;
    await expectLater(
      h.auth.loginWithEmailCode(
        email: 'person@example.test',
        code: '123456',
        consent: false,
      ),
      throwsStateError,
    );
    expect(h.auth.isAuthenticated, isFalse);
    expect(h.auth.tokens, isNull);
    expect(h.store.value, isNull);
    expect(h.session.accessToken, isNull);
  });
  test(
    '401 from public login preserves session; protected 401 clears all metadata',
    () async {
      final h = AuthHarness(
        handler: (_) => Future.value(response({}, status: 401, code: 100002)),
      );
      addTearDown(h.dispose);
      h.store.value = loginTokens();
      await h.auth.restore();
      await expectLater(
        h.client.request('POST', '/auth/email/login', requiresAuth: false),
        throwsA(
          isA<ApiException>().having((e) => e.serverCode, 'serverCode', 100002),
        ),
      );
      expect(h.auth.isAuthenticated, isTrue);
      await expectLater(
        h.client.request('GET', '/me/profile'),
        throwsA(isA<ApiException>()),
      );
      await Future<void>.delayed(Duration.zero);
      expect(h.auth.status, AuthStatus.anonymous);
      expect(h.store.value, isNull);
      expect(h.session.accessToken, isNull);
    },
  );
  test(
    'Google sends provider ID token and explicit consent; cancellation writes nothing',
    () async {
      final google = FakeGoogleIdentity();
      final h = AuthHarness(google: google);
      addTearDown(h.dispose);
      await h.auth.restore();
      expect(await h.auth.loginWithGoogle(consent: true), isTrue);
      expect(h.requests.single.url.path, '/api/v1/auth/google');
      expect(jsonDecode(h.requests.single.body), {
        'idToken': 'google-id-token',
        'consent': true,
      });
      await h.auth.logout();
      google.token = null;
      expect(await h.auth.loginWithGoogle(consent: true), isFalse);
      expect(h.store.value, isNull);
      expect(h.requests.length, 1);
    },
  );
  testWidgets(
    'access expiry signs out without calling a nonexistent refresh API',
    (tester) async {
      var now = DateTime.now();
      final h = AuthHarness(clock: () => now);
      addTearDown(h.dispose);
      h.store.value = loginTokens(now: now, seconds: 62);
      await h.auth.restore();
      expect(h.auth.isAuthenticated, isTrue);
      now = now.add(const Duration(seconds: 3));
      await tester.pump(const Duration(seconds: 3));
      await tester.pump();
      expect(h.auth.status, AuthStatus.anonymous);
      expect(h.auth.exitReason, AuthExitReason.expired);
      expect(h.requests, isEmpty);
    },
  );
  test(
    'legacy JCVital JWT and cached email migrate without changing storage keys',
    () async {
      final payload = {
        'uid': 'legacy-user',
        'sub': 'user:legacy-user',
        'typ': 'access',
        'exp': DateTime.now().millisecondsSinceEpoch ~/ 1000 + 7200,
      };
      final token =
          'header.${base64Url.encode(utf8.encode(jsonEncode(payload))).replaceAll('=', '')}.signature';
      FlutterSecureStorage.setMockInitialValues({
        AuthStorageKeys.accessToken: token,
      });
      SharedPreferences.setMockInitialValues({
        AuthStorageKeys.userEmail: 'legacy@example.test',
      });
      final store = SecureTokenStore();
      final stored = await store.read();
      expect(stored?.userId, 'legacy-user');
      expect(stored?.email, 'legacy@example.test');
      expect(stored?.accessToken, token);
      final refresh = {...payload, 'typ': 'refresh'};
      expect(
        AuthTokens.fromLegacyToken(
          'header.${base64Url.encode(utf8.encode(jsonEncode(refresh)))}.signature',
        ),
        isNull,
      );
    },
  );
}
