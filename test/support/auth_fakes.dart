import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:new_jcvital/core/auth/auth_api.dart';
import 'package:new_jcvital/core/auth/auth_controller.dart';
import 'package:new_jcvital/core/auth/auth_session.dart';
import 'package:new_jcvital/core/auth/auth_tokens.dart';
import 'package:new_jcvital/core/auth/google_identity.dart';
import 'package:new_jcvital/core/auth/token_store.dart';
import 'package:new_jcvital/core/network/api_client.dart';

class MemoryAccessStorage implements AccessTokenStorage {
  String? value;
  bool failWrite = false;
  @override
  Future<String?> read() async => value;
  @override
  Future<void> write(String token) async {
    if (failWrite) throw StateError('storage unavailable');
    value = token;
  }

  @override
  Future<void> delete() async {
    value = null;
  }
}

class MemoryTokenStore implements TokenStore {
  AuthTokens? value;
  Completer<AuthTokens?>? reading;
  bool failWrite = false;
  @override
  Future<AuthTokens?> read() async =>
      reading == null ? value : await reading!.future;
  @override
  Future<void> write(AuthTokens tokens) async {
    if (failWrite) throw StateError('storage unavailable');
    value = tokens;
  }

  @override
  Future<void> clear() async {
    value = null;
  }
}

class FakeGoogleIdentity implements GoogleIdentity {
  String? token = 'google-id-token';
  int requests = 0, signOuts = 0;
  @override
  bool get supported => true;
  @override
  Future<String?> getIdToken() async {
    requests++;
    return token;
  }

  @override
  Future<void> signOut() async {
    signOuts++;
  }
}

AuthTokens loginTokens({
  String id = 'user-a',
  String email = 'person@example.test',
  String token = 'access-a',
  DateTime? now,
  int seconds = 7200,
}) => AuthTokens(
  userId: id,
  email: email,
  accessToken: token,
  refreshToken: 'refresh',
  tokenType: 'Bearer',
  accessTokenExpiresAt:
      (now ?? DateTime.now()).millisecondsSinceEpoch ~/ 1000 + seconds,
  refreshTokenExpiresAt: 0,
);
http.Response response(
  Map<String, dynamic> data, {
  int status = 200,
  int code = 200,
  Map<String, String>? headers,
}) => http.Response(
  jsonEncode({'code': code, 'data': data}),
  status,
  headers: headers ?? const {},
);

class AuthHarness {
  bool _disposed = false;
  AuthHarness({
    Future<http.Response> Function(http.Request)? handler,
    GoogleIdentity? google,
    DateTime Function()? clock,
  }) {
    client = ApiClient(
      baseUrl: Uri.parse('https://unit.example/api/v1'),
      tokenProvider: () async => session.accessToken,
      onUnauthorized: session.invalidate,
      client: MockClient(
        handler ??
            (r) async {
              requests.add(r);
              if (r.url.path.endsWith('/email/code')) {
                return response({'expiresIn': 600, 'newUser': newUser});
              }
              return response(loginTokens(now: clock?.call()).toJson());
            },
      ),
    );
    auth = AuthController(
      api: AuthApi(client),
      store: store,
      session: session,
      clock: clock,
      google: google,
    );
  }
  final access = MemoryAccessStorage();
  late final AuthSession session = AuthSession(storage: access);
  final store = MemoryTokenStore();
  final requests = <http.Request>[];
  bool newUser = false;
  late final ApiClient client;
  late final AuthController auth;
  void dispose() {
    if (_disposed) return;
    _disposed = true;
    auth.dispose();
    session.dispose();
  }
}
