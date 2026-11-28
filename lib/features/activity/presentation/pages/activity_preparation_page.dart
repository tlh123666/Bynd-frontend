import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations_context.dart';

import '../../../../design_system/components/app_pull_to_refresh.dart';
import '../../../../design_system/tokens/app_colors.dart';
import '../../../../design_system/tokens/app_dimensions.dart';
import '../../../../design_system/tokens/app_typography.dart';
import '../../domain/models/activity_type.dart';
import '../../data/local_workout_store.dart';
import '../localization/activity_type_localizations.dart';
import '../widgets/activity_selection_sheet.dart';
import '../widgets/activity_preparation_controls.dart';
import '../widgets/activity_preparation_heart_rate.dart';
import '../widgets/activity_type_icon.dart';
import '../widgets/strength_workout_sheet.dart';

/// 活动准备页：演示数据明确标记，尚未接入真实会话。
class ActivityPreparationPage extends StatefulWidget {
  const ActivityPreparationPage({
    required this.initialActivity,
    this.initialWorkout,
    super.key,
  });

  final ActivityType initialActivity;
  final LocalWorkoutPlan? initialWorkout;

  @override
  State<ActivityPreparationPage> createState() =>
      _ActivityPreparationPageState();
}

class _ActivityPreparationPageState extends State<ActivityPreparationPage> {
  late ActivityType _activity = widget.initialActivity;
  late LocalWorkoutPlan? _workout = widget.initialWorkout?.copy();
  bool _routeRecordingEnabled = false;

  Future<void> _changeActivity() async {
    final selected = await ActivitySelectionSheet.show(
      context,
      waitForExit: true,
    );
    if (!mounted || selected == null) return;

    LocalWorkoutPlan? workout;
    if (selected.id == 'musculacao') {
      final start = await StrengthWorkoutSheet.show(context, selected);
      if (!mounted || start == null) return;
      workout = start.plan;
    }

    setState(() {
      _activity = selected;
      _workout = workout?.copy();
      _routeRecordingEnabled = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    final activityName = activityTypeLocalizedName(_activity, strings);
    // 没有实际地图时显示静态示例心率；路线预览开启时保留地图区域。
    final showHeartRate = !(_activity.hasRouteToggle && _routeRecordingEnabled);
    final hero = Column(
      children: [
        Expanded(
          child: showHeartRate
              ? const ActivityPreparationHeartRate()
              : const SizedBox(),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.battery_std_outlined,
                color: AppColors.textMuted,
                size: 19,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  strings.preparationBatteryExample,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
    const controls = ActivityPreparationControls();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF21303B), Color(0xFF151E24), Color(0xFF0F1519)],
            stops: [0, .40, 1],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _PreparationHeader(
                activityName: activityName,
                activity: _activity,
                onClose: () => Navigator.of(context).pop(),
                onChangeActivity: _changeActivity,
              ),
              if (_workout != null)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  child: Column(
                    children: [
                      Text(_workout!.name, style: AppTypography.title),
                      const SizedBox(height: 4),
                      Text(
                        strings.strengthExerciseCount(
                          _workout!.exercises.length,
                          _workout!.setCount,
                        ),
                        style: AppTypography.caption,
                      ),
                      Text(
                        strings.workoutPlanPreview,
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              if (_activity.hasRouteToggle)
                _RouteRecordingToggle(
                  enabled: _routeRecordingEnabled,
                  onChanged: (enabled) =>
                      setState(() => _routeRecordingEnabled = enabled),
                ),
              Expanded(
                child: AppPullToRefresh(
                  successLabel: strings.preparationDemoRefreshed,
                  // 当前只刷新明确标记的演示内容，不代表设备或天气已同步。
                  onRefresh: () async {
                    if (mounted) setState(() {});
                  },
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // 空间不足时整页可滚动；常规高度时面板固定贴底。
                      if (constraints.maxHeight <
                          520 * MediaQuery.textScalerOf(context).scale(1)) {
                        return SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(
                            children: [
                              SizedBox(
                                height: showHeartRate ? 300 : 200,
                                child: hero,
                              ),
                              controls,
                            ],
                          ),
                        );
                      }

                      return SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: SizedBox(
                          height: constraints.maxHeight,
                          child: Column(
                            children: [
                              Expanded(child: hero),
                              controls,
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PreparationHeader extends StatelessWidget {
  const _PreparationHeader({
    required this.activityName,
    required this.activity,
    required this.onClose,
    required this.onChangeActivity,
  });

  final String activityName;
  final ActivityType activity;
  final VoidCallback onClose;
  final VoidCallback onChangeActivity;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 62,
    child: Stack(
      alignment: Alignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 56),
          child: Center(
            child: TextButton(
              onPressed: onChangeActivity,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textPrimary,
                overlayColor: Colors.transparent,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ActivityTypeIcon(
                    type: activity,
                    fallback: Icons.fitness_center,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      activityName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.title.copyWith(fontSize: 17),
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    size: 18,
                    color: AppColors.textMuted,
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: 8,
          child: IconButton(
            tooltip: context.l10n.preparationClose,
            onPressed: onClose,
            icon: const Icon(Icons.close, color: AppColors.textPrimary),
          ),
        ),
      ],
    ),
  );
}

class _RouteRecordingToggle extends StatelessWidget {
  const _RouteRecordingToggle({required this.enabled, required this.onChanged});

  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(
      AppSpacing.lg,
      AppSpacing.xxs,
      AppSpacing.lg,
      AppSpacing.xs,
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.routeRecording,
                style: AppTypography.body.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                context.l10n.gpsUnavailable,
                style: AppTypography.caption.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
        Switch.adaptive(
          key: const ValueKey('route-recording-switch'),
          value: enabled,
          onChanged: onChanged,
          activeTrackColor: AppColors.textPrimary,
          inactiveTrackColor: AppColors.textMuted,
        ),
      ],
    ),
  );
}
