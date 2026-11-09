import 'package:flutter/material.dart';

import '../../design_system/tokens/app_colors.dart';
import '../../design_system/tokens/app_typography.dart';
import 'centered_tab_strip.dart';
import 'day_calendar.dart';
import '../../l10n/app_localizations_context.dart';

/// 全站共用的日期带：当前日固定在中央标记处，支持横向切换最近 30 天。
///
/// `day == 0` 表示今天，`day == 1` 表示昨天；点选已选中的日期打开日期选择器。
class DayStrip extends StatefulWidget {
  const DayStrip({
    required this.day,
    required this.onDayChanged,
    this.daysCount = 30,
    this.tone = DayStripTone.neutral,
    super.key,
  }) : assert(daysCount > 1),
       assert(day >= 0 && day < daysCount);

  final int day;
  final ValueChanged<int> onDayChanged;
  final int daysCount;
  final DayStripTone tone;

  @override
  State<DayStrip> createState() => _DayStripState();
}

class _DayStripState extends State<DayStrip> {
  @override
  Widget build(BuildContext context) {
    return CenteredTabStrip(
      itemCount: widget.daysCount,
      selectedIndex: widget.daysCount - 1 - widget.day,
      height: 46,
      onSelectedIndexChanged: (index) {
        widget.onDayChanged(widget.daysCount - 1 - index);
      },
      onItemTap: (index) => _selectDay(widget.daysCount - 1 - index),
      itemBuilder: (context, index, itemWidth) {
        final day = widget.daysCount - 1 - index;
        return _DayOption(
          key: ValueKey('day-strip-$day'),
          width: itemWidth,
          day: day,
          selected: day == widget.day,
        );
      },
    );
  }

  void _selectDay(int day) {
    if (day == widget.day) {
      _openCalendar();
      return;
    }
    widget.onDayChanged(day);
  }

  Future<void> _openCalendar() async {
    final pickedDay = await showDayCalendar(
      context: context,
      selectedDay: widget.day,
      daysCount: widget.daysCount,
      tone: widget.tone,
    );
    if (!mounted || pickedDay == null) return;
    widget.onDayChanged(pickedDay);
  }
}

class _DayOption extends StatelessWidget {
  const _DayOption({
    required this.width,
    required this.day,
    required this.selected,
    super.key,
  });

  final double width;
  final int day;
  final bool selected;

  String label(BuildContext context) {
    final strings = context.l10n;
    if (day == 0) return strings.today;
    if (day == 1) return strings.yesterday;
    final date = DateTime.now().subtract(Duration(days: day));
    final weekday = switch (date.weekday % 7) {
      0 => strings.calendarWeekdaySun,
      1 => strings.calendarWeekdayMon,
      2 => strings.calendarWeekdayTue,
      3 => strings.calendarWeekdayWed,
      4 => strings.calendarWeekdayThu,
      5 => strings.calendarWeekdayFri,
      _ => strings.calendarWeekdaySat,
    };
    if (strings.localeName == 'en') {
      return '$weekday, ${_monthsEn[date.month - 1]} ${date.day}';
    }
    return '$weekday, ${date.day} de ${_monthsPt[date.month - 1]}';
  }

  static const _monthsPt = [
    'jan',
    'fev',
    'mar',
    'abr',
    'mai',
    'jun',
    'jul',
    'ago',
    'set',
    'out',
    'nov',
    'dez',
  ];
  static const _monthsEn = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 14),
        child: Center(
          child: Text(
            label(context),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.body.copyWith(
              fontSize: 15,
              color: selected ? AppColors.textPrimary : const Color(0x73F4F5F7),
            ),
          ),
        ),
      ),
    );
  }
}
