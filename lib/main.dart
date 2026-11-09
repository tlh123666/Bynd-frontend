import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'design_system/theme/app_theme.dart';
import 'features/home/home_page.dart';
import 'features/device/application/device_controller.dart';
import 'features/device/application/device_scope.dart';

void main() => runApp(const ByndApp());

class ByndApp extends StatefulWidget {
  const ByndApp({this.deviceController, super.key});
  final DeviceController? deviceController;
  @override
  State<ByndApp> createState() => _ByndAppState();
}

class _ByndAppState extends State<ByndApp> {
  late final DeviceController _devices;
  @override
  void initState() {
    super.initState();
    _devices = widget.deviceController ?? DeviceRuntime.create();
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
      child: MaterialApp(
        title: 'BYND',
        debugShowCheckedModeBanner: false,
        locale: const Locale('pt', 'BR'),
        supportedLocales: const [Locale('pt', 'BR')],
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        theme: AppTheme.dark,
        home: const HomePage(),
      ),
    );
  }
}
