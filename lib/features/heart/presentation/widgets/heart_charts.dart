import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../design_system/design_system.dart';
import '../../domain/heart_models.dart';
import '../heart_copy.dart';

class HeartLineChart extends StatefulWidget {
  const HeartLineChart({
    required this.points,
    required this.date,
    this.height = 160,
    super.key,
  });
  final List<HeartPoint> points;
  final DateTime date;
  final double height;
  @override
  State<HeartLineChart> createState() => _HeartLineChartState();
}

class _HeartLineChartState extends State<HeartLineChart> {
  double? _selection;
  @override
  Widget build(BuildContext context) {
    if (widget.points.isEmpty) {
      return SizedBox(
        height: widget.height,
        child: Center(
          child: Text(
            heartText(
              context,
              'Sem amostras nesta data.',
              'No samples on this date.',
            ),
            style: AppHeartStyle.caption,
          ),
        ),
      );
    }
    final sorted = List<HeartPoint>.of(widget.points)
      ..sort((a, b) => a.at.compareTo(b.at));
    final first = sorted.first.at,
        last = sorted.last.at,
        span = math.max(60, last.difference(first).inSeconds);
    final selected = _selection == null
        ? null
        : sorted.reduce(
            (a, b) =>
                (a.at.difference(first).inSeconds / span - _selection!).abs() <
                    (b.at.difference(first).inSeconds / span - _selection!)
                        .abs()
                ? a
                : b,
          );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (selected != null)
          Text(
            '${heartClock(selected.at)} · ${selected.bpm} bpm',
            style: AppHeartStyle.caption,
            textAlign: TextAlign.center,
          ),
        Semantics(
          label: heartText(
            context,
            'Curva de frequência cardíaca. Arraste para explorar.',
            'Heart rate chart. Drag to explore.',
          ),
          child: LayoutBuilder(
            builder: (c, box) => GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: (e) => setState(
                () => _selection = (e.localPosition.dx / box.maxWidth).clamp(
                  0,
                  1,
                ),
              ),
              onHorizontalDragUpdate: (e) => setState(
                () => _selection = (e.localPosition.dx / box.maxWidth).clamp(
                  0,
                  1,
                ),
              ),
              child: CustomPaint(
                size: Size(box.maxWidth, widget.height),
                painter: _HeartLinePainter(
                  downsampleHeartPoints(sorted, 600),
                  _selection,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (var i = 0; i <= 3; i++)
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    heartClock(
                      first.add(Duration(seconds: (span * i / 3).round())),
                    ),
                    style: AppHeartStyle.caption.copyWith(fontSize: 11),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _HeartLinePainter extends CustomPainter {
  const _HeartLinePainter(this.points, this.selection);
  final List<HeartPoint> points;
  final double? selection;
  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    final lo = math
            .max(20, points.map((p) => p.bpm).reduce(math.min) - 8)
            .toDouble(),
        hi = math
            .min(250, points.map((p) => p.bpm).reduce(math.max) + 8)
            .toDouble(),
        range = math.max(1, hi - lo),
        span = math.max(
          60,
          points.last.at.difference(points.first.at).inSeconds,
        );
    final grid = Paint()
      ..color = AppColors.glassBorder
      ..strokeWidth = .5;
    for (var i = 0; i < 4; i++) {
      canvas.drawLine(
        Offset(0, size.height * i / 3),
        Offset(size.width, size.height * i / 3),
        grid,
      );
    }
    final path = Path();
    DateTime? prior;
    for (final p in points) {
      final x = p.at.difference(points.first.at).inSeconds / span * size.width,
          y = size.height - (p.bpm - lo) / range * size.height;
      if (prior == null || p.at.difference(prior).inMinutes > 20) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      prior = p.at;
    }
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4
        ..strokeJoin = StrokeJoin.round
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppHeartStyle.family, Color(0xFFF4F5F7)],
        ).createShader(Offset.zero & size),
    );
    if (points.length == 1) {
      canvas.drawCircle(
        Offset(0, size.height - (points.first.bpm - lo) / range * size.height),
        3,
        Paint()..color = AppHeartStyle.family,
      );
    }
    if (selection != null) {
      canvas.drawLine(
        Offset(size.width * selection!, 0),
        Offset(size.width * selection!, size.height),
        Paint()
          ..color = AppColors.textPrimary
          ..strokeWidth = 1,
      );
    }
  }

  @override
  bool shouldRepaint(_HeartLinePainter old) => true;
}

class HeartTrendChart extends StatelessWidget {
  const HeartTrendChart({
    required this.trend,
    required this.metric,
    this.onDay,
    super.key,
  });
  final HeartTrend trend;
  final HeartMetric metric;
  final ValueChanged<DateTime>? onDay;
  @override
  Widget build(BuildContext context) {
    if (trend.locked) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.lock_outline, color: AppHeartStyle.muted),
            const SizedBox(height: 12),
            Text(
              heartText(
                context,
                'Histórico disponível no Premium.',
                'History is available with Premium.',
              ),
              style: AppHeartStyle.body,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    final vals = trend.values(metric);
    if (vals.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          heartText(
            context,
            'Ainda não há leituras neste período.',
            'No measurements in this period yet.',
          ),
          style: AppHeartStyle.caption,
        ),
      );
    }
    final maxValue = math.max(1, vals.reduce(math.max).toDouble()) * 1.15;
    return Column(
      children: [
        SizedBox(
          height: 160,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (final d in trend.days)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Semantics(
                      button: onDay != null,
                      label:
                          '${d['statDate']}: ${d[metric.field] ?? '—'}${metric == HeartMetric.pressure ? '/${d['diastolicBp'] ?? '—'}' : ''} ${metric.unit}',
                      child: InkWell(
                        onTap: onDay == null
                            ? null
                            : () => onDay!(DateTime.parse('${d['statDate']}')),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            margin: EdgeInsets.only(
                              bottom:
                                  metric == HeartMetric.pressure &&
                                      d['diastolicBp'] is num
                                  ? (d['diastolicBp'] as num) / maxValue * 150
                                  : 0,
                            ),
                            height:
                                metric == HeartMetric.pressure &&
                                    d[metric.field] is num &&
                                    d['diastolicBp'] is num
                                ? math.max(
                                    3,
                                    ((d[metric.field] as num) -
                                            (d['diastolicBp'] as num)) /
                                        maxValue *
                                        150,
                                  )
                                : d[metric.field] is num
                                ? math.max(
                                    3,
                                    (d[metric.field] as num) / maxValue * 150,
                                  )
                                : 3,
                            decoration: BoxDecoration(
                              color: d[metric.field] is num
                                  ? AppHeartStyle.family
                                  : AppColors.glassBorder,
                              borderRadius: BorderRadius.circular(3),
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
        const SizedBox(height: 10),
        if (metric == HeartMetric.pressure)
          Text(
            heartText(
              context,
              'Diastólica — sistólica · mmHg',
              'Diastolic — systolic · mmHg',
            ),
            style: AppHeartStyle.caption,
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (final d in [trend.days.first, trend.days.last])
              Flexible(
                child: Text(
                  heartShortDate(context, DateTime.parse('${d['statDate']}')),
                  style: AppHeartStyle.caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class HeartWaveform extends StatelessWidget {
  const HeartWaveform({
    required this.samples,
    this.height = 120,
    this.live = false,
    super.key,
  });
  final List<int> samples;
  final double height;
  final bool live;
  @override
  Widget build(BuildContext context) => RepaintBoundary(
    child: SizedBox(
      height: height,
      width: double.infinity,
      child: samples.isEmpty
          ? Center(
              child: Text(
                heartText(
                  context,
                  'Aguardando sinal do sensor…',
                  'Waiting for the sensor signal…',
                ),
                style: AppHeartStyle.caption,
              ),
            )
          : CustomPaint(
              painter: _WavePainter(
                live && samples.length > 600
                    ? samples.sublist(samples.length - 600)
                    : samples,
              ),
            ),
    ),
  );
}

class _WavePainter extends CustomPainter {
  const _WavePainter(this.samples);
  final List<int> samples;
  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..strokeWidth = .5
      ..color = AppColors.glassBorder;
    for (var x = 0.0; x < size.width; x += 12) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (var y = 0.0; y < size.height; y += 12) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
    if (samples.isEmpty) return;
    final low = samples.reduce(math.min),
        high = samples.reduce(math.max),
        range = math.max(1, high - low),
        count = math.min(samples.length, math.max(600, size.width.round() * 2));
    final path = Path();
    for (var i = 0; i < count; i++) {
      final index = (i * (samples.length - 1) / math.max(1, count - 1)).round(),
          x = i / math.max(1, count - 1) * size.width,
          y =
              size.height * .85 -
              (samples[index] - low) / range * size.height * .7;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = AppHeartStyle.family
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_WavePainter old) => true;
}
