import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_jcvital/design_system/design_system.dart';
import 'package:new_jcvital/features/diary/data/demo_diary_repository.dart';
import 'package:new_jcvital/features/diary/domain/diary_models.dart';
import 'package:new_jcvital/features/sleep/presentation/widgets/sleep_habits_card.dart';
import 'package:new_jcvital/l10n/generated/app_localizations.dart';

class HabitRepository extends DemoDiaryRepository {
  DiaryDay day = DiaryDay(date: DateTime(2026, 11, 14), events: const []);
  DiaryDay? savedBase;
  @override
  Future<DiaryDay> load(DateTime date) async => day;
  @override
  Future<List<DiaryTracker>> catalog() async => [
    for (final key in ['cafe15', 'alc', 'tela'])
      DiaryTracker({'key': key, 'label': key, 'kind': 'boolean'}),
  ];
  @override
  Future<DiaryDay> save(
    DiaryDay base,
    List<DiaryMoment> events,
    String note,
    String mutationId,
  ) async {
    savedBase = base;
    expect(mutationId, isNotEmpty);
    return day = DiaryDay(
      date: base.date,
      events: events,
      note: note,
      revision: base.revision + 1,
    );
  }
}

void main() {
  testWidgets(
    'habit answers merge the latest diary revision and preserve unrelated records',
    (tester) async {
      final repo = HabitRepository();
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.dark,
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SingleChildScrollView(
              child: SleepHabitsCard(
                repository: repo,
                date: repo.day.date,
                onBusyChanged: (_) {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      repo.day = DiaryDay(
        date: repo.day.date,
        events: const [
          DiaryMoment({'id': 'other', 'valueKey': 'agua', 'numericValue': 500}),
        ],
        note: 'Keep my note',
        revision: 7,
      );
      final yes = find.byKey(const ValueKey('sleep-habit-cafe15-true'));
      await tester.tap(yes);
      await tester.pumpAndSettle();
      expect(repo.savedBase!.revision, 7);
      expect(repo.day.note, 'Keep my note');
      expect(repo.day.events.map((e) => e.key), ['agua', 'cafe15']);
      expect(repo.day.events.last.happened, isTrue);
      expect(repo.day.events.last.value, isNull);
      await tester.tap(yes);
      await tester.pumpAndSettle();
      expect(repo.day.events.map((e) => e.key), ['agua']);
      await tester.tap(find.byKey(const ValueKey('sleep-habit-cafe15-false')));
      await tester.pumpAndSettle();
      expect(repo.day.events.last.happened, isFalse);
      expect(tester.takeException(), isNull);
    },
  );
}
