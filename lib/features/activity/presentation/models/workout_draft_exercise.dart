import 'exercise_catalog_item.dart';

/// 按原型创建的训练草稿，不代表已经完成的训练或设备测量数据。
class WorkoutDraftExercise {
  WorkoutDraftExercise(this.exercise)
    : sets = List.generate(
        exercise.unit == 'reps' ? 3 : 1,
        (_) => WorkoutDraftSet(
          amount: exercise.unit == 'seg' ? 30 : 10,
          weight: exercise.unit == 'reps' && !exercise.bodyweight ? 10 : 0,
        ),
      );

  WorkoutDraftExercise.withSets(this.exercise, List<WorkoutDraftSet> values)
    : sets = [
        for (final value in values)
          WorkoutDraftSet(amount: value.amount, weight: value.weight),
      ];

  WorkoutDraftExercise copy() => WorkoutDraftExercise.withSets(exercise, sets);

  final ExerciseCatalogItem exercise;
  final List<WorkoutDraftSet> sets;

  /// 自重与计时动作不纳入举重总量，与网页原型的计算规则一致。
  double get liftedWeight => exercise.bodyweight || exercise.unit != 'reps'
      ? 0
      : sets.fold(0, (total, set) => total + set.amount * set.weight);
}

class WorkoutDraftSet {
  WorkoutDraftSet({required this.amount, required this.weight});
  int amount;
  double weight;
}
