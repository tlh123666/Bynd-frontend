import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../../design_system/design_system.dart';
import '../../../../shared/widgets/day_calendar.dart';
import '../../../../shared/widgets/day_strip.dart';
import '../../../../l10n/app_localizations_context.dart';
import '../activity_selection_flow.dart';

/// 活动总览页：对应网页原型的 `exercicio` 页面。
///
/// 首页快捷入口会带着“打开活动选择面板”的意图进入本页；面板关闭后，
/// 用户仍然停留在活动总览页，和网页原型的导航层级保持一致。
class ActivityOverviewPage extends StatefulWidget {
  const ActivityOverviewPage({this.openSelectorOnEnter = false, super.key});

  final bool openSelectorOnEnter;

  @override
  State<ActivityOverviewPage> createState() => _ActivityOverviewPageState();
}

class _ActivityOverviewPageState extends State<ActivityOverviewPage> {
  final GlobalKey _moreButtonKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();
  bool _didOpenInitialSelector = false;
  bool _quickActionsOpen = false;
  Rect? _quickActionOrigin;
  int _selectedDay = 0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _openQuickActions() {
    final box = _moreButtonKey.currentContext?.findRenderObject();
    if (box is! RenderBox || !box.hasSize) return;
    setState(() {
      _quickActionOrigin = box.localToGlobal(Offset.zero) & box.size;
      _quickActionsOpen = true;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!widget.openSelectorOnEnter || _didOpenInitialSelector) return;
    _didOpenInitialSelector = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) openActivitySelection(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final safeTop = MediaQuery.paddingOf(context).top;
    const headerContentHeight = 56.0 + 46.0;
    final glassHeight = safeTop + headerContentHeight + 20;
    return Stack(
      children: [
        Scaffold(
          extendBody: true,
          backgroundColor: const Color(0xFF100F0F),
          body: Stack(
            fit: StackFit.expand,
            children: [
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF2A1C16),
                      Color(0xFF17110F),
                      Color(0xFF0D0B0A),
                    ],
                    stops: [0, .45, 1],
                  ),
                ),
              ),
              Positioned.fill(
                child: ClipRect(
                  child: AnimatedBuilder(
                    animation: _scrollController,
                    builder: (context, child) => Transform.translate(
                      // 背景与正文共用滚动偏移，导航和日期带则继续固定在上层。
                      offset: Offset(
                        0,
                        -(_scrollController.hasClients
                            ? _scrollController.offset
                            : 0.0),
                      ),
                      child: child,
                    ),
                    child: const Align(
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        height: 820,
                        child: _ActivityHeroBackground(),
                      ),
                    ),
                  ),
                ),
              ),
              SafeArea(
                bottom: false,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned.fill(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        // 正文从固定头部下方开始，但滚动视口覆盖头部，内容可从头部后方经过。
                        padding: const EdgeInsets.fromLTRB(
                          24,
                          headerContentHeight + 74,
                          24,
                          128,
                        ),
                        child: _DailySummary(
                          onStart: () => openActivitySelection(context),
                          onRegister: () => AppNotice.show(
                            context,
                            kind: AppNoticeKind.info,
                            message: context.l10n.activityRegisterComingSoon,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: -safeTop,
                      left: 0,
                      right: 0,
                      height: glassHeight,
                      child: _ActivityScrollFrostedHeader(
                        controller: _scrollController,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _ActivityHeader(
                            onBack: () => Navigator.of(context).maybePop(),
                          ),
                          DayStrip(
                            day: _selectedDay,
                            tone: DayStripTone.ember,
                            onDayChanged: (day) {
                              setState(() => _selectedDay = day);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // 导航组件内部已处理底部安全区，避免像首页一样重复叠加留白。
          bottomNavigationBar: AppBottomNav(
            selectedIndex: null,
            moreButtonKey: _moreButtonKey,
            moreOpen: _quickActionsOpen,
            onDestinationSelected: _selectTab,
            onMorePressed: _openQuickActions,
          ),
        ),
        if (_quickActionsOpen)
          Positioned.fill(
            child: AppQuickActionsOverlay(
              origin: _quickActionOrigin!,
              onClose: () => setState(() => _quickActionsOpen = false),
              onActionSelected: (action) {
                setState(() => _quickActionsOpen = false);
                if (action == AppQuickAction.startActivity) {
                  openActivitySelection(context);
                } else {
                  AppNotice.show(
                    context,
                    kind: AppNoticeKind.info,
                    message: context.l10n.comingSoon(
                      action.localizedLabel(context.l10n).replaceAll('\n', ' '),
                    ),
                  );
                }
              },
            ),
          ),
      ],
    );
  }

  void _selectTab(int index) {
    if (index == 0) {
      // 将目标标签通过路由结果交给上一页，避免返回首页后仍保留旧选中态。
      Navigator.of(context).pop(index);
      return;
    }
    AppNotice.show(
      context,
      kind: AppNoticeKind.info,
      message: context.l10n.sectionComingSoon,
    );
  }
}

class _ActivityHeroBackground extends StatelessWidget {
  const _ActivityHeroBackground();

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.dstIn,
      shaderCallback: (bounds) => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.black, Colors.black, Colors.transparent],
        stops: [0, .66, 1],
      ).createShader(bounds),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/activity-track.webp', fit: BoxFit.cover),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x591A1614),
                  Color(0x1A1A1614),
                  Color(0x401A1614),
                  Color(0xBF1A1614),
                  Color(0x001A1614),
                ],
                stops: [0, .20, .55, .82, 1],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 活动页滚动时覆盖在固定头部下方的渐隐磨砂层。
class _ActivityScrollFrostedHeader extends StatelessWidget {
  const _ActivityScrollFrostedHeader({required this.controller});

  final ScrollController controller;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: controller,
    builder: (context, _) => IgnorePointer(
      child: TweenAnimationBuilder<double>(
        key: const ValueKey('activity-scroll-frosted-header'),
        tween: Tween<double>(
          begin: 0,
          end: controller.hasClients && controller.offset > 6 ? 1 : 0,
        ),
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
        builder: (context, progress, child) => ClipRect(
          // 保持 BackdropFilter 直接参与页面合成，避免外层 ShaderMask、
          // ColorFiltered 或 Opacity 在 Web 上隔离背景采样。
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(
              sigmaX: 22 * progress,
              sigmaY: 22 * progress,
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                // 原型在标题区更深、向下逐渐透明；滚动停止时色彩和模糊同步淡出。
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(0, 0, 0, .5 * progress),
                    Color.fromRGBO(0, 0, 0, .32 * progress),
                    Colors.transparent,
                  ],
                  stops: const [0, .6, 1],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class _ActivityHeader extends StatelessWidget {
  const _ActivityHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return AppPageHeader(
      title: Text(context.l10n.activities, style: AppTypography.title),
      leading: Semantics(
        label: context.l10n.back,
        button: true,
        child: IconButton(
          onPressed: onBack,
          icon: const AppSvgIcon(AppSvgAssets.back, size: 21),
        ),
      ),
      trailing: Semantics(
        label: context.l10n.history,
        button: true,
        child: IconButton(
          onPressed: () => AppNotice.show(
            context,
            kind: AppNoticeKind.info,
            message: context.l10n.activityHistoryComingSoon,
          ),
          icon: const Icon(Icons.history, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}

class _DailySummary extends StatelessWidget {
  const _DailySummary({required this.onStart, required this.onRegister});

  final VoidCallback onStart;
  final VoidCallback onRegister;

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    const demoActivity = _DemoActivityData(
      startTime: '07:50',
      durationMinutes: 35,
      heartRate: 97,
      load: 28,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text('28', style: AppTypography.hero.copyWith(fontSize: 68)),
            const SizedBox(width: 14),
            Flexible(
              child: Text(
                strings.activityTargetStatus,
                style: AppTypography.kicker.copyWith(
                  color: AppColors.sage,
                  fontSize: 12,
                  letterSpacing: 1.3,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          strings.activityTargetTitle,
          style: AppTypography.homeTitle.copyWith(
            fontSize: 48,
            fontWeight: FontWeight.w400,
            height: 1.12,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          strings.activityTargetDescription,
          style: AppTypography.homeBody.copyWith(
            fontSize: 17,
            color: AppColors.textSecondary,
            height: 1.58,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 1),
              child: Icon(
                Icons.info_outline,
                size: 14,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                strings.activityDemoLabel,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.caption.copyWith(
                  color: AppColors.textMuted,
                  fontSize: 12,
                  height: 1.25,
                ),
              ),
            ),
          ],
        ),
        // 原型中的操作区属于页面滚动内容；窄屏提示换行时自然保留更多间距。
        const SizedBox(height: 107),
        _ActivityActions(onStart: onStart, onRegister: onRegister),
        const SizedBox(height: 36),
        _OverviewSectionTitle(strings.dayInNumbers, icon: Icons.bolt_outlined),
        const _DailyMetricsGrid(),
        const SizedBox(height: 36),
        _OverviewSectionTitle(
          strings.modalities,
          icon: Icons.apps_outlined,
          actionLabel: strings.viewAll,
          onAction: () => openActivitySelection(context),
        ),
        _RecentModalities(),
        const SizedBox(height: 36),
        _OverviewSectionTitle(
          strings.todayActivities,
          icon: Icons.history,
          trailingLabel: strings.activityDemoSummary(
            1,
            demoActivity.durationMinutes,
          ),
        ),
        const _DemoActivityRow(activity: demoActivity),
      ],
    );
  }
}

class _OverviewSectionTitle extends StatelessWidget {
  const _OverviewSectionTitle(
    this.label, {
    required this.icon,
    this.actionLabel,
    this.onAction,
    this.trailingLabel,
  });

  final String label;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;
  final String? trailingLabel;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: LayoutBuilder(
      builder: (context, constraints) {
        final summaryWidth = trailingLabel == null
            ? 0.0
            : (constraints.maxWidth * .36).clamp(108.0, 132.0).toDouble();
        return Row(
          crossAxisAlignment: trailingLabel == null
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: trailingLabel == null ? 0 : 3),
              child: Icon(icon, size: 19, color: AppColors.textSecondary),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                maxLines: trailingLabel == null ? 1 : 2,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.section.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            if (trailingLabel != null) ...[
              const SizedBox(width: 12),
              SizedBox(
                width: summaryWidth,
                child: Text(
                  trailingLabel!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textMuted,
                    height: 1.25,
                  ),
                ),
              ),
            ],
            if (actionLabel != null && onAction != null)
              TextButton.icon(
                onPressed: onAction,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                ),
                iconAlignment: IconAlignment.end,
                icon: const Icon(Icons.chevron_right, size: 18),
                label: Text(actionLabel!),
              ),
          ],
        );
      },
    ),
  );
}

/// 仅用于还原网页原型的静态演示数据，不代表设备同步结果或正式算法输出。
class _DailyMetricsGrid extends StatelessWidget {
  const _DailyMetricsGrid();

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    final metrics = <_DemoMetricData>[
      _DemoMetricData(
        icon: Icons.water_drop_outlined,
        label: strings.activityMetricActiveCalories,
        value: '399',
        unit: 'kcal',
        trend: strings.activityMetricAbove25,
        trendColor: AppColors.sage,
        normal: strings.activityMetricNormalCalories,
      ),
      _DemoMetricData(
        icon: Icons.bolt_outlined,
        label: strings.activityMetricActiveMinutes,
        value: '46',
        unit: 'min',
        trend: strings.activityMetricWithinNormal,
        trendColor: AppColors.sage,
        normal: strings.activityMetricNormalMinutes,
      ),
      _DemoMetricData(
        icon: Icons.directions_walk,
        label: strings.activityMetricSteps,
        value: strings.activityDemoStepsValue,
        unit: '',
        trend: strings.activityMetricAbove28,
        trendColor: AppColors.sage,
        normal: strings.activityMetricNormalSteps,
      ),
      _DemoMetricData(
        icon: Icons.bed_outlined,
        label: strings.activityMetricRestingTime,
        value: strings.activityDemoRestingTimeValue,
        unit: '',
        trend: strings.activityMetricWithinNormal,
        trendColor: AppColors.sage,
        normal: strings.activityMetricNormalRest,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = (constraints.maxWidth - 6) / 2;
        return Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final metric in metrics)
              SizedBox(
                width: cardWidth,
                height: 150,
                child: _DemoMetricCard(
                  metric: metric,
                  onPressed: () => AppNotice.show(
                    context,
                    kind: AppNoticeKind.info,
                    message: strings.sectionComingSoon,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _DemoMetricData {
  const _DemoMetricData({
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
    required this.trend,
    required this.trendColor,
    required this.normal,
  });

  final IconData icon;
  final String label;
  final String value;
  final String unit;
  final String trend;
  final Color trendColor;
  final String normal;
}

class _DemoMetricCard extends StatelessWidget {
  const _DemoMetricCard({required this.metric, required this.onPressed});

  final _DemoMetricData metric;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Material(
    color: const Color(0xFF1F1B19),
    borderRadius: const BorderRadius.all(Radius.circular(18)),
    child: InkWell(
      onTap: onPressed,
      borderRadius: const BorderRadius.all(Radius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 12, 13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(metric.icon, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    metric.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: AppColors.textMuted,
                ),
              ],
            ),
            const SizedBox(height: 18),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text.rich(
                TextSpan(
                  text: metric.value,
                  style: AppTypography.signalValue.copyWith(fontSize: 36),
                  children: [
                    if (metric.unit.isNotEmpty)
                      TextSpan(
                        text: ' ${metric.unit}',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              metric.trend,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.label.copyWith(
                color: metric.trendColor,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              metric.normal,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.caption.copyWith(
                color: AppColors.textMuted,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _RecentModalities extends StatelessWidget {
  const _RecentModalities();

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    final modalities = [
      (
        Icons.fitness_center,
        strings.activityDemoStrength,
        strings.activityDemoSetsAndWeight,
      ),
      (
        Icons.directions_run,
        strings.activityDemoRun,
        strings.activityDemoWithGps,
      ),
      (
        Icons.directions_walk,
        strings.activityDemoWalk,
        strings.activityDemoWithGps,
      ),
    ];
    return SizedBox(
      height: 112,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: modalities.length,
        separatorBuilder: (context, index) => const SizedBox(width: 6),
        itemBuilder: (context, index) {
          final modality = modalities[index];
          return Container(
            width: 118,
            padding: const EdgeInsets.fromLTRB(16, 14, 12, 13),
            decoration: BoxDecoration(
              color: const Color(0xFF1F1B19),
              borderRadius: const BorderRadius.all(Radius.circular(18)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(modality.$1, size: 18, color: AppColors.textPrimary),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      modality.$2,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.label,
                    ),
                    Text(
                      modality.$3,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _DemoActivityData {
  const _DemoActivityData({
    required this.startTime,
    required this.durationMinutes,
    required this.heartRate,
    required this.load,
  });

  final String startTime;
  final int durationMinutes;
  final int heartRate;
  final int load;
}

/// 示例活动采用原型中的轻量信息行，不套用活动准备页的实心卡片样式。
class _DemoActivityRow extends StatelessWidget {
  const _DemoActivityRow({required this.activity});

  final _DemoActivityData activity;

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    final metadataStyle = AppTypography.caption.copyWith(
      color: AppColors.textMuted,
      fontSize: 12,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            width: 24,
            child: Padding(
              padding: EdgeInsets.only(top: 2),
              child: Icon(
                Icons.fitness_center,
                size: 16,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  strings.activityDemoStrength,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.label.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 3),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 7,
                  runSpacing: 3,
                  children: [
                    Text(activity.startTime, style: metadataStyle),
                    Icon(
                      Icons.schedule_outlined,
                      size: 12,
                      color: AppColors.textMuted,
                    ),
                    Text(
                      '${activity.durationMinutes} min',
                      style: metadataStyle,
                    ),
                    Icon(
                      Icons.favorite_border,
                      size: 12,
                      color: AppColors.textMuted,
                    ),
                    Text('${activity.heartRate} bpm', style: metadataStyle),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text.rich(
            TextSpan(
              text: '${activity.load}',
              style: AppTypography.label.copyWith(fontSize: 15),
              children: [
                TextSpan(
                  text: ' ${strings.activityDemoLoadLabel}',
                  style: metadataStyle.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityActions extends StatelessWidget {
  const _ActivityActions({required this.onStart, required this.onRegister});

  final VoidCallback onStart;
  final VoidCallback onRegister;

  @override
  Widget build(BuildContext context) {
    const actionRadius = BorderRadius.all(Radius.circular(999));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.wb_sunny_outlined,
              size: 19,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 9),
            Flexible(
              child: Text(
                context.l10n.todayPlanPrompt,
                style: AppTypography.section.copyWith(letterSpacing: -.24),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        LayoutBuilder(
          builder: (context, constraints) {
            final actionsWidth = constraints.maxWidth
                .clamp(0.0, 328.0)
                .toDouble();
            return Center(
              child: SizedBox(
                key: const ValueKey('activity-overview-action-row'),
                width: actionsWidth,
                height: 48,
                child: Row(
                  children: [
                    Expanded(
                      child: AppFrostedSurface(
                        key: const ValueKey(
                          'activity-overview-register-surface',
                        ),
                        borderRadius: actionRadius,
                        blurSigma: 14,
                        saturation: 1.5,
                        tintColor: AppColors.sheetGlassTint,
                        child: DecoratedBox(
                          key: const ValueKey(
                            'activity-overview-register-highlight',
                          ),
                          // 原型按钮没有整圈描边，只保留顶部的内侧高光线。
                          decoration: BoxDecoration(
                            borderRadius: actionRadius,
                            border: Border(
                              top: BorderSide(
                                color: AppColors.sheetGlassBorder,
                              ),
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              key: const ValueKey(
                                'activity-overview-register-button',
                              ),
                              onTap: onRegister,
                              borderRadius: actionRadius,
                              child: Center(
                                child: Text(
                                  context.l10n.register,
                                  style: AppTypography.label.copyWith(
                                    color: AppColors.textPrimary,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    height: 1.2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FilledButton(
                        key: const ValueKey('activity-overview-start-button'),
                        onPressed: onStart,
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.textPrimary,
                          foregroundColor: AppColors.onAction,
                          minimumSize: const Size.fromHeight(48),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          shape: const StadiumBorder(),
                          textStyle: AppTypography.label.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            height: 1.2,
                          ),
                        ),
                        child: Text(context.l10n.startActivityTitle),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
