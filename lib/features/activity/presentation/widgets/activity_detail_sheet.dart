import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../design_system/design_system.dart';
import '../../../../l10n/app_localizations_context.dart';
import '../models/demo_history_activity.dart';
import '../../domain/models/activity_type_catalog.dart';
import '../localization/activity_type_localizations.dart';

/// 展示所选示例活动；设备数据和心率分区算法尚未接入。
class ActivityDetailSheet extends StatefulWidget {
  const ActivityDetailSheet({
    required this.activity,
    this.onChanged,
    this.onDeleted,
    super.key,
  });
  final DemoHistoryActivity activity;
  final ValueChanged<DemoHistoryActivity>? onChanged;
  final VoidCallback? onDeleted;

  static Future<void> show(
    BuildContext context,
    DemoHistoryActivity activity, {
    ValueChanged<DemoHistoryActivity>? onChanged,
    VoidCallback? onDeleted,
  }) => AppFrostedModalSheet.show<void>(
    context,
    topInset: math.max(MediaQuery.viewPaddingOf(context).top, 20) + 34,
    showHandle: false,
    barrierColor: AppColors.contentSheetVeil,
    builder: (_) => ActivityDetailSheet(
      activity: activity,
      onChanged: onChanged,
      onDeleted: onDeleted,
    ),
  );

  @override
  State<ActivityDetailSheet> createState() => _ActivityDetailSheetState();
}

enum _DemoAction { share, edit, delete }

class _ActivityDetailSheetState extends State<ActivityDetailSheet> {
  late DemoHistoryActivity activity = widget.activity;

  String _title(BuildContext context) {
    final type = activity.typeId == null
        ? null
        : ActivityTypeCatalog.findById(activity.typeId!);
    if (type != null) return activityTypeLocalizedName(type, context.l10n);
    return activity.kind == DemoActivityKind.sauna
        ? 'Sauna'
        : context.l10n.activityDemoStrength;
  }

  String _day(BuildContext context) {
    final offset = activity.dayOffset;
    if (offset == null) {
      return activity.isToday ? context.l10n.today : context.l10n.yesterday;
    }
    if (offset == 0) return context.l10n.today;
    if (offset == 1) return context.l10n.yesterday;
    final now = DateTime.now();
    return DateFormat.yMMMd(
      Localizations.localeOf(context).toString(),
    ).format(DateTime(now.year, now.month, now.day - offset));
  }

  Future<void> _handleAction(_DemoAction action) async {
    final s = context.l10n;
    switch (action) {
      case _DemoAction.share:
        final title = _title(context);
        var message = s.activityDetailCopied;
        try {
          await Clipboard.setData(
            ClipboardData(
              text:
                  '$title · ${activity.start}–${activity.end} · ${activity.duration} min · ${activity.isRegistrationPreview ? s.activityRegistrationPreview : s.activityDetailDemoSource}',
            ),
          );
        } on PlatformException {
          message = s.activityDetailCopyFailed;
        } on MissingPluginException {
          message = s.activityDetailCopyFailed;
        }
        if (!mounted) return;
        await showDialog<void>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(s.close),
              ),
            ],
          ),
        );
        return;
      case _DemoAction.edit:
        final updated = await AppFrostedModalSheet.show<DemoHistoryActivity>(
          context,
          builder: (_) => _EditDemoActivitySheet(activity: activity),
        );
        if (!mounted || updated == null) return;
        setState(() => activity = updated);
        widget.onChanged?.call(updated);
        return;
      case _DemoAction.delete:
        final confirmed = await AppConfirmationSheet.show(
          context,
          title: s.activityDetailDeleteConfirm,
          message: s.activityDetailDemoOnly,
          confirmLabel: s.activityDetailDelete,
          cancelLabel: s.activityDetailCancel,
          danger: true,
        );
        if (!mounted || !confirmed) return;
        widget.onDeleted?.call();
        Navigator.of(context).pop();
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final title = _title(context);
    final day = _day(context);
    final maxZoneMinutes = activity.zoneMinutes.reduce(math.max);
    final mostZone = activity.zoneMinutes.indexOf(maxZoneMinutes);
    final height = math.max(
      0.0,
      MediaQuery.sizeOf(context).height -
          (math.max(MediaQuery.viewPaddingOf(context).top, 20) + 34) -
          MediaQuery.viewInsetsOf(context).bottom -
          MediaQuery.paddingOf(context).bottom,
    );
    return SizedBox(
      height: height,
      child: Column(
        children: [
          SizedBox(
            height: math.min(62.0, height),
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
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 6,
                  top: 14,
                  child: Semantics(
                    label: s.close,
                    button: true,
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.close,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 6,
                  top: 14,
                  child: Semantics(
                    label: s.activityDetailOptions,
                    button: true,
                    child: PopupMenuButton<_DemoAction>(
                      tooltip: '',
                      color: AppColors.menuPanel,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      onSelected: _handleAction,
                      itemBuilder: (_) => [
                        PopupMenuItem(
                          value: _DemoAction.share,
                          child: Text(s.activityDetailShare),
                        ),
                        PopupMenuItem(
                          value: _DemoAction.edit,
                          child: Text(s.activityDetailEdit),
                        ),
                        PopupMenuItem(
                          value: _DemoAction.delete,
                          child: Text(
                            s.activityDetailDelete,
                            style: const TextStyle(color: AppColors.error),
                          ),
                        ),
                      ],
                      icon: const Icon(
                        Icons.more_horiz,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.page.copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$day, ${activity.start} ${s.activityDetailTimeTo} ${activity.end}',
                    style: AppTypography.label.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    activity.isRegistrationPreview
                        ? s.activityRegistrationPreview
                        : s.activityDetailDemoSource,
                    style: AppTypography.label.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 28),
                  _MetricPair(
                    left: _Metric(
                      s.activityDetailDuration,
                      '${activity.duration}',
                      'min',
                    ),
                    right: _Metric(
                      s.activityDetailCalories,
                      '${activity.calories}',
                      'kcal',
                    ),
                  ),
                  const SizedBox(height: 24),
                  _MetricPair(
                    left: _Metric(
                      s.activityDetailAverageHeartRate,
                      '${activity.averageHeartRate}',
                      'bpm',
                    ),
                    right: _Metric(
                      s.activityDetailMaximumHeartRate,
                      '${activity.maximumHeartRate}',
                      'bpm',
                    ),
                  ),
                  if (activity.isRegistrationPreview) ...[
                    const SizedBox(height: 24),
                    _MetricPair(
                      left: _Metric(s.activityDetailHighIntensity, '0', 'min'),
                      right: _Metric(s.activityDetailEffortPeaks, '0', ''),
                    ),
                  ],
                  const SizedBox(height: 28),
                  Semantics(
                    label:
                        '${s.activityDetailAverageHeartRate} ${activity.averageHeartRate} bpm, ${s.activityDetailMaximumHeartRate} ${activity.maximumHeartRate} bpm',
                    child: SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: CustomPaint(
                        painter: _HeartRatePainter(
                          activity: activity,
                          minLabel: s.activityDetailMin,
                          maxLabel: s.activityDetailMax,
                          textDirection: Directionality.of(context),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),
                  Row(
                    children: [
                      const Icon(
                        Icons.favorite_border,
                        color: AppColors.textSecondary,
                        size: 18,
                      ),
                      const SizedBox(width: 9),
                      Expanded(
                        child: Text(
                          s.activityDetailHeartZones,
                          style: AppTypography.section,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          s.activityDetailZoneMost(mostZone),
                          textAlign: TextAlign.end,
                          style: AppTypography.caption.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  ...[
                    s.activityDetailZoneRest,
                    s.activityDetailZoneVeryLight,
                    s.activityDetailZoneLight,
                    s.activityDetailZoneModerate,
                    s.activityDetailZoneHard,
                    s.activityDetailZoneMaximum,
                  ].asMap().entries.map(
                    (entry) => _ZoneRow(
                      index: entry.key,
                      description: entry.value,
                      minutes: activity.zoneMinutes[entry.key],
                      maxMinutes: maxZoneMinutes,
                      label: s.activityDetailZone,
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
}

/// 编辑仅更新当前历史页持有的示例数据，不写入设备或后端。
class _EditDemoActivitySheet extends StatefulWidget {
  const _EditDemoActivitySheet({required this.activity});
  final DemoHistoryActivity activity;
  @override
  State<_EditDemoActivitySheet> createState() => _EditDemoActivitySheetState();
}

class _EditDemoActivitySheetState extends State<_EditDemoActivitySheet> {
  late final _start = TextEditingController(text: widget.activity.start);
  late final _duration = TextEditingController(
    text: '${widget.activity.duration}',
  );
  bool _invalid = false;

  @override
  void dispose() {
    _start.dispose();
    _duration.dispose();
    super.dispose();
  }

  void _save() {
    final start = _start.text.trim();
    final duration = int.tryParse(_duration.text.trim());
    if (!RegExp(r'^([01]\d|2[0-3]):[0-5]\d$').hasMatch(start) ||
        duration == null ||
        duration < 1 ||
        duration > 720) {
      setState(() => _invalid = true);
      return;
    }
    Navigator.of(context).pop(widget.activity.withTime(start, duration));
  }

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(s.activityDetailEdit, style: AppTypography.title),
          const SizedBox(height: 8),
          Text(
            s.activityDetailDemoOnly,
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _start,
            decoration: InputDecoration(labelText: s.activityDetailStart),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _duration,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: '${s.activityDetailDuration} (min)',
            ),
          ),
          if (_invalid)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                s.activityDetailInvalid,
                style: AppTypography.caption.copyWith(color: AppColors.error),
              ),
            ),
          const SizedBox(height: 20),
          AppButton(
            label: s.activityDetailSave,
            expanded: true,
            onPressed: _save,
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(s.activityDetailCancel),
          ),
        ],
      ),
    );
  }
}

class _Metric {
  const _Metric(this.label, this.value, this.unit);
  final String label, value, unit;
}

class _MetricPair extends StatelessWidget {
  const _MetricPair({required this.left, required this.right});
  final _Metric left, right;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(child: _metric(left)),
      const SizedBox(width: 16),
      Expanded(child: _metric(right)),
    ],
  );
  Widget _metric(_Metric item) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        item.label,
        style: AppTypography.label.copyWith(color: AppColors.textMuted),
      ),
      const SizedBox(height: 8),
      Text.rich(
        TextSpan(
          text: item.value,
          style: AppTypography.section.copyWith(fontSize: 24),
          children: [
            TextSpan(
              text: ' ${item.unit}',
              style: AppTypography.caption.copyWith(color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    ],
  );
}

class _ZoneRow extends StatelessWidget {
  const _ZoneRow({
    required this.index,
    required this.description,
    required this.minutes,
    required this.maxMinutes,
    required this.label,
  });
  final int index, minutes, maxMinutes;
  final String description, label;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: 14),
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: AppColors.divider)),
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$label $index',
                style: AppTypography.label.copyWith(fontSize: 15),
              ),
              Text(
                description,
                style: AppTypography.caption.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: maxMinutes > 0 ? minutes / maxMinutes : 0,
              minHeight: 6,
              backgroundColor: AppColors.glassBorderStrong,
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xffa4a9b0),
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        SizedBox(
          width: 54,
          child: Text(
            '$minutes min',
            textAlign: TextAlign.end,
            style: AppTypography.label.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    ),
  );
}

/// 按原型绘制静态心率胶囊图；示例点不代表真实传感器记录。
class _HeartRatePainter extends CustomPainter {
  const _HeartRatePainter({
    required this.activity,
    required this.minLabel,
    required this.maxLabel,
    required this.textDirection,
  });
  final DemoHistoryActivity activity;
  final String minLabel, maxLabel;
  final TextDirection textDirection;

  @override
  void paint(Canvas canvas, Size size) {
    final data = activity.heartRateSamples;
    final minimum = data.reduce(math.min), maximum = data.reduce(math.max);
    final lo = minimum - 4.0, hi = maximum + 4.0;
    final graphWidth = math.max(1.0, size.width - 62),
        top = 20.0,
        bottom = size.height - 34;
    double y(double value) =>
        top + (1 - (value - lo) / (hi - lo)) * (bottom - top);
    final avgY = y(activity.averageHeartRate.toDouble());
    final dots = Paint()
      ..color = AppColors.textMuted
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 4) {
      canvas.drawLine(Offset(x, avgY), Offset(x + 1.5, avgY), dots);
    }
    final paint = Paint()
      ..color = const Color(0xffa4a9b0)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.5;
    for (var i = 0; i < data.length; i++) {
      final previous = data[i == 0 ? i : i - 1],
          next = data[i == data.length - 1 ? i : i + 1];
      final lower = math.min(
        data[i].toDouble(),
        math.min((previous + data[i]) / 2, (next + data[i]) / 2),
      );
      final upper = math.max(
        data[i].toDouble(),
        math.max((previous + data[i]) / 2, (next + data[i]) / 2),
      );
      final middle = (y(lower) + y(upper)) / 2;
      final halfHeight = math.max(5.0, (y(lower) - y(upper)) / 2);
      final x = 3 + i / math.max(1, data.length - 1) * (graphWidth - 6);
      if (activity.isRegistrationPreview) {
        // 色彩仅描述演示曲线，不代表真实心率分区。
        paint.color = data[i] < 93
            ? const Color(0xffa4a9b0)
            : data[i] < 112
            ? const Color(0xff91c7ee)
            : data[i] < 132
            ? const Color(0xff86d4a3)
            : const Color(0xfff1d98c);
      }
      canvas.drawLine(
        Offset(x, middle - halfHeight),
        Offset(x, middle + halfHeight),
        paint,
      );
    }
    _text(
      canvas,
      '$maxLabel ${activity.maximumHeartRate}',
      Offset(size.width - 58, y(maximum.toDouble()) - 8),
    );
    _text(canvas, '$minLabel $minimum', Offset(size.width - 58, bottom - 8));
    final parts = activity.start.split(':');
    final startMinutes = int.parse(parts[0]) * 60 + int.parse(parts[1]);
    for (var i = 0; i < 4; i++) {
      final minutes =
          (startMinutes + (activity.duration * i / 3).round()) % 1440;
      final time =
          '${(minutes ~/ 60).toString().padLeft(2, '0')}:${(minutes % 60).toString().padLeft(2, '0')}';
      _text(
        canvas,
        time,
        Offset(i * (graphWidth - 28) / 3, size.height - 18),
        muted: i == 1 || i == 2,
      );
    }
  }

  void _text(Canvas canvas, String text, Offset offset, {bool muted = false}) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontFamily: AppFontFamilies.geist,
          fontSize: 10,
          color: muted ? AppColors.textMuted : AppColors.textPrimary,
        ),
      ),
      textDirection: textDirection,
    )..layout();
    painter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant _HeartRatePainter old) =>
      old.activity != activity ||
      old.minLabel != minLabel ||
      old.maxLabel != maxLabel ||
      old.textDirection != textDirection;
}
