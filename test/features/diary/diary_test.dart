import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:new_jcvital/core/network/api_client.dart';
import 'package:new_jcvital/design_system/design_system.dart';
import 'package:new_jcvital/features/diary/data/demo_diary_repository.dart';
import 'package:new_jcvital/features/diary/data/remote_diary_repository.dart';
import 'package:new_jcvital/features/diary/domain/diary_models.dart';
import 'package:new_jcvital/features/diary/presentation/diary_page.dart';
import 'package:new_jcvital/features/diary/presentation/diary_record_sheet.dart';
import 'package:new_jcvital/l10n/generated/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:new_jcvital/core/auth/auth_session.dart';

class MemoryDiary extends DemoDiaryRepository {
  DiaryDay day = DiaryDay(date: DateTime.now(), events: []);
  int saves = 0;
  @override
  Future<DiaryDay> load(DateTime date) async => day;
  @override
  Future<List<DiaryTracker>> catalog() async => [
    const DiaryTracker({
      'key': 'vit',
      'label': 'Vitaminas',
      'icon': 'cap',
      'kind': 'boolean',
      'enabled': true,
    }),
    const DiaryTracker({
      'key': 'humor',
      'label': 'Humor',
      'prompt': 'Como está o humor?',
      'icon': 'mente',
      'kind': 'scale',
      'values': [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
      'enabled': true,
    }),
    const DiaryTracker({
      'key': 'cafe15',
      'label': 'Café depois das 15h',
      'icon': 'cafe',
      'kind': 'quantity',
      'values': ['15:00', '15:30', '16:00'],
      'enabled': true,
    }),
  ];
  @override
  Future<DiaryDay> save(
    DiaryDay base,
    List<DiaryMoment> events,
    String note,
    String id,
  ) async {
    saves++;
    day = DiaryDay(
      date: base.date,
      events: [...events],
      note: note,
      revision: base.revision + 1,
    );
    return day;
  }
}

Future<void> mount(
  WidgetTester tester,
  MemoryDiary repo, {
  Size size = const Size(390, 844),
  double scale = 1,
  String? initialTracker,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.dark,
      locale: const Locale('pt', 'BR'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (c, child) => MediaQuery(
        data: MediaQuery.of(c).copyWith(textScaler: TextScaler.linear(scale)),
        child: child!,
      ),
      home: DiaryPage(
        repository: repo,
        openRecord: initialTracker != null,
        initialTracker: initialTracker,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> open(WidgetTester tester) async {
  await tester.tap(find.byTooltip('Registrar'));
  await tester.pumpAndSettle();
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));
  test(
    'all diary catalog icons and meal illustrations are bundled and parse',
    () async {
      final catalog =
          jsonDecode(
                await rootBundle.loadString('assets/data/diary-catalog.json'),
              )
              as List;
      final meals =
          jsonDecode(
                await rootBundle.loadString('assets/data/diary-meals.json'),
              )
              as List;
      final paths = <String>{
        ...catalog.map((e) => 'assets/icons/site/diary-${e['icon']}.svg'),
        ...meals.map((e) => 'assets/images/diary/${e['key']}.svg'),
      };
      for (final path in paths) {
        final xml = await rootBundle.loadString(path);
        final result = await vg.loadPicture(SvgStringLoader(xml), null);
        result.picture.dispose();
      }
      for (final meal in meals) {
        expect(
          (await rootBundle.load(
            'assets/images/diary/${meal['key']}.png',
          )).lengthInBytes,
          greaterThan(100),
        );
      }
    },
  );
  testWidgets(
    'switching accounts hides the open private diary and modal draft',
    (tester) async {
      FlutterSecureStorage.setMockInitialValues({});
      final session = AuthSession.instance;
      await session.setAccessToken('diary-account-a');
      final repo = MemoryDiary();
      repo.day = DiaryDay(
        date: DateTime.now(),
        events: [
          DiaryMoment({
            'id': diaryId(),
            'label': 'Private event A',
            'occurredAt': DateTime.now().toIso8601String(),
            'valueKey': 'vit',
            'details': {'icon': 'cap'},
          }),
        ],
      );
      await mount(tester, repo);
      expect(find.text('Private event A'), findsOneWidget);
      await open(tester);
      await session.setAccessToken('diary-account-b');
      await tester.pumpAndSettle();
      expect(find.text('Private event A'), findsNothing);
      expect(find.text('Vitaminas'), findsNothing);
      expect(repo.saves, 0);
      await tester.pumpWidget(const SizedBox());
      await session.signOut();
    },
  );
  test(
    'real adapter preserves IDs, selected local day, revision and retry mutation',
    () async {
      late http.Request sent;
      final api = ApiClient(
        baseUrl: Uri.parse('https://api.example/api/v1'),
        tokenProvider: () async => 'token',
        client: MockClient((r) async {
          sent = r;
          return http.Response(
            jsonEncode({
              'code': 0,
              'data': {
                'date': '2026-11-09',
                'events': [],
                'revision': 2,
                'editable': true,
              },
            }),
            200,
          );
        }),
      );
      final repo = RemoteDiaryRepository(api, timezone: () => 'Asia/Shanghai');
      final base = DiaryDay(
        date: DateTime(2026, 11, 9),
        events: [],
        revision: 1,
      );
      final moment = DiaryMoment({
        'id': diaryId(),
        'valueKey': 'humor',
        'label': 'Humor',
        'category': 'mood',
        'occurredAt': '2026-11-09T07:05:00+08:00',
        'numericValue': 7,
        'details': {'kind': 'scale'},
      });
      final id = diaryId();
      await repo.save(base, [moment], 'private', id);
      final body = jsonDecode(sent.body) as Map;
      expect(sent.url.path, '/api/v1/me/diary/2026-11-09/workspace');
      expect(sent.headers['authorization'], 'Bearer token');
      expect(body['mutationId'], id);
      expect(body['revision'], 1);
      expect(body['note'], 'private');
      expect((body['events'] as List).single['id'], moment.id);
      expect(
        (body['events'] as List).single['occurredAt'],
        '2026-11-08T23:05:00.000Z',
      );
      repo.dispose();
    },
  );
  test(
    'demo data and catalog persist, source time choices are supported',
    () async {
      final now = DateTime(2026, 11, 9, 12);
      final r = DemoDiaryRepository(clock: () => now);
      final catalog = await r.catalog();
      expect(catalog.where((e) => !e.meal && e.key != 'gripe').length, 433);
      expect(
        catalog.firstWhere((e) => e.key == 'cafe15').timeValues.first,
        '15:00',
      );
      final day = await r.load(now);
      expect(day.events.length, 19);
      expect(day.automatic.length, 8);
      await r.save(day, day.events, 'my note', diaryId());
      final reopened = DemoDiaryRepository(clock: () => now);
      expect((await reopened.load(now)).note, 'my note');
    },
  );
  testWidgets(
    'record cancel discards draft; save commits once and updates timeline',
    (tester) async {
      final repo = MemoryDiary();
      await mount(tester, repo);
      await open(tester);
      await tester.tap(find.text('Vitaminas').first);
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.close).last);
      await tester.pumpAndSettle();
      expect(repo.saves, 0);
      expect(repo.day.events, isEmpty);
      await open(tester);
      await tester.tap(find.text('Vitaminas').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Salvar'));
      await tester.pumpAndSettle();
      expect(repo.saves, 1);
      expect(repo.day.events.single.key, 'vit');
      expect(find.byType(DiaryRecordSheet), findsNothing);
      expect(find.text('Vitaminas'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'nested rating closes into draft and saving keeps 1 to 10 score',
    (tester) async {
      final repo = MemoryDiary();
      await mount(tester, repo);
      await open(tester);
      await tester.scrollUntilVisible(
        find.byKey(const ValueKey('diary-tracker-humor')),
        150,
        scrollable: find
            .descendant(
              of: find.byType(DiaryRecordSheet),
              matching: find.byType(Scrollable),
            )
            .first,
      );
      await tester.tap(find.text('Humor').first);
      await tester.pumpAndSettle();
      final slider = find.byType(Slider);
      await tester.tapAt(
        tester.getRect(slider).centerRight - const Offset(22, 0),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Concluir'));
      await tester.pumpAndSettle();
      expect(repo.saves, 0);
      expect(find.byType(DiaryRecordSheet), findsOneWidget);
      await tester.tap(find.text('Salvar'));
      await tester.pumpAndSettle();
      expect(repo.day.events.single.value, greaterThanOrEqualTo(9));
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('time-choice behavior opens without numeric cast failures', (
    tester,
  ) async {
    final repo = MemoryDiary();
    await mount(
      tester,
      repo,
      size: const Size(320, 640),
      scale: 1.3,
      initialTracker: 'cafe15',
    );
    expect(find.text('15:30'), findsOneWidget);
    await tester.tap(find.text('Concluir'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();
    expect(repo.day.events.single.value, isNull);
    expect(tester.takeException(), isNull);
  });
}
