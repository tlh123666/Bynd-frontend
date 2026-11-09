import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import '../tokens/app_colors.dart';
import '../tokens/app_motion.dart';
import 'app_detail_background.dart';

/// Native modal sheet gestures, focus, safe area and keyboard handling, with
/// the reference's animated 14px backdrop blur applied to its modal barrier.
Future<T?> showAppContentSheet<T>(
  BuildContext context,
  WidgetBuilder builder, {
  double heightFactor = .936,
}) {
  final navigator = Navigator.of(context);
  return navigator.push<T>(
    _BlurredContentSheetRoute<T>(
      builder: (context) => FractionallySizedBox(
        heightFactor: heightFactor,
        child: AppDetailBackground(
          child: Column(
            children: [
              SizedBox(
                height: 16,
                child: Center(
                  child: Container(
                    width: 38,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.textDim,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              ),
              Expanded(child: builder(context)),
            ],
          ),
        ),
      ),
      capturedThemes: InheritedTheme.capture(
        from: context,
        to: navigator.context,
      ),
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: false,
      backgroundColor: AppColors.homeCanvas,
      modalBarrierColor: AppColors.contentSheetVeil,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      clipBehavior: Clip.antiAlias,
      sheetAnimationStyle: AnimationStyle(
        duration: AppMotion.enabled(context) ? AppMotion.page : Duration.zero,
        reverseDuration: AppMotion.enabled(context)
            ? AppMotion.veil
            : Duration.zero,
      ),
    ),
  );
}

class _BlurredContentSheetRoute<T> extends ModalBottomSheetRoute<T> {
  _BlurredContentSheetRoute({
    required super.builder,
    required super.isScrollControlled,
    super.capturedThemes,
    super.barrierLabel,
    super.useSafeArea,
    super.showDragHandle,
    super.backgroundColor,
    super.modalBarrierColor,
    super.shape,
    super.clipBehavior,
    super.sheetAnimationStyle,
  });
  @override
  Widget buildModalBarrier() => AnimatedBuilder(
    animation: animation!,
    builder: (context, _) => BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 14 * animation!.value,
        sigmaY: 14 * animation!.value,
      ),
      child: super.buildModalBarrier(),
    ),
  );
}
