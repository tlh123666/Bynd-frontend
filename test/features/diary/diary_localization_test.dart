import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_jcvital/design_system/design_system.dart';
import 'package:new_jcvital/features/diary/data/demo_diary_repository.dart';
import 'package:new_jcvital/features/diary/domain/diary_models.dart';
import 'package:new_jcvital/features/diary/presentation/diary_catalog_sheet.dart';
import 'package:new_jcvital/features/diary/presentation/diary_capture_sheet.dart';
import 'package:new_jcvital/features/diary/presentation/diary_chapters_page.dart';
import 'package:new_jcvital/features/diary/presentation/diary_moment_editor.dart';
import 'package:new_jcvital/features/diary/presentation/localization/diary_builtin_copy.dart';
import 'package:new_jcvital/features/diary/presentation/localization/diary_localizations.dart';
import 'package:new_jcvital/l10n/generated/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart';

class CaptureLocaleDiary extends DemoDiaryRepository {
  String? parsedLocale;
  @override
  Future<List<DiaryMoment>> parse(
    String text,
    DateTime date,
    String locale, {
    bool voice = false,
  }) async {
    parsedLocale = locale;
    return [];
  }
}

class LocalizedDiary extends DemoDiaryRepository {
  int chapterLoads = 0;
  @override
  Future<List<Map<String, dynamic>>> chapters() {
    chapterLoads++;
    return super.chapters();
  }
}

Future<List<DiaryTracker>> catalog() async =>
    (jsonDecode(await rootBundle.loadString('assets/data/diary-catalog.json'))
            as List)
        .map((v) => DiaryTracker(Map<String, dynamic>.from(v as Map)))
        .toList();

Future<void> mount(
  WidgetTester tester,
  Widget page, {
  String locale = 'en',
}) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.dark,
      locale: locale == 'pt' ? const Locale('pt', 'BR') : const Locale('en'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: Scaffold(body: page),
    ),
  );
  // Asset bundle decoding uses real isolates; let that I/O complete outside fake time.
  await tester.runAsync(() async {
    await rootBundle.loadString('assets/data/diary-catalog.json');
    await rootBundle.loadString('assets/data/diary-meals.json');
  });
  await tester.pumpAndSettle();
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test(
    'every bundled catalog key has Portuguese and English labels and prompts',
    () async {
      final items = await catalog();
      expect(items.length, 516);
      final pt = lookupAppLocalizations(const Locale('pt', 'BR'));
      final en = lookupAppLocalizations(const Locale('en'));
      for (final item in items) {
        final original = diaryBuiltinCopy(pt, item.key);
        final english = diaryBuiltinCopy(en, item.key);
        expect(original, isNotNull, reason: item.key);
        expect(english, isNotNull, reason: item.key);
        expect(original!.label, item.label, reason: item.key);
        expect(original.prompt, item.prompt, reason: item.key);
        expect(english!.label, isNotEmpty, reason: item.key);
        expect(english.prompt, isNotEmpty, reason: item.key);
      }
    },
  );

  testWidgets(
    'translated labels, scales, units and decimal separator preserve raw API values',
    (tester) async {
      final items = (await tester.runAsync(catalog))!;
      final water = items.firstWhere((t) => t.key == 'agua');
      final mood = items.firstWhere((t) => t.key == 'humor');
      final event = DiaryMoment.forTracker(
        water,
        DateTime(2026, 11, 15),
      ).copy({'numericValue': 1.5});
      final raw = jsonEncode(event.json);
      late BuildContext context;
      final page = Builder(
        builder: (c) {
          context = c;
          return const SizedBox();
        },
      );
      await mount(tester, page);
      expect(diaryTrackerLabel(context, water), 'Drink water');
      expect(diaryTrackerPrompt(context, water), 'Did you drink water?');
      expect(diaryScaleLabels(context, mood).first, 'Very bad');
      expect(diaryUnit(context, 'vezes'), 'times');
      expect(diaryPortionLabel(context, 'Pesado'), 'Heavy');
      expect(diaryMomentValue(context, event), '1.5 ml');
      expect(diaryGroupLabel(context, 'Saúde hormonal'), 'Hormonal health');
      expect(
        diaryChapterPeriod(context, {
          'startDate': '2026-11-01',
          'endDate': '2026-11-15',
        }),
        contains(' to '),
      );
      await mount(tester, page, locale: 'pt');
      expect(diaryTrackerLabel(context, water), water.label);
      expect(diaryMomentValue(context, event), '1,5 ml');
      expect(diaryUnit(context, 'vezes'), 'vezes');
      expect(jsonEncode(event.json), raw);
    },
  );

  testWidgets(
    'custom names and free text never pass through preset translation',
    (tester) async {
      late BuildContext context;
      await mount(
        tester,
        Builder(
          builder: (c) {
            context = c;
            return const SizedBox();
          },
        ),
      );
      const custom = DiaryTracker({
        'key': 'u_private',
        'label': 'Humor',
        'prompt': 'Meu hábito',
        'custom': true,
      });
      expect(diaryTrackerLabel(context, custom), 'Humor');
      expect(diaryTrackerPrompt(context, custom), 'Meu hábito');
      const edited = DiaryMoment({
        'id': 'customized',
        'valueKey': 'humor',
        'label': 'Meu humor depois do trabalho',
        'note': 'Sono',
        'details': {'kind': 'meal'},
      });
      expect(diaryMomentLabel(context, edited), 'Meu humor depois do trabalho');
      expect(diaryMomentValue(context, edited), 'Sono');
    },
  );

  testWidgets('catalog searches English names and shows translated groups', (
    tester,
  ) async {
    final repo = LocalizedDiary();
    await tester.runAsync(repo.catalog);
    await mount(tester, DiaryCatalogSheet(repository: repo));
    await tester.enterText(
      find.byKey(const Key('diary-catalog-search')),
      'magnesium',
    );
    await tester.pumpAndSettle();
    expect(find.text('Magnesium'), findsOneWidget);
    expect(find.text('Did you take magnesium?'), findsOneWidget);
    expect(find.text('Movimento'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'meal templates translate foods and portions without changing macros',
    (tester) async {
      final meals = (await tester.runAsync(
        () async =>
            jsonDecode(
                  await rootBundle.loadString('assets/data/diary-meals.json'),
                )
                as List,
      ))!;
      late BuildContext context;
      final page = Builder(
        builder: (c) {
          context = c;
          return const SizedBox();
        },
      );
      await mount(tester, page);
      for (final raw in meals.cast<Map>()) {
        final original = jsonEncode(raw);
        final localized = diaryMealTemplate(context, raw);
        for (final key in ['key', 'p', 'c', 'g', 'f']) {
          expect(localized[key], raw[key]);
        }
        expect(jsonEncode(raw), original);
        expect('${localized['it']}', isNot(contains('unidades')));
        expect('${localized['it']}', isNot(contains('xícara')));
      }
      await mount(tester, const DiaryMealSearchSheet());
      await tester.enterText(find.byType(TextField), 'pumpkin');
      await tester.pumpAndSettle();
      expect(find.textContaining('Pumpkin soup'), findsOneWidget);
      expect(find.textContaining('· F '), findsOneWidget);
    },
  );

  testWidgets(
    'editing in English retains canonical meal portion and untouched preset label',
    (tester) async {
      final items = (await tester.runAsync(catalog))!;
      final tracker = items.firstWhere((t) => t.key == 'almoco');
      final moment = DiaryMoment.forTracker(tracker, DateTime.now());
      DiaryMoment? saved;
      await mount(
        tester,
        Builder(
          builder: (c) => TextButton(
            onPressed: () async {
              saved = await Navigator.of(c).push<DiaryMoment>(
                MaterialPageRoute(
                  builder: (_) => Scaffold(
                    body: DiaryMomentEditor(
                      moment: moment,
                      tracker: tracker,
                      repository: LocalizedDiary(),
                      date: DateTime.now(),
                    ),
                  ),
                ),
              );
            },
            child: const Text('Open'),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      final heavy = find.text('Heavy');
      await tester.ensureVisible(heavy);
      await tester.tap(heavy);
      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();
      expect(saved!.details['portion'], 'Pesado');
      expect(saved!.label, moment.label);
    },
  );

  testWidgets(
    'mounted chapters reload in the new language and translate reference text',
    (tester) async {
      final repo = LocalizedDiary();
      final page = DiaryChaptersPage(repository: repo);
      await mount(tester, page);
      expect(find.text('Your chapters'), findsOneWidget);
      expect(find.text('The 14 km'), findsOneWidget);
      expect(repo.chapterLoads, 1);
      await mount(tester, page, locale: 'pt');
      expect(repo.chapterLoads, 2);
      expect(find.text('Seus capítulos'), findsOneWidget);
      expect(find.text('Os 14 km'), findsOneWidget);
    },
  );

  testWidgets(
    'capture switches native recognition and parser locale with the app language',
    (tester) async {
      const channel = MethodChannel('plugin.csdcorp.com/speech_to_text');
      final messenger = tester.binding.defaultBinaryMessenger;
      final listenedLocales = <String?>[];
      messenger.setMockMethodCallHandler(channel, (call) async {
        if (call.method == 'locales') {
          return ['en_US:English', 'pt_BR:Portuguese'];
        }
        if (call.method == 'listen') {
          listenedLocales.add((call.arguments as Map)['localeId'] as String?);
        }
        return true;
      });
      addTearDown(() => messenger.setMockMethodCallHandler(channel, null));
      final repo = CaptureLocaleDiary();
      final page = DiaryCaptureSheet(repository: repo, date: DateTime.now());
      await mount(tester, page);
      await tester.tap(find.text('Speak'));
      await tester.pumpAndSettle();
      expect(listenedLocales, ['en_US']);
      await SpeechToText().cancel();
      await mount(tester, page, locale: 'pt');
      await tester.tap(find.text('Falar'));
      await tester.pumpAndSettle();
      expect(listenedLocales, ['en_US', 'pt_BR']);
      await tester.enterText(
        find.byKey(const Key('diary-capture-text')),
        'Meu texto',
      );
      await tester.tap(find.text('Revisar registros'));
      await tester.pumpAndSettle();
      expect(repo.parsedLocale, 'pt-BR');
      await SpeechToText().cancel();
      await tester.pumpWidget(const SizedBox());
      await tester.pump();
    },
  );

  test(
    'speech locale uses supported native IDs and never silently changes language',
    () {
      expect(diarySpeechLocale('pt-BR', ['en_US', 'pt_PT', 'pt_BR']), 'pt_BR');
      expect(diarySpeechLocale('en', ['pt_BR', 'en_US']), 'en_US');
      expect(diarySpeechLocale('en-GB', ['en_US']), 'en_US');
      expect(diarySpeechLocale('pt-BR', ['en_US']), isNull);
    },
  );
}
