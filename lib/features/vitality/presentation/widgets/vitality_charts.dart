import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import '../../../../design_system/tokens/app_vitality_style.dart';
import '../../../../l10n/app_localizations_context.dart';
import '../../domain/vitality_models.dart';
import '../vitality_copy.dart';

(double, double) _timeRange(List<VitalityPoint> points) {
  final outside = points.any((p) {
    final t = p.at.toLocal();
    return t.hour < 6 || t.hour > 22 || (t.hour == 22 && t.minute > 0);
  });
  return outside ? (0, 24) : (6, 22);
}

class VitalityChart extends StatefulWidget {
  const VitalityChart({
    required this.points,
    required this.color,
    this.forecast = const [],
    this.low,
    this.high,
    this.intraday = false,
    this.height = 210,
    super.key,
  });
  final List<VitalityPoint> points;
  final List<VitalityPoint> forecast;
  final Color color;
  final double? low, high;
  final bool intraday;
  final double height;
  @override
  State<VitalityChart> createState() => _VitalityChartState();
}

class _VitalityChartState extends State<VitalityChart> {
  int? _selected;
  @override
  void didUpdateWidget(VitalityChart old) {
    super.didUpdateWidget(old);
    if (old.points != widget.points) _selected = null;
  }

  @override
  Widget build(BuildContext context) {
    final hasData = widget.points.any((p) => p.score != null);
    if (!hasData) {
      return SizedBox(
        height: widget.height,
        child: Center(
          child: Text(
            context.l10n.vitalityNoCurve,
            style: AppVitalityStyle.caption,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    final points = widget.points;
    final selected = _selected == null
        ? null
        : points[_selected!.clamp(0, points.length - 1)];
    return Column(
      children: [
        if (selected != null)
          Text(
            context.l10n.vitalitySelectedPoint(
              widget.intraday
                  ? TimeOfDay.fromDateTime(
                      selected.at.toLocal(),
                    ).format(context)
                  : vitalityDateLabel(context, selected.at),
              vitalityNumber(context, selected.score),
            ),
            style: AppVitalityStyle.caption,
          ),
        LayoutBuilder(
          builder: (c, box) {
            void select(Offset offset) {
              final ratio = (offset.dx / box.maxWidth).clamp(0.0, 1.0);
              int index;
              if (widget.intraday) {
                final range = _timeRange([...points, ...widget.forecast]);
                final target = range.$1 + ratio * (range.$2 - range.$1);
                final last = points.last.at.toLocal();
                if (widget.forecast.isNotEmpty &&
                    target > last.hour + last.minute / 60) {
                  setState(() => _selected = null);
                  return;
                }
                index = 0;
                for (var i = 1; i < points.length; i++) {
                  if ((points[i].at.toLocal().hour +
                              points[i].at.toLocal().minute / 60 -
                              target)
                          .abs() <
                      (points[index].at.toLocal().hour +
                              points[index].at.toLocal().minute / 60 -
                              target)
                          .abs()) {
                    index = i;
                  }
                }
              } else {
                index = (ratio * (points.length - 1)).round();
              }
              setState(() => _selected = index);
            }

            return Semantics(
              label: context.l10n.vitalitySelectedPoint(
                vitalityDateLabel(context, points.last.at),
                vitalityNumber(context, points.last.score),
              ),
              child: GestureDetector(
                onTapDown: (d) => select(d.localPosition),
                onHorizontalDragUpdate: (d) => select(d.localPosition),
                child: CustomPaint(
                  size: Size(box.maxWidth, widget.height),
                  painter: _ChartPainter(
                    points,
                    widget.forecast,
                    widget.color,
                    widget.low,
                    widget.high,
                    widget.intraday,
                    _selected,
                    Localizations.localeOf(context).toLanguageTag(),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _ChartPainter extends CustomPainter {
  _ChartPainter(
    this.points,
    this.forecast,
    this.color,
    this.low,
    this.high,
    this.intraday,
    this.selected,
    this.locale,
  );
  final List<VitalityPoint> points;
  final List<VitalityPoint> forecast;
  final Color color;
  final double? low, high;
  final bool intraday;
  final int? selected;
  final String locale;
  void label(Canvas c, String text, Offset at, {Color? color}) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: AppVitalityStyle.caption.copyWith(fontSize: 11, color: color),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: 64);
    tp.paint(c, Offset(at.dx - tp.width / 2, at.dy));
  }

  @override
  void paint(Canvas c, Size size) {
    const left = 13.0;
    final width = size.width - 26, height = size.height - 38;
    final range = _timeRange([...points, ...forecast]);
    double x(int i) {
      if (intraday) {
        final t = points[i].at.toLocal();
        return left +
            ((t.hour + t.minute / 60 - range.$1) / (range.$2 - range.$1)).clamp(
                  0.0,
                  1.0,
                ) *
                width;
      }
      return left +
          (points.length == 1 ? 0.5 : i / (points.length - 1)) * width;
    }

    double y(double v) => 12 + (1 - v.clamp(0, 100) / 100) * (height - 12);
    if (low != null && high != null) {
      c.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTRB(left, y(high!), left + width, y(low!)),
          const Radius.circular(4),
        ),
        Paint()..color = Colors.white.withValues(alpha: .09),
      );
    }
    final path = Path();
    var pen = false;
    DateTime? previous;
    for (var i = 0; i < points.length; i++) {
      final p = points[i];
      if (p.score == null) {
        pen = false;
        previous = null;
        continue;
      }
      if (intraday &&
          previous != null &&
          p.at.difference(previous).inMinutes > 180) {
        pen = false;
      }
      if (pen) {
        path.lineTo(x(i), y(p.score!));
      } else {
        path.moveTo(x(i), y(p.score!));
      }
      pen = true;
      previous = p.at;
      {
        c.drawCircle(
          Offset(x(i), y(p.score!)),
          i == selected
              ? 5
              : intraday
              ? 1.5
              : 3,
          Paint()..color = color,
        );
      }
    }
    c.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6
        ..strokeJoin = StrokeJoin.round,
    );
    if (intraday && forecast.isNotEmpty && points.last.score != null) {
      Offset position(VitalityPoint p) {
        final t = p.at.toLocal();
        return Offset(
          left +
              ((t.hour + t.minute / 60 - range.$1) / (range.$2 - range.$1))
                      .clamp(0.0, 1.0) *
                  width,
          y(p.score!),
        );
      }

      var previous = points.last;
      for (final point in forecast.where(
        (p) => p.score != null && p.at.isAfter(points.last.at),
      )) {
        final a = position(previous),
            b = position(point),
            distance = (b - a).distance;
        if (distance > 0) {
          for (double step = 0; step < distance; step += 8) {
            c.drawLine(
              Offset.lerp(a, b, step / distance)!,
              Offset.lerp(a, b, math.min(step + 4, distance) / distance)!,
              Paint()
                ..color = color.withValues(alpha: .65)
                ..strokeWidth = 1.5,
            );
          }
        }
        previous = point;
      }
    }
    if (selected != null &&
        selected! < points.length &&
        points[selected!].score != null) {
      final dx = x(selected!);
      c.drawLine(
        Offset(dx, 8),
        Offset(dx, height),
        Paint()
          ..color = AppVitalityStyle.muted
          ..strokeWidth = .6,
      );
      c.drawCircle(
        Offset(dx, y(points[selected!].score!)),
        4,
        Paint()..color = color,
      );
    }
    if (intraday) {
      for (final hour
          in range.$1 == 0 ? [0, 6, 12, 18, 24] : [6, 10, 14, 18, 22]) {
        label(
          c,
          '${hour.toString().padLeft(2, '0')}:00',
          Offset(
            left + (hour - range.$1) / (range.$2 - range.$1) * width,
            height + 10,
          ),
        );
      }
    } else {
      final stride = points.length > 10 ? 5 : 1;
      for (var i = 0; i < points.length; i += stride) {
        label(
          c,
          '${DateFormat.E(locale).format(points[i].at)}\n${points[i].at.day}',
          Offset(x(i), height + 7),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ChartPainter old) =>
      old.points != points ||
      old.forecast != forecast ||
      old.selected != selected ||
      old.locale != locale ||
      old.low != low ||
      old.high != high ||
      old.color != color;
}

class RecoveryArc extends StatelessWidget {
  const RecoveryArc({required this.score, super.key});
  final double? score;
  @override
  Widget build(BuildContext context) => Semantics(
    label: context.l10n.vitalityScoreSummary(
      vitalityNumber(context, score),
      vitalityStatus(context, score),
    ),
    child: SizedBox(
      height: 150,
      width: double.infinity,
      child: CustomPaint(painter: _ArcPainter(score)),
    ),
  );
}

class _ArcPainter extends CustomPainter {
  _ArcPainter(this.score);
  final double? score;
  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width * 1.1,
        center = Offset(size.width / 2, radius + 15),
        sweep = 2 * math.asin((size.width / 2) / radius),
        start = -math.pi / 2 - sweep / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(
      rect,
      start,
      sweep,
      false,
      Paint()
        ..color = AppVitalityStyle.line
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
    final count = score?.clamp(0, 100).toDouble();
    if (count != null) {
      canvas.drawArc(
        rect,
        start,
        sweep * count / 100,
        false,
        Paint()
          ..shader = const LinearGradient(
            colors: [AppVitalityStyle.arcStart, AppVitalityStyle.arcEnd],
          ).createShader(rect)
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke,
      );
      final angle = start + sweep * count / 100;
      final p = center + Offset(math.cos(angle), math.sin(angle)) * radius;
      canvas.drawCircle(
        p,
        13,
        Paint()..color = AppVitalityStyle.arcEnd.withValues(alpha: .13),
      );
      canvas.drawCircle(p, 6, Paint()..color = AppVitalityStyle.arcEnd);
    }
    for (var i = 0; i <= 50; i++) {
      final angle = start + sweep * i / 50;
      final a =
              center + Offset(math.cos(angle), math.sin(angle)) * (radius - 10),
          b =
              center +
              Offset(math.cos(angle), math.sin(angle)) *
                  (radius - (i % 10 == 0 ? 23 : 17));
      canvas.drawLine(
        a,
        b,
        Paint()
          ..color = AppVitalityStyle.secondary.withValues(
            alpha: i % 10 == 0 ? 0.6 : 0.22,
          ),
      );
      if (i % 10 == 0) {
        final tp = TextPainter(
          text: TextSpan(text: '${i * 2}', style: AppVitalityStyle.caption),
          textDirection: TextDirection.ltr,
        )..layout();
        final p =
            center + Offset(math.cos(angle), math.sin(angle)) * (radius - 38);
        tp.paint(canvas, p - Offset(tp.width / 2, 0));
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ArcPainter old) => old.score != score;
}
