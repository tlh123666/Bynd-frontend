import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_jcvital/design_system/design_system.dart';
import 'package:new_jcvital/features/home/application/home_controller.dart';
import 'package:new_jcvital/features/home/data/demo_home_repository.dart';
import 'package:new_jcvital/features/home/domain/home_models.dart';
import 'package:new_jcvital/features/home/presentation/widgets/home_content.dart';
import 'package:new_jcvital/features/home/presentation/widgets/home_customize_sheet.dart';
import 'package:new_jcvital/features/home/presentation/pages/home_signal_detail_page.dart';
import 'package:new_jcvital/features/home/presentation/pages/home_diary_page.dart';
import 'package:new_jcvital/l10n/generated/app_localizations.dart';
import 'package:new_jcvital/main.dart';
import 'package:new_jcvital/core/auth/auth_session.dart';
import 'package:new_jcvital/core/auth/auth_token_store.dart';
import 'package:new_jcvital/features/home/presentation/widgets/home_account_guard.dart';
import 'home_controller_test.dart'
    show MemoryHomePreferences, MemoryHomeAccessStorage;

Future<HomeController> mount(
  WidgetTester tester, {
  Size size = const Size(390, 844),
  double scale = 1,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  final controller = HomeController(
    repository: DemoHomeRepository(),
    preferences: MemoryHomePreferences(),
  );
  addTearDown(controller.dispose);
  await controller.initialize();
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.dark,
      locale: const Locale('pt', 'BR'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: TextScaler.linear(scale)),
        child: child!,
      ),
      home: Scaffold(
        body: HomeContent(
          controller: controller,
          onMenu: () {},
          onProfile: () {},
          onDevice: () {},
          onMapa: () {},
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return controller;
}

void main() {
  testWidgets('open content cannot retain another account\'s private data', (
    tester,
  ) async {
    final session = AuthSession(storage: MemoryHomeAccessStorage());
    await session.setAccessToken('account-a');
    final controller = HomeController(
      repository: DemoHomeRepository(),
      preferences: MemoryHomePreferences(),
      session: session,
    );
    await controller.initialize();
    addTearDown(() {
      controller.dispose();
      session.dispose();
      AuthTokenStore.instance.clear();
    });
    await tester.pumpWidget(
      MaterialApp(
        home: HomeAccountGuard(
          controller: controller,
          child: const Text('private-history'),
        ),
      ),
    );
    expect(find.text('private-history'), findsOneWidget);
    await session.signOut();
    await tester.pumpAndSettle();
    expect(find.text('private-history'), findsNothing);
  });
  testWidgets('dragging the handle changes the saved Home order', (
    tester,
  ) async {
    final controller = await mount(tester);
    await tester.ensureVisible(find.byTooltip('Personalizar a Home'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Personalizar a Home'));
    await tester.pumpAndSettle();
    final handle = find.byType(ReorderableDragStartListener).first;
    final start = tester.getCenter(handle);
    final gesture = await tester.startGesture(start);
    await gesture.moveBy(const Offset(0, 10));
    await tester.pump(const Duration(milliseconds: 200));
    await gesture.moveTo(start + const Offset(0, 95));
    await tester.pump(const Duration(milliseconds: 600));
    await gesture.up();
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Salvar'));
    await tester.pumpAndSettle();
    expect(controller.signals.first, HomeSignal.steps);
    expect(controller.signals.indexOf(HomeSignal.sleep), greaterThan(0));
  });
  testWidgets('anonymous Home renders at 320px without overflowing', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const ByndApp());
    await tester.pumpAndSettle();
    expect(
      find.text('Entre na sua conta para ver seus dados.'),
      findsOneWidget,
    );
  });
  testWidgets(
    'Home renders six signals and a photo change, customization enforces six and persists',
    (tester) async {
      final controller = await mount(tester);
      expect(find.text('A direção é recuperar.'), findsOneWidget);
      expect(find.byType(AppSignalCard), findsNWidgets(6));
      await tester.tap(find.text('1/25'));
      await tester.pumpAndSettle();
      expect(controller.photo, 2);
      await tester.ensureVisible(find.byTooltip('Personalizar a Home'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Personalizar a Home'));
      await tester.pumpAndSettle();
      final sheet = find.byType(HomeCustomizeSheet);
      final checkboxes = find.descendant(
        of: sheet,
        matching: find.byType(Checkbox),
      );
      await tester.tap(checkboxes.first);
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<IconButton>(
              find.ancestor(
                of: find.byTooltip('Salvar'),
                matching: find.byType(IconButton),
              ),
            )
            .onPressed,
        isNull,
      );
      final distance = find.descendant(
        of: sheet,
        matching: find.text('Distância'),
      );
      await tester.ensureVisible(distance);
      await tester.tap(distance);
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Salvar'));
      await tester.pumpAndSettle();
      expect(controller.signals.length, 6);
      expect(controller.signals.contains(HomeSignal.sleep), false);
      expect(controller.signals.last, HomeSignal.distance);
      await controller.reload();
      await tester.pumpAndSettle();
      expect(controller.signals.last, HomeSignal.distance);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('signal card opens history and closes back to the same Home', (
    tester,
  ) async {
    await mount(tester);
    final card = find.byKey(const ValueKey('home-signal-sleep'));
    await tester.ensureVisible(card);
    await tester.tap(card);
    await tester.pumpAndSettle();
    expect(find.byType(HomeSignalDetailPage), findsOneWidget);
    expect(find.text('SEMANA · UM PONTO POR DIA'), findsOneWidget);
    await tester.tap(find.byTooltip('Voltar'));
    await tester.pumpAndSettle();
    expect(find.byType(HomeSignalDetailPage), findsNothing);
    expect(find.byType(HomeContent), findsOneWidget);
  });
  testWidgets('diary validates empty entry and saves a real form submission', (
    tester,
  ) async {
    final controller = await mount(tester);
    await tester.ensureVisible(find.text('Adicionar registro +'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Adicionar registro +'));
    await tester.pumpAndSettle();
    expect(find.byType(HomeDiaryPage), findsOneWidget);
    await tester.tap(find.text('Adicionar registro +').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();
    expect(find.text('Descreva o registro antes de salvar.'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('home-diary-label')), 'Almoço');
    await tester.enterText(find.byKey(const Key('home-diary-note')), 'Leve');
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();
    final events = await controller.repository.diary(controller.date, 'pt');
    expect(events.single.label, 'Almoço');
    expect(events.single.note, 'Leve');
    expect(find.text('Almoço'), findsOneWidget);
  });
  testWidgets(
    'compact screen and large text remain scrollable without overflow',
    (tester) async {
      await mount(tester, size: const Size(320, 600), scale: 1.5);
      await tester.ensureVisible(find.text('Adicionar registro +'));
      await tester.pumpAndSettle();
      expect(find.byType(HomeContent), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
