import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

import '../presentation/models/exercise_catalog_item.dart';
import '../presentation/models/workout_draft_exercise.dart';

/// 保存在当前设备的训练模板，不代表已完成的运动或服务器数据。
class LocalWorkoutPlan {
  LocalWorkoutPlan({String? id, required this.name, required this.exercises})
    : id = id ?? _newId();
  static String _newId() =>
      'local:${DateTime.now().microsecondsSinceEpoch}:${Random.secure().nextInt(1 << 32)}';
  final String id;
  final String name;
  final List<WorkoutDraftExercise> exercises;

  int get setCount => exercises.fold(0, (sum, item) => sum + item.sets.length);
  double get liftedWeight =>
      exercises.fold(0, (sum, item) => sum + item.liftedWeight);

  Map<String, Object> toJson() => {
    'id': id,
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
  LocalWorkoutPlan copy({String? id, String? name}) => LocalWorkoutPlan(
    id: id ?? this.id,
    name: name ?? this.name,
    exercises: [for (final item in exercises) item.copy()],
  );
}

class LocalWorkoutStore {
  LocalWorkoutStore(String? userId)
    : _key =
          'activity.workouts.v1.${base64Url.encode(utf8.encode(userId == null ? 'guest:' : 'user:$userId'))}';
  final String _key;
  static Future<void>? _writes;

  Future<List<dynamic>> _readEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];
    final decoded = jsonDecode(raw);
    if (decoded is! List) throw const FormatException('Invalid workout list');
    return decoded;
  }

  Future<List<LocalWorkoutPlan>> load() async => (await _readState()).$1;
  Future<Set<String>> hiddenDemoIds() async => (await _readState()).$2;

  Future<(List<LocalWorkoutPlan>, Set<String>)> _readState() async {
    final decoded = await _readEntries();
    final catalog = {
      for (final item in await ExerciseCatalogItem.load()) item.id: item,
    };
    final plans = <LocalWorkoutPlan>[];
    final hidden = <String>{};
    final ids = <String>{};
    for (var index = 0; index < decoded.length; index++) {
      final value = decoded[index];
      if (value is Map && value['deleted'] == true) {
        if (value['id'] is! String ||
            !(value['id'] as String).startsWith('demo:')) {
          throw const FormatException('Invalid deleted workout');
        }
        hidden.add(value['id'] as String);
        continue;
      }
      if (value is! Map ||
          value['name'] is! String ||
          value['exercises'] is! List) {
        throw const FormatException('Invalid workout');
      }
      final id = value['id'] ?? 'legacy:$index';
      if (id is! String || id.isEmpty || !ids.add(id)) {
        throw const FormatException('Invalid workout id');
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
        LocalWorkoutPlan(
          id: id,
          name: value['name'] as String,
          exercises: exercises,
        ),
      );
    }
    return (plans, hidden);
  }

  Future<void> add(LocalWorkoutPlan plan) => save(plan);

  /// 同一标识覆盖已有模板；旧版本无标识数据在首次写入时安全迁移。
  Future<void> save(LocalWorkoutPlan plan) {
    final snapshot = plan.copy();
    return _mutate((plans, hidden) {
      final index = plans.indexWhere((p) => p.id == snapshot.id);
      if (index < 0) {
        plans.insert(0, snapshot);
      } else {
        plans[index] = snapshot;
      }
      hidden.remove(snapshot.id);
    });
  }

  /// 编辑已删除的本地模板时拒绝覆盖，避免旧页面重新创建已删除的数据。
  Future<void> update(LocalWorkoutPlan plan) {
    final snapshot = plan.copy();
    return _mutate((plans, hidden) {
      final index = plans.indexWhere((p) => p.id == snapshot.id);
      if (index < 0 &&
          (!snapshot.id.startsWith('demo:') || hidden.contains(snapshot.id))) {
        throw StateError('Workout no longer exists');
      }
      if (index < 0) {
        plans.insert(0, snapshot);
      } else {
        plans[index] = snapshot;
      }
    });
  }

  Future<void> duplicate(
    LocalWorkoutPlan plan, {
    Iterable<LocalWorkoutPlan> demoPlans = const [],
  }) {
    final snapshot = plan.copy();
    final demos = demoPlans.map((p) => p.copy()).toList();
    return _mutate((plans, hidden) {
      if (snapshot.id.startsWith('demo:')
          ? hidden.contains(snapshot.id)
          : !plans.any((p) => p.id == snapshot.id)) {
        throw StateError('Workout no longer exists');
      }
      // 示例可能已被修改或隐藏，按当前实际可见的训练名称避开重名。
      final overriddenIds = plans.map((p) => p.id).toSet();
      final names = {
        for (final p in plans) p.name.trim().toLowerCase(),
        for (final p in demos)
          if (!hidden.contains(p.id) && !overriddenIds.contains(p.id))
            p.name.trim().toLowerCase(),
      };
      var n = 2;
      var name = '${snapshot.name} ($n)';
      while (names.contains(name.toLowerCase())) {
        n++;
        name = '${snapshot.name} ($n)';
      }
      plans.insert(
        0,
        LocalWorkoutPlan(
          name: name,
          exercises: snapshot.exercises.map((e) => e.copy()).toList(),
        ),
      );
    });
  }

  Future<void> delete(String id) => _mutate((plans, hidden) {
    final index = plans.indexWhere((p) => p.id == id);
    if (index >= 0) plans.removeAt(index);
    if (id.startsWith('demo:')) {
      hidden.add(id);
    } else if (index < 0) {
      throw StateError('Workout no longer exists');
    }
  });

  Future<void> _mutate(
    void Function(List<LocalWorkoutPlan>, Set<String>) change,
  ) {
    final result = Completer<void>();
    final finished = Completer<void>();
    // 串行化写入，避免并发保存互相覆盖。
    final previous = _writes;
    _writes = finished.future;
    Future<void> write() async {
      try {
        // 原数据读取失败时不能覆盖它，留待用户恢复。
        final (plans, hidden) = await _readState();
        change(plans, hidden);
        final prefs = await SharedPreferences.getInstance();
        if (!await prefs.setString(
          _key,
          jsonEncode([
            for (final item in plans) item.toJson(),
            for (final id in hidden) {'id': id, 'deleted': true},
          ]),
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
