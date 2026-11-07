import 'package:flutter/material.dart';

/// 暂用系统字体，正式品牌字体到位后可从主题统一替换。
abstract final class AppFontSizes {
  static const caption = 12.0;
  static const label = 14.0;
  static const body = 16.0;
  static const title = 20.0;
  static const section = 24.0;
  static const page = 32.0;
  static const hero = 48.0;
}

abstract final class AppTypography {
  static const caption = TextStyle(
    fontSize: AppFontSizes.caption,
    height: 1.35,
    fontWeight: FontWeight.w500,
  );
  static const label = TextStyle(
    fontSize: AppFontSizes.label,
    height: 1.3,
    fontWeight: FontWeight.w600,
  );
  static const body = TextStyle(
    fontSize: AppFontSizes.body,
    height: 1.5,
    fontWeight: FontWeight.w400,
  );
  static const title = TextStyle(
    fontSize: AppFontSizes.title,
    height: 1.2,
    fontWeight: FontWeight.w700,
  );
  static const section = TextStyle(
    fontSize: AppFontSizes.section,
    height: 1.2,
    fontWeight: FontWeight.w700,
  );
  static const page = TextStyle(
    fontSize: AppFontSizes.page,
    height: 1.1,
    fontWeight: FontWeight.w700,
  );
  static const hero = TextStyle(
    fontSize: AppFontSizes.hero,
    height: 1,
    fontWeight: FontWeight.w700,
  );
}
