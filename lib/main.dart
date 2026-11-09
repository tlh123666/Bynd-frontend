import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/bootstrap/app_bootstrap.dart';
import 'core/config/app_config.dart';
import 'core/localization/app_locale_controller.dart';

import 'design_system/theme/app_theme.dart';
import 'features/home/home_page.dart';
import 'features/device/application/device_controller.dart';
import 'features/device/application/device_scope.dart';

Future<void> main() async {
  final config = await AppBootstrap.initialize();
  runApp(ByndApp(config: config));
}

class ByndApp extends StatefulWidget {
  const ByndApp({
    this.deviceController,
    this.config,
    this.localeController,
    super.key,
  });
  final DeviceController? deviceController;
  final AppConfig? config;
  final AppLocaleController? localeController;
  @override
  State<ByndApp> createState() => _ByndAppState();
}

class _ByndAppState extends State<ByndApp> {
  late final DeviceController _devices;
  @override
  void initState() {
    super.initState();
    _devices =
        widget.deviceController ??
        DeviceRuntime.create(
          config: widget.config,
          locale: widget.localeController,
        );
    unawaited(_devices.initialize());
  }

  @override
  void dispose() {
    if (widget.deviceController == null) _devices.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DeviceScope(
      controller: _devices,
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
    );
  }
}
