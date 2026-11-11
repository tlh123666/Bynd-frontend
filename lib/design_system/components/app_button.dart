import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_dimensions.dart';
import '../theme/app_button_styles.dart';
import 'app_icon.dart';
import 'app_loading.dart';

enum AppButtonVariant { primary, secondary, ghost, danger }

enum AppButtonSize { small, regular }

class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.regular,
    this.iconAsset,
    this.loading = false,
    this.expanded = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final String? iconAsset;
  final bool loading;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final height = size == AppButtonSize.small
        ? AppSizes.buttonSmall
        : AppSizes.buttonRegular;
    final foreground = switch (variant) {
      AppButtonVariant.primary || AppButtonVariant.danger => AppColors.onAction,
      _ => AppColors.textPrimary,
    };
    final contentColor = loading || onPressed == null
        ? AppColors.textDim
        : foreground;
    final baseStyle = switch (variant) {
      AppButtonVariant.primary => AppButtonStyles.filled,
      AppButtonVariant.danger => AppButtonStyles.danger,
      AppButtonVariant.secondary => AppButtonStyles.outlined,
      AppButtonVariant.ghost => AppButtonStyles.text,
    };
    final style = baseStyle.copyWith(
      minimumSize: WidgetStatePropertyAll(Size(0, height)),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      ),
    );
    final content = Stack(
      alignment: Alignment.center,
      children: [
        Opacity(
          opacity: loading ? 0 : 1,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (iconAsset != null) ...[
                AppSvgIcon(
                  iconAsset!,
                  size: AppSizes.iconSmall,
                  color: contentColor,
                ),
                const SizedBox(width: AppSpacing.xs),
              ],
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        if (loading)
          AppLoadingIndicator(
            size: AppSizes.iconSmall,
            color: contentColor,
            showLabel: false,
          ),
      ],
    );
    final effectiveOnPressed = loading ? null : onPressed;
    final button = switch (variant) {
      AppButtonVariant.primary || AppButtonVariant.danger => FilledButton(
        onPressed: effectiveOnPressed,
        style: style,
        child: content,
      ),
      AppButtonVariant.secondary => OutlinedButton(
        onPressed: effectiveOnPressed,
        style: style,
        child: content,
      ),
      AppButtonVariant.ghost => TextButton(
        onPressed: effectiveOnPressed,
        style: style,
        child: content,
      ),
    };
    return expanded ? SizedBox(width: double.infinity, child: button) : button;
  }
}
