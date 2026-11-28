import '../../shared/navigation/app_quick_action_navigation.dart';
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
import '../atlas/presentation/pages/mapa_page.dart';
import '../atlas/application/atlas_greeting_store.dart';
import '../atlas/application/atlas_scope.dart';
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
    // 当前 tab 的开场白在页面层预取：用户点开 Atlas 弹窗之前就绪。
    unawaited(
      AtlasGreetingStore.instance.prepare(
        _originForTab(_selectedIndex),
        AtlasScope.of(context),
      ),
    );
  }

  /// 底部 tab → 开场白上下文（home / community / signals）。
  String _originForTab(int index) => switch (index) {
    2 => 'community',
    3 => 'signals',
    _ => 'home',
  };

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
  /// 打开来源跟随当前 tab——开场白按所在页面生成（home/community/signals）。
  void _openAtlasSheet() {
    AtlasOverlayScope.show(context, origin: _originForTab(_selectedIndex));
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

  void _featureDestination(int index) {
    Navigator.of(context).popUntil((r) => r.isFirst);
    if (index == 1) {
      _openAtlasSheet();
      return;
    }
    setState(() => _selectedIndex = index);
    // 切 tab 即预取对应模块的开场白。
    unawaited(
      AtlasGreetingStore.instance.prepare(
        _originForTab(index),
        AtlasScope.of(context),
      ),
    );
  }

  Future<void> _handleQuickAction(AppQuickAction action) async {
    setState(() => _quickActionsOpen = false);
    if (AppQuickActionNavigation.open(
      context,
      action,
      demo: _home.demoData,
      date: _home.date,
      onDestinationSelected: _featureDestination,
    )) {
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
          // 所有主标签都延伸到悬浮玻璃导航后方，保证导航始终从真实页面
          // 背景取样模糊，不露出 Scaffold 的固定深色底板。
          extendBody: true,
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
                onDestinationSelected: _featureDestination,
              ),
              HomeAccountGuard(controller: _home, child: const CommunityPage()),
              HomeSignalsPage(
                controller: _home,
                showClose: false,
                onDestinationSelected: _featureDestination,
              ),
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
