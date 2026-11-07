import 'package:flutter/material.dart';

/// 以 bynd-app.vercel.app 的 main-BSoQRcP6.css 为准。
/// 透明色保持 CSS 的 alpha，叠在背景上时才会得到原站的视觉颜色。
abstract final class AppColors {
  static const brandSlate = Color(0xFF2C3A4E);
  static const brandLight = Color(0xFFF4F5F7);
  static const action = Color(0xFFFF6900);
  static const metallic = Color(0x8AF4F5F7);
  static const brandBlue = Color(0xFF7088A1);
  static const sky = Color(0xFFB4D0F0);
  static const sage = Color(0xFF86D4A3);
  static const rose = Color(0xFFFF7A6E);

  // CSS :root variables.
  static const background = Color(0xFF14181D); // --bg
  static const canvas = Color(0xFF0F141B); // .device
  static const surface = Color(0xFF1B1F25); // --surface
  static const surfaceDock = Color(0xFF1D2127); // --surface-dock
  static const textPrimary = Color(0xFFF4F5F7); // --text
  static const textSecondary = Color(0xB8F4F5F7); // --text-2, .72
  static const textMuted = Color(0x8AF4F5F7); // --text-3, .54
  static const textKicker = Color(0x8CF4F5F7); // #f4f5f78c, .55
  static const textHalf = Color(0x80F4F5F7); // #f4f5f780, .50
  static const textInactive = Color(0x73F4F5F7); // .45
  static const textDim = Color(0x6BF4F5F7); // #f4f5f76b, .42
  static const textOnVeil = Color(0xE6F4F5F7); // .90
  static const glassBorder = Color(0x14FFFFFF); // --stroke, .08
  static const glassBorderStrong = Color(0x24FFFFFF); // --stroke-strong, .14

  // Site-specific surfaces from .ml-*, .dock3-* and .ar-*.
  static const surfaceRaised = Color(0xFF282C34);
  static const glass = Color(0x0DFFFFFF); // #ffffff0d
  static const glassLow = Color(0x05FFFFFF); // #ffffff05
  static const divider = Color(0x0FFFFFFF); // rgba(255,255,255,.06)
  static const navGlass = Color(0x8C282C34); // #282c348c
  static const navSelected = Color(0x1FFFFFFF); // #ffffff1f
  static const navBorder = Color(0x1FFFFFFF); // rgba(255,255,255,.12)
  static const menuPanel = Color(0xE6161A20); // #161a20e6
  static const menuVeil = Color(0x66000000); // #0006
  static const menuIcon = Color(0x99F4F5F7); // #f4f5f799
  static const menuChevron = Color(0x4DF4F5F7); // #f4f5f74d
  static const menuExit = Color(0xFFFF7A6E); // .ml-sair2
  static const homeCounter = Color(0x5914181E); // #14181e59
  static const quickActionsVeil = Color(0xB80C0F14); // #0c0f14b8

  // .hn-noite .hn-ceu and .pf, scoped to their respective pages.
  static const homeNightSky = <Color>[
    Color(0xFF2C3A4E),
    Color(0xFF2E3D52),
    Color(0xFF2A384C),
    Color(0xFF212C3B),
    Color(0xFF171D27),
    background,
  ];
  static const homeNightCloud = Color(0x14AABED7);
  static const profileTop = Color(0xFF2B3644);
  static const profileMiddle = Color(0xFF1A2029);
  static const profileBottom = Color(0xFF121418);

  static const onAction = profileBottom;
  static const success = sage;
  static const error = rose;
  static const warning = Color(0xFFFF8A3D);
  static const info = sky;

  static const successSurface = Color(0x2286D4A3);
  static const errorSurface = Color(0x22FF7A6E);
  static const warningSurface = Color(0x22FF8A3D);
  static const infoSurface = Color(0x22B4D0F0);
  static const disabled = Color(0x8AF4F5F7);
}
