import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_jcvital/core/auth/auth_token_store.dart';
import 'package:new_jcvital/features/auth/application/login_controller.dart';
import '../../support/auth_fakes.dart';

void main() {
  setUp(() => AuthTokenStore.instance.clear());
  tearDown(() => AuthTokenStore.instance.clear());
  test(
    'invalid email does not request a code; new account requires explicit consent',
    () async {
      final h = AuthHarness()..newUser = true;
      await h.auth.restore();
      final flow = LoginController(h.auth);
      addTearDown(() {
        flow.dispose();
        h.dispose();
      });
      expect(await flow.sendCode('invalid'), isFalse);
      expect(h.requests, isEmpty);
      expect(await flow.sendCode('New@Example.test'), isTrue);
      expect(flow.email, 'new@example.test');
      expect(flow.newUser, isTrue);
      await flow.verify('123456', consent: false);
      expect(flow.failure, LoginFailure.consent);
      expect(h.requests.length, 1);
      await flow.verify('123456', consent: true);
      expect(h.auth.isAuthenticated, isTrue);
      expect((jsonDecode(h.requests.last.body) as Map)['consent'], isTrue);
    },
  );
  test(
    'resend uses a real deadline and cannot be bypassed by editing email',
    () async {
      var now = DateTime.now();
      final h = AuthHarness(clock: () => now);
      await h.auth.restore();
      final flow = LoginController(h.auth, clock: () => now);
      addTearDown(() {
        flow.dispose();
        h.dispose();
      });
      await flow.sendCode('person@example.test');
      expect(flow.resendSeconds, 60);
      flow.editEmail();
      expect(await flow.sendCode('person@example.test'), isFalse);
      expect(h.requests.length, 1);
      now = now.add(const Duration(seconds: 61));
      expect(flow.resendSeconds, 0);
      expect(await flow.sendCode('person@example.test'), isTrue);
      expect(h.requests.length, 2);
    },
  );
  test('expired or incomplete code cannot sign in', () async {
    var now = DateTime.now();
    final h = AuthHarness(clock: () => now);
    await h.auth.restore();
    final flow = LoginController(h.auth, clock: () => now);
    addTearDown(() {
      flow.dispose();
      h.dispose();
    });
    await flow.sendCode('person@example.test');
    await flow.verify('123', consent: false);
    expect(flow.failure, LoginFailure.code);
    now = now.add(const Duration(minutes: 11));
    await flow.verify('123456', consent: false);
    expect(flow.failure, LoginFailure.expired);
    expect(h.requests.length, 1);
  });
}
