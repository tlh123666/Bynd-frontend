import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../../design_system/design_system.dart';
import '../../../../l10n/app_localizations_context.dart';
import '../../../../shared/widgets/day_calendar.dart';
import '../../domain/models/activity_type.dart';
import '../../domain/models/activity_type_catalog.dart';
import '../localization/activity_type_localizations.dart';
import 'activity_selection_sheet.dart';
import 'activity_detail_sheet.dart';
import '../models/demo_history_activity.dart';
import 'activity_type_icon.dart';

/// 手动登记的演示面板；完成后打开不写入存储的活动详情预览。
class ActivityRegistrationSheet extends StatefulWidget {
  const ActivityRegistrationSheet({required this.initialDay, super.key});
  final int initialDay;

  static Future<void> show(BuildContext context, {int initialDay = 0}) async {
    final preview = await AppFrostedModalSheet.show<DemoHistoryActivity>(
      context,
      topInset: math.max(MediaQuery.viewPaddingOf(context).top, 20) + 34,
      showHandle: false,
      barrierColor: AppColors.contentSheetVeil,
      builder: (_) => ActivityRegistrationSheet(initialDay: initialDay),
    );
    // 等待登记弹窗退出后再打开详情，避免两层蒙罩叠加。
    if (context.mounted && preview != null) {
      await ActivityDetailSheet.show(context, preview);
    }
  }

  @override
  State<ActivityRegistrationSheet> createState() =>
      _ActivityRegistrationSheetState();
}

class _ActivityRegistrationSheetState extends State<ActivityRegistrationSheet> {
  late int day = widget.initialDay.clamp(0, 29);
  ActivityType type = ActivityTypeCatalog.findById('funcional')!;
  int duration = 45;
  int effort = 6;
  int? startOverride;

  // 原型公式仅用于演示，不表示已接入设备数据或经过验证的健康算法。
  int get load => (100 * (1 - math.exp(-effort * duration / 360))).round();
  int get start {
    if (startOverride case final value?) return value;
    if (day != 0) return 7 * 60 + 15;
    final now = DateTime.now();
    return math.max(0, now.hour * 60 + now.minute - duration);
  }

  bool get invalid {
    final now = DateTime.now();
    return start + duration > 24 * 60 ||
        (day == 0 && start + duration > now.hour * 60 + now.minute);
  }

  String get startText =>
      '${(start ~/ 60).toString().padLeft(2, '0')}:${(start % 60).toString().padLeft(2, '0')}';

  Future<void> chooseType() async {
    final selected = await ActivitySelectionSheet.show(
      context,
      title: context.l10n.registrationModality,
    );
    if (mounted && selected != null) setState(() => type = selected);
  }

  Future<void> chooseDay() async {
    final selected = await showDayCalendar(
      context: context,
      selectedDay: day,
      daysCount: 30,
      tone: DayStripTone.ember,
    );
    if (mounted && selected != null) setState(() => day = selected);
  }

  Future<void> chooseNumber({required bool isTime}) async {
    final result = await AppFrostedModalSheet.show<int>(
      context,
      builder: (_) => _NumberPickerSheet(
        isTime: isTime,
        initialValue: isTime ? start : duration,
      ),
    );
    if (!mounted || result == null) return;
    setState(() {
      if (isTime) {
        startOverride = result;
      } else {
        duration = result;
      }
    });
  }

  String dayLabel(int offset) {
    final s = context.l10n;
    if (offset == 0) return s.today;
    if (offset == 1) return s.yesterday;
    final now = DateTime.now();
    final date = DateTime(now.year, now.month, now.day - offset);
    final locale = Localizations.localeOf(context).toString();
    final value = DateFormat.yMMMd(locale).format(date);
    return value;
  }

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final screen = MediaQuery.sizeOf(context);
    final top = math.max(MediaQuery.viewPaddingOf(context).top, 20) + 34;
    final height = math.max(
      0.0,
      screen.height - top - MediaQuery.viewPaddingOf(context).bottom,
    );
    return SizedBox(
      height: height,
      child: Column(
        children: [
          SizedBox(
            height: 62,
            child: Stack(
              children: [
                Positioned(
                  top: 8,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      width: 38,
                      height: 5,
                      decoration: BoxDecoration(
                        color: const Color(0x47ffffff),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  top: 12,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 56,
                        child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close, color: Colors.white),
                          tooltip: s.close,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          s.registrationTitle,
                          textAlign: TextAlign.center,
                          style: AppTypography.title.copyWith(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 56),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '$load',
                      style: AppTypography.title.copyWith(
                        fontSize: 48,
                        height: 1,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      (load < 35
                              ? s.registrationLight
                              : load < 55
                              ? s.registrationModerate
                              : s.registrationHigh)
                          .toUpperCase(),
                      style: AppTypography.caption.copyWith(
                        color: const Color(0xff86d4a3),
                        letterSpacing: 1.4,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${s.registrationEstimated} · ${activityTypeLocalizedName(type, s).toLowerCase()} · $duration min',
                  style: AppTypography.caption.copyWith(
                    fontSize: 13,
                    color: AppColors.textHalf,
                  ),
                ),
                const SizedBox(height: 42),
                _label(s.registrationModality),
                InkWell(
                  onTap: chooseType,
                  child: Container(
                    height: 72,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(0x14ffffff)),
                      ),
                    ),
                    child: Row(
                      children: [
                        ActivityTypeIcon(
                          type: type,
                          fallback: Icons.directions_run,
                          size: 20,
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                activityTypeLocalizedName(type, s),
                                style: AppTypography.body.copyWith(
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                s.registrationChange,
                                style: AppTypography.caption.copyWith(
                                  color: AppColors.textHalf,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          size: 18,
                          color: AppColors.textHalf,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _label(s.registrationWhen),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final offset in [0, 1, 2, if (day > 2) day])
                        Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: _dayChip(
                            dayLabel(offset),
                            day == offset,
                            () => setState(() => day = offset),
                          ),
                        ),
                      _dayChip(
                        s.registrationOtherDay,
                        false,
                        chooseDay,
                        icon: Icons.calendar_today_outlined,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _field(
                  s.registrationStart,
                  startText,
                  () => chooseNumber(isTime: true),
                  topBorder: true,
                ),
                _field(
                  s.registrationDuration,
                  '$duration min',
                  () => chooseNumber(isTime: false),
                ),
                if (invalid)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      s.registrationInvalid,
                      style: const TextStyle(
                        color: Color(0xffffa69c),
                        fontSize: 12,
                      ),
                    ),
                  ),
                const SizedBox(height: 25),
                _label(s.registrationEffort),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '$effort',
                      style: AppTypography.title.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      s.registrationOfTen,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textHalf,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      (effort <= 3
                              ? s.registrationLight
                              : effort <= 5
                              ? s.registrationModerate
                              : effort <= 8
                              ? s.registrationStrong
                              : s.registrationMaximum)
                          .toUpperCase(),
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textHalf,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
                Text(
                  effort == 6 ? s.registrationShortPhrases : '',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 18),
                _effortScale(),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:
                      [
                            s.registrationLight,
                            s.registrationModerate,
                            s.registrationStrong,
                            s.registrationMaximum,
                          ]
                          .map(
                            (e) => Text(
                              e,
                              style: AppTypography.caption.copyWith(
                                fontSize: 11,
                                color: AppColors.textHalf,
                              ),
                            ),
                          )
                          .toList(),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: SizedBox(
              width: 272,
              height: 48,
              child: FilledButton(
                onPressed: invalid
                    ? null
                    : () {
                        // 在点击时重新校验，避免页面停留期间跨日或时间变化。
                        if (invalid) return;
                        Navigator.of(context).pop(
                          DemoHistoryActivity.registrationPreview(
                            typeId: type.id,
                            dayOffset: day,
                            startMinutes: start,
                            duration: duration,
                            load: load,
                          ),
                        );
                      },
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xfff4f5f7),
                  foregroundColor: const Color(0xff121418),
                  disabledBackgroundColor: const Color(0x59f4f5f7),
                ),
                child: Text(s.registrationSave),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) => Text(
    text,
    style: AppTypography.caption.copyWith(
      fontSize: 11,
      letterSpacing: 1.5,
      color: AppColors.textHalf,
    ),
  );
  Widget _dayChip(
    String label,
    bool selected,
    VoidCallback onTap, {
    IconData? icon,
  }) => Material(
    color: selected ? const Color(0xfff4f5f7) : const Color(0x12ffffff),
    borderRadius: BorderRadius.circular(30),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: selected ? Colors.black : Colors.white,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: selected ? const Color(0xff121418) : Colors.white,
              ),
            ),
          ],
        ),
      ),
    ),
  );
  Widget _field(
    String label,
    String value,
    VoidCallback onTap, {
    bool topBorder = false,
  }) => InkWell(
    onTap: onTap,
    child: Container(
      height: 60,
      decoration: BoxDecoration(
        border: Border(
          top: topBorder
              ? const BorderSide(color: Color(0x14ffffff))
              : BorderSide.none,
          bottom: const BorderSide(color: Color(0x14ffffff)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTypography.body.copyWith(fontSize: 15),
            ),
          ),
          Text(
            value,
            style: AppTypography.title.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    ),
  );
  Widget _effortScale() => LayoutBuilder(
    builder: (context, constraints) {
      void update(double x) => setState(
        () => effort = (x / constraints.maxWidth * 10).ceil().clamp(1, 10),
      );
      const colors = [
        Color(0xff91c7ee),
        Color(0xff91c7ee),
        Color(0xff86d4a3),
        Color(0xff86d4a3),
        Color(0xfff1d98c),
        Color(0xfff1d98c),
        Color(0xfff0ad7b),
        Color(0xfff0ad7b),
        Color(0xffe88983),
        Color(0xffe88983),
      ];
      return Semantics(
        key: const Key('registration-effort'),
        slider: true,
        label: context.l10n.registrationEffortDescription,
        value: '$effort / 10',
        increasedValue: '${math.min(10, effort + 1)} / 10',
        decreasedValue: '${math.max(1, effort - 1)} / 10',
        onIncrease: () => setState(() => effort = math.min(10, effort + 1)),
        onDecrease: () => setState(() => effort = math.max(1, effort - 1)),
        child: Focus(
          onKeyEvent: (_, event) {
            if (event is KeyDownEvent &&
                (event.logicalKey == LogicalKeyboardKey.arrowLeft ||
                    event.logicalKey == LogicalKeyboardKey.arrowRight)) {
              setState(
                () => effort =
                    (effort +
                            (event.logicalKey == LogicalKeyboardKey.arrowRight
                                ? 1
                                : -1))
                        .clamp(1, 10),
              );
              return KeyEventResult.handled;
            }
            return KeyEventResult.ignored;
          },
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (d) => update(d.localPosition.dx),
            onHorizontalDragUpdate: (d) => update(d.localPosition.dx),
            child: SizedBox(
              height: 62,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (var i = 0; i < 10; i++)
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: i == 9 ? 0 : 6),
                        child: Container(
                          height: 14 + i * 4.2,
                          decoration: BoxDecoration(
                            color: i < effort
                                ? colors[i]
                                : const Color(0x14ffffff),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

/// 复用磨砂弹窗承载滚轮；取消时不修改登记表单。
class _NumberPickerSheet extends StatefulWidget {
  const _NumberPickerSheet({required this.isTime, required this.initialValue});
  final bool isTime;
  final int initialValue;
  @override
  State<_NumberPickerSheet> createState() => _NumberPickerSheetState();
}

class _NumberPickerSheetState extends State<_NumberPickerSheet> {
  late int hours = widget.initialValue ~/ 60;
  late int minutes = (widget.initialValue % 60) ~/ 5 * 5;
  late final FixedExtentScrollController hourController =
      FixedExtentScrollController(
        initialItem: hours.clamp(0, widget.isTime ? 23 : 5),
      );
  late final FixedExtentScrollController minuteController =
      FixedExtentScrollController(initialItem: minutes ~/ 5);

  @override
  void dispose() {
    hourController.dispose();
    minuteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    return SizedBox(
      height: 300,
      child: Column(
        children: [
          Text(
            widget.isTime ? s.registrationStart : s.registrationDuration,
            style: AppTypography.title,
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: CupertinoPicker(
                    itemExtent: 40,
                    scrollController: hourController,
                    onSelectedItemChanged: (v) => setState(() => hours = v),
                    children: [
                      for (var i = 0; i <= (widget.isTime ? 23 : 5); i++)
                        Center(
                          child: Text(
                            i.toString().padLeft(2, '0'),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: CupertinoPicker(
                    itemExtent: 40,
                    scrollController: minuteController,
                    onSelectedItemChanged: (v) =>
                        setState(() => minutes = v * 5),
                    children: [
                      for (var i = 0; i < 60; i += 5)
                        Center(
                          child: Text(
                            i.toString().padLeft(2, '0'),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              final value = hours * 60 + minutes;
              Navigator.pop(
                context,
                widget.isTime ? value : math.max(5, value),
              );
            },
            child: Text(s.registrationDone),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
