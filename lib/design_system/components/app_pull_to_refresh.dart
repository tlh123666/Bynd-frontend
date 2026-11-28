import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../l10n/app_localizations_context.dart';
import '../tokens/app_colors.dart';
import '../tokens/app_motion.dart';
import '../tokens/app_typography.dart';
import 'app_loading.dart';

/// 可复用的下拉刷新外壳；成功状态仅在调用方的刷新任务完成后显示。
/// [child] 须包含一个允许顶部过度滚动的纵向 Scrollable。
class AppPullToRefresh extends StatefulWidget {
  const AppPullToRefresh({
    required this.child,
    required this.onRefresh,
    this.successLabel,
    super.key,
  });

  final Widget child;
  final Future<void> Function() onRefresh;
  final String? successLabel;

  @override
  State<AppPullToRefresh> createState() => _AppPullToRefreshState();
}

class _AppPullToRefreshState extends State<AppPullToRefresh> {
  RefreshIndicatorStatus? _status;
  DateTime? _updatedAt;
  bool _failed = false;
  Timer? _hideTimer;

  Future<void> _refresh() async {
    _hideTimer?.cancel();
    setState(() {
      _updatedAt = null;
      _failed = false;
    });
    final started = Stopwatch()..start();
    try {
      await widget.onRefresh();
      // 成功动画最短展示时间与原型一致，同时等待真实任务完成。
      final remaining = const Duration(milliseconds: 1450) - started.elapsed;
      if (remaining > Duration.zero) await Future<void>.delayed(remaining);
      if (!mounted) return;
      setState(() => _updatedAt = DateTime.now());
    } catch (_) {
      if (!mounted) return;
      setState(() => _failed = true);
    }
    if (mounted) {
      _hideTimer = Timer(const Duration(milliseconds: 2200), () {
        if (mounted) {
          setState(() {
            _updatedAt = null;
            _failed = false;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final loading =
        _status == RefreshIndicatorStatus.snap ||
        _status == RefreshIndicatorStatus.refresh;
    final pulling =
        _status == RefreshIndicatorStatus.drag ||
        _status == RefreshIndicatorStatus.armed;
    final showMessage = _updatedAt != null || _failed;
    final time = _updatedAt == null
        ? ''
        : DateFormat.Hm(
            Localizations.localeOf(context).toString(),
          ).format(_updatedAt!);
    return Stack(
      children: [
        RefreshIndicator.noSpinner(
          onRefresh: _refresh,
          onStatusChange: (status) {
            if (!mounted || _status == status) return;
            if (status == RefreshIndicatorStatus.drag) _hideTimer?.cancel();
            setState(() {
              _status = status;
              if (status == RefreshIndicatorStatus.drag) {
                _updatedAt = null;
                _failed = false;
              }
            });
          },
          child: widget.child,
        ),
        if (loading || pulling || showMessage)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Center(
                child: showMessage
                    ? Semantics(
                        liveRegion: true,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0x8c1c2026),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: const Color(0x17ffffff)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _failed
                                    ? Icons.error_outline
                                    : Icons.check_circle,
                                size: 18,
                                color: _failed
                                    ? AppColors.textMuted
                                    : const Color(0xff86d4a3),
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  _failed
                                      ? s.refreshFailed
                                      : widget.successLabel ?? s.refreshUpdated,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTypography.caption.copyWith(
                                    fontSize: 13,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              if (!_failed) ...[
                                const SizedBox(width: 8),
                                Text(
                                  s.refreshTime(time),
                                  style: AppTypography.caption.copyWith(
                                    fontSize: 13,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      )
                    : SizedBox(
                        width: 34,
                        height: 34,
                        child: Center(
                          child: loading
                              ? const _RefreshGlyph()
                              : Icon(
                                  _status == RefreshIndicatorStatus.armed
                                      ? Icons.arrow_upward
                                      : Icons.arrow_downward,
                                  size: 20,
                                  color: AppColors.textMuted,
                                ),
                        ),
                      ),
              ),
            ),
          ),
      ],
    );
  }
}

/// 先显示旋转弧线，再合成带 BYND 标记的圆环。
class _RefreshGlyph extends StatelessWidget {
  const _RefreshGlyph();

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
    tween: Tween(begin: 0, end: 1),
    duration: AppMotion.enabled(context)
        ? const Duration(milliseconds: 750)
        : Duration.zero,
    builder: (context, value, _) => SizedBox(
      width: 24,
      height: 24,
      child: value < 1
          ? const CircularProgressIndicator(
              strokeWidth: 1.3,
              color: AppColors.textMuted,
            )
          : DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.textMuted, width: 1.3),
              ),
              child: const Center(
                child: AppLoadingIndicator(
                  size: 14,
                  showLabel: false,
                  color: AppColors.textMuted,
                ),
              ),
            ),
    ),
  );
}
