import 'dart:ui';

import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_dimensions.dart';
import '../tokens/app_motion.dart';
import 'app_icon.dart';
import 'app_quick_actions_button.dart';
import '../../l10n/app_localizations_context.dart';

/// 对照网页版底部导航：四个胶囊内入口 + 独立的圆形新增操作。
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.onMorePressed,
    this.moreButtonKey,
    this.moreOpen = false,
    super.key,
  }) : assert(
         selectedIndex == null || (selectedIndex >= 0 && selectedIndex < 4),
       );

  /// 为推入式页面（例如活动详情）保留“无选中主标签”的状态。
  final int? selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final VoidCallback onMorePressed;
  final Key? moreButtonKey;
  final bool moreOpen;

  static const _icons = [
    AppSvgAssets.home,
    AppSvgAssets.atlas,
    AppSvgAssets.community,
    AppSvgAssets.health,
  ];

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    final labels = [
      strings.today,
      strings.atlas,
      strings.community,
      strings.health,
    ];
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.only(bottom: AppSizes.navBottomInset),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: Center(
          heightFactor: 1,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppSizes.navMaxWidth),
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
                          border: Border.fromBorderSide(AppBorders.nav),
                        ),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final itemWidth =
                                constraints.maxWidth / _icons.length;
                            return Stack(
                              children: [
                                // 共用选中胶囊按活动标签序号横向滑动；详情页无选中项时不显示。
                                if (selectedIndex != null)
                                  AnimatedPositioned(
                                    key: const Key(
                                      'bottom-nav-active-indicator',
                                    ),
                                    duration: AppMotion.enabled(context)
                                        ? const Duration(milliseconds: 450)
                                        : Duration.zero,
                                    curve: const Cubic(.32, .72, 0, 1),
                                    left: itemWidth * selectedIndex!,
                                    top: 2,
                                    width: itemWidth,
                                    height: 46,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: AppColors.navSelected,
                                        borderRadius: AppRadii.pillBorder,
                                      ),
                                    ),
                                  ),
                                Row(
                                  children: List.generate(_icons.length, (
                                    index,
                                  ) {
                                    final selected = selectedIndex == index;
                                    return Expanded(
                                      child: Semantics(
                                        label: labels[index],
                                        selected: selected,
                                        button: true,
                                        child: _BottomNavDestination(
                                          label: labels[index],
                                          selected: selected,
                                          icon: _icons[index],
                                          onTap: () =>
                                              onDestinationSelected(index),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.navGap),
                IgnorePointer(
                  ignoring: moreOpen,
                  child: Opacity(
                    opacity: moreOpen ? 0 : 1,
                    child: AppQuickActionsButton(
                      key: moreButtonKey,
                      isOpen: false,
                      label: strings.quickActions,
                      onPressed: onMorePressed,
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

/// 单个导航入口只负责触控压感，选中胶囊仍由外层统一滑动。
class _BottomNavDestination extends StatefulWidget {
  const _BottomNavDestination({
    required this.label,
    required this.selected,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final String icon;
  final VoidCallback onTap;

  @override
  State<_BottomNavDestination> createState() => _BottomNavDestinationState();
}

class _BottomNavDestinationState extends State<_BottomNavDestination> {
  bool _pressed = false;
  int? _activePointer;

  void _handlePointerDown(PointerDownEvent event) {
    // 忽略鼠标右键和额外触点，避免非主操作意外触发压感。
    if (event.buttons != 1 || _activePointer != null) return;
    _activePointer = event.pointer;
    setState(() => _pressed = true);
  }

  void _handlePointerEnd(PointerEvent event) {
    if (_activePointer != event.pointer) return;
    _activePointer = null;
    setState(() => _pressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final motionEnabled = AppMotion.enabled(context);
    return Material(
      color: Colors.transparent,
      borderRadius: AppRadii.pillBorder,
      child: Listener(
        onPointerDown: _handlePointerDown,
        onPointerUp: _handlePointerEnd,
        onPointerCancel: _handlePointerEnd,
        child: InkWell(
          onTap: widget.onTap,
          // 原型没有 Material 水波纹；避免它与滑动选中胶囊叠成双重亮圈。
          splashFactory: NoSplash.splashFactory,
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          borderRadius: AppRadii.pillBorder,
          child: AnimatedScale(
            scale: motionEnabled && _pressed ? .97 : 1,
            duration: motionEnabled
                ? (_pressed ? AppMotion.touchPress : AppMotion.touchRelease)
                : Duration.zero,
            curve: _pressed ? AppMotion.touchPressCurve : Curves.easeOutBack,
            child: AnimatedOpacity(
              // 原型在减少动态效果时用轻微淡化代替缩放。
              opacity: !motionEnabled && _pressed ? .6 : 1,
              duration: motionEnabled ? Duration.zero : AppMotion.touchPress,
              curve: Curves.easeOut,
              child: Center(
                child: AppSvgIcon(
                  widget.icon,
                  size: 26,
                  color: widget.selected
                      ? AppColors.textPrimary
                      : AppColors.menuIcon,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
