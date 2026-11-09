import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../design_system/design_system.dart';
import '../../../../l10n/app_localizations_context.dart';
import '../../../../shared/widgets/day_strip.dart';
import '../../application/home_controller.dart';
import '../../domain/home_models.dart';

class HomeSignalDetailPage extends StatefulWidget {
  const HomeSignalDetailPage({
    required this.controller,
    required this.signal,
    super.key,
  });
  final HomeController controller;
  final HomeSignal signal;
  @override
  State<HomeSignalDetailPage> createState() => _HomeSignalDetailPageState();
}

class _HomeSignalDetailPageState extends State<HomeSignalDetailPage> {
  late int _day = widget.controller.day;
  late DateTime _date = widget.controller.date;
  Future<List<HomeHistoryPoint>>? _future;
  String? _locale;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_locale != context.l10n.localeName) {
      _locale = context.l10n.localeName;
      _load();
    }
  }

  void _load() {
    _future = widget.controller.repository.history(
      widget.signal,
      _date,
      _locale!,
    );
  }

  void _select(int day) {
    setState(() {
      _day = day;
      _date = homeDay(widget.controller.now, day);
      _load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    return Scaffold(
      backgroundColor: AppColors.homeCanvas,
      body: AppDetailBackground(
        child: SafeArea(
          child: Column(
            children: [
              AppDetailHeader(
                title: widget.signal.label(s.localeName),
                onClose: () => Navigator.pop(context),
                closeLabel: s.back,
              ),
              DayStrip(day: _day, onDayChanged: _select),
              Expanded(
                child: FutureBuilder<List<HomeHistoryPoint>>(
                  future: _future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(child: AppLoadingIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(s.homeHistoryError, style: AppTypography.body),
                            const SizedBox(height: 16),
                            AppButton(
                              label: s.homeRetry,
                              onPressed: () => setState(_load),
                            ),
                          ],
                        ),
                      );
                    }
                    final points = snapshot.data ?? [];
                    final values = points
                        .map((p) => p.value)
                        .whereType<num>()
                        .toList();
                    final value = points.isEmpty ? null : points.last.value;
                    return ListView(
                      padding: const EdgeInsets.fromLTRB(22, 24, 22, 40),
                      children: [
                        Center(
                          child: Text.rich(
                            TextSpan(
                              text: widget.signal.format(value, s.localeName),
                              style: AppTypography.signalValue.copyWith(
                                fontSize: 64,
                              ),
                              children: [
                                if (value != null)
                                  TextSpan(
                                    text: ' ${widget.signal.unit}',
                                    style: AppTypography.body.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Center(
                          child: Text(
                            value == null
                                ? s.homeNoMeasurement
                                : homeDateKey(_date),
                            style: AppTypography.caption.copyWith(
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),
                        const SizedBox(height: 52),
                        Text(
                          s.homeWeek,
                          style: AppTypography.kicker.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 26),
                        if (values.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 80),
                            child: Text(
                              s.homeHistoryEmpty,
                              textAlign: TextAlign.center,
                              style: AppTypography.body.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          )
                        else
                          SizedBox(
                            height: 200,
                            child: Semantics(
                              label: points
                                  .map(
                                    (p) =>
                                        '${homeDateKey(p.date)}: ${widget.signal.format(p.value, s.localeName)}',
                                  )
                                  .join(', '),
                              child: CustomPaint(
                                painter: _HistoryPainter(points),
                              ),
                            ),
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            for (final point in points)
                              Text(
                                '${point.date.day}',
                                style: AppTypography.caption.copyWith(
                                  color: AppColors.textMuted,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        if (values.isNotEmpty)
                          Row(
                            children: [
                              _stat(s.homeMinimum, values.reduce(math.min)),
                              _stat(
                                s.homeAverage,
                                values.reduce((a, b) => a + b) / values.length,
                              ),
                              _stat(s.homeMaximum, values.reduce(math.max)),
                            ],
                          ),
                        const SizedBox(height: 32),
                        Text(
                          s.homeDataOnly,
                          style: AppTypography.caption.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stat(String label, num value) => Expanded(
    child: Column(
      children: [
        Text(
          label,
          style: AppTypography.caption.copyWith(color: AppColors.textMuted),
        ),
        const SizedBox(height: 8),
        FittedBox(
          child: Text(
            widget.signal.format(value, _locale!),
            style: AppTypography.title,
          ),
        ),
      ],
    ),
  );
}

class _HistoryPainter extends CustomPainter {
  _HistoryPainter(this.points);
  final List<HomeHistoryPoint> points;
  @override
  void paint(Canvas canvas, Size size) {
    final values = points
        .map((p) => p.value?.toDouble())
        .whereType<double>()
        .toList();
    if (values.isEmpty) return;
    final lo = values.reduce(math.min), hi = values.reduce(math.max);
    final span = hi == lo ? math.max(hi.abs() * .1, 1) : hi - lo;
    final line = Paint()
      ..color = AppColors.divider
      ..strokeWidth = 1;
    for (var i = 0; i < 4; i++) {
      canvas.drawLine(
        Offset(0, size.height * i / 3),
        Offset(size.width, size.height * i / 3),
        line,
      );
    }
    Offset? previous;
    for (var i = 0; i < points.length; i++) {
      final value = points[i].value;
      if (value == null) {
        previous = null;
        continue;
      }
      final offset = Offset(
        6 + (size.width - 12) * i / math.max(points.length - 1, 1),
        size.height -
            20 -
            ((value - lo + span * .2) / (span * 1.4)) * (size.height - 40),
      );
      if (previous != null) {
        canvas.drawLine(
          previous,
          offset,
          Paint()
            ..color = AppColors.sky
            ..strokeWidth = 1.5,
        );
      }
      canvas.drawCircle(
        offset,
        i == points.length - 1 ? 5 : 3,
        Paint()..color = AppColors.sky,
      );
      previous = offset;
    }
  }

  @override
  bool shouldRepaint(_HistoryPainter oldDelegate) =>
      oldDelegate.points != points;
}
