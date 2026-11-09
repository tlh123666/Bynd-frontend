import 'package:flutter/material.dart';
import '../tokens/app_colors.dart';
import '../tokens/app_dimensions.dart';
import '../tokens/app_typography.dart';
import 'app_icon.dart';

/// Borderless card used by the reference's detail and advanced settings pages.
class AppGradientCard extends StatelessWidget {
  const AppGradientCard({
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
    super.key,
  });
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    borderRadius: AppRadii.detailCardBorder,
    clipBehavior: Clip.antiAlias,
    child: Ink(
      decoration: const BoxDecoration(
        borderRadius: AppRadii.detailCardBorder,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.glass, AppColors.glassLow],
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: DefaultTextStyle.merge(
          style: const TextStyle(letterSpacing: 0, fontWeight: FontWeight.w400),
          child: Padding(padding: padding, child: child),
        ),
      ),
    ),
  );
}

class AppActionCard extends StatelessWidget {
  const AppActionCard({
    required this.title,
    required this.description,
    required this.iconAsset,
    required this.onTap,
    this.danger = false,
    super.key,
  });
  final String title;
  final String description;
  final String iconAsset;
  final VoidCallback? onTap;
  final bool danger;
  @override
  Widget build(BuildContext context) => AppGradientCard(
    onTap: onTap,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AppSvgIcon(
              iconAsset,
              size: 20,
              color: danger ? AppColors.error : AppColors.deviceIcon,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: AppFontFamilies.geist,
                  fontSize: 15.5,
                  fontWeight: FontWeight.w400,
                  color: danger ? AppColors.error : AppColors.textPrimary,
                  height: 1.35,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              '›',
              style: TextStyle(
                fontSize: 20,
                color: AppColors.menuChevron,
                height: 1,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 32, top: 6),
          child: Text(
            description,
            style: const TextStyle(
              fontFamily: AppFontFamilies.geist,
              fontSize: 13,
              fontWeight: FontWeight.w400,
              height: 1.45,
              color: AppColors.textKicker,
            ),
          ),
        ),
      ],
    ),
  );
}
