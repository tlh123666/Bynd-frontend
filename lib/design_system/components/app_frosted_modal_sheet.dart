import 'dart:ui';

import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_dimensions.dart';
import '../tokens/app_motion.dart';
import 'app_frosted_surface.dart';

/// 统一自适应高度、背景磨砂、拖拽把手和上推动画的底部弹窗。
class AppFrostedModalSheet extends StatelessWidget {
  const AppFrostedModalSheet({
    required this.child,
    this.showHandle = true,
    this.useSafeArea = true,
    super.key,
  });

  final Widget child;
  final bool showHandle;
  final bool useSafeArea;

  /// 展示从底部升起的磨砂弹窗，并统一处理背景遮罩和关闭手势。
  static Future<T?> show<T>(
    BuildContext context, {
    required WidgetBuilder builder,
    bool isScrollControlled = true,
    bool useSafeArea = true,
    bool showHandle = true,
    bool enableDrag = true,
    double maxHeightFraction = .84,
    double? topInset,
    Color barrierColor = AppColors.menuVeil,
    bool waitForExit = false,
  }) async {
    final motionEnabled = AppMotion.enabled(context);
    final duration = motionEnabled
        ? const Duration(milliseconds: 450)
        : Duration.zero;
    final maxHeightFactor = isScrollControlled ? maxHeightFraction : .5;

    final route = _FrostedModalRoute<T>(
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      transitionDuration: duration,
      reverseTransitionDuration: motionEnabled
          ? const Duration(milliseconds: 220)
          : Duration.zero,
      pageBuilder: (sheetContext, _, _) {
        final size = MediaQuery.sizeOf(sheetContext);
        final bottomInset = MediaQuery.viewInsetsOf(sheetContext).bottom;
        return _ModalSheetDragController(
          enabled: enableDrag,
          motionEnabled: motionEnabled,
          child: Padding(
            padding: EdgeInsets.only(bottom: bottomInset),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: topInset == null
                    ? size.height * maxHeightFactor
                    : (size.height - topInset - bottomInset).clamp(
                        0.0,
                        size.height,
                      ),
              ),
              child: SizedBox(
                width: double.infinity,
                child: AppFrostedModalSheet(
                  showHandle: showHandle,
                  useSafeArea: useSafeArea,
                  child: builder(sheetContext),
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (dialogContext, animation, _, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: const Cubic(.32, .72, 0, 1),
          reverseCurve: Curves.easeInCubic,
        );
        // 遮罩先于面板完成淡入，关闭时也随面板快速淡出。
        final backdropAnimation = CurvedAnimation(
          parent: animation,
          curve: const Interval(0, .28, curve: Curves.easeOut),
          reverseCurve: Curves.easeInCubic,
        );
        return Stack(
          children: [
            Positioned.fill(
              child: FadeTransition(
                key: const Key('frosted-modal-scrim'),
                opacity: backdropAnimation,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Navigator.of(dialogContext).pop(),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                    child: ColoredBox(color: barrierColor),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 1),
                  end: Offset.zero,
                ).animate(curvedAnimation),
                child: child,
              ),
            ),
          ],
        );
      },
    );
    final result = await Navigator.of(
      context,
      rootNavigator: false,
    ).push<T>(route);
    if (waitForExit) await route.completed;
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return AppFrostedSurface.modalSheet(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppRadii.sheet),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: SafeArea(
          top: false,
          left: useSafeArea,
          right: useSafeArea,
          bottom: useSafeArea,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showHandle) ...[
                const SizedBox(height: AppSpacing.md),
                Container(
                  width: 38,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.menuChevron,
                    borderRadius: AppRadii.pillBorder,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
              child,
            ],
          ),
        ),
      ),
    );
  }
}

/// 为弹窗的打开和关闭动画分别设置时长。
class _FrostedModalRoute<T> extends RawDialogRoute<T> {
  _FrostedModalRoute({
    required super.pageBuilder,
    required super.transitionBuilder,
    required super.barrierLabel,
    required super.transitionDuration,
    required this.reverseTransitionDuration,
  }) : super(barrierDismissible: true, barrierColor: Colors.transparent);

  @override
  final Duration reverseTransitionDuration;
}

/// 让内容高度保持自适应，同时支持向下拖动关闭。
class _ModalSheetDragController extends StatefulWidget {
  const _ModalSheetDragController({
    required this.child,
    required this.enabled,
    required this.motionEnabled,
  });

  final Widget child;
  final bool enabled;
  final bool motionEnabled;

  @override
  State<_ModalSheetDragController> createState() =>
      _ModalSheetDragControllerState();
}

class _ModalSheetDragControllerState extends State<_ModalSheetDragController> {
  double _dragOffset = 0;
  bool _dragging = false;

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;

    return GestureDetector(
      onVerticalDragStart: (_) => setState(() => _dragging = true),
      onVerticalDragUpdate: (details) {
        setState(() {
          _dragOffset = (_dragOffset + details.delta.dy).clamp(0, 1000);
        });
      },
      onVerticalDragEnd: (details) {
        if (_dragOffset > 100 || (details.primaryVelocity ?? 0) > 650) {
          Navigator.of(context).pop();
          return;
        }
        setState(() {
          _dragOffset = 0;
          _dragging = false;
        });
      },
      child: AnimatedContainer(
        duration: !widget.motionEnabled || _dragging
            ? Duration.zero
            : const Duration(milliseconds: 220),
        transform: Matrix4.translationValues(0, _dragOffset, 0),
        child: widget.child,
      ),
    );
  }
}
