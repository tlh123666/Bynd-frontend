import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_jcvital/design_system/design_system.dart';
import 'package:new_jcvital/features/sleep/domain/sleep_models.dart';
import 'package:new_jcvital/features/sleep/presentation/pages/sleep_page.dart';
import 'package:new_jcvital/features/sleep/presentation/sheets/sleep_metric_sheet.dart';
import 'package:new_jcvital/features/sleep/presentation/sheets/sleep_preferences_sheet.dart';
import 'package:new_jcvital/l10n/generated/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'sleep_test_support.dart';
import 'package:new_jcvital/features/diary/domain/diary_models.dart';

class PendingSleepDiary extends MemorySleepDiary {
  final pending = Completer<DiaryDay>();
  bool started = false;
  @override
  Future<DiaryDay> save(
    DiaryDay base,
    List<DiaryMoment> events,
    String note,
    String mutationId,
  ) {
    started = true;
    return pending.future;
  }
}

Future<void> mountSleep(
  WidgetTester tester,
  MemorySleepRepository repo, {
  Size size = const Size(390, 844),
  double scale = 1,
  Locale locale = const Locale('pt', 'BR'),
  MemorySleepDiary? diary,
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
      home: SleepPage(
        repository: repo,
        diaryRepository: diary ?? MemorySleepDiary(),
        date: DateTime(2026, 11, 14),
        demo: true,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));
  testWidgets(
    'refresh cannot dispose a pending diary save or leave the page locked',
    (tester) async {
      final repo = MemorySleepRepository();
      final diary = PendingSleepDiary();
      await mountSleep(tester, repo, diary: diary);
      final answer = find.byKey(const ValueKey('sleep-habit-cafe15-true'));
      await tester.ensureVisible(answer);
      await tester.tap(answer);
      await tester.pump();
      expect(diary.started, isTrue);
      await tester
          .widget<RefreshIndicator>(find.byType(RefreshIndicator))
          .onRefresh();
      await tester.pump();
      expect(repo.loads, 1);
      diary.pending.complete(
        DiaryDay(date: DateTime(2026, 11, 14), events: const []),
      );
      await tester.pumpAndSettle();
      await tester
          .widget<RefreshIndicator>(find.byType(RefreshIndicator))
          .onRefresh();
      await tester.pumpAndSettle();
      expect(repo.loads, 2);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'sleep duration opens stages and supports day/week/month navigation',
    (tester) async {
      final repo = MemorySleepRepository();
      await mountSleep(tester, repo);
      expect(find.text('Sono'), findsOneWidget);
      expect(find.text('82'), findsWidgets);
      await tester.ensureVisible(find.text('TEMPO DE SONO'));
      await tester.tap(find.text('TEMPO DE SONO'));
      await tester.pumpAndSettle();
      expect(find.byType(SleepMetricSheet), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('sleep-period-week')));
      await tester.pumpAndSettle();
      expect(find.text('média dos dias com leitura'), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('sleep-period-month')));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Fechar'));
      await tester.pumpAndSettle();
      expect(find.byType(SleepMetricSheet), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'saving settings persists explicit disabled stages and keeps the route on failure',
    (tester) async {
      final repo = MemorySleepRepository()..failSave = true;
      await mountSleep(tester, repo);
      await tester.tap(find.byTooltip('Ajustes do sono'));
      await tester.pumpAndSettle();
      final toggle = find.widgetWithText(SwitchListTile, 'Fases do sono');
      await tester.ensureVisible(toggle);
      await tester.tap(toggle);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Salvar'));
      await tester.pumpAndSettle();
      expect(find.byType(SleepPreferencesSheet), findsOneWidget);
      expect(repo.saves, 0);
      repo.failSave = false;
      await tester.tap(find.text('Salvar'));
      await tester.pumpAndSettle();
      expect(repo.saved!.show('showStages'), false);
      expect(find.byType(SleepPreferencesSheet), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'empty night has no invented score and keeps planner accessible',
    (tester) async {
      final repo = MemorySleepRepository()..empty = true;
      await mountSleep(tester, repo);
      expect(
        find.text('Não conseguimos ler o seu sono nessa noite.'),
        findsOneWidget,
      );
      expect(
        find.text('82'),
        findsWidgets,
      ); // measured historic nights remain independent
      expect(find.text('TEMPO DE SONO'), findsNothing);
      expect(find.text('PLANEJADOR DE SONO'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'compact layout with large text remains scrollable without overflow',
    (tester) async {
      final repo = MemorySleepRepository();
      await mountSleep(tester, repo, size: const Size(320, 640), scale: 1.4);
      await tester.drag(
        find.byType(SingleChildScrollView).first,
        const Offset(0, -450),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('English sleep uses the same controls and data', (tester) async {
    final repo = MemorySleepRepository();
    await mountSleep(tester, repo, locale: const Locale('en'));
    expect(find.text('Sleep'), findsOneWidget);
    expect(find.byTooltip('Sleep settings'), findsOneWidget);
    expect(find.text('SLEEP DURATION'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('premium-locked trend never displays simulated history', (
    tester,
  ) async {
    final repo = MemorySleepRepository()
      ..history = const SleepTrend(locked: true);
    await mountSleep(tester, repo);
    final locked = find.text('Histórico detalhado disponível no Premium.');
    await tester.ensureVisible(locked);
    await tester.pumpAndSettle();
    expect(locked, findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
