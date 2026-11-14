import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../design_system/design_system.dart';
import '../../../../l10n/app_localizations_context.dart';
import '../../domain/models/activity_type.dart';
import '../localization/activity_type_localizations.dart';
import 'activity_type_icon.dart';
import 'workout_builder_sheet.dart';
import 'activity_frosted_sheet_header.dart';

/// 力量训练选择叶片；模板仅用于还原示例，不代表用户已保存的训练。
class StrengthWorkoutSheet extends StatefulWidget {
  const StrengthWorkoutSheet({required this.activity, super.key});
  final ActivityType activity;

  /// 选择新建时先关闭本叶片；编辑器关闭后恢复训练列表。
  static Future<bool> show(BuildContext context, ActivityType activity) async {
    while (true) {
      if (!context.mounted) return false;
      final action = await AppFrostedModalSheet.show<_StrengthAction>(
        context,
        topInset: math.max(MediaQuery.viewPaddingOf(context).top, 20) + 34,
        showHandle: false,
        barrierColor: AppColors.contentSheetVeil,
        waitForExit: true,
        builder: (_) => StrengthWorkoutSheet(activity: activity),
      );
      if (!context.mounted || action == null) return false;
      if (action == _StrengthAction.start) return true;
      await WorkoutBuilderSheet.show(context);
    }
  }

  @override
  State<StrengthWorkoutSheet> createState() => _StrengthWorkoutSheetState();
}

enum _StrengthAction { start, build }

class _StrengthWorkoutSheetState extends State<StrengthWorkoutSheet> {
  bool _showUnavailable = false;

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
    final workouts = <(String, int, int)>[
      (s.strengthDemoName1, 4, 9),
      (s.strengthDemoName2, 5, 17),
      (s.strengthDemoName3, 6, 20),
      (s.strengthDemoName4, 5, 16),
      (s.strengthDemoName5, 5, 17),
      (s.strengthDemoName6, 6, 20),
      (s.strengthDemoName7, 4, 11),
    ];
    return SizedBox(
      height: height,
      child: Column(
        children: [
          ActivityFrostedSheetHeader(
            height: math.min(62, height),
            title: activityTypeLocalizedName(widget.activity, s),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              children: [
                _WorkoutRow(
                  icon: const Icon(
                    Icons.play_circle_outline,
                    size: 20,
                    color: AppColors.textSecondary,
                  ),
                  title: s.startWithoutPlan,
                  subtitle: s.exercisesCanBeAddedLater,
                  onTap: () => Navigator.pop(context, _StrengthAction.start),
                ),
                _SectionLabel(label: s.yourWorkouts, count: workouts.length),
                // 提醒示例来源，避免将原型模板误认为账号中的真实训练。
                Text(
                  s.strengthDemoNote,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 11,
                  ),
                ),
                if (_showUnavailable)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      s.strengthDemoUnavailable,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                for (final (name, exercises, sets) in workouts)
                  _WorkoutRow(
                    icon: ActivityTypeIcon(
                      type: widget.activity,
                      fallback: Icons.fitness_center,
                      size: 20,
                    ),
                    title: name,
                    subtitle: s.strengthExerciseCount(exercises, sets),
                    onTap: () => setState(() => _showUnavailable = true),
                    optionsLabel: s.strengthOptions(name),
                    onOptions: () => setState(() => _showUnavailable = true),
                  ),
                _SectionLabel(label: s.otherWays),
                _WorkoutRow(
                  icon: const Icon(
                    Icons.add,
                    size: 20,
                    color: AppColors.textSecondary,
                  ),
                  title: s.buildWorkout,
                  subtitle: s.strengthCreateHint,
                  onTap: () => Navigator.pop(context, _StrengthAction.build),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label, this.count});
  final String label;
  final int? count;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 24, bottom: 10),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label.toUpperCase(),
            style: AppTypography.caption.copyWith(
              color: AppColors.textHalf,
              fontSize: 11,
              letterSpacing: 1.54,
            ),
          ),
        ),
        if (count != null)
          Text(
            '$count',
            style: AppTypography.caption.copyWith(
              color: AppColors.textHalf,
              fontSize: 11,
            ),
          ),
      ],
    ),
  );
}

class _WorkoutRow extends StatelessWidget {
  const _WorkoutRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.optionsLabel,
    this.onOptions,
  });
  final Widget icon;
  final String title, subtitle;
  final VoidCallback onTap;
  final String? optionsLabel;
  final VoidCallback? onOptions;
  @override
  Widget build(BuildContext context) => Container(
    height: 72,
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: Color(0x14ffffff))),
    ),
    child: Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: onTap,
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            child: Row(
              children: [
                SizedBox(width: 24, child: Center(child: icon)),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.listItem.copyWith(fontSize: 15),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.caption.copyWith(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (onOptions != null)
          Semantics(
            label: optionsLabel,
            button: true,
            child: IconButton(
              onPressed: onOptions,
              icon: const Icon(
                Icons.more_horiz,
                size: 18,
                color: AppColors.textSecondary,
              ),
            ),
          )
        else
          const Icon(Icons.chevron_right, size: 16, color: AppColors.textMuted),
      ],
    ),
  );
}
