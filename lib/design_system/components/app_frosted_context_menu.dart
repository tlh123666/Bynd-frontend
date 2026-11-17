import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'app_frosted_surface.dart';
import '../tokens/app_colors.dart';

/// 从触发按钮展开的玻璃菜单；遮罩和面板分别模糊，菜单始终留在视口内。
class AppFrostedContextMenu {
  static Future<T?> show<T>(
    BuildContext context, {
    required Rect anchor,
    required List<AppFrostedMenuItem<T>> items,
  }) {
    final reducedMotion = MediaQuery.disableAnimationsOf(context);
    return showGeneralDialog<T>(
      context: context,
      useRootNavigator: false,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.transparent,
      transitionDuration: reducedMotion
          ? Duration.zero
          : const Duration(milliseconds: 240),
      pageBuilder: (routeContext, animation, _) => LayoutBuilder(
        builder: (context, bounds) {
          final width = math.min(236.0, math.max(0.0, bounds.maxWidth - 16));
          final desiredHeight = 12.0 + 46.0 * items.length;
          final height = math.min(
            desiredHeight,
            math.max(0.0, bounds.maxHeight - 16),
          );
          final left = (anchor.right - width)
              .clamp(8.0, math.max(8.0, bounds.maxWidth - width - 8))
              .toDouble();
          final below = anchor.top + height <= bounds.maxHeight - 16;
          final top = (below ? anchor.top : anchor.bottom - height)
              .clamp(8.0, math.max(8.0, bounds.maxHeight - height - 8))
              .toDouble();
          return Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  key: const ValueKey('frosted-menu-backdrop'),
                  onTap: () => Navigator.pop(routeContext),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                    child: const ColoredBox(color: Color(0x47080a0d)),
                  ),
                ),
              ),
              Positioned(
                left: left,
                top: top,
                width: width,
                height: height,
                // 遮罩首帧即显示，只有菜单面板随路由动画淡入淡出。
                child: FadeTransition(
                  key: const ValueKey('frosted-menu-panel-transition'),
                  opacity: animation,
                  child: AppFrostedSurface(
                    borderRadius: BorderRadius.circular(24),
                    blurSigma: 14,
                    saturation: 1.5,
                    tintColor: const Color(0xb314181e),
                    borderColor: AppColors.sheetGlassBorder,
                    borderFadeHeight: height,
                    child: Material(
                      type: MaterialType.transparency,
                      child: ListView(
                        padding: const EdgeInsets.all(6),
                        children: [
                          for (var i = 0; i < items.length; i++)
                            Container(
                              decoration: i == 0
                                  ? null
                                  : const BoxDecoration(
                                      border: Border(
                                        top: BorderSide(
                                          color: Color(0x1fffffff),
                                          width: .5,
                                        ),
                                      ),
                                    ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () =>
                                    Navigator.pop(routeContext, items[i].value),
                                child: SizedBox(
                                  height: 46,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            items[i].label,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: items[i].destructive
                                                  ? const Color(0xffee9a94)
                                                  : AppColors.textPrimary,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 18),
                                        Icon(
                                          items[i].icon,
                                          size: 19,
                                          color: items[i].destructive
                                              ? const Color(0xffee9a94)
                                              : AppColors.textSecondary,
                                        ),
                                      ],
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
              ),
            ],
          );
        },
      ),
      // 禁用默认整页淡入，避免全屏模糊被一起延迟合成。
      transitionBuilder: (_, _, _, child) => child,
    );
  }
}

class AppFrostedMenuItem<T> {
  const AppFrostedMenuItem({
    required this.value,
    required this.label,
    required this.icon,
    this.destructive = false,
  });
  final T value;
  final String label;
  final IconData icon;
  final bool destructive;
}
