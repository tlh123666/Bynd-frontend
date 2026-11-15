import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../presentation/models/exercise_catalog_item.dart';
import '../presentation/models/workout_draft_exercise.dart';

/// 保存在当前设备的训练模板，不代表已完成的运动或服务器数据。
class LocalWorkoutPlan {
  LocalWorkoutPlan({required this.name, required this.exercises});
  final String name;
  final List<WorkoutDraftExercise> exercises;

  int get setCount => exercises.fold(0, (sum, item) => sum + item.sets.length);
  double get liftedWeight =>
      exercises.fold(0, (sum, item) => sum + item.liftedWeight);

  Map<String, Object> toJson() => {
    'name': name,
    'exercises': [
      for (final item in exercises)
        {
          'id': item.exercise.id,
          'sets': [
            for (final set in item.sets)
              {'amount': set.amount, 'weight': set.weight},
          ],
        },
    ],
  };

  /// 保存和开始时复制，避免多个页面共享可变的组数。
  LocalWorkoutPlan copy() => LocalWorkoutPlan(
    name: name,
    exercises: [for (final item in exercises) item.copy()],
  );
}

class LocalWorkoutStore {
  LocalWorkoutStore(String? userId)
    : _key =
          'activity.workouts.v1.${base64Url.encode(utf8.encode(userId == null ? 'guest:' : 'user:$userId'))}';
  final String _key;
  static Future<void>? _writes;

  Future<List<LocalWorkoutPlan>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];
    final decoded = jsonDecode(raw);
    if (decoded is! List) throw const FormatException('Invalid workout list');
    final catalog = {
      for (final item in await ExerciseCatalogItem.load()) item.id: item,
    };
    final plans = <LocalWorkoutPlan>[];
    for (final value in decoded) {
      if (value is! Map ||
          value['name'] is! String ||
          value['exercises'] is! List) {
        throw const FormatException('Invalid workout');
      }
      final exercises = <WorkoutDraftExercise>[];
      for (final row in value['exercises'] as List) {
        if (row is! Map || row['id'] is! String || row['sets'] is! List) {
          throw const FormatException('Invalid exercise');
        }
        final exercise = catalog[row['id']];
        if (exercise == null) throw const FormatException('Unknown exercise');
        final sets = <WorkoutDraftSet>[];
        for (final set in row['sets'] as List) {
          if (set is! Map ||
              set['amount'] is! int ||
              set['weight'] is! num ||
              (set['amount'] as int) < 1 ||
              (set['weight'] as num) < 0 ||
              !(set['weight'] as num).isFinite) {
            throw const FormatException('Invalid set');
          }
          sets.add(
            WorkoutDraftSet(
              amount: set['amount'] as int,
              weight: (set['weight'] as num).toDouble(),
            ),
          );
        }
        if (sets.isEmpty) throw const FormatException('Empty exercise');
        exercises.add(WorkoutDraftExercise.withSets(exercise, sets));
      }
      if (exercises.isEmpty) throw const FormatException('Empty workout');
      plans.add(
        LocalWorkoutPlan(name: value['name'] as String, exercises: exercises),
      );
    }
    return plans;
  }

  Future<void> add(LocalWorkoutPlan plan) {
    final snapshot = plan.copy();
    final result = Completer<void>();
    final finished = Completer<void>();
    // 串行化写入，避免并发保存互相覆盖。
    final previous = _writes;
    _writes = finished.future;
    Future<void> write() async {
      try {
        // 原数据读取失败时不能覆盖它，留待用户恢复。
        final plans = await load();
        plans.insert(0, snapshot);
        final prefs = await SharedPreferences.getInstance();
        if (!await prefs.setString(
          _key,
          jsonEncode([for (final item in plans) item.toJson()]),
        )) {
          throw StateError('Unable to save workout');
        }
        if (identical(_writes, finished.future)) _writes = null;
        finished.complete();
        result.complete();
      } catch (error, stack) {
        if (identical(_writes, finished.future)) _writes = null;
        finished.complete();
        result.completeError(error, stack);
      }
    }

    if (previous == null) {
      write();
    } else {
      previous.then((_) => write());
    }
    return result.future;
  }
}
