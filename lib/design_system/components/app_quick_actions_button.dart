import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_dimensions.dart';
import '../tokens/app_motion.dart';
import 'app_icon.dart';

/// 快捷操作入口与遮罩关闭键共用的按钮外观。
class AppQuickActionsButton extends StatelessWidget {
  const AppQuickActionsButton({
    required this.isOpen,
    required this.onPressed,
    required this.label,
    super.key,
  });

  final bool isOpen;
  final VoidCallback? onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    final motionEnabled = AppMotion.enabled(context);
    final button = Material(
      color: isOpen ? AppColors.textPrimary : AppColors.navGlass,
      elevation: isOpen ? 8 : 0,
      shadowColor: AppColors.background.withValues(alpha: .55),
      shape: CircleBorder(side: isOpen ? BorderSide.none : AppBorders.nav),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: SizedBox.square(
          dimension: 56,
          child: Center(
            child: AnimatedSwitcher(
              duration: motionEnabled
                  ? const Duration(milliseconds: 180)
                  : Duration.zero,
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: RotationTransition(
                  turns: Tween<double>(begin: -.25, end: 0).animate(animation),
                  child: child,
                ),
              ),
              child: AppSvgIcon(
                isOpen ? AppSvgAssets.close : AppSvgAssets.more,
                key: ValueKey<bool>(isOpen),
                size: 22,
                color: isOpen ? AppColors.background : AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );

    return Tooltip(
      message: label,
      child: Semantics(
        label: label,
        button: true,
        child: isOpen
            ? button
            : ClipOval(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: AppSizes.glassBlur,
                    sigmaY: AppSizes.glassBlur,
                  ),
                  child: button,
                ),
              ),
      ),
    );
  }
}
