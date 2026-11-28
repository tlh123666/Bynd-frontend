import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_jcvital/design_system/design_system.dart';
import 'package:new_jcvital/features/heart/presentation/pages/heart_page.dart';
import 'package:new_jcvital/features/activity/presentation/widgets/activity_selection_sheet.dart';
import 'package:new_jcvital/features/heart/presentation/pages/heart_recording_page.dart';
import 'package:new_jcvital/features/heart/domain/heart_models.dart';
import 'package:new_jcvital/features/heart/presentation/sheets/heart_detail_sheet.dart';
import 'package:new_jcvital/features/heart/presentation/sheets/heart_settings_sheet.dart';
import 'package:new_jcvital/features/heart/presentation/sheets/heart_recording_report.dart';
import 'package:new_jcvital/l10n/generated/app_localizations.dart';
import 'package:new_jcvital/features/device/application/device_controller.dart';
import 'package:new_jcvital/features/device/application/device_scope.dart';
import 'package:new_jcvital/features/device/domain/device_models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../device/device_test_support.dart';
import 'heart_test_support.dart';

Future<void> mountHeart(
  WidgetTester t,
  MemoryHeartRepository repo, {
  Size size = const Size(390, 844),
  double scale = 1,
  Widget? child,
}) async {
  t.view.physicalSize = size;
  t.view.devicePixelRatio = 1;
  addTearDown(t.view.resetPhysicalSize);
  addTearDown(t.view.resetDevicePixelRatio);
  await t.pumpWidget(
    MaterialApp(
      theme: AppTheme.dark,
      locale: const Locale('en'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      builder: (c, w) => MediaQuery(
        data: MediaQuery.of(c).copyWith(
          disableAnimations: true,
          textScaler: TextScaler.linear(scale),
        ),
        child: w!,
      ),
      home:
          child ??
          HeartPage(
            repository: repo,
            diaryRepository: MemoryHeartDiary(),
            date: DateTime(2026, 11, 14),
            demo: true,
          ),
    ),
  );
  await t.pumpAndSettle();
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));
  testWidgets('heart quick action opens activity sheet over current page', (t) async {
    await mountHeart(t, MemoryHeartRepository());
    await t.tap(find.bySemanticsLabel('Quick actions'));
    await t.pumpAndSettle();
    await t.tap(find.text('Start\nactivity'));
    await t.pumpAndSettle();
    expect(find.byType(ActivitySelectionSheet), findsOneWidget);
    expect(find.byType(HeartPage), findsOneWidget);
    await t.tap(find.byTooltip('Close').last);
    await t.pumpAndSettle();
    expect(find.byType(ActivitySelectionSheet), findsNothing);
    expect(find.byType(HeartPage), findsOneWidget);
    expect(t.takeException(), isNull);
  });
  testWidgets(
    'backgrounding during connection cancels capture and ignores late start',
    (t) async {
      final repo = MemoryHeartRepository();
      final gateway = FakeHeartGateway()..startWait = Completer<void>();
      t.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      addTearDown(() {
        if (!gateway.startWait!.isCompleted) gateway.startWait!.complete();
        t.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      });
      await mountHeart(
        t,
        repo,
        child: Scaffold(
          body: HeartRecordingPage(
            repository: repo,
            demo: true,
            gateway: gateway,
          ),
        ),
      );
      await t.tap(find.text('Start'));
      await t.pump();
      expect(gateway.startedDevices.length, 1);
      t.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      await t.runAsync(() => Future<void>.delayed(Duration.zero));
      await t.pump();
      expect(gateway.stops, greaterThan(0));
      gateway.startWait!.complete();
      await t.pumpAndSettle();
      gateway.emit({
        'event': 'ecg_waveform',
        'samples': [1, 2, 3],
      });
      gateway.emit({'event': 'ecg_completed', 'durationMillis': 30000});
      t.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await t.pumpAndSettle();
      expect(repo.creates, 0);
      expect(gateway.startedDevices.length, 1);
      expect(find.text('Start'), findsOneWidget);
    },
  );
  testWidgets(
    'retry on the same page connects the replacement band and saves its serial',
    (t) async {
      final repo = MemoryHeartRepository(), gateway = FakeHeartGateway();
      final devices =
          DeviceController(
              repository: TestDeviceRepository(testDeviceStore()),
              gateway: TestDeviceGateway(),
              isDemo: false,
            )
            ..device = const DeviceSnapshot(
              id: 'cloud-a',
              serialNumber: 'B1',
              connected: true,
              transportId: 'BLE-A',
            );
      addTearDown(devices.dispose);
      await mountHeart(
        t,
        repo,
        child: DeviceScope(
          controller: devices,
          child: Scaffold(
            body: HeartRecordingPage(
              repository: repo,
              demo: false,
              gateway: gateway,
            ),
          ),
        ),
      );
      await t.tap(find.text('Start'));
      await t.pumpAndSettle();
      gateway.emit({'event': 'ecg_failed'});
      await t.runAsync(() => Future<void>.delayed(Duration.zero));
      await t.pumpAndSettle();
      devices.device = const DeviceSnapshot(
        id: 'cloud-b',
        serialNumber: 'B2',
        connected: true,
        transportId: 'BLE-B',
      );
      await t.tap(find.text('Start'));
      await t.pumpAndSettle();
      expect(gateway.startedDevices.last.transportId, 'BLE-B');
      gateway.emit({
        'event': 'ecg_waveform',
        'samples': validCaptureWaveform(),
        'waveformKind': 'ppg',
      });
      gateway.emit({'event': 'ecg_completed', 'durationMillis': 30000});
      await t.pumpAndSettle();
      expect(repo.payloads.single['deviceSerial'], 'B2');
      expect(t.takeException(), isNull);
    },
  );
  testWidgets(
    'quick recording opens before an offline overview request finishes',
    (t) async {
      final pending = Completer<HeartSnapshot>();
      final repo = MemoryHeartRepository()..onLoad = (_) => pending.future;
      await mountHeart(
        t,
        repo,
        child: HeartPage(
          repository: repo,
          diaryRepository: MemoryHeartDiary(),
          date: DateTime(2026, 11, 14),
          demo: true,
          openRecording: true,
        ),
      );
      expect(find.byType(HeartRecordingPage), findsOneWidget);
      pending.complete(heartSnapshotFixture(DateTime(2026, 11, 14)));
      await t.pumpAndSettle();
      expect(t.takeException(), isNull);
    },
  );
  testWidgets(
    'heart chart opens and measured week/month navigate without errors',
    (t) async {
      await mountHeart(t, MemoryHeartRepository());
      await t.ensureVisible(find.byKey(const ValueKey('heart-signal-pulse')));
      await t.tap(find.byKey(const ValueKey('heart-signal-pulse')));
      await t.pumpAndSettle();
      expect(find.byType(HeartDetailSheet), findsOneWidget);
      await t.tap(find.byKey(const ValueKey('heart-period-week')));
      await t.pumpAndSettle();
      await t.tap(find.byKey(const ValueKey('heart-period-month')));
      await t.pumpAndSettle();
      expect(t.takeException(), isNull);
    },
  );
  testWidgets(
    'failed preference save keeps explicit disabled choice for retry',
    (t) async {
      final repo = MemoryHeartRepository()..failSave = true;
      await mountHeart(t, repo);
      final settings = find.byKey(const Key('heart-settings-entry'));
      await t.ensureVisible(settings);
      await t.tap(settings);
      await t.pumpAndSettle();
      await t.tap(
        find.widgetWithText(SwitchListTile, 'Estimated blood pressure'),
      );
      await t.pumpAndSettle();
      await t.ensureVisible(find.text('Save'));
      await t.tap(find.text('Save'));
      await t.pumpAndSettle();
      expect(find.byType(HeartSettingsSheet), findsOneWidget);
      expect(repo.saves, 0);
      repo.failSave = false;
      await t.tap(find.text('Save'));
      await t.pumpAndSettle();
      expect(repo.preferences.pressure, false);
      expect(find.byType(HeartSettingsSheet), findsNothing);
      expect(t.takeException(), isNull);
    },
  );
  testWidgets('compact large type has no clipped or overflowing cards', (
    t,
  ) async {
    await mountHeart(
      t,
      MemoryHeartRepository(),
      size: const Size(320, 640),
      scale: 1.4,
    );
    for (var i = 0; i < 8; i++) {
      await t.drag(
        find.byType(SingleChildScrollView).first,
        const Offset(0, -450),
      );
      await t.pumpAndSettle();
      expect(t.takeException(), isNull);
    }
  });
  testWidgets(
    'empty live measurements do not display reference health values',
    (t) async {
      final repo = MemoryHeartRepository()..empty = true;
      await mountHeart(t, repo);
      expect(find.text('Your heart, in perspective.'), findsOneWidget);
      expect(find.text('64'), findsNothing);
      expect(find.text('—'), findsWidgets);
    },
  );
  testWidgets(
    'failed note save keeps drafts; PPG never becomes a normal ECG report',
    (t) async {
      final repo = MemoryHeartRepository()..failAnnotation = true;
      await mountHeart(
        t,
        repo,
        child: Scaffold(
          body: HeartRecordingReport(
            repository: repo,
            record: heartRecordingFixture(),
          ),
        ),
      );
      expect(find.textContaining('Rhythm unclassified'), findsOneWidget);
      await t.scrollUntilVisible(
        find.text('Log in Diary'),
        220,
        scrollable: find.byType(Scrollable).first,
      );
      await t.tap(find.text('Log in Diary'));
      await t.pumpAndSettle();
      await t.ensureVisible(find.text('After coffee'));
      await t.tap(find.text('After coffee'));
      await t.pumpAndSettle();
      await t.ensureVisible(find.text('Save observations'));
      await t.tap(find.text('Save observations'));
      await t.pumpAndSettle();
      expect(repo.annotations, 0);
      repo.failAnnotation = false;
      await t.scrollUntilVisible(
        find.text('Save observations'),
        180,
        scrollable: find.byType(Scrollable).first,
      );
      await t.tap(find.text('Save observations'));
      await t.pumpAndSettle();
      expect(repo.savedRecord.context, 'after_coffee');
      expect(t.takeException(), isNull);
    },
  );
}
