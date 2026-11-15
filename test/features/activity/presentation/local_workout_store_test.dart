import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:new_jcvital/features/activity/data/local_workout_store.dart';
import 'package:new_jcvital/features/activity/presentation/models/exercise_catalog_item.dart';
import 'package:new_jcvital/features/activity/presentation/models/workout_draft_exercise.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('本地模板按账号隔离，保存与读取保留每组数据', () async {
    final exercise = (await ExerciseCatalogItem.load()).first;
    final draft = WorkoutDraftExercise(exercise);
    draft.sets.first.amount = 8;
    draft.sets.first.weight = 12.5;
    final original = LocalWorkoutPlan(name: 'Treino', exercises: [draft]);
    final alice = LocalWorkoutStore('alice');
    await alice.add(original);
    draft.sets.first.amount = 20;
    final restored = await alice.load();
    expect(restored.single.name, 'Treino');
    expect(restored.single.exercises.single.sets.first.amount, 8);
    expect(restored.single.exercises.single.sets.first.weight, 12.5);
    expect(await LocalWorkoutStore('bob').load(), isEmpty);
    expect(await LocalWorkoutStore(null).load(), isEmpty);
  });

  test('损坏的模板不会被新的保存覆盖', () async {
    final key =
        'activity.workouts.v1.${base64Url.encode(utf8.encode('user:alice'))}';
    SharedPreferences.setMockInitialValues({key: '{broken'});
    final exercise = (await ExerciseCatalogItem.load()).first;
    final store = LocalWorkoutStore('alice');
    await expectLater(
      store.add(
        LocalWorkoutPlan(
          name: 'A',
          exercises: [WorkoutDraftExercise(exercise)],
        ),
      ),
      throwsFormatException,
    );
    expect((await SharedPreferences.getInstance()).getString(key), '{broken');
  });
  test('并发保存不会覆盖之前的模板', () async {
    final exercise = (await ExerciseCatalogItem.load()).first;
    final store = LocalWorkoutStore('alice');
    await Future.wait([
      store.add(
        LocalWorkoutPlan(
          name: 'A',
          exercises: [WorkoutDraftExercise(exercise)],
        ),
      ),
      LocalWorkoutStore('alice').add(
        LocalWorkoutPlan(
          name: 'B',
          exercises: [WorkoutDraftExercise(exercise)],
        ),
      ),
    ]);
    expect((await store.load()).map((e) => e.name), ['B', 'A']);
  });
}
