import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../design_system/design_system.dart';
import '../../../../core/auth/auth_scope.dart';
import '../../data/local_workout_store.dart';
import '../../../../l10n/app_localizations_context.dart';
import '../../domain/models/activity_type.dart';
import '../localization/activity_type_localizations.dart';
import '../models/demo_workout_plans.dart';
import 'activity_type_icon.dart';
import 'workout_builder_sheet.dart';
import 'activity_frosted_sheet_header.dart';

/// 力量训练选择叶片；示例和本地模板分别标记来源。
class StrengthWorkoutSheet extends StatefulWidget {
  const StrengthWorkoutSheet({
    required this.activity,
    this.localPlans = const [],
    this.loadFailed = false,
    required this.store,
    required this.demoPlans,
    required this.hiddenDemoIds,
    super.key,
  });
  final ActivityType activity;
  final List<LocalWorkoutPlan> localPlans;
  final bool loadFailed;
  final LocalWorkoutStore store;
  final List<LocalWorkoutPlan> demoPlans;
  final Set<String> hiddenDemoIds;

  /// 选择新建时先关闭本叶片；编辑器关闭后恢复训练列表。
  static Future<StrengthWorkoutResult?> show(
    BuildContext context,
    ActivityType activity,
  ) async {
    // 按登录用户隔离本地模板，访客使用独立命名空间。
    final store = LocalWorkoutStore(AuthScope.maybeOf(context)?.userId);
    final s = context.l10n;
    final demos = await demoWorkoutPlans([
      s.strengthDemoName1,
      s.strengthDemoName2,
      s.strengthDemoName3,
      s.strengthDemoName4,
      s.strengthDemoName5,
      s.strengthDemoName6,
      s.strengthDemoName7,
    ]);
    while (context.mounted) {
      List<LocalWorkoutPlan> plans = [];
      Set<String> hidden = {};
      var loadFailed = false;
      try {
        plans = await store.load();
        hidden = await store.hiddenDemoIds();
      } catch (_) {
        loadFailed = true;
      }
      if (!context.mounted) return null;
      final action = await AppFrostedModalSheet.show<_StrengthAction>(
        context,
        topInset: math.max(MediaQuery.viewPaddingOf(context).top, 20) + 34,
        showHandle: false,
        barrierColor: AppColors.contentSheetVeil,
        waitForExit: true,
        builder: (_) => StrengthWorkoutSheet(
          activity: activity,
          localPlans: plans,
          loadFailed: loadFailed,
          store: store,
          demoPlans: demos,
          hiddenDemoIds: hidden,
        ),
      );
      if (!context.mounted || action == null) return null;
      if (action.kind == _StrengthActionKind.start) {
        return StrengthWorkoutResult(action.plan?.copy());
      }
      final plan = await WorkoutBuilderSheet.show(
        context,
        store: store,
        initialPlan: action.kind == _StrengthActionKind.edit
            ? action.plan
            : null,
      );
      if (!context.mounted) return null;
      if (plan != null) return StrengthWorkoutResult(plan);
    }
    return null;
  }

  @override
  State<StrengthWorkoutSheet> createState() => _StrengthWorkoutSheetState();
}

class StrengthWorkoutResult {
  const StrengthWorkoutResult(this.plan);
  final LocalWorkoutPlan? plan;
}

enum _StrengthActionKind { start, build, edit }

class _StrengthAction {
  const _StrengthAction(this.kind, [this.plan]);
  final _StrengthActionKind kind;
  final LocalWorkoutPlan? plan;
}

class _StrengthWorkoutSheetState extends State<StrengthWorkoutSheet> {
  late List<LocalWorkoutPlan> _plans = widget.localPlans;
  late Set<String> _hidden = widget.hiddenDemoIds;
  bool _actionFailed = false;
  bool _busy = false;

  Future<void> _showOptions(
    BuildContext anchorContext,
    LocalWorkoutPlan plan,
  ) async {
    if (_busy) return;
    final box = anchorContext.findRenderObject() as RenderBox;
    final overlay =
        Navigator.of(anchorContext).overlay!.context.findRenderObject()
            as RenderBox;
    final anchor = MatrixUtils.transformRect(
      box.getTransformTo(overlay),
      Offset.zero & box.size,
    );
    final s = context.l10n;
    final action = await AppFrostedContextMenu.show<_WorkoutMenuAction>(
      anchorContext,
      anchor: anchor,
      items: [
        AppFrostedMenuItem(
          value: _WorkoutMenuAction.edit,
          label: s.workoutMenuEdit,
          icon: Icons.edit_outlined,
        ),
        AppFrostedMenuItem(
          value: _WorkoutMenuAction.duplicate,
          label: s.workoutDuplicateExercise,
          icon: Icons.copy_outlined,
        ),
        AppFrostedMenuItem(
          value: _WorkoutMenuAction.delete,
          label: s.workoutMenuDelete,
          icon: Icons.delete_outline,
          destructive: true,
        ),
      ],
    );
    if (!mounted || action == null) return;
    if (action == _WorkoutMenuAction.edit) {
      Navigator.pop(
        context,
        _StrengthAction(_StrengthActionKind.edit, plan.copy()),
      );
      return;
    }
    if (action == _WorkoutMenuAction.delete) {
      final confirmed = await AppConfirmationSheet.show(
        context,
        title: s.workoutDeleteTitle,
        message: s.workoutDeleteMessage(plan.name),
        confirmLabel: s.workoutMenuDelete,
        cancelLabel: s.workoutCancel,
        danger: true,
      );
      if (!mounted || !confirmed) return;
    }
    if (_busy) return;
    setState(() {
      _busy = true;
      _actionFailed = false;
    });
    try {
      if (action == _WorkoutMenuAction.delete) {
        await widget.store.delete(plan.id);
      } else {
        await widget.store.duplicate(plan);
      }
      final plans = await widget.store.load();
      final hidden = await widget.store.hiddenDemoIds();
      if (mounted) {
        setState(() {
          _plans = plans;
          _hidden = hidden;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _actionFailed = true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

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
    final local = _plans.where((p) => !p.id.startsWith('demo:')).toList();
    final overrides = {
      for (final plan in _plans.where((p) => p.id.startsWith('demo:')))
        plan.id: plan,
    };
    final demos = [
      for (final plan in widget.demoPlans)
        if (!_hidden.contains(plan.id)) overrides[plan.id] ?? plan,
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
                  onTap: () => Navigator.pop(
                    context,
                    const _StrengthAction(_StrengthActionKind.start),
                  ),
                ),
                _SectionLabel(
                  label: s.yourWorkouts,
                  count: demos.length + local.length,
                ),
                if (widget.loadFailed)
                  Text(
                    s.workoutLoadError,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                if (_actionFailed)
                  Text(
                    s.workoutActionError,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                if (local.isNotEmpty || overrides.isNotEmpty)
                  Text(
                    s.workoutLocalNote,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textMuted,
                      fontSize: 11,
                    ),
                  ),
                for (final plan in local)
                  _WorkoutRow(
                    icon: ActivityTypeIcon(
                      type: widget.activity,
                      fallback: Icons.fitness_center,
                      size: 20,
                    ),
                    title: plan.name,
                    subtitle: s.strengthExerciseCount(
                      plan.exercises.length,
                      plan.setCount,
                    ),
                    onTap: () => Navigator.pop(
                      context,
                      _StrengthAction(_StrengthActionKind.start, plan),
                    ),
                    optionsLabel: s.strengthOptions(plan.name),
                    onOptions: (anchor) => _showOptions(anchor, plan),
                  ),
                // 提醒示例来源，避免将原型模板误认为账号中的真实训练。
                Text(
                  s.strengthDemoNote,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 11,
                  ),
                ),
                for (final plan in demos)
                  _WorkoutRow(
                    icon: ActivityTypeIcon(
                      type: widget.activity,
                      fallback: Icons.fitness_center,
                      size: 20,
                    ),
                    title: plan.name,
                    subtitle: s.strengthExerciseCount(
                      plan.exercises.length,
                      plan.setCount,
                    ),
                    onTap: () => Navigator.pop(
                      context,
                      _StrengthAction(_StrengthActionKind.start, plan),
                    ),
                    optionsLabel: s.strengthOptions(plan.name),
                    onOptions: (anchor) => _showOptions(anchor, plan),
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
                  onTap: () => Navigator.pop(
                    context,
                    const _StrengthAction(_StrengthActionKind.build),
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

enum _WorkoutMenuAction { edit, duplicate, delete }

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
  final ValueChanged<BuildContext>? onOptions;
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
            child: Builder(
              builder: (buttonContext) => IconButton(
                onPressed: () => onOptions!(buttonContext),
                icon: const Icon(
                  Icons.more_horiz,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          )
        else
          const Icon(Icons.chevron_right, size: 16, color: AppColors.textMuted),
      ],
    ),
  );
}
