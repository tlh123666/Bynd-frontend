import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../design_system/design_system.dart';
import '../../domain/sleep_models.dart';
import '../sleep_copy.dart';

const _lanes = [
  ('awake', SleepMetric.awake, AppHealthStyle.awake),
  ('rem', SleepMetric.rem, AppHealthStyle.rem),
  ('light', SleepMetric.light, AppHealthStyle.light),
  ('deep', SleepMetric.deep, AppHealthStyle.deep),
];

class SleepNightTracks extends StatefulWidget {
  const SleepNightTracks({required this.session, super.key});
  final SleepSession session;

  @override
  State<SleepNightTracks> createState() => _SleepNightTracksState();
}

class _SleepNightTracksState extends State<SleepNightTracks> {
  SleepStage? _selected;

  @override
  Widget build(BuildContext context) {
    final segments = widget.session.segments;
    if (segments.isEmpty) {
      return Text(
        sleepText(
          context,
          'Sem fases registradas.',
          'No sleep stages recorded.',
        ),
        style: AppHealthStyle.small,
      );
    }
    final duration = segments.fold<int>(
      widget.session.duration ?? 0,
      (end, stage) => math.max(end, stage.offset + stage.minutes),
    );
    final start = widget.session.start;
    String hour(int offset) {
      if (start == null) return '+$offset min';
      return MaterialLocalizations.of(context).formatTimeOfDay(
        TimeOfDay.fromDateTime(start.add(Duration(minutes: offset))),
        alwaysUse24HourFormat: MediaQuery.alwaysUse24HourFormatOf(context),
      );
    }

    final selection = _selected;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 211,
          child: LayoutBuilder(
            builder: (context, box) {
              final width = math.max(box.maxWidth, duration * (100 / 60));
              final scale = width / duration;
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapUp: (event) {
                    final minute = event.localPosition.dx / scale;
                    final lane = (event.localPosition.dy / 45).floor();
                    final hit = lane >= 0 && lane < _lanes.length
                        ? segments
                              .where(
                                (stage) =>
                                    stage.stage == _lanes[lane].$1 &&
                                    minute >= stage.offset &&
                                    minute < stage.offset + stage.minutes,
                              )
                              .firstOrNull
                        : null;
                    setState(() => _selected = hit);
                  },
                  child: CustomPaint(
                    size: Size(width, 211),
                    painter: _TracksPainter(
                      segments: segments,
                      scale: scale,
                      selected: selection,
                      ticks: [
                        for (var minute = 0; minute < duration; minute += 60)
                          (minute, hour(minute)),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        if (selection != null) ...[
          const SizedBox(height: 4),
          Text(
            '${sleepMetricTitle(context, _lanes.firstWhere((lane) => lane.$1 == selection.stage).$2)} · ${hour(selection.offset)}–${hour(selection.offset + selection.minutes)}',
            style: AppHealthStyle.small,
          ),
        ],
        AppChartLegend([
          for (final (_, metric, color) in _lanes)
            (color, sleepMetricTitle(context, metric)),
        ]),
      ],
    );
  }
}

class _TracksPainter extends CustomPainter {
  const _TracksPainter({
    required this.segments,
    required this.scale,
    required this.selected,
    required this.ticks,
  });
  final List<SleepStage> segments;
  final double scale;
  final SleepStage? selected;
  final List<(int, String)> ticks;

  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()..color = AppHealthStyle.divider;
    for (var lane = 0; lane <= 4; lane++) {
      canvas.drawLine(
        Offset(0, lane * 45),
        Offset(size.width, lane * 45),
        grid,
      );
    }
    for (final (minute, label) in ticks) {
      final x = minute * scale;
      canvas.drawLine(Offset(x, 0), Offset(x, 180), grid);
      final text = TextPainter(
        text: TextSpan(text: label, style: AppHealthStyle.legend),
        textDirection: TextDirection.ltr,
      )..layout();
      text.paint(canvas, Offset(x + 3, 188));
      text.dispose();
    }
    for (final stage in segments) {
      final lane = _lanes.indexWhere((item) => item.$1 == stage.stage);
      if (lane < 0) continue;
      final span = stage.minutes * scale;
      final rect = Rect.fromLTWH(
        stage.offset * scale,
        lane * 45 + 18,
        math.max(1, span - 1),
        9,
      );
      final active =
          selected == null ||
          (selected!.offset == stage.offset && selected!.stage == stage.stage);
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(4)),
        Paint()..color = _lanes[lane].$3.withValues(alpha: active ? 1 : .36),
      );
    }
  }

  @override
  bool shouldRepaint(_TracksPainter old) =>
      old.segments != segments ||
      old.scale != scale ||
      old.selected != selected ||
      old.ticks != ticks;
}
