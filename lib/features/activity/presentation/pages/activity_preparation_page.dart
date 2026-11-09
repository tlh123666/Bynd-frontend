import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations_context.dart';

import '../../../../design_system/tokens/app_colors.dart';
import '../../../../design_system/tokens/app_dimensions.dart';
import '../../../../design_system/tokens/app_typography.dart';
import '../../../../design_system/components/app_page_header.dart';
import '../../domain/models/activity_type.dart';
import '../localization/activity_type_localizations.dart';
import '../widgets/activity_selection_sheet.dart';

/// 活动准备页的安全基础版：先复现主布局，不生成演示指标或会话。
class ActivityPreparationPage extends StatefulWidget {
  const ActivityPreparationPage({required this.initialActivity, super.key});

  final ActivityType initialActivity;

  @override
  State<ActivityPreparationPage> createState() =>
      _ActivityPreparationPageState();
}

class _ActivityPreparationPageState extends State<ActivityPreparationPage> {
  late ActivityType _activity = widget.initialActivity;
  bool _routeRecordingEnabled = false;

  Future<void> _changeActivity() async {
    final selected = await ActivitySelectionSheet.show(context);
    if (!mounted || selected == null) return;

    if (selected.id == 'musculacao') {
      await Navigator.of(context).push<void>(
        MaterialPageRoute<void>(
          builder: (_) => StrengthStartPage(activity: selected),
        ),
      );
      return;
    }

    setState(() {
      _activity = selected;
      _routeRecordingEnabled = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    final activityName = activityTypeLocalizedName(_activity, strings);
    final hero = Center(
      child: _StatusLine(
        icon: Icons.watch_outlined,
        title: strings.watchNotIntegrated,
        detail: strings.heartRateBatteryUnavailable,
      ),
    );
    final controls = _PreparationControls();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF252A31), AppColors.background],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _PreparationHeader(
                activityName: activityName,
                onClose: () => Navigator.of(context).pop(),
                onChangeActivity: _changeActivity,
              ),
              if (_activity.hasRouteToggle)
                _RouteRecordingToggle(
                  enabled: _routeRecordingEnabled,
                  onChanged: (enabled) =>
                      setState(() => _routeRecordingEnabled = enabled),
                ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // 空间不足时整页可滚动；常规高度时面板固定贴底。
                    if (constraints.maxHeight < 680) {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: 200, child: hero),
                            controls,
                          ],
                        ),
                      );
                    }

                    return Column(
                      children: [
                        Expanded(child: hero),
                        controls,
                      ],
                    );
                  },
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
    required this.onClose,
    required this.onChangeActivity,
  });

  final String activityName;
  final VoidCallback onClose;
  final VoidCallback onChangeActivity;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(
      AppSpacing.sm,
      AppSpacing.xs,
      AppSpacing.lg,
      AppSpacing.xs,
    ),
    child: Row(
      children: [
        IconButton(
          tooltip: context.l10n.preparationClose,
          onPressed: onClose,
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
        ),
        const Spacer(),
        TextButton.icon(
          onPressed: onChangeActivity,
          icon: const Icon(Icons.expand_more),
          label: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 210),
            child: Text(
              activityName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          style: TextButton.styleFrom(foregroundColor: AppColors.textPrimary),
        ),
      ],
    ),
  );
}

class _PreparationControls extends StatelessWidget {
  const _PreparationControls();

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: const BorderRadius.vertical(
      top: Radius.circular(AppRadii.sheet),
    ),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
      child: Container(
        key: const ValueKey('activity-preparation-controls'),
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.xl,
        ),
        decoration: BoxDecoration(
          color: AppColors.menuPanel,
          border: Border(top: AppBorders.glass),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 38,
                height: 4,
                decoration: const BoxDecoration(
                  color: AppColors.textMuted,
                  borderRadius: AppRadii.pillBorder,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _WeatherStatusCard(),
            _LoadTargetStatus(),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: null,
                child: Text(context.l10n.startActivityButton),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Center(
              child: Text(
                context.l10n.waitingForSensors,
                textAlign: TextAlign.center,
                style: AppTypography.caption.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            ),
          ],
        ),
      ),
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

class _WeatherStatusCard extends StatelessWidget {
  const _WeatherStatusCard();

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
    padding: const EdgeInsets.all(AppSpacing.md),
    decoration: BoxDecoration(
      color: AppColors.glass,
      borderRadius: AppRadii.cardBorder,
      border: Border.fromBorderSide(AppBorders.glass),
    ),
    child: _StatusLine(
      icon: Icons.cloud_outlined,
      title: context.l10n.weatherUnavailable,
      detail: context.l10n.weatherNotIntegrated,
    ),
  );
}

class _LoadTargetStatus extends StatelessWidget {
  const _LoadTargetStatus();

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.textMuted, width: 2),
        ),
        child: const Icon(
          Icons.bolt_outlined,
          size: 18,
          color: AppColors.textMuted,
        ),
      ),
      const SizedBox(width: AppSpacing.sm),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.suggestedLoadUnavailable,
              style: AppTypography.body.copyWith(color: AppColors.textPrimary),
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              context.l10n.loadNotIntegrated,
              style: AppTypography.caption.copyWith(color: AppColors.textMuted),
            ),
          ],
        ),
      ),
      Semantics(
        label: context.l10n.suggestedLoadUnavailable,
        child: Switch.adaptive(value: false, onChanged: null),
      ),
    ],
  );
}

class _StatusLine extends StatelessWidget {
  const _StatusLine({
    required this.icon,
    required this.title,
    required this.detail,
  });

  final IconData icon;
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, color: AppColors.textMuted),
      const SizedBox(width: AppSpacing.sm),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTypography.body.copyWith(color: AppColors.textPrimary),
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              detail,
              style: AppTypography.caption.copyWith(color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    ],
  );
}

/// 保留原型训练选择页的区块顺序，但不把 Clara 演示模板展示成用户数据。
class StrengthStartPage extends StatelessWidget {
  const StrengthStartPage({required this.activity, super.key});

  final ActivityType activity;

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    final activityName = activityTypeLocalizedName(activity, strings);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            AppPageHeader(
              title: Text(
                activityName,
                style: const TextStyle(
                  fontFamily: AppFontFamilies.geist,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              leading: IconButton(
                tooltip: strings.close,
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.sm,
                  AppSpacing.lg,
                  AppSpacing.xl,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strings.howToStart,
                      style: AppTypography.title.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _StrengthOption(
                      icon: Icons.play_arrow,
                      title: strings.startWithoutPlan,
                      detail: strings.exercisesCanBeAddedLater,
                      onTap: () => Navigator.of(context).push<void>(
                        MaterialPageRoute<void>(
                          builder: (_) => ActivityPreparationPage(
                            initialActivity: activity,
                          ),
                        ),
                      ),
                    ),
                    _StrengthSectionHeading(title: strings.yourWorkouts),
                    _StatusLine(
                      icon: Icons.fitness_center,
                      title: strings.savedWorkoutsUnavailable,
                      detail: strings.savedWorkoutsNotConnected,
                    ),
                    _StrengthSectionHeading(title: strings.otherWays),
                    _StrengthOption(
                      icon: Icons.add,
                      title: strings.buildWorkout,
                      detail: strings.workoutEditorNotIntegrated,
                      onTap: null,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StrengthSectionHeading extends StatelessWidget {
  const _StrengthSectionHeading({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(4, AppSpacing.lg, 4, AppSpacing.xs),
    child: Text(
      title.toUpperCase(),
      style: AppTypography.caption.copyWith(
        color: AppColors.textMuted,
        letterSpacing: 1.5,
      ),
    ),
  );
}

class _StrengthOption extends StatelessWidget {
  const _StrengthOption({
    required this.icon,
    required this.title,
    required this.detail,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String detail;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: AppColors.surface,
    borderRadius: AppRadii.controlBorder,
    child: InkWell(
      onTap: onTap,
      borderRadius: AppRadii.controlBorder,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 68),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.textSecondary),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.body.copyWith(
                        color: onTap == null
                            ? AppColors.textMuted
                            : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      detail,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: onTap == null
                    ? AppColors.menuChevron
                    : AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
