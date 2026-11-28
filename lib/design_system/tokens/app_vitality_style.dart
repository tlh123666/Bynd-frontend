import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_atmosphere_palette.dart';

/// Final CSS variables of recuperacao.html / energia.html, 2026-11-15.
abstract final class AppVitalityStyle {
  static const arcStart = Color(0xFFE7F6F0), arcEnd = Color(0xFF009B6E);
  static const recoveryPalette = AppAtmospherePalette(
    Color(0xFF0B1612),
    Color(0xFF537468),
    Color(0xFF7FAD9C),
    Color.from(alpha: 1, red: .141, green: .328, blue: .25),
  );
  static const energyPalette = AppAtmospherePalette(
    Color(0xFF19120E),
    Color(0xFF7C675B),
    Color(0xFFB89A8A),
    Color.from(alpha: 1, red: .385, green: .242, blue: .179),
  );
  static const recovery = Color(0xFF8FCDB9), energy = Color(0xFFEBB79A);
  static const attention = Color(0xFFECD27C),
      good = Color(0xFF86D4A3),
      low = Color(0xFFEE9A94);
  static const secondary = Color(0xB8F4F5F7),
      muted = Color(0x80F4F5F7),
      line = Color(0x14FFFFFF);
  static const recoverySky = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF1D3C30), Color(0xFF10251C), Color(0xFF030705)],
    stops: [0, .45, 1],
  );
  static const energySky = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF442E22), Color(0xFF281B14), Color(0xFF070503)],
    stops: [0, .45, 1],
  );
  static const number = TextStyle(
    fontFamily: AppFontFamilies.urbanist,
    fontSize: 64,
    fontWeight: FontWeight.w200,
    height: .9,
    letterSpacing: -2.56,
    color: AppColors.textPrimary,
  );
  static const title = TextStyle(
    fontFamily: AppFontFamilies.urbanist,
    fontSize: 28,
    fontWeight: FontWeight.w300,
    height: 1.15,
    letterSpacing: -.56,
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
    color: secondary,
  );
  static const caption = TextStyle(
    fontFamily: AppFontFamilies.urbanist,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: muted,
  );
  static const kicker = TextStyle(
    fontFamily: AppFontFamilies.urbanist,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    height: 1.35,
    letterSpacing: 1.54,
    color: secondary,
  );
}
