import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat, NumberFormat;

import '../tokens/app_colors.dart';
import '../tokens/app_health_style.dart';
import '../tokens/app_typography.dart';

typedef AppHealthPoint = ({DateTime date, num? value});

/// Keeps both directions reachable after picking a date inside the visible
/// history. The server still controls how many days are available.
class AppHealthHistory {
  List<AppHealthPoint> _window = const [];

  List<AppHealthPoint> resolve(
    List<AppHealthPoint> fetched,
    DateTime selected,
  ) {
    if (fetched.isEmpty ||
        fetched.length != _window.length ||
        !_window.any((point) => DateUtils.isSameDay(point.date, selected))) {
      return _window = fetched;
    }
    final updates = {
      for (final point in fetched) DateUtils.dateOnly(point.date): point,
    };
    return _window = [
      for (final point in _window)
        updates[DateUtils.dateOnly(point.date)] ?? point,
    ];
  }
}

/// A centered cursor stays fixed while the dates and series scroll below it.
/// Null readings break the line. Bounds come from the same units as the data.
class AppHealthTrend extends StatefulWidget {
  const AppHealthTrend({
    required this.points,
    required this.selected,
    required this.minimum,
    required this.maximum,
    this.onSelected,
    this.low,
    this.high,
    this.rangeLabel,
    this.emptyLabel,
    this.unit = '',
    this.marker = AppColors.textPrimary,
    this.height = AppHealthStyle.trendHeight,
    this.connect = true,
    super.key,
  });
  final List<AppHealthPoint> points;
  final DateTime selected;
  final ValueChanged<DateTime>? onSelected;
  final num minimum, maximum;
  final num? low, high;
  final String? rangeLabel, emptyLabel;
  final String unit;
  final Color marker;
  final double height;
  final bool connect;

  @override
  State<AppHealthTrend> createState() => _AppHealthTrendState();
}

class _AppHealthTrendState extends State<AppHealthTrend> {
  static const _step = 32.0;
  late final ScrollController _scroll;
  late int _current;
  bool _gesture = false;

  int get _selected {
    final index = widget.points.lastIndexWhere(
      (point) => DateUtils.isSameDay(point.date, widget.selected),
    );
    return index < 0 ? math.max(0, widget.points.length - 1) : index;
  }

  @override
  void initState() {
    super.initState();
    _current = _selected;
    _scroll = ScrollController(initialScrollOffset: _current * _step)
      ..addListener(_readPosition);
  }

  @override
  void didUpdateWidget(AppHealthTrend oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (DateUtils.isSameDay(oldWidget.selected, widget.selected) &&
        oldWidget.points.length == widget.points.length) {
      return;
    }
    _gesture = false;
    _current = _selected;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _scroll.hasClients) _scroll.jumpTo(_selected * _step);
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _readPosition() {
    if (widget.points.isEmpty) return;
    final index = (_scroll.offset / _step).round().clamp(
      0,
      widget.points.length - 1,
    );
    if (index != _current) setState(() => _current = index);
  }

  void _commit(int index) {
    if (index == _selected) return;
    widget.onSelected?.call(widget.points[index].date);
  }

  @override
  Widget build(BuildContext context) {
    final points = widget.points;
    if (!points.any((point) => point.value?.isFinite == true)) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Text(widget.emptyLabel ?? '—', style: AppHealthStyle.small),
      );
    }
    final point = points[_current.clamp(0, points.length - 1)];
    final tag = Localizations.localeOf(context).toLanguageTag();
    final date = DateFormat.MMMd(tag);
    final number = NumberFormat.decimalPattern(tag);
    final readings = points
        .map((point) => point.value)
        .whereType<num>()
        .where((value) => value.isFinite);
    final lo = readings.fold<num>(widget.minimum, math.min);
    final hi = math.max(lo + 1, readings.fold<num>(widget.maximum, math.max));
    final top = 31.0, bottom = widget.height - 20;
    final value = point.value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '${date.format(point.date)}  ·  ${value == null ? '—' : '${number.format(value)} ${widget.unit}'.trim()}',
          style: AppHealthStyle.body,
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: widget.height,
          child: Row(
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, box) => Stack(
                    children: [
                      NotificationListener<ScrollNotification>(
                        onNotification: (notice) {
                          if (notice is ScrollStartNotification &&
                              notice.dragDetails != null) {
                            _gesture = true;
                          }
                          if (notice is ScrollEndNotification && _gesture) {
                            _gesture = false;
                            final index = _current;
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (!mounted ||
                                  !_scroll.hasClients ||
                                  index >= widget.points.length) {
                                return;
                              }
                              _scroll.jumpTo(index * _step);
                              _commit(index);
                            });
                          }
                          return false;
                        },
                        child: SingleChildScrollView(
                          controller: _scroll,
                          scrollDirection: Axis.horizontal,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTapUp: (d) {
                              final index =
                                  ((d.localPosition.dx - box.maxWidth / 2) /
                                          _step)
                                      .round()
                                      .clamp(0, points.length - 1);
                              _scroll.jumpTo(index * _step);
                              _commit(index);
                            },
                            child: CustomPaint(
                              size: Size(
                                box.maxWidth + (points.length - 1) * _step,
                                widget.height,
                              ),
                              painter: _TrendPainter(
                                points: points,
                                firstX: box.maxWidth / 2,
                                step: _step,
                                top: top,
                                bottom: bottom,
                                min: lo,
                                max: hi,
                                low: widget.low,
                                high: widget.high,
                                index: _current,
                                marker: widget.marker,
                                labels: [
                                  for (final p in points)
                                    DateFormat.d(tag).format(p.date),
                                ],
                                connect: widget.connect,
                              ),
                            ),
                          ),
                        ),
                      ),
                      IgnorePointer(
                        child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: top,
                              bottom: widget.height - bottom,
                            ),
                            child: const VerticalDivider(
                              width: 1,
                              thickness: 1,
                              color: Color(0x42FFFFFF),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 31,
                child: Stack(
                  children: [
                    for (var i = 0; i <= 5; i++)
                      Positioned(
                        right: 0,
                        top: top + (bottom - top) * i / 5 - 9,
                        child: Text(
                          number.format((hi - (hi - lo) * i / 5).round()),
                          style: AppHealthStyle.legend,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (widget.rangeLabel != null &&
            widget.low != null &&
            widget.high != null)
          Text(
            '${widget.rangeLabel} ${number.format(widget.low!)}–${number.format(widget.high!)}',
            style: AppHealthStyle.legend,
          ),
      ],
    );
  }
}

class _TrendPainter extends CustomPainter {
  const _TrendPainter({
    required this.points,
    required this.firstX,
    required this.step,
    required this.top,
    required this.bottom,
    required this.min,
    required this.max,
    required this.low,
    required this.high,
    required this.index,
    required this.marker,
    required this.labels,
    required this.connect,
  });
  final List<AppHealthPoint> points;
  final List<String> labels;
  final double firstX, step, top, bottom;
  final num min, max;
  final num? low, high;
  final int index;
  final Color marker;
  final bool connect;

  @override
  void paint(Canvas canvas, Size size) {
    double y(num value) =>
        bottom - ((value - min) / (max - min)).clamp(0, 1) * (bottom - top);
    final grid = Paint()..color = AppHealthStyle.divider;
    if (low != null &&
        high != null &&
        low!.isFinite &&
        high!.isFinite &&
        low! <= high!) {
      canvas.drawRect(
        Rect.fromLTRB(0, y(high!), size.width, y(low!)),
        Paint()..color = AppHealthStyle.surface,
      );
    }
    for (var i = 0; i <= 5; i++) {
      final yy = top + (bottom - top) * i / 5;
      canvas.drawLine(Offset(0, yy), Offset(size.width, yy), grid);
    }
    Offset? previous;
    final trace = Paint()
      ..color = AppColors.textPrimary
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < points.length; i++) {
      final x = firstX + i * step;
      final value = points[i].value;
      final text = TextPainter(
        text: TextSpan(
          text: labels[i],
          style: TextStyle(
            fontFamily: AppFontFamilies.urbanist,
            color: i == index ? AppColors.textPrimary : AppColors.textDim,
            fontSize: 11,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      text.paint(canvas, Offset(x - text.width / 2, 8));
      text.dispose();
      if (value == null || !value.isFinite) {
        previous = null;
        continue;
      }
      final current = Offset(x, y(value));
      if (connect && previous != null) {
        canvas.drawLine(previous, current, trace);
      }
      if (i == index || !connect || previous == null) {
        canvas.drawCircle(
          current,
          i == index ? 4.5 : 2,
          Paint()
            ..color = i == index || !connect ? marker : AppColors.textPrimary,
        );
      }
      previous = current;
    }
  }

  @override
  bool shouldRepaint(_TrendPainter old) =>
      old.points != points ||
      old.index != index ||
      old.firstX != firstX ||
      old.min != min ||
      old.max != max ||
      old.low != low ||
      old.high != high ||
      old.marker != marker ||
      old.connect != connect ||
      old.labels != labels ||
      old.top != top ||
      old.bottom != bottom;
}
