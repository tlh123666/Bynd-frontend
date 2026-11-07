import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_dimensions.dart';
import '../tokens/app_typography.dart';
import '../navigation/app_page_transitions.dart';

abstract final class AppTheme {
  static final dark = ThemeData(
    useMaterial3: true,
    fontFamily: AppFontFamilies.geist,
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: AppPageTransitionsBuilder(),
        TargetPlatform.iOS: AppPageTransitionsBuilder(),
        TargetPlatform.macOS: AppPageTransitionsBuilder(),
        TargetPlatform.windows: AppPageTransitionsBuilder(),
        TargetPlatform.linux: AppPageTransitionsBuilder(),
        TargetPlatform.fuchsia: AppPageTransitionsBuilder(),
      },
    ),
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.action,
      onPrimary: AppColors.onAction,
      secondary: AppColors.brandBlue,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      error: AppColors.error,
      outline: AppColors.glassBorder,
    ),
    scaffoldBackgroundColor: AppColors.background,
    iconTheme: const IconThemeData(color: AppColors.textPrimary),
    textTheme:
        const TextTheme(
          displayLarge: AppTypography.hero,
          headlineLarge: AppTypography.page,
          headlineMedium: AppTypography.section,
          titleLarge: AppTypography.title,
          titleMedium: AppTypography.label,
          bodyLarge: AppTypography.body,
          bodyMedium: AppTypography.label,
          bodySmall: AppTypography.caption,
          labelLarge: AppTypography.label,
          labelSmall: AppTypography.caption,
        ).apply(
          bodyColor: AppColors.textPrimary,
          displayColor: AppColors.textPrimary,
        ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      centerTitle: false,
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.divider,
      thickness: AppBorders.hairline,
    ),
    cardTheme: const CardThemeData(
      color: AppColors.glass,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadii.cardBorder,
        side: BorderSide(color: AppColors.glassBorder),
      ),
    ),
  );
}
