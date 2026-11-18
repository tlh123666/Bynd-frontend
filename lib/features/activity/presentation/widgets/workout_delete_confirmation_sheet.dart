import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../design_system/design_system.dart';
import '../../../../l10n/app_localizations_context.dart';
import 'activity_frosted_sheet_header.dart';

/// 删除训练入口共用的低位确认叶片；关闭或点击遮罩均视为取消。
abstract final class WorkoutDeleteConfirmationSheet {
  static Future<bool> show(BuildContext context, {required String name}) async {
    final s = context.l10n;
    return await AppFrostedModalSheet.show<bool>(
          context,
          showHandle: false,
          waitForExit: true,
          builder: (context) => LayoutBuilder(
            builder: (context, constraints) {
              final media = MediaQuery.of(context);
              final available = math.max(
                0.0,
                media.size.height * .84 -
                    media.padding.bottom -
                    media.viewInsets.bottom,
              );
              final height = math.min(
                302.0,
                math.min(constraints.maxHeight, available),
              );
              return SizedBox(
                height: height,
                child: Column(
                  children: [
                    ActivityFrostedSheetHeader(
                      title: s.workoutDeleteTitle,
                      height: math.min(62, height),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 6, 20, 8),
                        child: Text(
                          s.workoutDeleteMessage(name),
                          style: AppTypography.caption.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 15,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                    if (height >= 134)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                        child: SizedBox(
                          width: 272,
                          height: 48,
                          child: AppButton(
                            label: s.workoutMenuDelete,
                            onPressed: () => Navigator.pop(context, true),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ) ??
        false;
  }
}
