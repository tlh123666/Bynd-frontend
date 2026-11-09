import 'package:flutter/material.dart';
import '../tokens/app_colors.dart';
import '../tokens/app_dimensions.dart';
import '../tokens/app_typography.dart';
import 'app_icon.dart';

/// Shared metric presentation used by Home and the complete signals list.
class AppSignalCard extends StatelessWidget {
  const AppSignalCard({
    required this.label,
    required this.value,
    required this.iconAsset,
    required this.caption,
    required this.onPressed,
    this.unit = '',
    this.captionColor = AppColors.textMuted,
    super.key,
  });
  final String label, value, iconAsset, caption, unit;
  final Color captionColor;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) => Material(
    color: AppColors.signalSurface,
    borderRadius: BorderRadius.circular(AppSizes.signalRadius),
    child: InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(AppSizes.signalRadius),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 17),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AppSvgIcon(iconAsset, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.signalLabel,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              caption,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.signalLabel.copyWith(color: captionColor),
            ),
            const Spacer(),
            FittedBox(
              alignment: Alignment.centerLeft,
              fit: BoxFit.scaleDown,
              child: Text.rich(
                TextSpan(
                  text: value,
                  style: AppTypography.signalValue,
                  children: [
                    if (unit.isNotEmpty)
                      TextSpan(
                        text: ' $unit',
                        style: const TextStyle(
                          fontFamily: AppFontFamilies.geist,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0,
                          color: AppColors.textHalf,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
