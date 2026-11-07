import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_dimensions.dart';
import '../tokens/app_typography.dart';
import 'app_icon.dart';

enum AppQuickAction {
  breathe('Respirar\n5 min', AppSvgAssets.breathe),
  meal('Registrar\nrefeição', AppSvgAssets.meal),
  startActivity('Iniciar\natividade', AppSvgAssets.startActivity),
  dayReview('Como foi\no dia', AppSvgAssets.dayReview),
  logActivity('Registrar\natividade', AppSvgAssets.logActivity),
  ecg('Fazer\nECG', AppSvgAssets.ecg);

  const AppQuickAction(this.label, this.iconAsset);

  final String label;
  final String iconAsset;
}

/// 线上原型右下角“更多”展开层。外部决定每个快捷入口如何导航。
class AppQuickActionsOverlay extends StatelessWidget {
  const AppQuickActionsOverlay({
    required this.onClose,
    required this.onActionSelected,
    super.key,
  });

  final VoidCallback onClose;
  final ValueChanged<AppQuickAction> onActionSelected;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: const ColoredBox(color: AppColors.quickActionsVeil),
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final actionHeight = math.min(
                  405.0,
                  constraints.maxHeight * .55,
                );
                final headlineTop = math.min(
                  120.0,
                  math.max(28.0, constraints.maxHeight - actionHeight - 160),
                );
                return Stack(
                  children: [
                    Positioned(
                      top: headlineTop,
                      left: AppSpacing.lg,
                      right: AppSpacing.lg,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AÇÕES RÁPIDAS',
                            style: AppTypography.label.copyWith(
                              color: AppColors.textMuted,
                              letterSpacing: 2.2,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 250),
                            child: Text(
                              'Para esta manhã, a BYND sugere 15 minutos de sol antes do trabalho.',
                              style: AppTypography.body.copyWith(
                                color: AppColors.textPrimary,
                                fontSize: 16,
                                height: 1.45,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      height: actionHeight,
                      child: LayoutBuilder(
                        builder: (context, area) {
                          const tileWidth = 104.0;
                          const tileHeight = 108.0;
                          Widget tile(
                            AppQuickAction action,
                            double x,
                            double y,
                          ) {
                            return Positioned(
                              left: (area.maxWidth - tileWidth) * x,
                              top: (area.maxHeight - tileHeight) * y,
                              width: tileWidth,
                              height: tileHeight,
                              child: _QuickActionTile(
                                action: action,
                                onTap: () => onActionSelected(action),
                              ),
                            );
                          }

                          return Stack(
                            children: [
                              tile(AppQuickAction.breathe, .99, .10),
                              tile(AppQuickAction.meal, .60, .22),
                              tile(AppQuickAction.dayReview, .30, .50),
                              tile(AppQuickAction.startActivity, .87, .50),
                              tile(AppQuickAction.ecg, .18, .86),
                              tile(AppQuickAction.logActivity, .64, .75),
                              Positioned(
                                right: AppSpacing.md + AppSpacing.xxs,
                                bottom: AppSpacing.lg,
                                child: Tooltip(
                                  message: 'Fechar',
                                  child: Semantics(
                                    label: 'Fechar',
                                    button: true,
                                    child: Material(
                                      color: AppColors.textPrimary,
                                      shape: const CircleBorder(),
                                      child: InkWell(
                                        onTap: onClose,
                                        customBorder: const CircleBorder(),
                                        child: const SizedBox(
                                          width: 58,
                                          height: 58,
                                          child: Center(
                                            child: AppSvgIcon(
                                              AppSvgAssets.close,
                                              size: 22,
                                              color: AppColors.background,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({required this.action, required this.onTap});

  final AppQuickAction action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: action.label.replaceAll('\n', ' '),
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.controlBorder,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppSvgIcon(action.iconAsset, size: 26),
            const SizedBox(height: AppSpacing.xs),
            Text(
              action.label,
              textAlign: TextAlign.center,
              style: AppTypography.label.copyWith(
                fontSize: 14,
                height: 1.15,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
