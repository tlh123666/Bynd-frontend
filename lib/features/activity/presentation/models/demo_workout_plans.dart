import '../../data/local_workout_store.dart';
import 'exercise_catalog_item.dart';
import 'workout_draft_exercise.dart';

/// 与网页原型一致的示例训练，所有数据均为演示用途。
Future<List<LocalWorkoutPlan>> demoWorkoutPlans(List<String> names) async {
  final catalog = {
    for (final exercise in await ExerciseCatalogItem.load())
      exercise.id: exercise,
  };
  const definitions = <List<(String, int, int, double)>>[
    [
      ('supino', 3, 8, 30),
      ('flexao', 3, 12, 0),
      ('prancha', 2, 45, 0),
      ('bike-ergometrica', 1, 10, 0),
    ],
    [
      ('agachamento', 4, 10, 40),
      ('terra-romeno', 3, 10, 35),
      ('pelvica', 4, 10, 50),
      ('afundo', 3, 12, 20),
      ('abdutora', 3, 15, 35),
    ],
    [
      ('supino-incl', 4, 10, 24),
      ('puxada', 4, 10, 35),
      ('remada-baixa', 3, 12, 30),
      ('desenvolvimento', 3, 10, 16),
      ('lateral', 3, 12, 10),
      ('triceps-polia', 3, 12, 15),
    ],
    [
      ('terra', 4, 6, 50),
      ('supino', 3, 8, 30),
      ('remada', 3, 10, 25),
      ('swing', 3, 15, 16),
      ('abdominal', 3, 15, 0),
    ],
    [
      ('legpress', 4, 12, 100),
      ('extensora', 3, 12, 30),
      ('flexora', 3, 12, 25),
      ('bulgaro', 3, 10, 16),
      ('panturrilha', 4, 15, 30),
    ],
    [
      ('supino', 4, 8, 30),
      ('puxada', 4, 10, 35),
      ('martelo', 3, 12, 16),
      ('triceps-frances', 3, 12, 12),
      ('elev-pernas', 3, 12, 0),
      ('prancha', 3, 45, 0),
    ],
    [
      ('agachamento', 3, 12, 10),
      ('pelvica', 3, 12, 20),
      ('remada-baixa', 2, 12, 20),
      ('prancha', 3, 30, 0),
    ],
  ];
  return [
    for (var i = 0; i < definitions.length; i++)
      LocalWorkoutPlan(
        id: 'demo:$i',
        name: names[i],
        exercises: [
          for (final (id, count, amount, weight) in definitions[i])
            WorkoutDraftExercise.withSets(catalog[id]!, [
              for (var j = 0; j < count; j++)
                WorkoutDraftSet(amount: amount, weight: weight),
            ]),
        ],
      ),
  ];
}
