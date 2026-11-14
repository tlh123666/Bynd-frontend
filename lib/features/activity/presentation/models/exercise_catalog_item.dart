part 'exercise_catalog_data.dart';

/// 原型目录的静态动作资料，不包含用户训练或设备数据。
/// 来源：bynd-app/src/exercicios.js；原型注明肌肉数据源为 Unlicense。
class ExerciseCatalogItem {
  const ExerciseCatalogItem({
    required this.id,
    required this.name,
    required this.muscles,
    required this.equipment,
    required this.group,
    required this.tip,
    required this.level,
    required this.unit,
    required this.bodyweight,
  });
  final String id, name, equipment, group, tip, level, unit;
  final bool bodyweight;
  final List<String> muscles;

  /// 编译时包含目录，避免开发服务器或离线缓存遗漏新资源导致加载失败。
  static Future<List<ExerciseCatalogItem>> load() async => _exerciseCatalog;
}
