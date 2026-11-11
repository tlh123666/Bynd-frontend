import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_jcvital/core/auth/auth_token_store.dart';
import 'package:new_jcvital/core/config/app_config.dart';
import 'package:new_jcvital/design_system/design_system.dart';
import 'package:new_jcvital/features/auth/application/login_controller.dart';
import 'package:new_jcvital/features/auth/presentation/login_page.dart';
import 'package:new_jcvital/features/device/application/device_scope.dart';
import 'package:new_jcvital/features/home/application/home_controller.dart';
import 'package:new_jcvital/features/home/data/demo_home_repository.dart';
import 'package:new_jcvital/features/home/home_page.dart';
import 'package:new_jcvital/l10n/generated/app_localizations.dart';
import 'package:new_jcvital/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../support/auth_fakes.dart';
import '../home/home_controller_test.dart' show MemoryHomePreferences;

Future<void> mountLogin(
  WidgetTester tester,
  LoginController flow, {
  Size size = const Size(390, 844),
  double scale = 1,
  Locale locale = const Locale('pt', 'BR'),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.dark,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      builder: (c, child) => MediaQuery(
        data: MediaQuery.of(c).copyWith(textScaler: TextScaler.linear(scale)),
        child: child!,
      ),
      home: LoginPage(controller: flow),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> openEmail(WidgetTester tester) async {
  await tester.ensureVisible(find.byKey(const Key('auth-email-continue')));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('auth-email-continue')));
  await tester.pumpAndSettle();
}

Future<void> sendCode(WidgetTester tester) async {
  await openEmail(tester);
  await tester.enterText(
    find.byKey(const Key('auth-email-field')),
    'person@example.test',
  );
  await tester.tap(find.text('Enviar código'));
  await tester.pumpAndSettle();
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    AuthTokenStore.instance.clear();
  });
  tearDown(() => AuthTokenStore.instance.clear());
  testWidgets('landing and email modal fit compact screens with large text', (
    tester,
  ) async {
    final h = AuthHarness(google: FakeGoogleIdentity());
    final flow = LoginController(h.auth);
    addTearDown(() {
      flow.dispose();
      h.dispose();
    });
    await mountLogin(tester, flow, size: const Size(320, 640), scale: 1.4);
    await openEmail(tester);
    expect(find.text('Qual é o seu e-mail?'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets(
    'email validation and six digit code submit the real API contract',
    (tester) async {
      final h = AuthHarness();
      final flow = LoginController(h.auth);
      addTearDown(() {
        flow.dispose();
        h.dispose();
      });
      await mountLogin(tester, flow);
      await openEmail(tester);
      await tester.enterText(
        find.byKey(const Key('auth-email-field')),
        'invalid',
      );
      await tester.tap(find.text('Enviar código'));
      await tester.pumpAndSettle();
      expect(find.text('Informe um e-mail válido.'), findsOneWidget);
      expect(h.requests, isEmpty);
      await tester.enterText(
        find.byKey(const Key('auth-email-field')),
        'person@example.test',
      );
      await tester.tap(find.text('Enviar código'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('auth-code-field')),
        '123456',
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Entrar').last);
      await tester.pumpAndSettle();
      expect(h.auth.isAuthenticated, isTrue);
      expect(jsonDecode(h.requests.last.body), {
        'email': 'person@example.test',
        'code': '123456',
        'consent': false,
      });
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      flow.dispose();
      h.dispose();
    },
  );
  testWidgets(
    'new account is blocked until health consent is explicitly selected',
    (tester) async {
      final h = AuthHarness()..newUser = true;
      final flow = LoginController(h.auth);
      addTearDown(() {
        flow.dispose();
        h.dispose();
      });
      await mountLogin(tester, flow);
      await sendCode(tester);
      await tester.enterText(
        find.byKey(const Key('auth-code-field')),
        '123456',
      );
      await tester.pumpAndSettle();
      expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, isFalse);
      expect(
        tester
            .widget<FilledButton>(
              find.descendant(
                of: find.byKey(const Key('auth-submit')),
                matching: find.byType(FilledButton),
              ),
            )
            .onPressed,
        isNull,
      );
      await tester.ensureVisible(find.byType(Checkbox));
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Criar conta e entrar'));
      await tester.pumpAndSettle();
      expect(h.auth.isAuthenticated, isTrue);
      expect((jsonDecode(h.requests.last.body) as Map)['consent'], isTrue);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      flow.dispose();
      h.dispose();
    },
  );
  testWidgets(
    'declining Google consent never starts Google or creates an account',
    (tester) async {
      final google = FakeGoogleIdentity();
      final h = AuthHarness(google: google);
      final flow = LoginController(h.auth);
      addTearDown(() {
        flow.dispose();
        h.dispose();
      });
      await mountLogin(tester, flow);
      await tester.tap(find.text('Continuar com Google'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Agora não'));
      await tester.pumpAndSettle();
      expect(google.requests, 0);
      expect(h.requests, isEmpty);
      expect(h.auth.isAuthenticated, isFalse);
    },
  );
  testWidgets('English login uses localized copy', (tester) async {
    final h = AuthHarness();
    final flow = LoginController(h.auth);
    addTearDown(() {
      flow.dispose();
      h.dispose();
    });
    await mountLogin(tester, flow, locale: const Locale('en'));
    await openEmail(tester);
    expect(find.text("What's your email?"), findsOneWidget);
    expect(find.text('Send code'), findsOneWidget);
  });
  testWidgets(
    'startup waits for restoration; logout discards private navigation',
    (tester) async {
      final h = AuthHarness();
      h.store.reading = Completer();
      final home = HomeController(
        repository: DemoHomeRepository(),
        preferences: MemoryHomePreferences(),
        session: h.session,
      );
      addTearDown(() {
        home.dispose();
        h.dispose();
      });
      final config = AppConfig.resolve(defines: {'DEVICE_DEMO': 'true'});
      await tester.pumpWidget(
        ByndApp(authController: h.auth, homeController: home, config: config),
      );
      await tester.pump();
      expect(find.byType(HomePage), findsNothing);
      expect(find.byType(DeviceScope), findsNothing);
      h.store.reading!.complete(null);
      await tester.pumpAndSettle();
      expect(find.byType(LoginPage), findsOneWidget);
      await h.auth.loginWithEmailCode(
        email: 'person@example.test',
        code: '123456',
        consent: false,
      );
      await tester.pumpAndSettle();
      expect(find.byType(HomePage), findsOneWidget);
      final navigation = Navigator.of(tester.element(find.byType(HomePage)));
      unawaited(
        navigation.push(
          MaterialPageRoute<void>(
            builder: (_) => const Scaffold(body: Text('private-account-a')),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('private-account-a'), findsOneWidget);
      await h.auth.logout();
      await tester.pumpAndSettle();
      expect(find.text('private-account-a'), findsNothing);
      expect(find.byType(HomePage), findsNothing);
      expect(find.byType(LoginPage), findsOneWidget);
      expect(find.byType(DeviceScope), findsNothing);
      expect(
        await Navigator.of(tester.element(find.byType(LoginPage))).maybePop(),
        isFalse,
      );
      expect(tester.takeException(), isNull);
    },
  );
}
