import 'package:flutter/material.dart';
import '../tokens/app_colors.dart';
import '../tokens/app_typography.dart';
import 'app_frosted_surface.dart';
import 'app_icon.dart';

class AppGlassPill extends StatelessWidget {
  const AppGlassPill({
    required this.label,
    required this.onPressed,
    this.leading,
    this.trailing,
    this.height = 48,
    super.key,
  });
  final String label;
  final VoidCallback onPressed;
  final String? leading;
  final Widget? trailing;
  final double height;
  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    child: SizedBox(
      height: height,
      child: IntrinsicWidth(
        child: AppFrostedSurface(
          borderRadius: BorderRadius.circular(999),
          blurSigma: 14,
          saturation: 1.5,
          tintColor: AppColors.sheetGlassTint,
          borderColor: AppColors.glassBorderStrong,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: AppColors.glassBorderStrong),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onPressed,
                borderRadius: BorderRadius.circular(999),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (leading != null) ...[
                        AppSvgIcon(leading!, size: 16),
                        const SizedBox(width: 12),
                      ],
                      Flexible(
                        child: Text(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.label.copyWith(fontSize: 14),
                        ),
                      ),
                      if (trailing != null) ...[
                        const SizedBox(width: 12),
                        trailing!,
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
