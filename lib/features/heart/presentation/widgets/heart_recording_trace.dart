import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../design_system/design_system.dart';
import '../../domain/heart_models.dart';
import '../heart_copy.dart';

class HeartLatestTrace extends StatefulWidget {
  const HeartLatestTrace({
    required this.repository,
    required this.record,
    super.key,
  });
  final HeartRepository repository;
  final HeartRecording record;

  @override
  State<HeartLatestTrace> createState() => _HeartLatestTraceState();
}

class _HeartLatestTraceState extends State<HeartLatestTrace> {
  late Future<HeartRecording> _record = _load();

  Future<HeartRecording> _load() => widget.record.available
      ? Future.value(widget.record)
      : widget.repository.recording(widget.record.id);

  @override
  void didUpdateWidget(HeartLatestTrace oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.repository != widget.repository ||
        oldWidget.record.id != widget.record.id ||
        oldWidget.record.status != widget.record.status) {
      _record = _load();
    }
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<HeartRecording>(
    key: ValueKey(widget.record.id),
    future: _record,
    builder: (context, snapshot) {
      final record = snapshot.data;
      if (record?.available != true) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Text(
            snapshot.connectionState == ConnectionState.waiting
                ? heartText(context, 'Carregando traçado…', 'Loading trace…')
                : heartText(
                    context,
                    'Traçado indisponível.',
                    'Waveform unavailable.',
                  ),
            style: AppHealthStyle.small,
          ),
        );
      }
      final samples = record!.samples;
      final preview = record.number('sampleRateHz') == null
          ? math.max(1, samples.length ~/ 6)
          : record.number('sampleRateHz')! * 5;
      return HeartRecordingTrace(
        samples: samples.take(preview).toList(growable: false),
        height: 96,
        reveal: true,
      );
    },
  );
}

/// Uses raw optical/electrode sample levels on a relative scale. Both rows
/// share the same amplitude and nominal time window.
class HeartRecordingTrace extends StatelessWidget {
  const HeartRecordingTrace({
    required this.samples,
    this.height = AppHealthStyle.trendHeight,
    this.twoRows = false,
    this.seconds = 30,
    this.elapsed,
    this.reveal = false,
    super.key,
  });
  final List<int> samples;
  final double height;
  final bool twoRows, reveal;
  final double seconds;
  final double? elapsed;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    Widget trace(double progress) => RepaintBoundary(
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: CustomPaint(
          painter: _RecordingPainter(
            samples: samples,
            rows: twoRows ? 2 : 1,
            seconds: seconds,
            extent: elapsed == null ? 1 : (elapsed! / seconds).clamp(0.0, 1.0),
            progress: progress,
          ),
        ),
      ),
    );
    return reveal && !reduceMotion
        ? TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeOutCubic,
            builder: (_, value, _) => trace(value),
          )
        : trace(1);
  }
}

class _RecordingPainter extends CustomPainter {
  const _RecordingPainter({
    required this.samples,
    required this.rows,
    required this.seconds,
    required this.extent,
    required this.progress,
  });
  final List<int> samples;
  final int rows;
  final double seconds, extent, progress;

  @override
  void paint(Canvas canvas, Size size) {
    final rowHeight = size.height / rows;
    final grid = Paint()
      ..strokeWidth = .6
      ..shader = const LinearGradient(
        colors: [
          Colors.transparent,
          AppHealthStyle.divider,
          AppHealthStyle.divider,
          Colors.transparent,
        ],
        stops: [0, .12, .88, 1],
      ).createShader(Offset.zero & size);
    for (var x = 0.0; x < size.width; x += 10) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (var y = 0.0; y < size.height; y += 10) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
    if (rows > 1) {
      for (var row = 0; row < rows; row++) {
        final start = seconds * row / rows;
        final time = TextPainter(
          text: TextSpan(
            text: '${start.toStringAsFixed(start == start.round() ? 0 : 1)} s',
            style: AppHealthStyle.legend,
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        time.paint(canvas, Offset(2, row * rowHeight + 3));
        time.dispose();
      }
    }
    if (samples.length < 2 || extent <= 0) return;
    final min = samples.reduce(math.min);
    final range = math.max(1, samples.reduce(math.max) - min);
    final maxIndex = samples.length - 1;
    final visible = extent * progress;
    final stroke = Paint()
      ..color = AppHealthStyle.pulse
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round;
    for (var row = 0; row < rows; row++) {
      final start = row / rows;
      final end = math.min(visible, (row + 1) / rows);
      if (end <= start) break;
      final first = (start / extent * maxIndex).round();
      final last = (end / extent * maxIndex).round();
      final count = math.min(
        last - first + 1,
        math.max(2, size.width.ceil() * 3),
      );
      final path = Path();
      for (var i = 0; i < count; i++) {
        final ratio = i / math.max(1, count - 1);
        final index = (first + ratio * (last - first)).round();
        final x = ratio * (end - start) * rows * size.width;
        final y = (row + .8 - .58 * (samples[index] - min) / range) * rowHeight;
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      canvas.drawPath(path, stroke);
    }
  }

  @override
  bool shouldRepaint(_RecordingPainter old) =>
      old.samples != samples ||
      old.extent != extent ||
      old.progress != progress ||
      old.rows != rows ||
      old.seconds != seconds;
}
