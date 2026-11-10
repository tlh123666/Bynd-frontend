import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_dimensions.dart';
import '../tokens/app_typography.dart';

/// Shared defaults for AppButton and Flutter's built-in button widgets.
abstract final class AppButtonStyles {
  static const base = ButtonStyle(
    minimumSize: WidgetStatePropertyAll(Size(0, AppSizes.buttonRegular)),
    padding: WidgetStatePropertyAll(
      EdgeInsets.symmetric(horizontal: AppSpacing.lg),
    ),
    shape: WidgetStatePropertyAll(StadiumBorder()),
    textStyle: WidgetStatePropertyAll(AppTypography.label),
    elevation: WidgetStatePropertyAll(0),
    surfaceTintColor: WidgetStatePropertyAll(Colors.transparent),
  );

  // Keep enabled colors unset here so FilledButton.tonal can use the neutral
  // secondary container while normal FilledButton uses the light primary.
  static final filledTheme = base.copyWith(
    backgroundColor: WidgetStateProperty.resolveWith(
      (states) => states.contains(WidgetState.disabled)
          ? AppColors.buttonDisabledBackground
          : null,
    ),
    foregroundColor: WidgetStateProperty.resolveWith(
      (states) =>
          states.contains(WidgetState.disabled) ? AppColors.textDim : null,
    ),
  );

  static final filled = _style(
    background: AppColors.action,
    foreground: AppColors.onAction,
    filled: true,
  );
  static final danger = _style(
    background: AppColors.error,
    foreground: AppColors.onAction,
    filled: true,
  );
  static final outlined = _style(
    background: AppColors.glass,
    foreground: AppColors.textPrimary,
    border: true,
  );
  static final text =
      _style(
        background: Colors.transparent,
        foreground: AppColors.textPrimary,
      ).copyWith(
        minimumSize: const WidgetStatePropertyAll(
          Size(0, AppSizes.buttonSmall),
        ),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: AppSpacing.md),
        ),
      );

  static ButtonStyle _style({
    required Color background,
    required Color foreground,
    bool filled = false,
    bool border = false,
  }) => base.copyWith(
    backgroundColor: WidgetStateProperty.resolveWith(
      (states) => states.contains(WidgetState.disabled)
          ? (filled ? AppColors.buttonDisabledBackground : Colors.transparent)
          : background,
    ),
    foregroundColor: WidgetStateProperty.resolveWith(
      (states) => states.contains(WidgetState.disabled)
          ? AppColors.textDim
          : foreground,
    ),
    overlayColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) return Colors.transparent;
      if (states.contains(WidgetState.pressed) ||
          states.contains(WidgetState.focused)) {
        return foreground.withValues(alpha: .12);
      }
      if (states.contains(WidgetState.hovered)) {
        return foreground.withValues(alpha: .08);
      }
      return Colors.transparent;
    }),
    side: WidgetStatePropertyAll(border ? AppBorders.glass : BorderSide.none),
  );
}
