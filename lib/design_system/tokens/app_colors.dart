import 'package:flutter/material.dart';

/// BYND 色板，以及深色界面常用的语义颜色。
abstract final class AppColors {
  static const brandSlate = Color(0xFF333F48);
  static const brandLight = Color(0xFFDDE5ED);
  static const action = Color(0xFFFF6900);
  static const metallic = Color(0xFF8D9093);
  static const brandBlue = Color(0xFF7088A1);
  static const sky = Color(0xFFABCAE9);
  static const sage = Color(0xFF697E70);
  static const rose = Color(0xFFC6858F);

  static const background = Color(0xFF0B0F12);
  static const surface = Color(0xFF1A2025);
  static const surfaceRaised = brandSlate;
  static const glass = Color(0x1FFFFFFF);
  static const glassBorder = Color(0x47FFFFFF);
  static const divider = Color(0x24FFFFFF);
  static const navGlass = Color(0x660B0F12);
  static const navSelected = Color(0x33FFFFFF);
  static const referenceCanvasTop = Color(0xFF9D978C);
  static const referenceCanvasBottom = Color(0xFF625E58);

  static const textPrimary = brandLight;
  static const textSecondary = Color(0xFFA4BCC2);
  static const textMuted = metallic;
  static const onAction = Color(0xFF0B1116);
  static const success = sage;
  static const error = rose;
  static const warning = Color(0xFFEA733D);
  static const info = sky;

  static const successSurface = Color(0x33697E70);
  static const errorSurface = Color(0x33C6858F);
  static const warningSurface = Color(0x33EA733D);
  static const infoSurface = Color(0x33ABCAE9);
  static const disabled = Color(0x618D9093);
}
