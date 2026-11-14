import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

/// Computed CSS from sono.html (2026-11-14). Kept local to the sleep family;
/// its stage palette and typography do not override diary or activity tokens.
abstract final class AppSleepStyle {
  static const background = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF2B405C), Color(0xFF18232F), Color(0xFF101418)],
    stops: [0, .42, 1],
  );
  static const card = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0x09FFFFFF), Color(0x03FFFFFF)],
  );
  static const score = TextStyle(
    fontFamily: AppFontFamilies.urbanist,
    fontSize: 64,
    fontWeight: FontWeight.w200,
    height: .9,
    color: AppColors.textPrimary,
  );
  static const title = TextStyle(
    fontFamily: AppFontFamilies.urbanist,
    fontSize: 28,
    fontWeight: FontWeight.w300,
    height: 1.15,
    color: AppColors.textPrimary,
  );
  static const value = TextStyle(
    fontFamily: AppFontFamilies.urbanist,
    fontSize: 34,
    fontWeight: FontWeight.w300,
    height: 1.1,
    color: AppColors.textPrimary,
  );
  static const body = TextStyle(
    fontFamily: AppFontFamilies.urbanist,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textSecondary,
  );
  static const caption = TextStyle(
    fontFamily: AppFontFamilies.urbanist,
    fontSize: 13,
    fontWeight: FontWeight.w300,
    height: 1.35,
    color: AppColors.textMuted,
  );
  static const kicker = TextStyle(
    fontFamily: AppFontFamilies.urbanist,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.5,
    color: AppColors.textSecondary,
  );
  static const pulse = Color(0xFF7DA5EE);
  static const levelGood = Color(0xFF86D4A3);
  static const levelNormal = Color(0xFFECD27C);
  static const levelLow = Color(0xFFEE9A94);
  static const stages = <String, Color>{
    'awake': Color(0xFFFFFFFF),
    'rem': Color(0xFFFFFFFF),
    'light': Color(0xFFFFFFFF),
    'deep': Color(0xFFFFFFFF),
  };
  static const radius = BorderRadius.all(Radius.circular(12));
}
