import 'package:flutter/material.dart';

/// Timings shared by navigation and reusable controls.
abstract final class AppMotion {
  static const feedback = Duration(milliseconds: 140);
  static const veil = Duration(milliseconds: 260);
  static const drawer = Duration(milliseconds: 300);
  static const page = Duration(milliseconds: 380);
  static const loadingCycle = Duration(milliseconds: 900);
  static const quickEnter = Duration(milliseconds: 540);
  static const quickBackdrop = Duration(milliseconds: 250);
  static const quickHeadlineDelay = Duration(milliseconds: 50);
  static const quickHeadline = Duration(milliseconds: 300);
  static const quickBubble = Duration(milliseconds: 400);
  static const quickBubbleStagger = Duration(milliseconds: 28);
  static const quickBubbleExit = Duration(milliseconds: 200);
  static const quickCloseButton = Duration(milliseconds: 300);
  static const quickExit = Duration(milliseconds: 220);

  static const drawerCurve = Cubic(0.32, 0.72, 0, 1);
  static const pageCurve = Cubic(0.2, 0.8, 0.2, 1);
  static const quickBubbleCurve = Cubic(0.34, 0.27, 0.05, 1);
  static const quickExitCurve = Cubic(0.4, 0, 1, 1);

  static bool enabled(BuildContext context) =>
      !MediaQuery.disableAnimationsOf(context);
}
