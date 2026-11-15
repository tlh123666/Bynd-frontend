import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../design_system/design_system.dart';
import '../../../../l10n/app_localizations_context.dart';
import '../models/exercise_anatomy_assets.dart';
import '../models/exercise_catalog_item.dart';
import 'activity_frosted_sheet_header.dart';
import 'exercise_anatomy.dart';

/// 动作详情叠放在选择器上；返回 true 表示从详情中标记添加。
class ExerciseDetailSheet extends StatelessWidget {
  const ExerciseDetailSheet({
    required this.exercise,
    required this.selected,
    super.key,
  });
  final ExerciseCatalogItem exercise;
  final bool selected;

  static Future<bool> show(
    BuildContext context,
    ExerciseCatalogItem exercise, {
    required bool selected,
  }) async =>
      await AppFrostedModalSheet.show<bool>(
        context,
        topInset: math.max(MediaQuery.viewPaddingOf(context).top, 20) + 34,
        showHandle: false,
        barrierColor: AppColors.contentSheetVeil,
        waitForExit: true,
        builder: (_) =>
            ExerciseDetailSheet(exercise: exercise, selected: selected),
      ) ??
      false;

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final media = MediaQuery.of(context);
    final height = math.max(
      0.0,
      media.size.height -
          math.max(media.viewPadding.top, 20) -
          34 -
          media.viewPadding.bottom -
          media.viewInsets.bottom,
    );
    final legend = exerciseAnatomyLegends[exercise.id];
    final measure = switch (exercise.unit) {
      'seg' => s.exerciseDetailSeconds,
      'min' => s.exerciseDetailMinutes,
      _ =>
        exercise.bodyweight
            ? s.exerciseDetailRepsBody
            : s.exerciseDetailRepsWeight,
    };
    return SizedBox(
      height: height,
      child: Column(
        children: [
          ActivityFrostedSheetHeader(
            title: s.exerciseDetailTitle,
            height: math.min(62, height),
          ),
          Expanded(
            child: Stack(
              children: [
                ListView(
                  padding: EdgeInsets.fromLTRB(20, 4, 20, selected ? 30 : 90),
                  children: [
                    if (legend != null) ...[
                      Semantics(
                        label: s.exerciseDetailAnimation(exercise.name),
                        image: true,
                        child: ExerciseAnatomy(
                          exercise: exercise,
                          animate: true,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, bottom: 14),
                        child: Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Color(0xffff8a7a),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                legend,
                                style: AppTypography.caption.copyWith(
                                  fontSize: 12,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      const SizedBox(height: 24),
                      Semantics(
                        label: s.exerciseDetailNoAnimation,
                        child: const Icon(
                          Icons.fitness_center,
                          size: 60,
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                    Text(
                      exercise.name,
                      style: AppTypography.page.copyWith(
                        fontSize: 36,
                        fontWeight: FontWeight.w300,
                        height: 1.08,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      exercise.tip,
                      style: AppTypography.body.copyWith(
                        fontSize: 15,
                        height: 1.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 18),
                    _DetailLine(
                      label: s.exerciseDetailMuscles,
                      value: exercise.muscles.join(' · '),
                    ),
                    _DetailLine(
                      label: s.exerciseDetailEquipment,
                      value: exercise.equipment,
                    ),
                    _DetailLine(
                      label: s.exerciseDetailGroup,
                      value: exercise.group,
                    ),
                    if (exercise.level.isNotEmpty)
                      _DetailLine(
                        label: s.exerciseDetailLevel,
                        value: exercise.level,
                      ),
                    _DetailLine(label: s.exerciseDetailCountAs, value: measure),
                  ],
                ),
                if (!selected && height >= 180)
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 16,
                    child: Center(
                      child: SizedBox(
                        width: 272,
                        height: 48,
                        child: FilledButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xfff4f5f7),
                            foregroundColor: const Color(0xff121418),
                          ),
                          child: Text(s.exerciseDetailMark),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailLine extends StatelessWidget {
  const _DetailLine({required this.label, required this.value});
  final String label, value;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
    decoration: const BoxDecoration(
      border: Border(top: BorderSide(color: Color(0x14ffffff))),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTypography.body.copyWith(
              color: AppColors.textMuted,
              fontSize: 15,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: AppTypography.body.copyWith(fontSize: 15),
          ),
        ),
      ],
    ),
  );
}
