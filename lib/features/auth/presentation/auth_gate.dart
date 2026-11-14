import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/auth/auth_controller.dart';
import '../../../core/auth/auth_scope.dart';
import '../../../core/config/app_config.dart';
import '../../../core/localization/app_locale_controller.dart';
import '../../../design_system/design_system.dart';
import '../../../l10n/app_localizations_context.dart';
import '../../home/application/home_controller.dart';
import '../../home/home_page.dart';
import '../../device/application/device_controller.dart';
import '../../device/application/device_scope.dart';
import '../../atlas/application/atlas_scope.dart';
import '../../atlas/data/atlas_repository.dart';
import 'login_page.dart';
import '../../sleep/application/sleep_reminder_scope.dart';

/// Changing accounts replaces the complete inner navigation stack. Private
/// pages and forms cannot survive logout underneath a new login screen.
class AuthGate extends StatelessWidget {
  const AuthGate({
    required this.config,
    this.homeController,
    this.deviceController,
    this.atlasRepository,
    this.localeController,
    super.key,
  });
  final AppConfig config;
  final HomeController? homeController;
  final DeviceController? deviceController;
  final AtlasRepository? atlasRepository;
  final AppLocaleController? localeController;
  @override
  Widget build(BuildContext context) {
    final auth = AuthScope.of(context);
    final demo = config.demoData && !auth.didSignOut && !auth.isAuthenticated;
    if (auth.status == AuthStatus.restoring && !demo) {
      return Scaffold(
        backgroundColor: AppColors.homeCanvas,
        body: Center(
          child: AppLoadingIndicator(label: context.l10n.authRestore),
        ),
      );
    }
    final home = auth.isAuthenticated || demo;
    final identity = demo
        ? 'auth-demo-home'
        : 'auth-${home ? 'home' : 'login'}-${auth.sessionRevision}';
    final navigator = _AuthNavigator(
      key: ValueKey(identity),
      page: home
          ? HomePage(controller: homeController, config: config)
          : const LoginPage(),
    );
    return home
        ? _AuthenticatedServices(
            key: ValueKey('services-$identity'),
            config: config,
            devices: deviceController,
            atlas: atlasRepository,
            locale: localeController,
            child: navigator,
          )
        : SleepReminderScope(
            config: config,
            authenticated: false,
            child: navigator,
          );
  }
}

class _AuthNavigator extends StatefulWidget {
  const _AuthNavigator({required this.page, super.key});
  final Widget page;
  @override
  State<_AuthNavigator> createState() => _AuthNavigatorState();
}

class _AuthNavigatorState extends State<_AuthNavigator> {
  final _navigator = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) => NavigatorPopHandler<Object?>(
    onPopWithResult: (result) => _navigator.currentState?.maybePop(result),
    child: Navigator(
      key: _navigator,
      onGenerateRoute: (_) =>
          MaterialPageRoute<void>(builder: (_) => widget.page),
    ),
  );
}

/// Device and Atlas lifetimes follow the authenticated route stack, so a
/// subsequent account starts with fresh private state and a closed BLE link.
class _AuthenticatedServices extends StatefulWidget {
  const _AuthenticatedServices({
    required this.config,
    required this.child,
    this.devices,
    this.atlas,
    this.locale,
    super.key,
  });
  final AppConfig config;
  final Widget child;
  final DeviceController? devices;
  final AtlasRepository? atlas;
  final AppLocaleController? locale;
  @override
  State<_AuthenticatedServices> createState() => _AuthenticatedServicesState();
}

class _AuthenticatedServicesState extends State<_AuthenticatedServices> {
  late final DeviceController _devices;
  late final AtlasRepository _atlas;
  @override
  void initState() {
    super.initState();
    _devices =
        widget.devices ??
        DeviceRuntime.create(config: widget.config, locale: widget.locale);
    _atlas =
        widget.atlas ??
        AtlasRuntime.create(config: widget.config, locale: widget.locale);
    unawaited(_devices.initialize());
  }

  @override
  void dispose() {
    if (widget.devices == null) _devices.dispose();
    if (widget.atlas == null) _atlas.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => DeviceScope(
    controller: _devices,
    child: AtlasScope(
      repository: _atlas,
      child: SleepReminderScope(config: widget.config, child: widget.child),
    ),
  );
}
