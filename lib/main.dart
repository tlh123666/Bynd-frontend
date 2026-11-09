import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/auth/auth_controller.dart';
import 'core/auth/auth_scope.dart';
import 'core/bootstrap/app_bootstrap.dart';
import 'core/config/app_config.dart';
import 'core/localization/app_locale_controller.dart';
import 'l10n/app_locale_controller.dart' as legacy_l10n;
import 'l10n/generated/app_localizations.dart';

import 'design_system/theme/app_theme.dart';
import 'features/atlas/application/atlas_scope.dart';
import 'features/atlas/data/atlas_repository.dart';
import 'features/device/application/device_controller.dart';
import 'features/device/application/device_scope.dart';
import 'features/home/home_page.dart';

Future<void> main() async {
  final config = await AppBootstrap.initialize();
  runApp(ByndApp(config: config));
}

class ByndApp extends StatefulWidget {
  const ByndApp({
    this.deviceController,
    this.atlasRepository,
    this.authController,
    this.config,
    this.localeController,
    super.key,
  });
  final DeviceController? deviceController;
  final AtlasRepository? atlasRepository;
  final AuthController? authController;
  final AppConfig? config;
  final AppLocaleController? localeController;
  @override
  State<ByndApp> createState() => _ByndAppState();
}

class _ByndAppState extends State<ByndApp> {
  late final DeviceController _devices;
  late final AtlasRepository _atlas;
  late final AuthController _auth;
  late final legacy_l10n.AppLocaleController _legacyLocale;
  @override
  void initState() {
    super.initState();
    _devices =
        widget.deviceController ??
        DeviceRuntime.create(
          config: widget.config,
          locale: widget.localeController,
        );
    _atlas =
        widget.atlasRepository ??
        AtlasRuntime.create(
          config: widget.config,
          locale: widget.localeController,
        );
    _auth =
        widget.authController ?? AuthRuntime.create(config: widget.config);
    _legacyLocale = legacy_l10n.AppLocaleController()..load();
    unawaited(_devices.initialize());
    // 恢复会话元数据；不阻塞首帧，进程被杀后重进也能带回登录态。
    unawaited(_auth.restore());
  }

  @override
  void dispose() {
    if (widget.deviceController == null) _devices.dispose();
    if (widget.atlasRepository == null) _atlas.dispose();
    if (widget.authController == null) _auth.dispose();
    _legacyLocale.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DeviceScope(
      controller: _devices,
      child: AtlasScope(
        repository: _atlas,
        child: AuthScope(
          controller: _auth,
          child: ListenableBuilder(
            listenable: _legacyLocale,
            builder: (context, _) => MaterialApp(
              title: AppConfig.applicationName,
              debugShowCheckedModeBanner: false,
              locale: _legacyLocale.locale,
              supportedLocales: const [Locale('pt', 'BR'), Locale('en')],
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                ...GlobalMaterialLocalizations.delegates,
              ],
              theme: AppTheme.dark,
              home: legacy_l10n.AppLocaleScope(
                controller: _legacyLocale,
                child: const HomePage(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
