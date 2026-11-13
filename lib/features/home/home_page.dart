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
import '../atlas/presentation/pages/insights_page.dart';
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

  Future<void> _pushAfterMenu(Widget page) async {
    final delay = AppMotion.enabled(context) ? AppMotion.drawer : Duration.zero;
    setState(() => _menuOpen = false);
    await Future<void>.delayed(delay);
    if (!mounted) return;
    await Navigator.of(
      context,
    ).push<void>(MaterialPageRoute(builder: (_) => page));
  }

  void _otherMenuItem(String label) {
    setState(() => _menuOpen = false);
    if (label == context.l10n.signOut) {
      unawaited(_signOut());
      return;
    }
    if (label == 'Mapa' || label == context.l10n.atlas) {
      // 抽屉收起有动画，直接 push 会和收起动作叠在一起；与设备页保持同一步调。
      _openMapa();
      return;
    }
    if (label == context.l10n.atlasInsights) {
      _pushAfterMenu(const InsightsPage());
      return;
    }
    if (label == context.l10n.atlasChat) {
      _pushAfterMenu(const AtlasChatPage());
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
          extendBody: true,
          backgroundColor: Colors.transparent,
          body: HomeContent(
            controller: _home,
            onMenu: () => setState(() => _menuOpen = true),
            onProfile: _openSettings,
            onDevice: _openDevice,
            onMapa: _openMapa,
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
