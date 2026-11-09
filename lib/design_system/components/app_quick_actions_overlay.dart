import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../../l10n/app_localizations_context.dart';
import '../../l10n/generated/app_localizations.dart';
import '../tokens/app_colors.dart';
import '../tokens/app_dimensions.dart';
import '../tokens/app_motion.dart';
import '../tokens/app_typography.dart';
import 'app_icon.dart';

enum AppQuickAction {
  breathe(AppSvgAssets.breathe),
  meal(AppSvgAssets.meal),
  startActivity(AppSvgAssets.startActivity),
  dayReview(AppSvgAssets.dayReview),
  logActivity(AppSvgAssets.logActivity),
  ecg(AppSvgAssets.ecg);

  const AppQuickAction(this.iconAsset);

  final String iconAsset;

  String localizedLabel(AppLocalizations strings) => switch (this) {
    AppQuickAction.breathe => strings.breatheFiveMinutes,
    AppQuickAction.meal => strings.logMeal,
    AppQuickAction.startActivity => strings.startActivity,
    AppQuickAction.dayReview => strings.reviewDay,
    AppQuickAction.logActivity => strings.logActivity,
    AppQuickAction.ecg => strings.doEcg,
  };
}

/// 复现网页原型中覆盖在当前页面上的全屏快捷操作层。
class AppQuickActionsOverlay extends StatefulWidget {
  const AppQuickActionsOverlay({
    required this.onClose,
    required this.onActionSelected,
    super.key,
  });

  final VoidCallback onClose;
  final ValueChanged<AppQuickAction> onActionSelected;

  @override
  State<AppQuickActionsOverlay> createState() => _AppQuickActionsOverlayState();
}

class _AppQuickActionsOverlayState extends State<AppQuickActionsOverlay>
    with SingleTickerProviderStateMixin {
  static const _entryDuration = Duration(milliseconds: 520);
  static const _exitDuration = Duration(milliseconds: 220);
  static const _placements = <(AppQuickAction, double, double)>[
    (AppQuickAction.breathe, -5, -232),
    (AppQuickAction.meal, -111, -198),
    (AppQuickAction.startActivity, -37, -110),
    (AppQuickAction.dayReview, -193, -118),
    (AppQuickAction.logActivity, -103, -44),
    (AppQuickAction.ecg, -225, -10),
  ];

  late final AnimationController _controller;
  bool _animationsEnabled = true;
  bool _closing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _entryDuration,
      reverseDuration: _exitDuration,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _animationsEnabled = AppMotion.enabled(context);
    if (_controller.status == AnimationStatus.dismissed) {
      if (_animationsEnabled) {
        _controller.forward();
      } else {
        _controller.value = 1;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _close({VoidCallback? afterClose}) async {
    if (_closing) return;
    _closing = true;
    if (_animationsEnabled) {
      await _controller.reverse();
    }
    if (!mounted) return;
    (afterClose ?? widget.onClose)();
  }

  Animation<double> _actionAnimation(int index, {required Curve curve}) {
    final start = index * .055;
    final end = math.min(1.0, start + .68);
    return CurvedAnimation(
      parent: _controller,
      curve: Interval(start, end, curve: curve),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    return Material(
      color: Colors.transparent,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: FadeTransition(
              opacity: CurvedAnimation(
                parent: _controller,
                curve: const Interval(0, .55, curve: Curves.easeOut),
              ),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _closing ? null : _close,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                  child: const ColoredBox(color: AppColors.quickActionsVeil),
                ),
              ),
            ),
          ),
          SafeArea(
            minimum: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: LayoutBuilder(
              builder: (context, constraints) {
                // X 与原型中的关闭按钮一样，固定在底部导航“+”按钮的位置。
                final anchor = Offset(
                  constraints.maxWidth - AppSpacing.md - 28,
                  constraints.maxHeight - 28,
                );
                final headlineTop = math.min(
                  110.0,
                  math.max(24.0, constraints.maxHeight - 390),
                );
                return Stack(
                  fit: StackFit.expand,
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: headlineTop,
                      left: 22,
                      right: 120,
                      child: FadeTransition(
                        opacity: CurvedAnimation(
                          parent: _controller,
                          curve: const Interval(
                            .08,
                            .68,
                            curve: Curves.easeOut,
                          ),
                        ),
                        child: SlideTransition(
                          position:
                              Tween<Offset>(
                                begin: const Offset(0, .08),
                                end: Offset.zero,
                              ).animate(
                                CurvedAnimation(
                                  parent: _controller,
                                  curve: const Interval(
                                    .08,
                                    .68,
                                    curve: Curves.easeOutCubic,
                                  ),
                                ),
                              ),
                          child: _QuickActionsHeadline(
                            strings: strings,
                            suggestion: _suggestionForNow(strings),
                          ),
                        ),
                      ),
                    ),
                    for (var index = 0; index < _placements.length; index++)
                      _buildAction(index, anchor, constraints, strings),
                    Positioned(
                      left: anchor.dx - 28,
                      top: anchor.dy - 28,
                      width: 56,
                      height: 56,
                      child: FadeTransition(
                        opacity: CurvedAnimation(
                          parent: _controller,
                          curve: const Interval(
                            .16,
                            .72,
                            curve: Curves.easeOut,
                          ),
                        ),
                        child: RotationTransition(
                          turns: Tween<double>(begin: -.25, end: 0).animate(
                            CurvedAnimation(
                              parent: _controller,
                              curve: const Interval(
                                .16,
                                .72,
                                curve: Curves.easeOutBack,
                              ),
                            ),
                          ),
                          child: _CloseButton(
                            label: strings.close,
                            onPressed: _closing ? null : _close,
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
      ),
    );
  }

  Widget _buildAction(
    int index,
    Offset anchor,
    BoxConstraints constraints,
    AppLocalizations strings,
  ) {
    const tileWidth = 92.0;
    const tileHeight = 106.0;
    final (action, offsetX, offsetY) = _placements[index];
    final target = Offset(anchor.dx + offsetX, anchor.dy + offsetY - 46);
    final left = (target.dx - tileWidth / 2)
        .clamp(0.0, math.max(0.0, constraints.maxWidth - tileWidth))
        .toDouble();
    final top = (target.dy - 13)
        .clamp(0.0, math.max(0.0, constraints.maxHeight - tileHeight))
        .toDouble();
    final fadeAnimation = _actionAnimation(index, curve: Curves.easeOut);
    final popAnimation = _actionAnimation(index, curve: Curves.easeOutBack);

    return Positioned(
      left: left,
      top: top,
      width: tileWidth,
      height: tileHeight,
      child: FadeTransition(
        opacity: fadeAnimation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, .22),
            end: Offset.zero,
          ).animate(popAnimation),
          child: ScaleTransition(
            scale: Tween<double>(begin: .92, end: 1).animate(popAnimation),
            child: _QuickActionTile(
              action: action,
              strings: strings,
              onTap: _closing
                  ? null
                  : () => _close(
                      afterClose: () => widget.onActionSelected(action),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickActionsHeadline extends StatelessWidget {
  const _QuickActionsHeadline({
    required this.strings,
    required this.suggestion,
  });

  final AppLocalizations strings;
  final String suggestion;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        strings.quickActionsHeading,
        style: AppTypography.kicker.copyWith(color: AppColors.textKicker),
      ),
      const SizedBox(height: AppSpacing.xs),
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 250),
        child: Text(
          suggestion,
          style: const TextStyle(
            fontFamily: AppFontFamilies.geist,
            fontSize: 15,
            fontWeight: FontWeight.w400,
            height: 1.4,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    ],
  );
}

String _suggestionForNow(AppLocalizations strings) {
  final hour = DateTime.now().hour;
  if (hour >= 5 && hour < 12) return strings.quickActionsSuggestion;
  if (hour >= 12 && hour < 18) return strings.quickActionsSuggestionAfternoon;
  return strings.quickActionsSuggestionEvening;
}

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({
    required this.action,
    required this.strings,
    required this.onTap,
  });

  final AppQuickAction action;
  final AppLocalizations strings;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final label = action.localizedLabel(strings);
    return Semantics(
      label: label.replaceAll('\n', ' '),
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.controlBorder,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AppSvgIcon(action.iconAsset, size: 26),
            const SizedBox(height: AppSpacing.xs),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: AppFontFamilies.geist,
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                height: 1.25,
                color: AppColors.textOnVeil,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CloseButton extends StatelessWidget {
  const _CloseButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => Tooltip(
    message: label,
    child: Semantics(
      label: label,
      button: true,
      child: Material(
        color: AppColors.textPrimary,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: const SizedBox(
            width: 56,
            height: 56,
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
  );
}
