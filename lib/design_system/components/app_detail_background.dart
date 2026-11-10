import 'package:flutter/material.dart';
import '../tokens/app_colors.dart';
import '../tokens/app_typography.dart';

class AppDetailBackground extends StatelessWidget {
  const AppDetailBackground({
    required this.child,
    this.gradient,
    this.headerWash,
    this.headerWashHeight = 380,
    super.key,
  });
  final Widget child;
  final Gradient? gradient, headerWash;
  final double headerWashHeight;
  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      gradient:
          gradient ??
          const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.detailTop,
              AppColors.profileMiddle,
              AppColors.profileBottom,
              AppColors.profileBottom,
            ],
            stops: [0, .22, .5, 1],
          ),
    ),
    child: Stack(
      fit: StackFit.passthrough,
      children: [
        if (headerWash != null)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: headerWashHeight,
            child: DecoratedBox(
              decoration: BoxDecoration(gradient: headerWash),
            ),
          ),
        DefaultTextStyle(style: AppTypography.detailBody, child: child),
      ],
    ),
  );
}
