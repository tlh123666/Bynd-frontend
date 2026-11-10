import 'package:flutter/material.dart';
import '../../design_system/design_system.dart';

class AppSheetHeader extends StatelessWidget {
  const AppSheetHeader({
    required this.title,
    this.trailing,
    this.canClose = true,
    super.key,
  });
  final String title;
  final Widget? trailing;
  final bool canClose;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 48,
    child: Row(
      children: [
        IconButton(
          tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
          onPressed: canClose ? () => Navigator.pop(context) : null,
          icon: const Icon(Icons.close, size: 22),
        ),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: AppTypography.detailBody.copyWith(
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(width: 48, child: trailing),
      ],
    ),
  );
}

class AppSheetSaveButton extends StatelessWidget {
  const AppSheetSaveButton({
    required this.label,
    this.onPressed,
    this.loading = false,
    super.key,
  });
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  @override
  Widget build(BuildContext context) => SafeArea(
    top: false,
    minimum: const EdgeInsets.fromLTRB(24, 16, 24, 20),
    child: Center(
      heightFactor: 1,
      child: SizedBox(
        width: 272,
        height: 48,
        child: FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.textPrimary,
            foregroundColor: AppColors.homeCanvas,
            disabledBackgroundColor: AppColors.textDim,
            disabledForegroundColor: AppColors.textMuted,
            shape: const StadiumBorder(),
            textStyle: AppTypography.label,
          ),
          onPressed: loading ? null : onPressed,
          child: loading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 1.5),
                )
              : Text(label),
        ),
      ),
    ),
  );
}

/// Compact paired actions used by capture panels and modal forms.
class AppSheetActionButton extends StatelessWidget {
  const AppSheetActionButton({
    required this.label,
    required this.onPressed,
    this.iconAsset,
    super.key,
  });
  final String label;
  final VoidCallback onPressed;
  final String? iconAsset;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 40,
    child: FilledButton(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        backgroundColor: AppColors.glass,
        foregroundColor: AppColors.textPrimary,
        shape: const StadiumBorder(),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textStyle: AppTypography.caption.copyWith(fontSize: 13),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (iconAsset != null) ...[
            AppSvgIcon(iconAsset!, size: 16),
            const SizedBox(width: 7),
          ],
          Flexible(
            child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    ),
  );
}
