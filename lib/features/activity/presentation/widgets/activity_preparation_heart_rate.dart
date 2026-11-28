import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../design_system/design_system.dart';
import '../../../../l10n/app_localizations_context.dart';

/// 非 GPS 运动的示例心率环；示例数值不代表设备测量或个人分区。
class ActivityPreparationHeartRate extends StatelessWidget {
  const ActivityPreparationHeartRate({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    return Semantics(
      label: s.preparationHeartRateSemantics,
      child: ExcludeSemantics(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = math.min(
              290.0,
              math.min(constraints.maxWidth, constraints.maxHeight * 320 / 300),
            );
            return Center(
              child: SizedBox(
                key: const ValueKey('preparation-heart-rate'),
                width: width,
                height: width * 300 / 320,
                child: CustomPaint(
                  painter: const _HeartRateRingPainter(),
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.favorite_border,
                                size: 14,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                s.preparationHeartRateZone,
                                style: AppTypography.kicker.copyWith(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '74',
                            style: AppTypography.signalValue.copyWith(
                              fontSize: 104,
                              letterSpacing: -3.1,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            s.preparationHeartRateRest,
                            style: AppTypography.caption.copyWith(
                              fontSize: 13,
                              color: AppColors.textMuted,
                            ),
                          ),
                          Text(
                            s.preparationHeartRateDemo,
                            style: AppTypography.caption.copyWith(
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _HeartRateRingPainter extends CustomPainter {
  const _HeartRateRingPainter();

  @override
  void paint(Canvas canvas, Size size) {
    // 使用网页原型的 320×300 视图、270 度弧线和 50–186 示例范围。
    canvas.save();
    canvas.scale(size.width / 320, size.height / 300);
    const center = Offset(160, 160);
    const radius = 132.0;
    final ring = Paint()
      ..color = const Color(0x1fffffff)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      135 * math.pi / 180,
      270 * math.pi / 180,
      false,
      ring,
    );
    final angle = (135 + (74 - 50) / (186 - 50) * 270) * math.pi / 180;
    final dot =
        center + Offset(math.cos(angle) * radius, math.sin(angle) * radius);
    canvas.drawCircle(dot, 4.75, Paint()..color = const Color(0xffa7aeb7));
    canvas.drawCircle(
      dot,
      4.75,
      Paint()
        ..color = AppColors.textPrimary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _HeartRateRingPainter oldDelegate) => false;
}
