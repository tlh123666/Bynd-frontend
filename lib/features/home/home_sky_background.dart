import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../../design_system/tokens/app_colors.dart';

/// CSS .hn-noite .hn-ceu and .hn-noite .hn-nuvem from the reference home.
/// The sky belongs to the home page, while its color values live in AppColors.
class HomeSkyBackground extends StatelessWidget {
  const HomeSkyBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.canvas,
      child: ClipRect(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 1020,
              child: ShaderMask(
                blendMode: BlendMode.dstIn,
                shaderCallback: (bounds) => const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, Colors.white, Colors.transparent],
                  stops: [0, 0.62, 1],
                ).createShader(bounds),
                child: Stack(
                  children: [
                    const Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: AppColors.homeNightSky,
                            stops: [0, 0.25, 0.48, 0.68, 0.86, 1],
                          ),
                        ),
                      ),
                    ),
                    const _NightCloud(
                      top: 470,
                      right: -80,
                      width: 300,
                      height: 120,
                    ),
                    const _NightCloud(
                      top: 620,
                      left: -70,
                      width: 260,
                      height: 90,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NightCloud extends StatelessWidget {
  const _NightCloud({
    required this.top,
    required this.width,
    required this.height,
    this.left,
    this.right,
  });

  final double top;
  final double width;
  final double height;
  final double? left;
  final double? right;

  @override
  Widget build(BuildContext context) => Positioned(
    top: top,
    left: left,
    right: right,
    width: width,
    height: height,
    child: ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
      child: const DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.homeNightCloud,
          borderRadius: BorderRadius.all(Radius.circular(999)),
        ),
      ),
    ),
  );
}
