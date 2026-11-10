import 'dart:ui';

import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_dimensions.dart';

/// 可复用的磨砂玻璃表面：统一背景模糊、饱和度、着色和渐隐描边。
class AppFrostedSurface extends StatelessWidget {
  /// 页面底部磨砂叶片使用的统一材质参数。
  const AppFrostedSurface.modalSheet({
    required this.child,
    required this.borderRadius,
    this.borderFadeHeight = 240,
    this.boxShadow = const [],
    super.key,
  }) : blurSigma = 14,
       saturation = 1.5,
       tintColor = AppColors.sheetGlassTint,
       borderColor = AppColors.sheetGlassBorder,
       fit = StackFit.loose;

  const AppFrostedSurface({
    required this.child,
    required this.borderRadius,
    this.blurSigma = AppSizes.glassBlur,
    this.saturation = 1,
    this.tintColor = AppColors.glass,
    this.borderColor = AppColors.glassBorder,
    this.borderFadeHeight = 0,
    this.boxShadow = const [],
    this.fit = StackFit.expand,
    super.key,
  });

  final Widget child;
  final BorderRadius borderRadius;
  final double blurSigma;
  final double saturation;
  final Color tintColor;
  final Color borderColor;

  /// 大于 0 时，描边从顶部向下渐隐，适用于原型中的底部面板。
  final double borderFadeHeight;
  final List<BoxShadow> boxShadow;
  final StackFit fit;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: boxShadow,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Stack(
          fit: fit,
          children: [
            Positioned.fill(
              child: ColorFiltered(
                colorFilter: ColorFilter.matrix(_saturationMatrix(saturation)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: blurSigma,
                    sigmaY: blurSigma,
                  ),
                  child: ColoredBox(color: tintColor),
                ),
              ),
            ),
            if (borderFadeHeight > 0)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: borderFadeHeight,
                child: IgnorePointer(
                  child: ShaderMask(
                    blendMode: BlendMode.dstIn,
                    shaderCallback: (bounds) => const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0, .4, 1],
                      colors: [Colors.white, Colors.white, Colors.transparent],
                    ).createShader(bounds),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: borderRadius,
                        border: Border.all(color: borderColor),
                      ),
                    ),
                  ),
                ),
              ),
            child,
          ],
        ),
      ),
    );
  }

  // 与 CSS saturate() 一致的亮度加权 RGB 矩阵。
  List<double> _saturationMatrix(double value) {
    const red = .213;
    const green = .715;
    const blue = .072;
    final inverse = 1 - value;
    return [
      red * inverse + value,
      green * inverse,
      blue * inverse,
      0,
      0,
      red * inverse,
      green * inverse + value,
      blue * inverse,
      0,
      0,
      red * inverse,
      green * inverse,
      blue * inverse + value,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ];
  }
}
