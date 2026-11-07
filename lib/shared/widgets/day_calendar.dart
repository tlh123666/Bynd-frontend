import 'dart:ui';

import 'package:flutter/material.dart';

import '../../design_system/tokens/app_colors.dart';
import '../../design_system/tokens/app_dimensions.dart';
import '../../design_system/tokens/app_typography.dart';

/// 日期带上方日历的配色；活动页使用原型中的暖色顶部光晕。
enum DayStripTone { neutral, ember }

/// 显示原型风格的月历，返回所选日期距离今天的天数。
Future<int?> showDayCalendar({
  required BuildContext context,
  required int selectedDay,
  required int daysCount,
  required DayStripTone tone,
}) {
  return showGeneralDialog<int>(
    context: context,
    barrierDismissible: false,
    barrierLabel: 'Calendário de dias',
    barrierColor: Colors.transparent,
    transitionDuration: Duration.zero,
    pageBuilder: (context, _, _) => _DayCalendarOverlay(
      selectedDay: selectedDay,
      daysCount: daysCount,
      tone: tone,
    ),
  );
}

class _DayCalendarOverlay extends StatefulWidget {
  const _DayCalendarOverlay({
    required this.selectedDay,
    required this.daysCount,
    required this.tone,
  });

  final int selectedDay;
  final int daysCount;
  final DayStripTone tone;

  @override
  State<_DayCalendarOverlay> createState() => _DayCalendarOverlayState();
}

class _DayCalendarOverlayState extends State<_DayCalendarOverlay>
    with SingleTickerProviderStateMixin {
  static const _monthNames = [
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro',
  ];
  static const _weekdays = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];

  late final DateTime _today = DateUtils.dateOnly(DateTime.now());
  late DateTime _month = _monthForDay(widget.selectedDay);
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
    reverseDuration: const Duration(milliseconds: 380),
  );
  bool _isClosing = false;

  DateTime get _firstAvailableDay =>
      _today.subtract(Duration(days: widget.daysCount - 1));

  DateTime _monthForDay(int day) {
    final selected = _today.subtract(Duration(days: day));
    return DateTime(selected.year, selected.month);
  }

  @override
  void initState() {
    super.initState();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final safeAreaTop = MediaQuery.paddingOf(context).top;
    // 原型 CSS 在设备未提供安全区变量时使用 47px 作为顶部回退值。
    final topInset = safeAreaTop > 0 ? safeAreaTop : 47.0;
    final fade = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    final slide = CurvedAnimation(
      parent: _controller,
      curve: const Cubic(.32, .72, 0, 1),
    );

    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          Positioned.fill(
            child: FadeTransition(
              opacity: fade,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: widget.tone == DayStripTone.ember
                          ? const [
                              Color(0xF51A1614),
                              Color(0xF5141211),
                              Color(0xF5100F0F),
                            ]
                          : const [
                              Color(0xF5141C26),
                              Color(0xE60C0F14),
                              Color(0xDB080A0E),
                            ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, -1.05),
                end: Offset.zero,
              ).animate(slide),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _CalendarBackdrop(
                    key: const ValueKey('day-calendar-background'),
                    tone: widget.tone,
                  ),
                  Positioned(
                    top: topInset + 80,
                    left: 24,
                    right: 24,
                    bottom: 30,
                    child: SingleChildScrollView(
                      child: _CalendarContent(
                        month: _month,
                        today: _today,
                        firstAvailableDay: _firstAvailableDay,
                        selectedDay: widget.selectedDay,
                        monthNames: _monthNames,
                        weekdays: _weekdays,
                        canGoBack: _month.isAfter(
                          DateTime(
                            _firstAvailableDay.year,
                            _firstAvailableDay.month,
                          ),
                        ),
                        canGoForward: _month.isBefore(
                          DateTime(_today.year, _today.month),
                        ),
                        onPreviousMonth: () => setState(
                          () =>
                              _month = DateTime(_month.year, _month.month - 1),
                        ),
                        onNextMonth: () => setState(
                          () =>
                              _month = DateTime(_month.year, _month.month + 1),
                        ),
                        onSelectDay: (day) => _close(day),
                      ),
                    ),
                  ),
                  Positioned(
                    top: topInset + 12,
                    left: 10,
                    child: IconButton(
                      tooltip: 'Fechar calendário',
                      onPressed: () => _close(null),
                      icon: const Icon(Icons.close, size: 23),
                      color: AppColors.textPrimary,
                      constraints: const BoxConstraints.tightFor(
                        width: 44,
                        height: 44,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _close(int? day) async {
    if (_isClosing) return;
    _isClosing = true;
    await _controller.reverse();
    if (mounted) Navigator.of(context).pop(day);
  }
}

class _CalendarBackdrop extends StatelessWidget {
  const _CalendarBackdrop({required this.tone, super.key});

  final DayStripTone tone;

  @override
  Widget build(BuildContext context) {
    final isEmber = tone == DayStripTone.ember;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: isEmber ? const Color(0xFF141211) : AppColors.background,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isEmber
              ? const [
                  Color(0xBF5C3A28),
                  Color(0x7342281C),
                  Color(0x331A1614),
                  Colors.transparent,
                ]
              : const [
                  Color(0x332C3A4E),
                  Color(0x1414181D),
                  Colors.transparent,
                ],
          stops: isEmber ? const [0, .16, .30, .42] : const [0, .2, .42],
        ),
      ),
    );
  }
}

class _CalendarContent extends StatelessWidget {
  const _CalendarContent({
    required this.month,
    required this.today,
    required this.firstAvailableDay,
    required this.selectedDay,
    required this.monthNames,
    required this.weekdays,
    required this.canGoBack,
    required this.canGoForward,
    required this.onPreviousMonth,
    required this.onNextMonth,
    required this.onSelectDay,
  });

  final DateTime month;
  final DateTime today;
  final DateTime firstAvailableDay;
  final int selectedDay;
  final List<String> monthNames;
  final List<String> weekdays;
  final bool canGoBack;
  final bool canGoForward;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;
  final ValueChanged<int> onSelectDay;

  @override
  Widget build(BuildContext context) {
    final firstWeekdayOffset = (month.weekday + 6) % 7;
    final daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);
    final cellCount = firstWeekdayOffset + daysInMonth;
    final rowCount = (cellCount / 7).ceil();
    final firstAvailableIndex = firstAvailableDay.difference(today).inDays;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            _MonthButton(
              tooltip: 'Mês anterior',
              icon: Icons.chevron_left,
              enabled: canGoBack,
              onPressed: onPreviousMonth,
            ),
            Expanded(
              child: Text(
                '${monthNames[month.month - 1]} ${month.year}',
                textAlign: TextAlign.center,
                style: AppTypography.title.copyWith(
                  fontSize: 19,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            _MonthButton(
              tooltip: 'Próximo mês',
              icon: Icons.chevron_right,
              enabled: canGoForward,
              onPressed: onNextMonth,
            ),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            for (final weekday in weekdays)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    weekday.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: AppTypography.caption.copyWith(
                      color: const Color(0x80F4F5F7),
                      fontSize: 11,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
          ],
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            final cellWidth = (constraints.maxWidth - 24) / 7;
            final cellHeight = (52.0 * rowCount) + (4.0 * (rowCount - 1));
            return SizedBox(
              height: cellHeight,
              child: GridView.builder(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: rowCount * 7,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  childAspectRatio: cellWidth / 52,
                ),
                itemBuilder: (context, index) {
                  final dayNumber = index - firstWeekdayOffset + 1;
                  if (dayNumber < 1 || dayNumber > daysInMonth) {
                    return const SizedBox.shrink();
                  }
                  final date = DateTime(month.year, month.month, dayNumber);
                  final dayOffset = today.difference(date).inDays;
                  final isFuture = dayOffset < 0;
                  final isOutsideRange = dayOffset > -firstAvailableIndex;
                  final isSelected = dayOffset == selectedDay;
                  final enabled = !isFuture && !isOutsideRange;

                  // 恢复状态点依赖原型中的演示数据，接入真实数据前不绘制，避免误导。
                  return _CalendarDay(
                    key: ValueKey('day-calendar-date-$dayOffset'),
                    dayNumber: dayNumber,
                    selected: isSelected,
                    enabled: enabled,
                    onTap: enabled ? () => onSelectDay(dayOffset) : null,
                  );
                },
              ),
            );
          },
        ),
        const SizedBox(height: 20),
        const _RecoveryLegend(),
      ],
    );
  }
}

/// 图例只解释原型中的颜色名称，不表示某一天已有恢复数据。
class _RecoveryLegend extends StatelessWidget {
  const _RecoveryLegend();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 16,
      runSpacing: 6,
      children: const [
        _RecoveryLegendItem(label: 'recuperação boa', color: Color(0xFF86D4A3)),
        _RecoveryLegendItem(
          label: 'recuperação média',
          color: Color(0xFFECD27C),
        ),
        _RecoveryLegendItem(
          label: 'recuperação baixa',
          color: Color(0xFFEE9A94),
        ),
      ],
    );
  }
}

class _RecoveryLegendItem extends StatelessWidget {
  const _RecoveryLegendItem({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 2.4,
          decoration: BoxDecoration(
            color: color,
            borderRadius: AppRadii.pillBorder,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTypography.caption.copyWith(
            color: AppColors.textPrimary.withValues(alpha: .6),
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

class _MonthButton extends StatelessWidget {
  const _MonthButton({
    required this.tooltip,
    required this.icon,
    required this.enabled,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 40,
    height: 40,
    child: IconButton(
      tooltip: tooltip,
      onPressed: enabled ? onPressed : null,
      icon: Icon(icon, size: 23),
      color: AppColors.textPrimary,
      disabledColor: AppColors.textPrimary.withValues(alpha: .25),
      padding: EdgeInsets.zero,
    ),
  );
}

class _CalendarDay extends StatelessWidget {
  const _CalendarDay({
    required this.dayNumber,
    required this.selected,
    required this.enabled,
    required this.onTap,
    super.key,
  });

  final int dayNumber;
  final bool selected;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$dayNumber',
      selected: selected,
      button: enabled,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (selected)
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.textPrimary.withValues(alpha: .12),
                ),
              ),
            Align(
              alignment: const Alignment(0, -.15),
              child: Text(
                '$dayNumber',
                style: AppTypography.label.copyWith(
                  fontSize: 15,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  color: AppColors.textPrimary.withValues(
                    alpha: enabled ? 1 : .25,
                  ),
                ),
              ),
            ),
            if (selected)
              Positioned(
                bottom: 13,
                child: Container(
                  width: 12,
                  height: 2.4,
                  decoration: BoxDecoration(
                    color: AppColors.textPrimary,
                    borderRadius: AppRadii.pillBorder,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
