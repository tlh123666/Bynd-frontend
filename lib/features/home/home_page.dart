import 'package:flutter/material.dart';

import '../../design_system/design_system.dart';
import '../../shared/navigation/app_side_menu.dart';
import 'home_sky_background.dart';
import '../profile/profile_page.dart';

/// 当前只实现参考图中的主页外壳与底部导航，内容页后续接入。
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  int _selectedDay = 1;
  bool _quickActionsOpen = false;
  bool _menuOpen = false;

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

  void _otherMenuItem(String label) {
    setState(() => _menuOpen = false);
    AppNotice.show(
      context,
      kind: AppNoticeKind.info,
      message: '$label: em breve.',
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _DayTab(
                          label: 'Ontem',
                          selected: _selectedDay == 0,
                          onTap: () => setState(() => _selectedDay = 0),
                        ),
                        const SizedBox(width: AppSpacing.lg),
                        _DayTab(
                          label: 'Hoje',
                          selected: _selectedDay == 1,
                          onTap: () => setState(() => _selectedDay = 1),
                        ),
                      ],
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
            onDestinationSelected: (index) =>
                setState(() => _selectedIndex = index),
            onMorePressed: () => setState(() => _quickActionsOpen = true),
          ),
        ),
        if (_quickActionsOpen)
          Positioned.fill(
            child: AppQuickActionsOverlay(
              onClose: () => setState(() => _quickActionsOpen = false),
              onActionSelected: (action) {
                setState(() => _quickActionsOpen = false);
                AppNotice.show(
                  context,
                  kind: AppNoticeKind.info,
                  message: '${action.label.replaceAll('\n', ' ')}: em breve.',
                );
              },
            ),
          ),
        AppSideMenu(
          visible: _menuOpen,
          onClose: () => setState(() => _menuOpen = false),
          onSettings: _openSettings,
          onOtherSelected: _otherMenuItem,
        ),
      ],
    );
  }
}

class _DayTab extends StatelessWidget {
  const _DayTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.controlBorder,
      child: Container(
        width: 96,
        padding: const EdgeInsets.only(bottom: AppSpacing.xs),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: selected ? AppColors.textPrimary : Colors.transparent,
              width: AppBorders.focused,
            ),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTypography.body.copyWith(
              color: selected ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
