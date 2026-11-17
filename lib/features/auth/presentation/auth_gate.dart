import 'dart:async';
import 'dart:ui' show ImageFilter;
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
import '../../atlas/presentation/pages/atlas_chat_page.dart';
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
      child: SleepReminderScope(
        config: widget.config,
        child: _AtlasOverlayHost(child: widget.child),
      ),
    ),
  );
}

/// Atlas remains in the same render tree as the authenticated Navigator. This
/// lets [ImageFiltered] blur the actual page subtree instead of sampling
/// through a transparent route, which is unreliable on some Android GPUs.
class _AtlasOverlayHost extends StatefulWidget {
  const _AtlasOverlayHost({required this.child});

  final Widget child;

  @override
  State<_AtlasOverlayHost> createState() => _AtlasOverlayHostState();
}

class _AtlasOverlayHostState extends State<_AtlasOverlayHost> {
  String? _origin;
  var _session = 0;
  var _visible = false;
  var _backgroundBlurFactor = 1.0;

  void _open(String origin) {
    setState(() {
      _origin = origin;
      _session++;
      _visible = false;
      _backgroundBlurFactor = 1;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _origin != null) setState(() => _visible = true);
    });
  }

  void _close() => setState(() {
    _visible = false;
    _origin = null;
    _backgroundBlurFactor = 1;
  });

  void _setBackgroundBlur(double value) {
    final next = value.clamp(0.0, 1.0);
    if ((next - _backgroundBlurFactor).abs() < .002) return;
    setState(() => _backgroundBlurFactor = next);
  }

  @override
  Widget build(BuildContext context) {
    final atlasOpen = _origin != null;
    return PopScope(
      canPop: !atlasOpen,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && atlasOpen) _close();
      },
      child: AtlasOverlayScope(
        open: _open,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ImageFiltered(
              enabled: atlasOpen,
              imageFilter: ImageFilter.blur(
                sigmaX: 14 * _backgroundBlurFactor,
                sigmaY: 14 * _backgroundBlurFactor,
              ),
              child: AbsorbPointer(absorbing: atlasOpen, child: widget.child),
            ),
            if (atlasOpen)
              AnimatedSlide(
                offset: _visible ? Offset.zero : const Offset(0, 1),
                duration: const Duration(milliseconds: 420),
                curve: const Cubic(0.32, 0.72, 0, 1),
                child: AtlasChatPage(
                  key: ValueKey('atlas-overlay-$_session'),
                  origin: _origin!,
                  onClose: _close,
                  onBackgroundBlurChanged: _setBackgroundBlur,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
