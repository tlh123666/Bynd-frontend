import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_dimensions.dart';

/// 从线上原型提取的 SVG。路径集中放在这里，避免页面内散落资源名。
abstract final class AppSvgAssets {
  static const logo = 'assets/icons/site/logo-bynd.svg';
  static const menu = 'assets/icons/site/menu.svg';
  static const photoCounter = 'assets/icons/site/icon-acd01ccb19fa.svg';
  static const home = 'assets/icons/site/nav-home.svg';
  static const atlas = 'assets/icons/site/nav-atlas.svg';
  static const community = 'assets/icons/site/nav-community.svg';
  static const health = 'assets/icons/site/nav-health.svg';
  static const more = 'assets/icons/site/nav-more.svg';
  static const breathe = 'assets/icons/site/quick-breathe.svg';
  static const meal = 'assets/icons/site/quick-meal.svg';
  static const startActivity = 'assets/icons/site/quick-start-activity.svg';
  static const dayReview = 'assets/icons/site/quick-day-review.svg';
  static const logActivity = 'assets/icons/site/quick-log-activity.svg';
  static const ecg = 'assets/icons/site/quick-ecg.svg';
  static const close = 'assets/icons/site/quick-close.svg';
  static const loadingSymbol = 'assets/icons/site/icon-ac0131c026ae.svg';
  static const settings = 'assets/icons/site/icon-87bf058e6cda.svg';
  static const back = 'assets/icons/site/icon-fdcacd7691d5.svg';
  static const edit = 'assets/icons/site/icon-d670f15d7a12.svg';
  static const device = 'assets/icons/site/icon-899fcc06875b.svg';
  static const diary = 'assets/icons/site/icon-938b4b6c110d.svg';
  static const journey = 'assets/icons/site/icon-d3ee07882b2c.svg';
  static const activities = 'assets/icons/site/icon-9e3e5c900961.svg';
  static const menuCommunity = 'assets/icons/site/icon-96edb8ec6e0a.svg';
  static const goals = 'assets/icons/site/icon-ef05fc70748c.svg';
  static const integrations = 'assets/icons/site/icon-9c42d2ebba19.svg';
  static const privacy = 'assets/icons/site/icon-ed0289e483bf.svg';
  static const help = 'assets/icons/site/icon-66baba9c54c2.svg';
}

class AppSvgIcon extends StatelessWidget {
  const AppSvgIcon(
    this.asset, {
    this.size = AppSizes.icon,
    this.color,
    this.label,
    super.key,
  });

  final String asset;
  final double size;
  final Color? color;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      asset,
      width: size,
      height: size,
      fit: BoxFit.contain,
      colorFilter: ColorFilter.mode(
        color ?? AppColors.textPrimary,
        BlendMode.srcIn,
      ),
      semanticsLabel: label,
      excludeFromSemantics: label == null,
    );
  }
}

/// 原型未提供的系统状态图标，仅用于通用反馈提醒。
abstract final class AppIcons {
  static const check = Icons.check_circle_outline_rounded;
  static const error = Icons.error_outline_rounded;
  static const warning = Icons.warning_amber_rounded;
  static const info = Icons.info_outline_rounded;
}

class AppIcon extends StatelessWidget {
  const AppIcon(
    this.icon, {
    this.size = AppSizes.icon,
    this.color,
    this.label,
    super.key,
  });

  final IconData icon;
  final double size;
  final Color? color;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: size,
      color: color ?? AppColors.textPrimary,
      semanticLabel: label,
    );
  }
}

/// 圆形图标按钮。label 同时作为辅助阅读器文本和长按提示。
class AppIconButton extends StatelessWidget {
  const AppIconButton({
    required this.asset,
    required this.label,
    required this.onPressed,
    this.selected = false,
    this.size = AppSizes.touchTarget,
    super.key,
  });

  final String asset;
  final String label;
  final VoidCallback? onPressed;
  final bool selected;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: Tooltip(
        message: label,
        child: Material(
          color: selected ? AppColors.glass : Colors.transparent,
          shape: const CircleBorder(side: AppBorders.glass),
          child: InkWell(
            onTap: onPressed,
            customBorder: const CircleBorder(),
            child: SizedBox(
              width: size,
              height: size,
              child: Center(
                child: AppSvgIcon(
                  asset,
                  color: onPressed == null
                      ? AppColors.disabled
                      : AppColors.textPrimary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
