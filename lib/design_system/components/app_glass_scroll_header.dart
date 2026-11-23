import 'package:flutter/material.dart';

import '../tokens/app_health_style.dart';
import '../tokens/app_motion.dart';
import 'app_frosted_surface.dart';

/// [body] receives the inset for content to start below the pinned header.
class AppGlassScrollHeader extends StatefulWidget {
  const AppGlassScrollHeader({
    required this.header,
    required this.height,
    required this.body,
    super.key,
  });
  final Widget header;
  final double height;
  final Widget Function(double inset) body;

  @override
  State<AppGlassScrollHeader> createState() => _AppGlassScrollHeaderState();
}

class _AppGlassScrollHeaderState extends State<AppGlassScrollHeader> {
  final _glass = ValueNotifier(false);

  @override
  void dispose() {
    _glass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      Positioned.fill(
        child: NotificationListener<ScrollNotification>(
          onNotification: (event) {
            if (event.depth == 0 && event.metrics.axis == Axis.vertical) {
              _glass.value = event.metrics.pixels > 6;
            }
            return false;
          },
          child: widget.body(widget.height),
        ),
      ),
      Positioned(
        top: 0,
        left: 0,
        right: 0,
        height: widget.height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            IgnorePointer(
              child: ValueListenableBuilder<bool>(
                valueListenable: _glass,
                builder: (context, show, child) => AnimatedOpacity(
                  opacity: show ? 1 : 0,
                  duration: AppMotion.enabled(context)
                      ? AppMotion.touchRelease
                      : Duration.zero,
                  child: child,
                ),
                child: const AppFrostedSurface(
                  borderRadius: BorderRadius.zero,
                  tintColor: AppHealthStyle.glass,
                  borderColor: Colors.transparent,
                  blurSigma: 16,
                  saturation: 1.2,
                  child: SizedBox.expand(),
                ),
              ),
            ),
            widget.header,
          ],
        ),
      ),
    ],
  );
}
