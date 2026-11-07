import 'dart:ui';

import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_dimensions.dart';
import 'app_icon.dart';

/// 对照网页版底部导航：四个胶囊内入口 + 独立的圆形新增操作。
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.onMorePressed,
    super.key,
  }) : assert(selectedIndex >= 0 && selectedIndex < 4);

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final VoidCallback onMorePressed;

  static const _icons = [
    AppSvgAssets.home,
    AppSvgAssets.atlas,
    AppSvgAssets.community,
    AppSvgAssets.health,
  ];
  static const _labels = ['Hoje', 'Atlas', 'Comunidade', 'Saúde'];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: Center(
          heightFactor: 1,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: AppRadii.pillBorder,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: AppSizes.glassBlur,
                        sigmaY: AppSizes.glassBlur,
                      ),
                      child: Container(
                        height: 56,
                        padding: const EdgeInsets.all(AppSpacing.xxs),
                        decoration: BoxDecoration(
                          color: AppColors.navGlass,
                          borderRadius: AppRadii.pillBorder,
                          border: Border.fromBorderSide(AppBorders.glass),
                        ),
                        child: Row(
                          children: List.generate(_icons.length, (index) {
                            final selected = selectedIndex == index;
                            return Expanded(
                              child: Tooltip(
                                message: _labels[index],
                                child: Semantics(
                                  label: _labels[index],
                                  selected: selected,
                                  button: true,
                                  child: Material(
                                    color: selected
                                        ? AppColors.navSelected
                                        : Colors.transparent,
                                    borderRadius: AppRadii.pillBorder,
                                    child: InkWell(
                                      onTap: () => onDestinationSelected(index),
                                      borderRadius: AppRadii.pillBorder,
                                      child: Center(
                                        child: AppSvgIcon(
                                          _icons[index],
                                          size: 26,
                                          color: selected
                                              ? AppColors.textPrimary
                                              : AppColors.textSecondary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                ClipOval(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: AppSizes.glassBlur,
                      sigmaY: AppSizes.glassBlur,
                    ),
                    child: Material(
                      color: AppColors.navGlass,
                      shape: const CircleBorder(side: AppBorders.glass),
                      child: Tooltip(
                        message: 'Ações rápidas',
                        child: Semantics(
                          label: 'Ações rápidas',
                          button: true,
                          child: InkWell(
                            onTap: onMorePressed,
                            customBorder: const CircleBorder(),
                            child: const SizedBox(
                              width: 56,
                              height: 56,
                              child: Center(
                                child: AppSvgIcon(AppSvgAssets.more, size: 22),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
