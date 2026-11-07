import 'package:flutter/material.dart';

/// Timings shared by navigation and reusable controls.
abstract final class AppMotion {
  static const feedback = Duration(milliseconds: 140);
  static const veil = Duration(milliseconds: 260);
  static const drawer = Duration(milliseconds: 300);
  static const page = Duration(milliseconds: 380);
  static const loadingCycle = Duration(milliseconds: 900);

  static const drawerCurve = Cubic(0.32, 0.72, 0, 1);
  static const pageCurve = Cubic(0.2, 0.8, 0.2, 1);

  static bool enabled(BuildContext context) =>
      !MediaQuery.disableAnimationsOf(context);
}
