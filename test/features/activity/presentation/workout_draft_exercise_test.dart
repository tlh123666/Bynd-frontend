import 'package:flutter_test/flutter_test.dart';
import 'package:new_jcvital/features/activity/presentation/models/exercise_catalog_item.dart';
import 'package:new_jcvital/features/activity/presentation/models/workout_draft_exercise.dart';

void main() {
  ExerciseCatalogItem exercise({
    String unit = 'reps',
    bool bodyweight = false,
  }) => ExerciseCatalogItem(
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

  test('力量动作默认三组，重量按组数、次数和负重计算', () {
    final draft = WorkoutDraftExercise(exercise());
    expect(draft.sets.length, 3);
    expect(draft.liftedWeight, 300);
    draft.sets.first.weight = 20;
    expect(draft.liftedWeight, 400);
  });

  test('自重动作与计时动作不计入举重总量', () {
    final bodyweight = WorkoutDraftExercise(exercise(bodyweight: true));
    expect(bodyweight.sets.length, 3);
    expect(bodyweight.liftedWeight, 0);
    for (final unit in ['seg', 'min']) {
      final timed = WorkoutDraftExercise(exercise(unit: unit));
      expect(timed.sets.length, 1);
      expect(timed.sets.first.amount, unit == 'seg' ? 30 : 10);
      expect(timed.liftedWeight, 0);
    }
  });
}
