import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_dimensions.dart';
import '../tokens/app_motion.dart';
import '../tokens/app_typography.dart';
import 'app_icon.dart';

/// BYND symbol loader for asynchronous content and navigation work.
class AppLoadingIndicator extends StatefulWidget {
  const AppLoadingIndicator({
    this.label = 'Carregando',
    this.size = 44,
    this.color = AppColors.textPrimary,
    this.showLabel = true,
    super.key,
  });

  final String label;
  final double size;
  final Color color;
  final bool showLabel;

  @override
  State<AppLoadingIndicator> createState() => _AppLoadingIndicatorState();
}

class _AppLoadingIndicatorState extends State<AppLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppMotion.loadingCycle,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (AppMotion.enabled(context)) {
      _controller.repeat(reverse: true);
    } else {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.label,
      liveRegion: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) => Transform.rotate(
              angle: (-24 + 46 * _controller.value) * math.pi / 180,
              child: Opacity(
                opacity: 0.6 + 0.4 * _controller.value,
                child: child,
              ),
            ),
            child: AppSvgIcon(
              AppSvgAssets.loadingSymbol,
              size: widget.size,
              color: widget.color,
            ),
          ),
          if (widget.showLabel) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              widget.label,
              style: AppTypography.caption.copyWith(color: AppColors.textMuted),
            ),
          ],
        ],
      ),
    );
  }
}

/// Place around a view while its data is loading. The child remains mounted.
class AppLoadingOverlay extends StatelessWidget {
  const AppLoadingOverlay({
    required this.loading,
    required this.child,
    this.label = 'Carregando',
    super.key,
  });

  final bool loading;
  final Widget child;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        child,
        if (loading)
          Positioned.fill(
            child: ColoredBox(
              color: AppColors.background.withValues(alpha: 0.88),
              child: Center(child: AppLoadingIndicator(label: label)),
            ),
          ),
      ],
    );
  }
}
