import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_dimensions.dart';
import '../tokens/app_motion.dart';
import '../tokens/app_typography.dart';
import 'app_icon.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../l10n/app_localizations_context.dart';

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

  String localizedLabel(AppLocalizations strings) => switch (this) {
    AppQuickAction.breathe => strings.breatheFiveMinutes,
    AppQuickAction.meal => strings.logMeal,
    AppQuickAction.startActivity => strings.startActivity,
    AppQuickAction.dayReview => strings.reviewDay,
    AppQuickAction.logActivity => strings.logActivity,
    AppQuickAction.ecg => strings.doEcg,
  };
}

/// The quick actions expand over the current route; no page is pushed.
/// [origin] is the visible bottom bar button's rectangle in screen coordinates.
class AppQuickActionsOverlay extends StatefulWidget {
  const AppQuickActionsOverlay({
    required this.origin,
    required this.onClose,
    required this.onActionSelected,
    super.key,
  });

  final Rect origin;
  final VoidCallback onClose;
  final ValueChanged<AppQuickAction> onActionSelected;

  @override
  State<AppQuickActionsOverlay> createState() => _AppQuickActionsOverlayState();
}

class _AppQuickActionsOverlayState extends State<AppQuickActionsOverlay>
    with TickerProviderStateMixin {
  late final AnimationController _enter = AnimationController(
    vsync: this,
    duration: AppMotion.quickEnter,
  );
  late final AnimationController _exit = AnimationController(
    vsync: this,
    duration: AppMotion.quickExit,
  );

  bool _started = false;
  bool _closing = false;
  late List<double> _bubbleAtClose;
  double _backdropAtClose = 0;
  double _headlineAtClose = 0;
  double _closeOpacityAtClose = 0;
  double _closeAngleAtClose = -math.pi / 2;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (AppMotion.enabled(context)) {
      _enter.forward();
    } else {
      _enter.value = 1;
    }
  }

  @override
  void dispose() {
    _enter.dispose();
    _exit.dispose();
    super.dispose();
  }

  double _enterProgress(Duration delay, Duration duration, Curve curve) {
    final elapsed = _enter.value * AppMotion.quickEnter.inMilliseconds;
    final fraction =
        ((elapsed - delay.inMilliseconds) / duration.inMilliseconds).clamp(
          0.0,
          1.0,
        );
    return curve.transform(fraction);
  }

  double _bubbleEnter(int index) => _enterProgress(
    AppMotion.quickBubbleStagger * index,
    AppMotion.quickBubble,
    AppMotion.quickBubbleCurve,
  );

  double get _bubbleExitProgress {
    final elapsed = _exit.value * AppMotion.quickExit.inMilliseconds;
    final fraction = (elapsed / AppMotion.quickBubbleExit.inMilliseconds).clamp(
      0.0,
      1.0,
    );
    return AppMotion.quickExitCurve.transform(fraction);
  }

  ({double opacity, double dy, double scale}) _bubbleState(int index) {
    final before = _closing ? _bubbleAtClose[index] : _bubbleEnter(index);
    final startDy = 26 * (1 - before);
    final startScale = 0.92 + 0.08 * before;
    if (!_closing) {
      return (opacity: before, dy: startDy, scale: startScale);
    }
    final exit = _bubbleExitProgress;
    return (
      opacity: before * (1 - exit),
      dy: startDy * (1 - exit) + 18 * exit,
      scale: startScale * (1 - exit) + 0.95 * exit,
    );
  }

  double get _backdropProgress => _closing
      ? _backdropAtClose * (1 - Curves.ease.transform(_exit.value))
      : _enterProgress(Duration.zero, AppMotion.quickBackdrop, Curves.ease);

  double get _headlineProgress => _closing
      ? _headlineAtClose * (1 - Curves.ease.transform(_exit.value))
      : _enterProgress(
          AppMotion.quickHeadlineDelay,
          AppMotion.quickHeadline,
          Curves.ease,
        );

  double get _closeEnterProgress => _enterProgress(
    Duration.zero,
    AppMotion.quickCloseButton,
    Curves.easeOutBack,
  );

  double get _closeOpacity => _closing
      ? _closeOpacityAtClose * (1 - _bubbleExitProgress)
      : _closeEnterProgress.clamp(0.0, 1.0);

  double get _closeAngle => _closing
      ? _closeAngleAtClose +
            (-math.pi / 2 - _closeAngleAtClose) * _bubbleExitProgress
      : -math.pi / 2 * (1 - _closeEnterProgress);

  String get _suggestion {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 'Para esta manhã, a BYND sugere 15 minutos de sol antes do trabalho.';
    }
    if (hour >= 12 && hour < 18) {
      return 'Para esta tarde, a BYND sugere uma pausa para respirar.';
    }
    return 'Para esta noite, a BYND sugere respirar antes de dormir.';
  }

  Future<void> _close([AppQuickAction? selected]) async {
    if (_closing) return;
    _bubbleAtClose = List.generate(AppQuickAction.values.length, _bubbleEnter);
    _backdropAtClose = _backdropProgress;
    _headlineAtClose = _headlineProgress;
    _closeOpacityAtClose = _closeOpacity;
    _closeAngleAtClose = _closeAngle;
    setState(() => _closing = true);

    if (AppMotion.enabled(context)) await _exit.forward();
    if (!mounted) return;
    if (selected == null) {
      widget.onClose();
    } else {
      widget.onActionSelected(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _close();
      },
      child: Material(
        color: Colors.transparent,
        child: AnimatedBuilder(
          animation: Listenable.merge([_enter, _exit]),
          builder: (context, _) {
            final center = widget.origin.center;
            final headlineTop =
                math.max(20.0, MediaQuery.paddingOf(context).top) + 110;
            final positions = <AppQuickAction, Offset>{
              AppQuickAction.breathe: center + const Offset(-5, -278),
              AppQuickAction.meal: center + const Offset(-111, -244),
              AppQuickAction.startActivity: center + const Offset(-37, -156),
              AppQuickAction.dayReview: center + const Offset(-193, -164),
              AppQuickAction.logActivity: center + const Offset(-103, -90),
              AppQuickAction.ecg: center + const Offset(-225, -56),
            };

            return Stack(
              children: [
                Positioned.fill(
                  child: Opacity(
                    key: const Key('quick-backdrop-opacity'),
                    opacity: _backdropProgress,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: _close,
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                        child: const ColoredBox(
                          color: AppColors.quickActionsVeil,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: headlineTop,
                  left: 22,
                  right: 120,
                  child: IgnorePointer(
                    child: Opacity(
                      opacity: _headlineProgress,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AÇÕES RÁPIDAS',
                            style: AppTypography.kicker.copyWith(
                              color: AppColors.textKicker,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _suggestion,
                            style: const TextStyle(
                              fontFamily: AppFontFamilies.geist,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              height: 1.4,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                for (final action in AppQuickAction.values)
                  _bubble(action, positions[action]!),
                Positioned.fromRect(
                  rect: widget.origin,
                  child: IgnorePointer(
                    ignoring: _closing || _closeOpacity < 0.3,
                    child: Opacity(
                      opacity: _closeOpacity,
                      child: Transform.rotate(
                        angle: _closeAngle,
                        child: Semantics(
                          label: 'Fechar',
                          button: true,
                          child: Material(
                            color: AppColors.textPrimary,
                            shape: const CircleBorder(),
                            child: InkWell(
                              key: const Key('quick-close-button'),
                              onTap: _close,
                              customBorder: const CircleBorder(),
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
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _bubble(AppQuickAction action, Offset center) {
    final iconSize = action == AppQuickAction.logActivity ? 52.0 : 46.0;
    final state = _bubbleState(action.index);
    return Positioned(
      left: center.dx - 52,
      top: center.dy - iconSize / 2,
      width: 104,
      child: IgnorePointer(
        ignoring: _closing || state.opacity < 0.8,
        child: Opacity(
          key: Key('quick-bubble-${action.name}'),
          opacity: state.opacity,
          child: Transform.translate(
            offset: Offset(0, state.dy),
            child: Transform.scale(
              scale: state.scale,
              alignment: Alignment.topCenter,
              child: _QuickActionTile(
                action: action,
                iconSize: iconSize,
                onTap: () => _close(action),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({
    required this.action,
    required this.iconSize,
    required this.onTap,
  });

  final AppQuickAction action;
  final double iconSize;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: action.localizedLabel(context.l10n).replaceAll('\n', ' '),
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.controlBorder,
        child: Column(
          children: [
            SizedBox(
              width: iconSize,
              height: iconSize,
              child: Center(
                child: AppSvgIcon(
                  action.iconAsset,
                  size: 27,
                  color: action == AppQuickAction.breathe
                      ? AppColors.sky
                      : AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 7),
            Text(
              action.localizedLabel(context.l10n),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: AppFontFamilies.geist,
                fontSize: 11.5,
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
