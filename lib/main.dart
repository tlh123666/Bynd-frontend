import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'design_system/theme/app_theme.dart';
import 'features/home/home_page.dart';
import 'l10n/app_locale_controller.dart';
import 'l10n/generated/app_localizations.dart';

void main() => runApp(const ByndApp());

class ByndApp extends StatefulWidget {
  const ByndApp({super.key});

  @override
  State<ByndApp> createState() => _ByndAppState();
}

class _ByndAppState extends State<ByndApp> {
  late final AppLocaleController _localeController;

  @override
  void initState() {
    super.initState();
    _localeController = AppLocaleController()..load();
  }

  @override
  void dispose() {
    _localeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _localeController,
      builder: (context, _) => MaterialApp(
        title: 'BYND',
        debugShowCheckedModeBanner: false,
        locale: _localeController.locale,
        supportedLocales: const [Locale('pt', 'BR'), Locale('en')],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: AppTheme.dark,
        home: AppLocaleScope(
          controller: _localeController,
          child: const HomePage(),
        ),
      ),
    );
  }
}
