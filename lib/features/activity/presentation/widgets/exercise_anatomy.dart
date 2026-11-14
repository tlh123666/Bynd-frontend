import 'package:flutter/material.dart';

import '../../../../design_system/design_system.dart';
import '../models/exercise_anatomy_assets.dart';
import '../models/exercise_catalog_item.dart';

/// 使用从网页原型导出的动作帧；列表显示静态姿势，详情播放循环动作。
class ExerciseAnatomy extends StatelessWidget {
  const ExerciseAnatomy({
    required this.exercise,
    this.animate = false,
    this.size,
    super.key,
  });
  final ExerciseCatalogItem exercise;
  final bool animate;
  final double? size;

  @override
  Widget build(BuildContext context) {
    if (!exerciseAnatomyLegends.containsKey(exercise.id)) {
      return SizedBox(
        width: size,
        height: size,
        child: Icon(
          Icons.fitness_center,
          size: size == null ? 48 : size! * .5,
          color: AppColors.textMuted,
        ),
      );
    }
    // 关闭动画或系统开启减少动态效果时，始终使用原型的静态姿势。
    final motion =
        animate &&
        !MediaQuery.disableAnimationsOf(context) &&
        TickerMode.valuesOf(context).enabled;
    // 列表维持小尺寸静态图；详情使用 600px 高清素材，避免放大模糊。
    final variant = motion ? 'motion-hd' : (animate ? 'still-hd' : 'still');
    return Image.asset(
      'assets/images/exercise_anatomy/${exerciseAnatomyAssetId(exercise.id)}-$variant.webp',
      key: ValueKey<String>(
        'anatomy-${exercise.id}-${motion ? 'motion' : 'still'}',
      ),
      width: size,
      height: size,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      excludeFromSemantics: true,
      errorBuilder: (_, _, _) => SizedBox(
        width: size,
        height: size,
        child: Icon(
          Icons.fitness_center,
          size: size == null ? 48 : size! * .5,
          color: AppColors.textMuted,
        ),
      ),
    );
  }
}
