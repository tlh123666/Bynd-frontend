import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_atmosphere_palette.dart';

/// Final computed CSS of coracao.html?app (2026-11-14), including overrides.
abstract final class AppHeartStyle {
  static const family = Color(0xFFF2B1AD);
  static const good = Color(0xFF86D4A3);
  static const attention = Color(0xFFECD27C);
  static const muted = Color(0x80F4F5F7);
  static const bodyColor = Color(0xB8F4F5F7);
  static const ecgButton = Color(0x21F2B1AD);
  static const sky = AppAtmospherePalette(
    Color(0xFF1A1111),
    Color(0xFF7F6562),
    Color(0xFFBB9794),
    Color.from(alpha: 1, red: .404, green: .23, blue: .218),
  );
  static const background = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF583C3A), Color(0xFF2F1F1E), Color(0xFF121418)],
    stops: [0, .55, 1],
  );
  static const number = TextStyle(
    fontFamily: AppFontFamilies.geist,
    fontSize: 64,
    fontWeight: FontWeight.w200,
    letterSpacing: -2.56,
    height: .9,
    color: AppColors.textPrimary,
  );
  static const title = TextStyle(
    fontFamily: AppFontFamilies.geist,
    fontSize: 28,
    fontWeight: FontWeight.w300,
    letterSpacing: -.56,
    height: 1.15,
    color: AppColors.textPrimary,
  );
  static const value = TextStyle(
    fontFamily: AppFontFamilies.geist,
    fontSize: 34,
    fontWeight: FontWeight.w300,
    height: 1.1,
    color: AppColors.textPrimary,
  );
  static const body = TextStyle(
    fontFamily: AppFontFamilies.geist,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: bodyColor,
  );
  static const caption = TextStyle(
    fontFamily: AppFontFamilies.geist,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: muted,
  );
  static const kicker = TextStyle(
    fontFamily: AppFontFamilies.geist,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.54,
    height: 1.35,
    color: bodyColor,
  );
}
