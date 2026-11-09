import 'package:flutter/material.dart';
import 'app_colors.dart';

/// 原站 CSS 使用 Geist 正文、Urbanist 大标题、Newsreader 衬线文字。
abstract final class AppFontFamilies {
  static const geist = 'Geist';
  static const urbanist = 'Urbanist';
  static const newsreader = 'Newsreader';
}

abstract final class AppFontSizes {
  // CSS :root --fs-* values; individual pages may override these.
  static const kicker = 11.0;
  static const greeting = 15.5;
  static const note = 12.5;
  static const rootHero = 28.0;
  static const lead = 14.0;
  static const value = 15.0;
  static const hint = 12.0;
  static const tab = 10.0;

  static const caption = 12.0;
  static const label = 14.0;
  static const body = 16.0;
  static const title = 20.0;
  static const section = 24.0;
  static const page = 32.0;
  static const hero = 48.0;
}

abstract final class AppTypography {
  static const detailBody = TextStyle(
    fontFamily: AppFontFamilies.geist,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.2,
    color: AppColors.textPrimary,
  );
  static const listItem = TextStyle(
    fontFamily: AppFontFamilies.geist,
    fontSize: 15.5,
    fontWeight: FontWeight.w400,
  );
  static const kicker = TextStyle(
    fontFamily: AppFontFamilies.geist,
    fontSize: AppFontSizes.kicker,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.76,
  );
  static const caption = TextStyle(
    fontFamily: AppFontFamilies.geist,
    fontSize: AppFontSizes.caption,
    height: 1.35,
    fontWeight: FontWeight.w400,
  );
  static const label = TextStyle(
    fontFamily: AppFontFamilies.geist,
    fontSize: AppFontSizes.label,
    height: 1.3,
    fontWeight: FontWeight.w500,
  );
  static const body = TextStyle(
    fontFamily: AppFontFamilies.geist,
    fontSize: AppFontSizes.body,
    height: 1.5,
    fontWeight: FontWeight.w400,
  );
  static const title = TextStyle(
    fontFamily: AppFontFamilies.geist,
    fontSize: AppFontSizes.title,
    height: 1.2,
    fontWeight: FontWeight.w500,
  );
  static const section = TextStyle(
    fontFamily: AppFontFamilies.urbanist,
    fontSize: AppFontSizes.section,
    height: 1.2,
    fontWeight: FontWeight.w300,
  );
  static const page = TextStyle(
    fontFamily: AppFontFamilies.urbanist,
    fontSize: AppFontSizes.page,
    height: 1.1,
    fontWeight: FontWeight.w300,
  );
  static const hero = TextStyle(
    fontFamily: AppFontFamilies.urbanist,
    fontSize: AppFontSizes.hero,
    height: 1,
    fontWeight: FontWeight.w300,
  );
}
