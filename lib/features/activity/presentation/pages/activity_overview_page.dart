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
  bool _didOpenInitialSelector = false;
  bool _quickActionsOpen = false;
  int _selectedDay = 0;

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
    return Stack(
      children: [
        Scaffold(
          extendBody: true,
          backgroundColor: AppColors.background,
          body: Stack(
            fit: StackFit.expand,
            children: [
              const _ActivityHeroBackground(),
              SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    _ActivityHeader(
                      onBack: () => Navigator.of(context).maybePop(),
                    ),
                    DayStrip(
                      day: _selectedDay,
                      tone: DayStripTone.ember,
                      onDayChanged: (day) => setState(() => _selectedDay = day),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 74, 24, 210),
                        child: _DailySummary(),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 24,
                right: 24,
                bottom: 88,
                child: _ActivityActions(
                  onStart: () => openActivitySelection(context),
                  onRegister: () => AppNotice.show(
                    context,
                    kind: AppNoticeKind.info,
                    message: context.l10n.activityRegisterComingSoon,
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: SafeArea(
            top: false,
            child: AppBottomNav(
              selectedIndex: null,
              onDestinationSelected: _selectTab,
              onMorePressed: () => setState(() => _quickActionsOpen = true),
            ),
          ),
        ),
        if (_quickActionsOpen)
          Positioned.fill(
            child: AppQuickActionsOverlay(
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
      Navigator.of(context).popUntil((route) => route.isFirst);
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
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset('assets/images/activity-track.webp', fit: BoxFit.cover),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0x660B0D10),
                Color(0x5511161B),
                Color(0xAA111418),
                AppColors.background,
              ],
              stops: [0, .25, .65, 1],
            ),
          ),
        ),
      ],
    );
  }
}

class _ActivityHeader extends StatelessWidget {
  const _ActivityHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return AppPageHeader(
      title: Text(context.l10n.activities, style: AppTypography.title),
      leading: IconButton(
        tooltip: context.l10n.back,
        onPressed: onBack,
        icon: const AppSvgIcon(AppSvgAssets.back, size: 21),
      ),
      trailing: IconButton(
        tooltip: context.l10n.history,
        onPressed: () => AppNotice.show(
          context,
          kind: AppNoticeKind.info,
          message: context.l10n.activityHistoryComingSoon,
        ),
        icon: const Icon(Icons.history, color: AppColors.textPrimary),
      ),
    );
  }
}

class _DailySummary extends StatelessWidget {
  const _DailySummary();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 14,
          children: [
            Text('—', style: AppTypography.hero.copyWith(fontSize: 48)),
            Text(
              context.l10n.activityUnavailableHeading,
              style: AppTypography.caption.copyWith(
                color: AppColors.textMuted,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          context.l10n.activityUnavailableTitle,
          style: AppTypography.page.copyWith(
            fontWeight: FontWeight.w400,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          context.l10n.activityUnavailableDescription,
          style: AppTypography.body.copyWith(
            color: AppColors.textSecondary,
            height: 1.65,
          ),
        ),
        const SizedBox(height: 88),
        _OverviewSectionTitle(context.l10n.dayInNumbers),
        _UnavailableSection(message: context.l10n.dailyMetricsUnavailable),
        const SizedBox(height: 30),
        _OverviewSectionTitle(context.l10n.modalities),
        _UnavailableSection(message: context.l10n.recentModalitiesUnavailable),
        const SizedBox(height: 30),
        _OverviewSectionTitle(context.l10n.todayActivities),
        _UnavailableSection(message: context.l10n.noSyncedActivity),
      ],
    );
  }
}

class _OverviewSectionTitle extends StatelessWidget {
  const _OverviewSectionTitle(this.label);

  final String label;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Text(label, style: AppTypography.title.copyWith(fontSize: 18)),
  );
}

class _UnavailableSection extends StatelessWidget {
  const _UnavailableSection({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.glass,
      borderRadius: AppRadii.controlBorder,
      border: Border.fromBorderSide(AppBorders.glass),
    ),
    child: Text(
      message,
      style: AppTypography.body.copyWith(color: AppColors.textMuted),
    ),
  );
}

class _ActivityActions extends StatelessWidget {
  const _ActivityActions({required this.onStart, required this.onRegister});

  final VoidCallback onStart;
  final VoidCallback onRegister;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.wb_sunny_outlined,
              size: 20,
              color: AppColors.textMuted,
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                context.l10n.todayPlanPrompt,
                style: AppTypography.section.copyWith(
                  fontSize: 21,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onRegister,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  side: const BorderSide(color: AppColors.glassBorderStrong),
                  minimumSize: const Size.fromHeight(52),
                  shape: const StadiumBorder(),
                ),
                child: Text(context.l10n.register),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton(
                onPressed: onStart,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.textPrimary,
                  foregroundColor: AppColors.background,
                  minimumSize: const Size.fromHeight(52),
                  shape: const StadiumBorder(),
                ),
                child: Text(context.l10n.startActivityTitle),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
