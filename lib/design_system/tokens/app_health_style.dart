import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

/// Design tokens from the November health pages and shared chart legend.
abstract final class AppHealthStyle {
  static const canvas = Color(0xFF111519);
  static const background = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF263440), Color(0xFF182026), canvas],
    stops: [0, .34, 1],
  );
  static const surface = Color(0x0BFFFFFF);
  static const divider = Color(0x12FFFFFF);
  static const glass = Color(0x8C14181E);
  static const positive = Color(0xFF86D4A3);
  static const attention = Color(0xFFECD27C);
  static const low = Color(0xFFEE9A94);
  static const pulse = Color(0xFFFF8A7A);
  static const awake = Color(0xFFEFECE4);
  static const rem = Color(0xFFA99BE6);
  static const light = Color(0xFFD4CDF3);
  static const deep = Color(0xFF6A6EC6);
  static const edge = 16.0;
  static const gap = 14.0;
  static const sectionGap = 36.0;
  static const radius = 18.0;
  static const trendHeight = 293.0;
  static const body = TextStyle(
    fontFamily: AppFontFamilies.urbanist,
    fontSize: 15,
    height: 1.5,
    color: AppColors.textSecondary,
  );
  static const small = TextStyle(
    fontFamily: AppFontFamilies.urbanist,
    fontSize: 13,
    height: 1.3,
    color: AppColors.textMuted,
  );
  static const legend = TextStyle(
    fontFamily: AppFontFamilies.urbanist,
    fontSize: 11,
    height: 14 / 11,
    color: Color(0x73FFFFFF),
  );
  static const title = TextStyle(
    fontFamily: AppFontFamilies.urbanist,
    fontSize: 26,
    height: 1.2,
    color: AppColors.textPrimary,
  );
  static const section = TextStyle(
    fontFamily: AppFontFamilies.urbanist,
    fontSize: 20,
    fontWeight: FontWeight.w300,
    color: AppColors.textPrimary,
  );
  static const value = TextStyle(
    fontFamily: AppFontFamilies.urbanist,
    fontSize: 30,
    fontWeight: FontWeight.w300,
    letterSpacing: -.5,
    height: 1.1,
    color: AppColors.textPrimary,
  );
  static final hero = value.copyWith(fontSize: 44);
}
