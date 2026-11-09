import 'package:flutter/material.dart';

import '../../design_system/design_system.dart';
import '../../shared/navigation/app_side_menu.dart';
import '../../shared/widgets/day_strip.dart';
import 'home_sky_background.dart';
import '../profile/profile_page.dart';
import '../activity/presentation/pages/activity_overview_page.dart';
import '../device/presentation/pages/device_management_page.dart';

/// 当前只实现参考图中的主页外壳与底部导航，内容页后续接入。
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey _moreButtonKey = GlobalKey();
  int _selectedIndex = 0;
  int _selectedDay = 0;
  bool _quickActionsOpen = false;
  Rect? _quickActionOrigin;
  bool _menuOpen = false;

  void _openQuickActions() {
    final box = _moreButtonKey.currentContext?.findRenderObject();
    if (box is! RenderBox || !box.hasSize) return;
    setState(() {
      _quickActionOrigin = box.localToGlobal(Offset.zero) & box.size;
      _quickActionsOpen = true;
    });
  }

  Future<void> _openSettings() async {
    final delay = AppMotion.enabled(context) ? AppMotion.drawer : Duration.zero;
    setState(() => _menuOpen = false);
    await Future<void>.delayed(delay);
    if (!mounted) return;
    final selected = await Navigator.of(
      context,
    ).push<int>(MaterialPageRoute(builder: (_) => const ProfilePage()));
    if (mounted && selected != null) setState(() => _selectedIndex = selected);
  }

  Future<void> _openDevice() async {
    final delay = AppMotion.enabled(context) ? AppMotion.drawer : Duration.zero;
    setState(() => _menuOpen = false);
    await Future<void>.delayed(delay);
    if (!mounted) return;
    await Navigator.of(context).push<void>(
      MaterialPageRoute(builder: (_) => const DeviceManagementPage()),
    );
  }

  void _otherMenuItem(String label) {
    setState(() => _menuOpen = false);
    AppNotice.show(
      context,
      kind: AppNoticeKind.info,
      message: '$label: em breve.',
    );
  }

  Future<void> _handleQuickAction(AppQuickAction action) async {
    setState(() => _quickActionsOpen = false);
    if (action == AppQuickAction.startActivity) {
      await Navigator.of(context).push<void>(
        MaterialPageRoute<void>(
          builder: (_) => const ActivityOverviewPage(openSelectorOnEnter: true),
        ),
      );
      return;
    }
    AppNotice.show(
      context,
      kind: AppNoticeKind.info,
      message: '${action.label.replaceAll('\n', ' ')}: em breve.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          extendBody: true,
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              const Positioned.fill(child: HomeSkyBackground()),
              SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.lg,
                        AppSpacing.md,
                        AppSpacing.lg,
                        0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () => setState(() => _menuOpen = true),
                            tooltip: 'Menu',
                            icon: const AppSvgIcon(AppSvgAssets.menu, size: 22),
                          ),
                          const CircleAvatar(
                            radius: 18,
                            backgroundImage: AssetImage(
                              'assets/images/avatar.webp',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    DayStrip(
                      day: _selectedDay,
                      onDayChanged: (day) => setState(() => _selectedDay = day),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: AppSpacing.md,
                        right: AppSpacing.md,
                      ),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.homeCounter,
                            borderRadius: AppRadii.pillBorder,
                            border: Border.all(color: AppColors.navBorder),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const AppSvgIcon(
                                AppSvgAssets.photoCounter,
                                size: 15,
                              ),
                              const SizedBox(width: AppSpacing.xxs),
                              Text(
                                '0/24',
                                style: AppTypography.caption.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: AppBottomNav(
            selectedIndex: _selectedIndex,
            moreButtonKey: _moreButtonKey,
            moreOpen: _quickActionsOpen,
            onDestinationSelected: (index) =>
                setState(() => _selectedIndex = index),
            onMorePressed: _openQuickActions,
          ),
        ),
        if (_quickActionsOpen)
          Positioned.fill(
            child: AppQuickActionsOverlay(
              origin: _quickActionOrigin!,
              onClose: () => setState(() => _quickActionsOpen = false),
              onActionSelected: _handleQuickAction,
            ),
          ),
        AppSideMenu(
          visible: _menuOpen,
          onClose: () => setState(() => _menuOpen = false),
          onSettings: _openSettings,
          onDevice: _openDevice,
          onOtherSelected: _otherMenuItem,
        ),
      ],
    );
  }
}
