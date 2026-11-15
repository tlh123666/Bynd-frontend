import 'package:flutter/material.dart';
import '../tokens/app_colors.dart';

/// Shared edge-to-edge metric surface used by the reference's detail pages.
class AppMetricCard extends StatelessWidget {
  const AppMetricCard({
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
    this.gradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0x09FFFFFF), Color(0x03FFFFFF)],
    ),
    this.radius = const BorderRadius.all(Radius.circular(12)),
    super.key,
  });
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final Gradient gradient;
  final BorderRadius radius;
  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    child: Ink(
      decoration: BoxDecoration(gradient: gradient, borderRadius: radius),
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        highlightColor: AppColors.glass,
        child: Padding(padding: padding, child: child),
      ),
    ),
  );
}
