import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'design_system/theme/app_theme.dart';
import 'features/home/home_page.dart';

void main() => runApp(const ByndApp());

class ByndApp extends StatelessWidget {
  const ByndApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BYND',
      debugShowCheckedModeBanner: false,
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [Locale('pt', 'BR')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      theme: AppTheme.dark,
      home: const HomePage(),
    );
  }
}
