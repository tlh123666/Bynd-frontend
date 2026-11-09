import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_typography.dart';
import 'app_button.dart';
import 'app_frosted_modal_sheet.dart';

abstract final class AppConfirmationSheet {
  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
    bool danger = false,
    String? note,
  }) async {
    return await AppFrostedModalSheet.show<bool>(
          context,
          builder: (context) => SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: AppFontFamilies.geist,
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: AppColors.textSecondary,
                  ),
                ),
                if (note != null) ...[
                  const SizedBox(height: 14),
                  Text(
                    note,
                    style: const TextStyle(
                      fontSize: 12,
                      height: 1.5,
                      color: AppColors.info,
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                AppButton(
                  label: confirmLabel,
                  expanded: true,
                  variant: danger
                      ? AppButtonVariant.danger
                      : AppButtonVariant.primary,
                  onPressed: () => Navigator.pop(context, true),
                ),
                const SizedBox(height: 10),
                AppButton(
                  label: 'Cancelar',
                  expanded: true,
                  variant: AppButtonVariant.ghost,
                  onPressed: () => Navigator.pop(context, false),
                ),
              ],
            ),
          ),
        ) ??
        false;
  }
}
