import 'package:flutter/material.dart';

/// 社区模块的视觉常量，逐项取自对方原型 `src/tokens.css` 与
/// `src/styles/comunidade.css`，不是 Flutter 侧自创的二手翻译。
///
/// 与全局设计系统同源的值（bg/surface/text 三层）直接用 `AppColors`；
/// 这里只收全局令牌里没有、原型社区独有的颜色与形状。
abstract final class CommunityStyle {
  // ---- tokens.css ----
  static const Color accent = Color(0xFFEC7030); // --accent
  static const Color accentSoft = Color(0xFF3A2A22); // --accent-soft
  static const Color accentText = Color(0xFFF0955C); // --accent-text
  static const Color blue = Color(0xFF8EA6D6); // --blue
  static const Color green = Color(0xFF8FCDB9); // --green
  static const Color gold = Color(0xFFF2C27F); // mural Atlas 的强调色
  static const Color skyBright = Color(0xFF9CC4FF); // 聊天 Atlas 渐变里的天蓝
  static const Color surface2 = Color(0xFF22272E); // --surface-2
  static const Color bubbleMine = Color(0xFF2B3442); // .gc-msg.eu .gc-bal
  static const Color bubbleOther = Color(0xFF1C1F24); // .gc-bal
  static const Color stroke = Color(0x14FFFFFF); // rgba(255,255,255,.08)
  static const Color strokeStrong = Color(0x24FFFFFF); // rgba(255,255,255,.14)
  static const Color onImage = Color(0xB3FFFFFF); // 封面上的次级白

  // ---- 形状 ----
  static const double coverWidth = 300; // .cmb-capa
  static const double coverHeight = 184;
  static const double coverRadius = 24;
  static const double cardRadius = 18; // --radius-lg
  static const double bubbleRadius = 18;

  /// .cmb-capa::after 的自上而下压暗层。
  static const LinearGradient coverScrim = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0, 0.35, 1],
    colors: [
      Color(0x40140C0C),
      Color(0x26140C0C),
      Color(0xD1140C0C),
    ],
  );

  /// .gc-atlas 的蓝调渐变底。
  static const LinearGradient atlasBubble = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0x1A9CC4FF), Color(0x08FFFFFF)],
  );

  /// .cmb-capa 无图时的替代底（真实图片要等群封面上传，见缺口 G-2）。
  static const LinearGradient coverFallback = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF232C38), Color(0xFF1B1F25)],
  );
}
