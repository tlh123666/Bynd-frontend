import 'package:flutter/material.dart';

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
      theme: AppTheme.dark,
      home: const HomePage(),
    );
  }
}
