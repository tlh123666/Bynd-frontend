import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:new_jcvital/core/auth/auth_session.dart';
import 'package:new_jcvital/core/auth/auth_token_store.dart';
import 'package:new_jcvital/core/network/api_client.dart';
import 'package:new_jcvital/design_system/design_system.dart';
import 'package:new_jcvital/features/diary/data/demo_diary_repository.dart';
import 'package:new_jcvital/features/diary/data/remote_diary_repository.dart';
import 'package:new_jcvital/features/diary/domain/diary_models.dart';
import 'package:new_jcvital/features/vitality/application/vitality_controller.dart';
import 'package:new_jcvital/features/vitality/application/vitality_exports.dart';
import 'package:new_jcvital/features/vitality/data/demo_vitality_repository.dart';
import 'package:new_jcvital/features/vitality/data/remote_vitality_repository.dart';
import 'package:new_jcvital/features/vitality/domain/vitality_models.dart';
import 'package:new_jcvital/features/vitality/presentation/pages/vitality_page.dart';
import 'package:new_jcvital/l10n/generated/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemoryTokenStorage implements AccessTokenStorage {
  String? token;
  @override
  Future<String?> read() async => token;
  @override
  Future<void> write(String value) async {
    token = value;
  }

  @override
  Future<void> delete() async {
    token = null;
  }
}

class MemoryVitality implements VitalityRepository {
  VitalityPreferences preferences = const VitalityPreferences();
  bool empty = false, failLoad = false, failSave = false, disposed = false;
  final loads = <DateTime>[];
  Future<VitalitySnapshot> Function(VitalityKind, DateTime, int)? onLoad;
  @override
  Future<VitalitySnapshot> load(
    VitalityKind kind,
    DateTime date, {
    int days = 7,
  }) async {
    loads.add(date);
    if (failLoad) throw StateError('offline');
    if (onLoad != null) return onLoad!(kind, date, days);
    return VitalitySnapshot(
      kind: kind,
      date: date,
      score: empty ? null : 57,
      yesterday: empty ? null : 51,
      average: empty ? null : 55,
      previousAverage: empty ? null : 78,
      preferences: preferences,
      baselineLow: empty ? null : 67,
      baselineHigh: empty ? null : 85,
      metrics: empty
          ? {}
          : {
              'hrvMs': 54,
              'restingHeartRate': 58,
              'stressScore': 47,
              'sleepMinutes': 462,
              'steps': 6240,
              'vo2Max': 43,
              'activeMinutes': 38,
            },
      trend: List.generate(
        days,
        (i) => VitalityPoint(
          date.subtract(Duration(days: days - 1 - i)),
          empty
              ? null
              : i == 2
              ? null
              : 50.0 + i,
        ),
      ),
      observations: empty
          ? []
          : List.generate(
              4,
              (i) => VitalityPoint(
                DateTime(date.year, date.month, date.day, 8 + i),
                65 - i * 3.0,
              ),
            ),
      forecast: empty
          ? []
          : [
              VitalityPoint(date, 57),
              VitalityPoint(date.add(const Duration(days: 1)), 66),
            ],
    );
  }

  @override
  Future<VitalityPreferences> savePreferences(VitalityPreferences p) async {
    if (failSave) throw StateError('offline');
    return preferences = p;
  }

  @override
  void dispose() {
    disposed = true;
  }
}

class MemoryVitalityDiary extends DemoDiaryRepository {
  DiaryDay day = DiaryDay(
    date: DateTime.now(),
    note: 'Private note',
    events: [
      DiaryMoment({
        'id': 'existing',
        'valueKey': 'alc',
        'label': 'Original label',
        'note': 'Original note',
        'details': {'kind': 'boolean'},
      }),
    ],
  );
  bool failSave = false;
  @override
  Future<DiaryDay> load(DateTime date) async => DiaryDay(
    date: date,
    note: day.note,
    events: day.events,
    revision: day.revision,
  );
  @override
  Future<List<DiaryTracker>> catalog() async => [
    for (final key in [
      'acordou',
      'energia',
      'dor',
      'gripe',
      'c_cafemanha',
      'c_cochilo',
    ])
      DiaryTracker({
        'key': key,
        'label': key,
        'kind': ['acordou', 'energia'].contains(key) ? 'scale' : 'boolean',
        'enabled': true,
      }),
  ];
  @override
  Future<DiaryDay> save(
    DiaryDay base,
    List<DiaryMoment> events,
    String note,
    String mutationId,
  ) async {
    if (failSave) throw StateError('offline');
    return day = DiaryDay(
      date: base.date,
      events: events,
      note: note,
      revision: base.revision + 1,
    );
  }
}

Future<void> mount(
  WidgetTester t,
  MemoryVitality repo, {
  VitalityKind kind = VitalityKind.recovery,
  MemoryVitalityDiary? diary,
  String locale = 'en',
  Size size = const Size(390, 844),
  double scale = 1,
}) async {
  t.view.physicalSize = size;
  t.view.devicePixelRatio = 1;
  addTearDown(t.view.resetPhysicalSize);
  addTearDown(t.view.resetDevicePixelRatio);
  await t.pumpWidget(
    MaterialApp(
      theme: AppTheme.dark,
      locale: Locale(locale),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      builder: (c, w) => MediaQuery(
        data: MediaQuery.of(c).copyWith(
          disableAnimations: true,
          textScaler: TextScaler.linear(scale),
        ),
        child: w!,
      ),
      home: VitalityPage(
        kind: kind,
        demo: true,
        repository: repo,
        diaryRepository: diary ?? MemoryVitalityDiary(),
      ),
    ),
  );
  await t.pumpAndSettle();
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    AuthTokenStore.instance.clear();
  });
  test(
    'all vitality strings exist in Portuguese and English without fallback',
    () async {
      final maps = <Map<String, dynamic>>[];
      for (final locale in ['pt_BR', 'pt', 'en']) {
        maps.add(
          jsonDecode(await File('lib/l10n/arb/app_$locale.arb').readAsString())
              as Map<String, dynamic>,
        );
      }
      final keys = maps.first.keys
          .where((k) => k.startsWith('vitality'))
          .toSet();
      expect(keys.length, greaterThan(100));
      for (final map in maps) {
        expect(map.keys.where((k) => k.startsWith('vitality')).toSet(), keys);
        for (final key in keys) {
          expect(map[key], isNotEmpty, reason: key);
        }
      }
    },
  );
  test('PDF contains an exportable report rather than a placeholder', () async {
    final bytes = await VitalityExports.pdf(
      title: 'Recuperação',
      explanation: 'Estimativa baseada nos seus dados',
      rows: [
        ['15 nov', '57'],
      ],
    );
    expect(utf8.decode(bytes.take(4).toList()), '%PDF');
    expect(bytes.length, greaterThan(1000));
  });
  test('zero values and null history survive API parsing and export', () {
    final s = VitalitySnapshot.fromJson({
      'kind': 'energy',
      'date': '2026-11-15',
      'score': 0,
      'trend': [
        {'date': '2026-11-14', 'score': null},
        {'date': '2026-11-15', 'score': 0},
      ],
      'observations': [],
    });
    expect(s.score, 0);
    expect(s.trend.first.score, isNull);
    expect(s.trend.last.score, 0);
    final csv = utf8.decode(VitalityExports.csv(s));
    expect(csv, contains('rules_estimate'));
    expect(csv, contains('"2026-11-14",""'));
    expect(csv, contains('"2026-11-15","0.0"'));
  });
  test('late date response cannot replace the current date', () async {
    final repo = MemoryVitality();
    final old = Completer<VitalitySnapshot>();
    final date = DateTime(2026, 11, 15);
    repo.onLoad = (k, d, days) => d == date
        ? old.future
        : Future.value(VitalitySnapshot(kind: k, date: d, score: 85));
    final controller = VitalityController(
      repository: repo,
      kind: VitalityKind.recovery,
      date: date,
    );
    final first = controller.load();
    await controller.load(date: date.subtract(const Duration(days: 1)));
    old.complete(
      VitalitySnapshot(kind: VitalityKind.recovery, date: date, score: 15),
    );
    await first;
    expect(controller.snapshot!.score, 85);
    expect(controller.date, date.subtract(const Duration(days: 1)));
    controller.dispose();
    expect(repo.disposed, isTrue);
  });
  test(
    'diary write cannot use another account token while authentication is pending',
    () async {
      final session = AuthSession(storage: MemoryTokenStorage());
      await session.setAccessToken('owner');
      final token = Completer<String?>();
      var requests = 0;
      final repo = RemoteDiaryRepository(
        ApiClient(
          baseUrl: Uri.parse('https://api.example/api/v1'),
          tokenProvider: () => token.future,
          client: MockClient((r) async {
            requests++;
            return http.Response('{}', 200);
          }),
        ),
        session: session,
      );
      final save = repo.save(
        DiaryDay(date: DateTime.now(), events: []),
        [],
        'Private note',
        diaryId(),
      );
      await session.setAccessToken('other');
      final rejected = expectLater(
        save,
        throwsA(
          isA<ApiException>().having((e) => e.code, 'code', 'account_changed'),
        ),
      );
      token.complete('other');
      await rejected;
      expect(requests, 0);
      repo.dispose();
      session.dispose();
    },
  );
  test(
    'changing accounts clears loaded data and rejects an in-flight response',
    () async {
      final session = AuthSession(storage: MemoryTokenStorage());
      await session.setAccessToken('owner');
      final repo = MemoryVitality(), wait = Completer<VitalitySnapshot>();
      repo.onLoad = (k, d, n) => wait.future;
      final controller = VitalityController(
        repository: repo,
        kind: VitalityKind.energy,
        date: DateTime.now(),
        session: session,
      );
      final loading = controller.load();
      await session.setAccessToken('other');
      wait.complete(
        VitalitySnapshot(
          kind: VitalityKind.energy,
          date: DateTime.now(),
          score: 80,
        ),
      );
      await loading;
      expect(controller.snapshot, isNull);
      expect(controller.accountChanged, isTrue);
      controller.dispose();
      session.dispose();
    },
  );
  test(
    'remote experience preserves date, timezone, JWT and false settings',
    () async {
      final requests = <http.Request>[];
      final repo = RemoteVitalityRepository(
        ApiClient(
          baseUrl: Uri.parse('https://api.example/api/v1'),
          tokenProvider: () async => 'owner',
          client: MockClient((request) async {
            requests.add(request);
            return http.Response(
              jsonEncode({
                'code': 0,
                'data': request.method == 'PUT'
                    ? jsonDecode(request.body)
                    : {'kind': 'recovery', 'date': '2026-11-15', 'score': 0},
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
          }),
        ),
        timezone: () => 'Asia/Shanghai',
      );
      final data = await repo.load(
        VitalityKind.recovery,
        DateTime(2026, 11, 15),
      );
      expect(data.score, 0);
      expect(
        requests.first.url.path,
        '/api/v1/me/health-data/vitality/recovery/experience',
      );
      expect(requests.first.url.queryParameters['date'], '2026-11-15');
      expect(requests.first.url.queryParameters['timezone'], 'Asia/Shanghai');
      expect(requests.first.headers['Authorization'], 'Bearer owner');
      await repo.savePreferences(
        const VitalityPreferences().change('showForecast', false),
      );
      expect((jsonDecode(requests.last.body) as Map)['showForecast'], false);
      repo.dispose();
    },
  );
  test(
    'demo is isolated, includes reference values and persists goals',
    () async {
      final repo = DemoVitalityRepository(clock: () => DateTime(2026, 11, 15));
      final recovery = await repo.load(
        VitalityKind.recovery,
        DateTime(2026, 11, 15),
      );
      final energy = await repo.load(
        VitalityKind.energy,
        DateTime(2026, 11, 15),
      );
      expect(recovery.score, 57);
      expect(energy.score, 51);
      expect(recovery.demo, isTrue);
      expect(energy.observations.last.at.hour, 15);
      expect(energy.forecast.last.at.hour, 21);
      await repo.savePreferences(
        const VitalityPreferences()
            .change('stepGoal', 9500)
            .change('showForecast', false),
      );
      final loaded = await repo.load(
        VitalityKind.energy,
        DateTime(2026, 11, 15),
      );
      expect(loaded.preferences.stepGoal, 9500);
      expect(loaded.preferences.flag('showForecast'), isFalse);
    },
  );
  testWidgets('recovery trend and the selected day stay synchronized', (
    t,
  ) async {
    final repo = MemoryVitality();
    await mount(t, repo);
    expect(find.text('Recovery'), findsOneWidget);
    final trend = find.byKey(const Key('vitality-trend'));
    expect(t.widget<AppHealthTrend>(trend).points, hasLength(30));
    await t.ensureVisible(trend);
    final viewport = find.descendant(
      of: trend,
      matching: find.byType(SingleChildScrollView),
    );
    final middle = t.getCenter(viewport);
    await t.tapAt(middle - const Offset(32, 0));
    await t.pumpAndSettle();
    final now = DateTime.now();
    expect(
      vitalityDate(repo.loads.last),
      vitalityDate(vitalityShiftDay(now, -1)),
    );
    expect(t.widget<AppHealthTrend>(trend).points.last.date.day, now.day);
    expect(t.takeException(), isNull);
  });
  testWidgets('system back closes More without leaving the recovery page', (
    t,
  ) async {
    await mount(t, MemoryVitality());
    final nav = t.widget<AppBottomNav>(find.byType(AppBottomNav));
    await t.tap(find.byKey(nav.moreButtonKey!));
    await t.pumpAndSettle();
    expect(find.byType(AppQuickActionsOverlay), findsOneWidget);
    await t.binding.handlePopRoute();
    await t.pumpAndSettle();
    expect(find.byType(AppQuickActionsOverlay), findsNothing);
    expect(find.byType(VitalityPage), findsOneWidget);
  });
  testWidgets('grouped diary preserves unrelated events and notes', (t) async {
    final diary = MemoryVitalityDiary();
    await mount(t, MemoryVitality(), diary: diary);
    final entry = find.text('Log in Diary');
    await t.scrollUntilVisible(
      entry,
      300,
      scrollable: find
          .descendant(
            of: find.byKey(const Key('vitality-content')),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await t.ensureVisible(entry);
    await t.tap(entry);
    await t.pumpAndSettle();
    final tracker = find.byKey(const ValueKey('diary-tracker-dor'));
    await t.ensureVisible(tracker);
    await t.tap(tracker);
    await t.pumpAndSettle();
    await t.tap(find.text('Save'));
    await t.pumpAndSettle();
    expect(diary.day.events.first.label, 'Original label');
    expect(diary.day.note, 'Private note');
    expect(
      diary.day.events.singleWhere((event) => event.key == 'dor').happened,
      isTrue,
    );
    expect(diary.day.revision, 1);
  });
  testWidgets(
    'Portuguese energy page renders correctly at narrow width and large text',
    (t) async {
      await mount(
        t,
        MemoryVitality(),
        kind: VitalityKind.energy,
        locale: 'pt',
        size: const Size(320, 740),
        scale: 1.6,
      );
      expect(find.text('Energia'), findsOneWidget);
      await t.drag(find.byType(ListView).first, const Offset(0, -500));
      await t.pumpAndSettle();
      expect(t.takeException(), isNull);
    },
  );
  testWidgets('no-data and network errors do not display reference scores', (
    t,
  ) async {
    await mount(t, MemoryVitality()..empty = true);
    expect(find.text('Sync your band to see your readings.'), findsOneWidget);
    expect(t.widget<Text>(find.byKey(const Key('vitality-score'))).data, '—');
    await t.pumpWidget(const SizedBox());
    await mount(t, MemoryVitality()..failLoad = true);
    expect(find.text('Could not load. Please try again.'), findsOneWidget);
  });
  test(
    'both languages include all feature strings and reference SVGs parse as assets',
    () async {
      final en = lookupAppLocalizations(const Locale('en')),
          pt = lookupAppLocalizations(const Locale('pt', 'BR'));
      expect(en.vitalityRecovery, 'Recovery');
      expect(pt.vitalityRecovery, 'Recuperação');
      expect(pt.vitalityEnergy, 'Energia');
      expect(
        await rootBundle.loadString('assets/icons/site/vitality-settings.svg'),
        contains('<svg'),
      );
    },
  );
}
