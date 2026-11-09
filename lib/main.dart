import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/auth/auth_controller.dart';
import 'core/auth/auth_scope.dart';
import 'core/bootstrap/app_bootstrap.dart';
import 'core/config/app_config.dart';
import 'core/localization/app_locale_controller.dart';

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
    unawaited(_devices.initialize());
    // 恢复会话元数据；不阻塞首帧，进程被杀后重进也能带回登录态。
    unawaited(_auth.restore());
  }

  @override
  void dispose() {
    if (widget.deviceController == null) _devices.dispose();
    if (widget.atlasRepository == null) _atlas.dispose();
    if (widget.authController == null) _auth.dispose();
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
          child: ValueListenableBuilder<Locale>(
            valueListenable:
                widget.localeController ?? AppLocaleController.instance,
            builder: (context, locale, _) => MaterialApp(
              title: AppConfig.applicationName,
              debugShowCheckedModeBanner: false,
              locale: locale,
              supportedLocales: AppLocaleController.supportedLocales,
              localizationsDelegates: GlobalMaterialLocalizations.delegates,
              theme: AppTheme.dark,
              home: const HomePage(),
            ),
          ),
        ),
      ),
    );
  }
}
