import 'dart:async';

import 'package:flutter/material.dart';
import '../../design_system/design_system.dart';
import '../../features/heart/presentation/pages/heart_page.dart';
import '../../features/activity/presentation/activity_selection_flow.dart';

/// Cross-page quick actions share one destination and its account-scoped state.
abstract final class AppQuickActionNavigation {
  static bool open(
    BuildContext context,
    AppQuickAction action, {
    bool? demo,
    DateTime? date,
    ValueChanged<int>? onDestinationSelected,
  }) {
    if (action == AppQuickAction.startActivity) {
      // 直接在当前页面上打开活动选择，取消后保持原页面和滚动状态。
      unawaited(openActivitySelection(context));
      return true;
    }
    if (action != AppQuickAction.ecg) return false;
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => HeartPage(
          date: date,
          demo: demo,
          openRecording: true,
          onDestinationSelected: onDestinationSelected,
        ),
      ),
    );
    return true;
  }
}
