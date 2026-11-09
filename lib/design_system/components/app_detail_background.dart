import 'package:flutter/material.dart';
import '../tokens/app_colors.dart';
import '../tokens/app_typography.dart';

class AppDetailBackground extends StatelessWidget {
  const AppDetailBackground({required this.child, super.key});
  final Widget child;
  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
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
    child: DefaultTextStyle(style: AppTypography.detailBody, child: child),
  );
}
