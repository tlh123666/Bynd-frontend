import 'package:flutter/material.dart';

import '../../design_system/design_system.dart';
import '../../shared/navigation/app_side_menu.dart';
import '../../l10n/app_locale_controller.dart';
import '../../l10n/app_localizations_context.dart';
import '../../l10n/language_picker_sheet.dart';
import '../../shared/widgets/day_strip.dart';
import 'home_sky_background.dart';
import '../profile/profile_page.dart';
import '../activity/presentation/pages/activity_overview_page.dart';
import '../atlas/presentation/pages/mapa_page.dart';
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

  Future<void> _openMapa() async {
    final delay = AppMotion.enabled(context) ? AppMotion.drawer : Duration.zero;
    setState(() => _menuOpen = false);
    await Future<void>.delayed(delay);
    if (!mounted) return;
    await Navigator.of(
      context,
    ).push<void>(MaterialPageRoute(builder: (_) => const MapaPage()));
  }

  void _otherMenuItem(String label) {
    setState(() => _menuOpen = false);
    if (label == 'Mapa' || label == context.l10n.atlas) {
      // 抽屉收起有动画，直接 push 会和收起动作叠在一起；与设备页保持同一步调。
      _openMapa();
      return;
    }
    AppNotice.show(
      context,
      kind: AppNoticeKind.info,
      message: context.l10n.comingSoon(label),
    );
  }

  Future<void> _openLanguagePicker() async {
    final localeController = AppLocaleScope.maybeOf(context);
    if (localeController == null) return;
    setState(() => _menuOpen = false);
    await AppFrostedModalSheet.show<void>(
      context,
      builder: (_) => LanguagePickerSheet(
        selectedLocale: localeController.locale,
        onSelected: localeController.setLocale,
      ),
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
      message: context.l10n.comingSoon(
        action.localizedLabel(context.l10n).replaceAll('\n', ' '),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Scaffold(
          extendBody: true,
          backgroundColor: Colors.transparent,
          body: Stack(
            fit: StackFit.expand,
            children: [
              const Positioned.fill(child: HomeSkyBackground()),
              SafeArea(
                bottom: false,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final headerContent = Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.lg,
                            AppSpacing.md,
                            AppSpacing.lg,
                            0,
                          ),
                          child: AppPageHeader(
                            height: 48,
                            padding: EdgeInsets.zero,
                            leading: IconButton(
                              onPressed: () => setState(() => _menuOpen = true),
                              tooltip: context.l10n.menu,
                              icon: const AppSvgIcon(
                                AppSvgAssets.menu,
                                size: 22,
                              ),
                            ),
                            title: const AppSvgIcon(
                              AppSvgAssets.logo,
                              label: 'BYND',
                              width: 72,
                              height: 16,
                            ),
                            trailing: const CircleAvatar(
                              radius: 18,
                              backgroundImage: AssetImage(
                                'assets/images/avatar.webp',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        DayStrip(
                          day: _selectedDay,
                          onDayChanged: (day) =>
                              setState(() => _selectedDay = day),
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
                    );

                    // 浏览器初始化或极小窗口下，顶部内容允许滚动，避免短暂溢出。
                    if (constraints.maxHeight < 180) {
                      return SingleChildScrollView(child: headerContent);
                    }
                    return headerContent;
                  },
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
          onLanguage: _openLanguagePicker,
          onDevice: _openDevice,
          onOtherSelected: _otherMenuItem,
        ),
      ],
    );
  }
}
