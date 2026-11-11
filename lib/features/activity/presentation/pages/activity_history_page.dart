import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../design_system/design_system.dart';
import '../../../../l10n/app_localizations_context.dart';
import '../../../diary/presentation/diary_page.dart';
import '../activity_selection_flow.dart';
import '../models/demo_history_activity.dart';
import '../widgets/activity_detail_sheet.dart';

/// 活动历史页面。当前数据仅用于演示页面，尚未连接历史记录接口。
class ActivityHistoryPage extends StatefulWidget {
  const ActivityHistoryPage({super.key});

  @override
  State<ActivityHistoryPage> createState() => _ActivityHistoryPageState();
}

class _ActivityHistoryPageState extends State<ActivityHistoryPage> {
  final _moreKey = GlobalKey();
  final _activities = List<DemoHistoryActivity>.of(
    DemoHistoryActivity.examples,
  );
  Rect? _origin;
  bool _menuOpen = false;

  void _openMenu() {
    final box = _moreKey.currentContext?.findRenderObject();
    if (box is! RenderBox || !box.hasSize) return;
    setState(() {
      _origin = box.localToGlobal(Offset.zero) & box.size;
      _menuOpen = true;
    });
  }

  void _onQuickAction(AppQuickAction action) {
    setState(() => _menuOpen = false);
    if (action == AppQuickAction.startActivity) {
      openActivitySelection(context);
    } else if (action == AppQuickAction.dayReview ||
        action == AppQuickAction.meal) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => DiaryPage(
            openRecord: true,
            initialTracker: action == AppQuickAction.meal ? 'almoco' : null,
          ),
        ),
      );
    } else {
      AppNotice.show(
        context,
        kind: AppNoticeKind.info,
        message: context.l10n.comingSoon(
          action.localizedLabel(context.l10n).replaceAll('\n', ' '),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    return Stack(
      children: [
        Scaffold(
          extendBody: true,
          backgroundColor: const Color(0xff100e0d),
          body: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xff39251d),
                  Color(0xff151110),
                  Color(0xff100e0d),
                ],
                stops: [0, .35, 1],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  AppPageHeader(
                    title: Text(strings.history, style: AppTypography.title),
                    leading: Semantics(
                      label: strings.back,
                      button: true,
                      child: IconButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        icon: const AppSvgIcon(AppSvgAssets.back, size: 21),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(21, 26, 21, 125),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            strings.historyNormalStatus,
                            style: AppTypography.kicker.copyWith(
                              color: AppColors.sage,
                              fontSize: 11,
                              letterSpacing: 1.54,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                '50',
                                style: AppTypography.hero.copyWith(
                                  fontSize: 48,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                strings.historyAverage,
                                style: AppTypography.caption.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Container(
                                width: 12,
                                height: 8,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  border: Border.all(
                                    color: AppColors.glassBorderStrong,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                strings.historyNormalRange,
                                style: AppTypography.caption.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            strings.activityDemoLabel,
                            style: AppTypography.caption.copyWith(
                              color: AppColors.textMuted,
                            ),
                          ),
                          const SizedBox(height: 24),
                          const _HistoryChart(),
                          const SizedBox(height: 48),
                          Row(
                            children: [
                              const Icon(
                                Icons.history,
                                size: 19,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(width: 9),
                              Expanded(
                                child: Text(
                                  strings.activities,
                                  style: AppTypography.section,
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  strings.historyDemoSummary(
                                    _activities.length,
                                    _activities.fold<int>(
                                      0,
                                      (sum, item) => sum + item.duration,
                                    ),
                                  ),
                                  textAlign: TextAlign.end,
                                  style: AppTypography.caption.copyWith(
                                    color: AppColors.textMuted,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          for (var i = 0; i < _activities.length; i++) ...[
                            _HistoryDemoRow(
                              activity: _activities[i],
                              onChanged: (updated) =>
                                  setState(() => _activities[i] = updated),
                              onDeleted: () =>
                                  setState(() => _activities.removeAt(i)),
                            ),
                            if (i < _activities.length - 1)
                              const Divider(
                                height: 1,
                                color: AppColors.divider,
                              ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: AppBottomNav(
            selectedIndex: null,
            moreButtonKey: _moreKey,
            moreOpen: _menuOpen,
            onDestinationSelected: (index) {
              if (index == 0) {
                Navigator.of(context).pop(index);
              } else {
                AppNotice.show(
                  context,
                  kind: AppNoticeKind.info,
                  message: strings.sectionComingSoon,
                );
              }
            },
            onMorePressed: _openMenu,
          ),
        ),
        if (_menuOpen)
          Positioned.fill(
            child: AppQuickActionsOverlay(
              origin: _origin!,
              onClose: () => setState(() => _menuOpen = false),
              onActionSelected: _onQuickAction,
            ),
          ),
      ],
    );
  }
}

class _HistoryDemoRow extends StatelessWidget {
  const _HistoryDemoRow({
    required this.activity,
    required this.onChanged,
    required this.onDeleted,
  });
  final DemoHistoryActivity activity;
  final ValueChanged<DemoHistoryActivity> onChanged;
  final VoidCallback onDeleted;

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final meta = AppTypography.caption.copyWith(
      color: AppColors.textMuted,
      fontSize: 13,
    );
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => ActivityDetailSheet.show(
          context,
          activity,
          onChanged: onChanged,
          onDeleted: onDeleted,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Icon(
                  activity.kind == DemoActivityKind.sauna
                      ? Icons.local_fire_department_outlined
                      : Icons.fitness_center,
                  size: 18,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.kind == DemoActivityKind.sauna
                          ? 'Sauna'
                          : s.activityDemoStrength,
                      style: AppTypography.label.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 7,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          '${(activity.isToday ? s.today : s.yesterday).toLowerCase()} ${activity.start}',
                          style: meta,
                        ),
                        const Icon(
                          Icons.schedule,
                          size: 13,
                          color: AppColors.textMuted,
                        ),
                        Text('${activity.duration} min', style: meta),
                        const Icon(
                          Icons.favorite_border,
                          size: 13,
                          color: AppColors.textMuted,
                        ),
                        Text('${activity.averageHeartRate} bpm', style: meta),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text.rich(
                TextSpan(
                  text: '${activity.load} ',
                  style: AppTypography.label.copyWith(fontSize: 16),
                  children: [
                    TextSpan(text: s.activityDemoLoadLabel, style: meta),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 图表使用固定样本点；拖动只选择样本点，不执行健康指标计算。
class _HistoryChart extends StatefulWidget {
  const _HistoryChart();
  @override
  State<_HistoryChart> createState() => _HistoryChartState();
}

class _HistoryChartState extends State<_HistoryChart>
    with SingleTickerProviderStateMixin {
  static const _values = <double>[
    17,
    19,
    32,
    45,
    58,
    74,
    75,
    74,
    74,
    73,
    74,
    76,
    74,
    75,
    73,
    71,
    66,
  ];
  static const _pointSpacing = 10.4;
  double _position = (_values.length - 1).toDouble();
  int get _selected => _position.round();
  late final AnimationController _snapController;
  Animation<double>? _snapAnimation;

  @override
  void initState() {
    super.initState();
    _snapController =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 180),
        )..addListener(() {
          if (_snapAnimation != null) {
            setState(() => _position = _snapAnimation!.value);
          }
        });
  }

  @override
  void dispose() {
    _snapController.dispose();
    super.dispose();
  }

  void _snapToPoint() {
    final target = _position.roundToDouble();
    if (MediaQuery.disableAnimationsOf(context)) {
      setState(() => _position = target);
      return;
    }
    _snapAnimation = Tween<double>(
      begin: _position,
      end: target,
    ).animate(CurvedAnimation(parent: _snapController, curve: Curves.easeOut));
    _snapController.forward(from: 0);
  }

  void _select(double x, double width) {
    if (width <= 0) return;
    _snapController.stop();
    setState(
      () => _position = (_position + (x - width / 2) / _pointSpacing).clamp(
        0.0,
        (_values.length - 1).toDouble(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return Semantics(
          key: const ValueKey('activity-history-chart'),
          label: '${s.historySevenDayAverage}: ${_values[_selected].round()}',
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapUp: (details) {
              _select(details.localPosition.dx, width);
              _snapToPoint();
            },
            onHorizontalDragStart: (_) => _snapController.stop(),
            onHorizontalDragUpdate: (details) => setState(() {
              // 游标固定在中央，拖动时曲线从游标下方经过。
              _position = (_position - details.delta.dx / _pointSpacing).clamp(
                0.0,
                (_values.length - 1).toDouble(),
              );
            }),
            onHorizontalDragEnd: (_) => _snapToPoint(),
            onHorizontalDragCancel: _snapToPoint,
            child: SizedBox(
              height: 310,
              width: double.infinity,
              child: CustomPaint(
                painter: _HistoryChartPainter(
                  values: _values,
                  selected: _selected,
                  position: _position,
                  month: s.historyDemoMonth,
                  today: s.today,
                  average: s.historySevenDayAverage,
                  textDirection: Directionality.of(context),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _HistoryChartPainter extends CustomPainter {
  const _HistoryChartPainter({
    required this.values,
    required this.selected,
    required this.position,
    required this.month,
    required this.today,
    required this.average,
    required this.textDirection,
  });
  final List<double> values;
  final int selected;
  final double position;
  final String month, today, average;
  final TextDirection textDirection;

  @override
  void paint(Canvas canvas, Size size) {
    final chart = Rect.fromLTRB(0, 26, size.width - 1, size.height - 4);
    final line = Paint()
      ..color = Colors.white.withValues(alpha: .08)
      ..strokeWidth = 1;
    for (var i = 0; i <= 5; i++) {
      final y = chart.bottom - chart.height * i / 5;
      canvas.drawLine(Offset(chart.left, y), Offset(chart.right, y), line);
      _text(
        canvas,
        '${i * 20}',
        Offset(chart.right - 22, y - 13),
        10,
        AppColors.textMuted,
      );
    }
    for (var i = 0; i < 4; i++) {
      final x = chart.left + chart.width * i / 5;
      canvas.drawLine(Offset(x, chart.top), Offset(x, chart.bottom), line);
    }
    _text(canvas, month, Offset(chart.width * .18, 2), 11, AppColors.textMuted);
    double xAt(int i) => chart.center.dx + (i - position) * 10.4;
    double yAt(double v) => chart.bottom - chart.height * v / 100;
    canvas.save();
    canvas.clipRect(
      Rect.fromLTRB(chart.left, chart.top, chart.right - 28, chart.bottom),
    );
    canvas.drawRect(
      Rect.fromLTRB(xAt(0), yAt(58), xAt(values.length - 1) + 5, yAt(35)),
      Paint()..color = Colors.white.withValues(alpha: .055),
    );
    final path = Path()..moveTo(xAt(0), yAt(values[0]));
    for (var i = 1; i < values.length; i++) {
      path.lineTo(xAt(i), yAt(values[i]));
    }
    final fill = Path.from(path)
      ..lineTo(xAt(values.length - 1), chart.bottom)
      ..lineTo(xAt(0), chart.bottom)
      ..close();
    canvas.drawPath(
      fill,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x40ffffff), Color(0x00ffffff)],
        ).createShader(chart),
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.textPrimary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8,
    );
    canvas.restore();
    final lower = position.floor();
    final upper = math.min(lower + 1, values.length - 1);
    final value =
        values[lower] + (values[upper] - values[lower]) * (position - lower);
    final x = chart.center.dx, y = yAt(value);
    canvas.drawLine(
      Offset(x, chart.top + 30),
      Offset(x, chart.bottom),
      Paint()
        ..color = AppColors.textSecondary
        ..strokeWidth = 1,
    );
    canvas.drawCircle(
      Offset(x, y),
      5,
      Paint()..color = const Color(0xffecd27c),
    );
    canvas.drawCircle(
      Offset(x, y),
      5,
      Paint()
        ..color = AppColors.textPrimary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
    final labelX = math.min(x + 9, chart.right - 125);
    _text(
      canvas,
      selected == values.length - 1 ? today : '$month ${selected + 1}',
      Offset(labelX, chart.top + 32),
      13,
      AppColors.textSecondary,
    );
    _text(
      canvas,
      '$average ${values[selected].round()}',
      Offset(labelX, chart.top + 49),
      12,
      AppColors.textSecondary,
    );
  }

  void _text(
    Canvas canvas,
    String text,
    Offset offset,
    double size,
    Color color,
  ) {
    final p = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontFamily: AppFontFamilies.geist,
          fontSize: size,
          color: color,
        ),
      ),
      textDirection: textDirection,
      maxLines: 1,
    )..layout(maxWidth: 160);
    p.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant _HistoryChartPainter old) =>
      old.selected != selected ||
      old.position != position ||
      old.today != today ||
      old.average != average ||
      old.month != month ||
      old.textDirection != textDirection;
}
