import 'package:flutter/material.dart';
import '../../design_system/design_system.dart';
import 'data/home_photo_assets.dart';

/// .hn-fundo.hn-hero: original image + CSS overlay + bottom mask.
class HomeSkyBackground extends StatelessWidget {
  const HomeSkyBackground({this.photo = 1, this.now, super.key});
  final int photo;
  final DateTime? now;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final top = MediaQuery.paddingOf(context).top.clamp(20.0, 80.0);
      return OverflowBox(
        alignment: Alignment.bottomCenter,
        maxHeight: constraints.maxHeight + top,
        child: SizedBox(
          height: constraints.maxHeight + top,
          child: ShaderMask(
            blendMode: BlendMode.dstIn,
            shaderCallback: (bounds) => const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Colors.white, Colors.transparent],
              stops: [0, .82, 1],
            ).createShader(bounds),
            child: Stack(
              fit: StackFit.expand,
              children: [
                AnimatedSwitcher(
                  duration: AppMotion.enabled(context)
                      ? AppMotion.homeEnter
                      : Duration.zero,
                  child: SizedBox.expand(
                    key: ValueKey(photo),
                    child: Image.asset(
                      HomePhotoAssets.path(photo, now ?? DateTime.now()),
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                      errorBuilder: (_, _, _) =>
                          const ColoredBox(color: AppColors.brandSlate),
                    ),
                  ),
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: AppColors.homePhotoShade,
                      stops: [0, .22, .5, .78, 1],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
