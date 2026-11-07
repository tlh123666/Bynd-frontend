import 'dart:ui';

import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_dimensions.dart';

enum AppCardVariant { glass, solid }

class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.onTap,
    this.variant = AppCardVariant.glass,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.selected = false,
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;
  final AppCardVariant variant;
  final EdgeInsetsGeometry padding;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final content = Container(
      decoration: BoxDecoration(
        color: variant == AppCardVariant.glass
            ? AppColors.glass
            : AppColors.surfaceRaised,
        borderRadius: AppRadii.cardBorder,
        border: Border.all(
          color: selected ? AppColors.textPrimary : AppColors.glassBorder,
          width: AppBorders.hairline,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.cardBorder,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
    return ClipRRect(
      borderRadius: AppRadii.cardBorder,
      child: variant == AppCardVariant.glass
          ? BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: AppSizes.glassBlur,
                sigmaY: AppSizes.glassBlur,
              ),
              child: content,
            )
          : content,
    );
  }
}
