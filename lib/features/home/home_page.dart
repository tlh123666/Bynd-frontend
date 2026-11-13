import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/config/app_config.dart';
import '../../core/auth/auth_scope.dart';

import '../../design_system/design_system.dart';
import '../../shared/navigation/app_side_menu.dart';
import '../../l10n/app_locale_controller.dart';
import '../../l10n/app_localizations_context.dart';
import '../../l10n/language_picker_sheet.dart';
import 'application/home_controller.dart';
import 'presentation/widgets/home_content.dart';
import '../community/presentation/community_page.dart';
import 'presentation/pages/home_diary_page.dart';
import 'presentation/widgets/home_account_guard.dart';
import '../profile/profile_page.dart';
import '../activity/presentation/pages/activity_overview_page.dart';
import '../atlas/presentation/pages/mapa_page.dart';
import '../atlas/presentation/pages/atlas_chat_page.dart';
import 'presentation/pages/home_signals_page.dart';
import '../device/presentation/pages/device_management_page.dart';

/// Home owns navigation; content and data live in the home feature layers.
class HomePage extends StatefulWidget {
  const HomePage({this.controller, this.config, super.key});
  final HomeController? controller;
  final AppConfig? config;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final GlobalKey _moreButtonKey = GlobalKey();
  int _selectedIndex = 0;
  late final HomeController _home;
  String? _homeLocale;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _home = widget.controller ?? HomeRuntime.create(config: widget.config);
    unawaited(_home.initialize());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = context.l10n.localeName;
    if (_homeLocale == locale) return;
    _homeLocale = locale;
    scheduleMicrotask(() {
      if (mounted) unawaited(_home.setLocale(locale));
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (widget.controller == null) _home.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) unawaited(_home.reload());
  }

  bool _quickActionsOpen = false;
  Rect? _quickActionOrigin;
  bool _menuOpen = false;

  /// body 的 IndexedStack 索引（Atlas 是浮层，不占 body 槽位）。
  int get _bodyIndex => switch (_selectedIndex) {
    2 => 1,
    3 => 2,
    _ => 0,
  };

  /// 底部 tab 的 Atlas：滑出对话浮层（Assistente.jsx 的 folha 模式）。
  void _openAtlasSheet() {
    Navigator.of(context).push<void>(AtlasSheetRoute());
  }

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
    if (label == context.l10n.signOut) {
      unawaited(_signOut());
      return;
    }
    if (label == context.l10n.menuMapa || label == 'Mapa') {
      // 抽屉收起有动画，直接 push 会和收起动作叠在一起；与设备页保持同一步调。
      _openMapa();
      return;
    }
    if (label == context.l10n.diary || label == 'Diário') {
      Navigator.of(context).push<void>(
        MaterialPageRoute(
          builder: (_) => HomeAccountGuard(
            controller: _home,
            child: HomeDiaryPage(controller: _home),
          ),
        ),
      );
      return;
    }
    if (label == context.l10n.community) {
      Navigator.of(context).push<void>(
        MaterialPageRoute(
          builder: (_) =>
              HomeAccountGuard(controller: _home, child: const CommunityPage()),
        ),
      );
      return;
    }
    AppNotice.show(
      context,
      kind: AppNoticeKind.info,
      message: context.l10n.comingSoon(label),
    );
  }

  Future<void> _signOut() async {
    await Future<void>.delayed(
      AppMotion.enabled(context) ? AppMotion.drawer : Duration.zero,
    );
    if (!mounted) return;
    final auth = AuthScope.maybeOf(context);
    if (auth == null) return;
    final s = context.l10n;
    final confirmed = await AppConfirmationSheet.show(
      context,
      title: s.authSignOutTitle,
      message: s.authSignOutBody,
      confirmLabel: s.authSignOutConfirm,
      cancelLabel: s.authCancel,
    );
    if (!mounted || !confirmed) return;
    await auth.logout();
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
      final selectedIndex = await Navigator.of(context).push<int>(
        MaterialPageRoute<int>(
          builder: (_) => const ActivityOverviewPage(openSelectorOnEnter: true),
        ),
      );
      if (mounted && selectedIndex != null) {
        setState(() => _selectedIndex = selectedIndex);
      }
      return;
    }
    if (action == AppQuickAction.dayReview || action == AppQuickAction.meal) {
      await Navigator.of(context).push<void>(
        MaterialPageRoute(
          builder: (_) => HomeAccountGuard(
            controller: _home,
            child: HomeDiaryPage(
              controller: _home,
              openRecord: true,
              initialTracker: action == AppQuickAction.meal ? 'almoco' : null,
            ),
          ),
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
          // Hoje 标签下内容延伸到底部玻璃胶囊后面（毛玻璃需要背景）；
          // 其余标签是自带 Scaffold 的整页，收回导航条上方。
          extendBody: _selectedIndex == 0,
          backgroundColor: Colors.transparent,
          // Atlas 不是 tab 页：TabBar.jsx 里点 Atlas 从底部滑出对话浮层
          // （folha，盖住 tabbar），body 只驻留 Hoje / Comunidade / Saúde。
          // body 索引映射：0→Hoje、2→Comunidade、3→Saúde。
          body: IndexedStack(
            index: _bodyIndex,
            children: [
              HomeContent(
                controller: _home,
                onMenu: () => setState(() => _menuOpen = true),
                onProfile: _openSettings,
                onDevice: _openDevice,
                onMapa: _openMapa,
              ),
              HomeAccountGuard(controller: _home, child: const CommunityPage()),
              HomeSignalsPage(controller: _home, showClose: false),
            ],
          ),
          bottomNavigationBar: AppBottomNav(
            selectedIndex: _selectedIndex,
            moreButtonKey: _moreButtonKey,
            moreOpen: _quickActionsOpen,
            onDestinationSelected: (index) {
              if (index == 1) {
                _openAtlasSheet();
                return;
              }
              setState(() => _selectedIndex = index);
            },
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
