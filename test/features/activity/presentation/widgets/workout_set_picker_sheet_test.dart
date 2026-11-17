import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_jcvital/features/activity/presentation/models/exercise_catalog_item.dart';
import 'package:new_jcvital/features/activity/presentation/models/workout_draft_exercise.dart';
import 'package:new_jcvital/features/activity/presentation/widgets/workout_set_picker_sheet.dart';
import 'package:new_jcvital/l10n/generated/app_localizations.dart';

void main() {
  ExerciseCatalogItem exercise(String unit, {bool bodyweight = false}) =>
      ExerciseCatalogItem(
        id: 'test',
        name: 'Test',
        muscles: const [],
        equipment: '',
        group: '',
        tip: '',
        level: '',
        unit: unit,
        bodyweight: bodyweight,
      );

  Future<void> showPicker(
    WidgetTester tester,
    WorkoutDraftExercise exercise,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('pt', 'BR'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: WorkoutSetPickerSheet(
            item: exercise,
            set: exercise.sets.first,
            number: 1,
            onChanged: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('秒数动作只有一个滚轮并以五秒为间隔', (tester) async {
    final item = WorkoutDraftExercise(exercise('seg'));
    await showPicker(tester, item);
    expect(find.byType(CupertinoPicker), findsOneWidget);
    final picker = tester.widget<CupertinoPicker>(find.byType(CupertinoPicker));
    (picker.scrollController!).jumpToItem(6);
    await tester.pumpAndSettle();
    expect(item.sets.first.amount, 35);
    expect(item.sets.first.weight, 0);
    expect(tester.takeException(), isNull);
  });

  testWidgets('体重动作不显示重量滚轮，原有非标准数值不被静默改写', (tester) async {
    final item = WorkoutDraftExercise(exercise('reps', bodyweight: true));
    item.sets.first.amount = 55;
    await showPicker(tester, item);
    expect(find.byType(CupertinoPicker), findsOneWidget);
    expect(item.sets.first.amount, 55);
    expect(find.text('55'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
