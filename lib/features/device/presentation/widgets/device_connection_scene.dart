import 'package:flutter/material.dart';
import '../../../../design_system/design_system.dart';

class DeviceConnectionScene extends StatelessWidget {
  const DeviceConnectionScene({required this.connected, super.key});
  final bool connected;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 260,
    child: LayoutBuilder(
      builder: (context, box) => Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          const Positioned(
            left: -46,
            top: 18,
            height: 224,
            child: Image(
              image: AssetImage('assets/images/device-band.png'),
              fit: BoxFit.contain,
              excludeFromSemantics: true,
            ),
          ),
          Positioned(
            left: 142,
            right: 88,
            top: 130,
            child: CustomPaint(
              painter: _ConnectionLine(),
              size: const Size(double.infinity, 1),
            ),
          ),
          Positioned(
            right: -40,
            top: 26,
            width: 118,
            height: 210,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                border: Border.all(
                  color: AppColors.devicePhoneBorder,
                  width: 3,
                ),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.devicePhoneTop,
                    AppColors.devicePhoneBottom,
                  ],
                ),
              ),
              child: const Center(
                child: AppSvgIcon(
                  AppSvgAssets.atlas,
                  size: 30,
                  color: AppColors.menuIcon,
                ),
              ),
            ),
          ),
          Positioned(
            left: (54 + box.maxWidth) / 2 - 18,
            top: 112,
            width: 36,
            height: 36,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.background,
                shape: BoxShape.circle,
                border: Border.all(
                  color: connected ? AppColors.success : AppColors.textMuted,
                  width: 1,
                ),
                boxShadow: connected
                    ? const [
                        BoxShadow(color: AppColors.deviceGlow, blurRadius: 18),
                      ]
                    : null,
              ),
              child: Center(
                child: AppSvgIcon(
                  connected ? AppSvgAssets.deviceCheck : AppSvgAssets.close,
                  size: 20,
                  color: connected ? AppColors.success : AppColors.textMuted,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _ConnectionLine extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.deviceLink
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 5) {
      canvas.drawLine(
        Offset(x, 0),
        Offset((x + 3).clamp(0, size.width), 0),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_ConnectionLine oldDelegate) => false;
}
