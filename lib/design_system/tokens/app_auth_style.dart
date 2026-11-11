import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

abstract final class AppAuthStyle {
  static const maxWidth = 520.0;
  static const headline = TextStyle(
    fontFamily: AppFontFamilies.urbanist,
    fontSize: 40,
    fontWeight: FontWeight.w300,
    height: 1.12,
    color: AppColors.textPrimary,
  );
  static const title = TextStyle(
    fontFamily: AppFontFamilies.urbanist,
    fontSize: 30,
    fontWeight: FontWeight.w300,
    height: 1.18,
    color: AppColors.textPrimary,
  );
  static const backdrop = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0x40121418),
      Color(0x0D121418),
      Color(0xD9121418),
      AppColors.homeCanvas,
    ],
    stops: [0, .25, .65, 1],
  );
}
