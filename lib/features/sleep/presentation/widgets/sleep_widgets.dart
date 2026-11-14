import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../design_system/design_system.dart';
import '../../domain/sleep_models.dart';
import '../sleep_copy.dart';

class SleepCard extends StatelessWidget {
  const SleepCard({
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(22),
    super.key,
  });
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets padding;
  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    child: Ink(
      decoration: const BoxDecoration(
        gradient: AppSleepStyle.card,
        borderRadius: AppSleepStyle.radius,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppSleepStyle.radius,
        child: Padding(padding: padding, child: child),
      ),
    ),
  );
}

class SleepLabel extends StatelessWidget {
  const SleepLabel(this.text, {this.chevron = false, super.key});
  final String text;
  final bool chevron;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(child: Text(text.toUpperCase(), style: AppSleepStyle.kicker)),
      if (chevron)
        const Icon(Icons.chevron_right, size: 20, color: AppColors.textMuted),
    ],
  );
}

class SleepExpandable extends StatefulWidget {
  const SleepExpandable(this.text, {super.key});
  final String text;
  @override
  State<SleepExpandable> createState() => _SleepExpandableState();
}

class _SleepExpandableState extends State<SleepExpandable> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        widget.text,
        style: AppSleepStyle.body,
        maxLines: _expanded ? null : 3,
        overflow: _expanded ? null : TextOverflow.fade,
      ),
      if (widget.text.length > 160)
        TextButton.icon(
          onPressed: () => setState(() => _expanded = !_expanded),
          iconAlignment: IconAlignment.end,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            textStyle: AppSleepStyle.body.copyWith(fontWeight: FontWeight.w500),
          ),
          label: Text(
            sleepText(
              context,
              _expanded ? 'Mostrar menos' : 'Mostrar mais',
              _expanded ? 'Show less' : 'Show more',
            ),
          ),
          icon: Icon(
            _expanded ? Icons.expand_less : Icons.expand_more,
            size: 18,
          ),
        ),
    ],
  );
}

class SleepPeriodPicker extends StatelessWidget {
  const SleepPeriodPicker({
    required this.period,
    required this.onChanged,
    this.day = true,
    super.key,
  });
  final SleepPeriod period;
  final ValueChanged<SleepPeriod> onChanged;
  final bool day;
  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      for (final p in SleepPeriod.values.reversed.where(
        (p) => day || p != SleepPeriod.day,
      ))
        Expanded(
          child: TextButton(
            key: ValueKey('sleep-period-${p.name}'),
            onPressed: () => onChanged(p),
            style: TextButton.styleFrom(
              foregroundColor: p == period
                  ? AppColors.textPrimary
                  : AppColors.textMuted,
              side: p == period
                  ? const BorderSide(color: AppColors.glassBorderStrong)
                  : BorderSide.none,
            ),
            child: Text(sleepPeriodTitle(context, p)),
          ),
        ),
    ],
  );
}

class SleepStageChart extends StatefulWidget {
  const SleepStageChart({
    required this.session,
    this.vitals = const {},
    this.compact = false,
    super.key,
  });
  final SleepSession session;
  final Map<String, dynamic> vitals;
  final bool compact;
  @override
  State<SleepStageChart> createState() => _SleepStageChartState();
}

class _SleepStageChartState extends State<SleepStageChart> {
  String? _stage;
  double? _position;
  @override
  Widget build(BuildContext context) {
    final session = widget.session, total = math.max(1, session.duration ?? 0);
    final stageAt = _position == null
        ? null
        : session.segments
              .where(
                (s) =>
                    s.offset <= _position! && s.offset + s.minutes > _position!,
              )
              .firstOrNull;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 16),
        if (session.segments.isEmpty)
          Padding(
            padding: const EdgeInsets.all(22),
            child: Text(
              sleepText(
                context,
                'As fases ainda não foram sincronizadas.',
                'Sleep stages have not synchronized yet.',
              ),
              style: AppSleepStyle.caption,
            ),
          )
        else
          LayoutBuilder(
            builder: (context, box) => Semantics(
              label: sleepText(
                context,
                'Gráfico de fases do sono. Toque para explorar.',
                'Sleep stage chart. Touch to explore.',
              ),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapDown: (e) => setState(
                  () => _position = (e.localPosition.dx / box.maxWidth * total)
                      .clamp(0, total.toDouble()),
                ),
                onHorizontalDragUpdate: (e) => setState(
                  () => _position = (e.localPosition.dx / box.maxWidth * total)
                      .clamp(0, total.toDouble()),
                ),
                child: CustomPaint(
                  size: Size(box.maxWidth, 160),
                  painter: _SleepTimelinePainter(
                    session.segments,
                    total,
                    sleepMaps(widget.vitals['points']),
                    _stage,
                    _position,
                    widget.compact,
                  ),
                ),
              ),
            ),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_clock(session.start), style: AppSleepStyle.caption),
            Text(_clock(session.end), style: AppSleepStyle.caption),
          ],
        ),
        if (stageAt != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              '${_clock(session.start?.add(Duration(minutes: _position!.round())))} · ${_stageName(context, stageAt.stage)}',
              style: AppSleepStyle.caption,
            ),
          ),
        if (!widget.compact)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final stage in ['awake', 'light', 'deep', 'rem'])
                  ChoiceChip(
                    label: Text(
                      '${_stageName(context, stage)} · ${sleepDuration(session.segments.where((s) => s.stage == stage).fold<int>(0, (n, s) => n + s.minutes))}',
                      style: AppSleepStyle.caption.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    selected: _stage == stage,
                    onSelected: (on) =>
                        setState(() => _stage = on ? stage : null),
                    showCheckmark: false,
                    selectedColor: AppSleepStyle.stages[stage]!.withValues(
                      alpha: .2,
                    ),
                    backgroundColor: Colors.transparent,
                    side: const BorderSide(color: AppColors.glassBorder),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  String _clock(DateTime? t) =>
      t == null ? '—' : sleepClock(t.hour * 60 + t.minute);
  String _stageName(BuildContext c, String stage) =>
      sleepMetricTitle(c, switch (stage) {
        'awake' => SleepMetric.awake,
        'light' => SleepMetric.light,
        'deep' => SleepMetric.deep,
        _ => SleepMetric.rem,
      });
}

class _SleepTimelinePainter extends CustomPainter {
  _SleepTimelinePainter(
    this.segments,
    this.total,
    this.points,
    this.stage,
    this.position,
    this.compact,
  );
  final List<SleepStage> segments;
  final int total;
  final List<Map<String, dynamic>> points;
  final String? stage;
  final double? position;
  final bool compact;
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint(), plotHeight = size.height - 12;
    for (var i = 0; i < 5; i++) {
      if (compact && i != 0 && i != 4) continue;
      p
        ..color = AppColors.glassBorder
        ..strokeWidth = .5;
      canvas.drawLine(
        Offset(size.width * i / 4, 0),
        Offset(size.width * i / 4, plotHeight),
        p,
      );
    }
    final phases = {'awake': .08, 'rem': .32, 'light': .56, 'deep': .82};
    final path = Path();
    for (final s in segments) {
      if (compact && points.isNotEmpty) continue;
      final x = (s.offset / total * size.width)
              .clamp(0.0, size.width)
              .toDouble(),
          w = (s.minutes / total * size.width)
              .clamp(0.0, size.width - x)
              .toDouble();
      if (w <= 0) continue;
      p.color = (AppSleepStyle.stages[s.stage] ?? AppColors.textMuted)
          .withValues(
            alpha: stage == null
                ? .08
                : stage == s.stage
                ? .38
                : .03,
          );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, plotHeight * (phases[s.stage] ?? .5) - 3, w, 6),
          const Radius.circular(2),
        ),
        p,
      );
      final y = plotHeight * (phases[s.stage] ?? .5);
      path.moveTo(x, y);
      path.lineTo(x + w, y);
    }
    p
      ..color = AppColors.textSecondary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;
    canvas.drawPath(path, p);
    if (points.isNotEmpty) {
      final valid = points
          .where((v) => v['offsetMinutes'] is num && v['bpm'] is num)
          .toList();
      if (valid.isNotEmpty) {
        final values = valid.map((v) => (v['bpm'] as num).toDouble());
        final lo = values.reduce(math.min) - 5,
            hi = values.reduce(math.max) + 5;
        final line = Path();
        bool begun = false;
        num? last;
        for (final v in valid) {
          final offset = v['offsetMinutes'] as num;
          if (offset < 0 || offset > total) continue;
          final point = Offset(
            offset / total * size.width,
            (1 - ((v['bpm'] as num) - lo) / (hi - lo)) * plotHeight,
          );
          if (!begun || (last != null && offset - last > 15)) {
            line.moveTo(point.dx, point.dy);
          } else {
            line.lineTo(point.dx, point.dy);
          }
          begun = true;
          last = offset;
        }
        p
          ..color = AppSleepStyle.pulse
          ..strokeWidth = 1.5;
        canvas.drawPath(line, p);
      }
    }
    if (position != null) {
      p
        ..color = AppColors.textPrimary
        ..strokeWidth = 1;
      final x = position! / total * size.width;
      canvas.drawLine(Offset(x, 0), Offset(x, plotHeight), p);
    }
  }

  @override
  bool shouldRepaint(covariant _SleepTimelinePainter old) => true;
}

class SleepHistoryChart extends StatelessWidget {
  const SleepHistoryChart({
    required this.trend,
    required this.field,
    this.unit = '',
    this.onDay,
    super.key,
  });
  final SleepTrend trend;
  final String field, unit;
  final ValueChanged<DateTime>? onDay;
  @override
  Widget build(BuildContext context) {
    final values = trend.days
        .where((d) => d['hasData'] == true)
        .map((d) => d[field])
        .whereType<num>();
    if (trend.locked) {
      return Padding(
        padding: const EdgeInsets.all(22),
        child: Text(
          sleepText(
            context,
            'Histórico detalhado disponível no Premium.',
            'Detailed history is available with Premium.',
          ),
          style: AppSleepStyle.body,
        ),
      );
    }
    if (values.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(22),
        child: Text(
          sleepText(
            context,
            'Ainda não há dados neste período.',
            'No measurements in this period yet.',
          ),
          style: AppSleepStyle.caption,
        ),
      );
    }
    final maxValue = math.max(1.0, values.reduce(math.max).toDouble());
    return Column(
      children: [
        SizedBox(
          height: 150,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (final d in trend.days)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Semantics(
                      label:
                          '${d['statDate']}: ${d['hasData'] == true ? d[field] ?? '—' : '—'} $unit',
                      button: onDay != null,
                      child: InkWell(
                        onTap: onDay == null
                            ? null
                            : () => onDay!(DateTime.parse('${d['statDate']}')),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: d['hasData'] == true && d[field] is num
                                ? math.max(
                                    3,
                                    (d[field] as num) / maxValue * 140,
                                  )
                                : 3,
                            decoration: BoxDecoration(
                              color: d['hasData'] == true && d[field] is num
                                  ? AppSleepStyle.pulse
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
        if (trend.days.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    '${trend.days.first['statDate']}',
                    style: AppSleepStyle.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    '${trend.days.last['statDate']}',
                    style: AppSleepStyle.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class SleepClockPainter extends CustomPainter {
  const SleepClockPainter(this.bedtime, this.wake);
  final int bedtime, wake;
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * .94),
        radius = math.min(size.width * .42, size.height * .82);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final rect = Rect.fromCircle(center: center, radius: radius);
    paint
      ..color = AppColors.glassBorder
      ..strokeWidth = 12;
    canvas.drawArc(rect, math.pi, math.pi, false, paint);
    paint
      ..shader = const LinearGradient(
        colors: [Color(0xFF47658F), Color(0xFFADC5E3)],
      ).createShader(rect)
      ..strokeWidth = 12;
    canvas.drawArc(rect, math.pi + .12, math.pi - .24, false, paint);
    paint.shader = null;
    for (var i = 0; i <= 24; i++) {
      final a = math.pi + math.pi * i / 24;
      final r = radius + 18;
      final b = Offset(
        center.dx + math.cos(a) * r,
        center.dy + math.sin(a) * r,
      );
      final e = Offset(
        center.dx + math.cos(a) * (r + (i % 3 == 0 ? 10 : 5)),
        center.dy + math.sin(a) * (r + (i % 3 == 0 ? 10 : 5)),
      );
      paint
        ..color = AppColors.textMuted
        ..strokeWidth = i % 3 == 0 ? 1 : .5;
      canvas.drawLine(b, e, paint);
    }
    final duration = (wake - bedtime + 1440) % 1440;
    final text = TextPainter(
      text: TextSpan(
        text: sleepDuration(duration),
        style: AppSleepStyle.value.copyWith(fontSize: 26),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    text.paint(
      canvas,
      Offset(center.dx - text.width / 2, center.dy - text.height - 14),
    );
  }

  @override
  bool shouldRepaint(covariant SleepClockPainter old) =>
      old.bedtime != bedtime || old.wake != wake;
}
