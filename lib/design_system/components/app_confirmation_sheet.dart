import 'package:flutter/material.dart';
import '../tokens/app_colors.dart';
import '../tokens/app_dimensions.dart';
import '../tokens/app_motion.dart';
import '../tokens/app_typography.dart';
import 'app_button.dart';

abstract final class AppConfirmationSheet {
  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
    bool danger = false,
    String? note,
  }) async {
    return await showModalBottomSheet<bool>(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          backgroundColor: AppColors.surface,
          barrierColor: AppColors.menuVeil,
          sheetAnimationStyle: AppMotion.enabled(context)
              ? null
              : AnimationStyle.noAnimation,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppRadii.sheet),
            ),
          ),
          builder: (context) => SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.menuChevron,
                        borderRadius: AppRadii.pillBorder,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
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
          ),
        ) ??
        false;
  }
}
