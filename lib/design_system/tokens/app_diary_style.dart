import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

/// diario.html/base.css computed values, shared by timeline and record sheets.
abstract final class AppDiaryStyle {
  static const background = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF151A24), Color(0xFF121620), Color(0xFF0E1118)],
    stops: [0, .45, 1],
  );
  static const headerWash = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color.fromRGBO(40, 58, 92, .55),
      Color.fromRGBO(28, 40, 66, .32),
      Color.fromRGBO(20, 26, 40, .12),
      Color.fromRGBO(0, 0, 0, 0),
    ],
    stops: [0, 140 / 380, 260 / 380, 1],
  );
  static const surface = Color.fromRGBO(255, 255, 255, .043);
  static const line = Color.fromRGBO(255, 255, 255, .08);
  static const faint = Color.fromRGBO(244, 245, 247, .35);
  static const muted = Color.fromRGBO(244, 245, 247, .5);
  static const radius = BorderRadius.all(Radius.circular(18));
  static const title = TextStyle(
    fontFamily: AppFontFamilies.urbanist,
    fontSize: 26,
    fontWeight: FontWeight.w300,
    height: 31 / 26,
    color: AppColors.textPrimary,
  );
  static const section = TextStyle(
    fontFamily: AppFontFamilies.urbanist,
    fontSize: 20,
    fontWeight: FontWeight.w300,
    height: 1.25,
    color: AppColors.textPrimary,
  );
  static const label = TextStyle(
    fontFamily: AppFontFamilies.geist,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 19 / 15,
    color: AppColors.textPrimary,
  );
  static const caption = TextStyle(
    fontFamily: AppFontFamilies.geist,
    fontSize: 13,
    fontWeight: FontWeight.w300,
    height: 17 / 13,
    color: muted,
  );
}
