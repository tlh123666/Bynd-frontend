import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../design_system/design_system.dart';
import '../../../../l10n/app_localizations_context.dart';
import '../../../../shared/widgets/app_sheet_controls.dart';
import '../../application/vitality_controller.dart';
import '../../application/vitality_exports.dart';
import '../../domain/vitality_models.dart';
import '../vitality_copy.dart';
import '../widgets/vitality_widgets.dart';

class VitalitySettingsSheet extends StatefulWidget {
  const VitalitySettingsSheet({
    required this.controller,
    required this.snapshot,
    super.key,
  });
  final VitalityController controller;
  final VitalitySnapshot snapshot;
  @override
  State<VitalitySettingsSheet> createState() => _VitalitySettingsSheetState();
}

class _VitalitySettingsSheetState extends State<VitalitySettingsSheet> {
  late VitalityPreferences _preferences = widget.snapshot.preferences;
  bool _saving = false, _exporting = false;
  String? _error;
  bool get _recovery => widget.snapshot.kind == VitalityKind.recovery;
  bool get _busy => _saving || _exporting;
  Future<void> _save() async {
    if (_busy || widget.controller.accountChanged) return;
    setState(() => _saving = true);
    final success = await widget.controller.save(_preferences);
    if (!mounted) return;
    if (success) {
      Navigator.pop(context);
    } else {
      setState(() {
        _saving = false;
        _error = 'save';
      });
    }
  }

  List<List<String>> _rows() {
    final s = widget.snapshot;
    return [
      [vitalityDateLabel(context, s.date), vitalityNumber(context, s.score)],
      [
        context.l10n.vitalityNormal,
        s.baselineLow == null
            ? '—'
            : '${vitalityNumber(context, s.baselineLow)}–${vitalityNumber(context, s.baselineHigh)}',
      ],
      for (final entry in s.metrics.entries)
        if (entry.value is num &&
            const [
              'hrvMs',
              'restingHeartRate',
              'sleepMinutes',
              'stressScore',
              'steps',
              'activeMinutes',
              'calories',
              'vo2Max',
              'temperatureDeviation',
              'respiratoryRate',
            ].contains(entry.key))
          [
            vitalityMetricName(context, entry.key),
            '${vitalityMetricValue(context, entry.key, entry.value)} ${vitalityMetricUnit(entry.key)}',
          ],
    ];
  }

  Future<void> _export(String format) async {
    if (_busy || widget.controller.accountChanged) return;
    setState(() => _exporting = true);
    try {
      final s = widget.snapshot,
          title = vitalityTitle(context, s.kind),
          explanation = context.l10n.vitalityEstimateExplanation;
      final box = context.findRenderObject();
      final origin = box is RenderBox
          ? box.localToGlobal(Offset.zero) & box.size
          : null;
      if (format == 'pdf') {
        final bytes = await VitalityExports.pdf(
          title: '$title · ${vitalityDate(s.date)}',
          explanation: explanation,
          rows: _rows(),
        );
        if (!mounted || widget.controller.accountChanged) return;
        await Printing.sharePdf(
          bytes: bytes,
          filename: 'bynd-${s.kind.name}-${vitalityDate(s.date)}.pdf',
        );
      } else if (format == 'csv') {
        await SharePlus.instance.share(
          ShareParams(
            files: [
              XFile.fromData(VitalityExports.csv(s), mimeType: 'text/csv'),
            ],
            fileNameOverrides: [
              'bynd-${s.kind.name}-${vitalityDate(s.date)}.csv',
            ],
            sharePositionOrigin: origin,
          ),
        );
      } else {
        await SharePlus.instance.share(
          ShareParams(
            text:
                'BYND · $title\n${_rows().map((r) => r.join(': ')).join('\n')}\n\n$explanation',
            sharePositionOrigin: origin,
          ),
        );
      }
    } catch (e) {
      if (mounted) setState(() => _error = 'export');
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return PopScope(
      canPop: !_busy,
      child: Column(
        children: [
          AppSheetHeader(title: l.vitalitySettings, canClose: !_busy),
          Expanded(
            child: AbsorbPointer(
              absorbing: _busy,
              child: ListView(
                padding: const EdgeInsets.all(22),
                children: [
                  Text(
                    _recovery
                        ? l.vitalityRecoverySettings
                        : l.vitalityEnergySettings,
                    style: AppVitalityStyle.body,
                  ),
                  if (_recovery) ...[
                    _section(l.vitalityCalculation),
                    _toggle(
                      'considerTraining',
                      l.vitalityTrainingSetting,
                      l.vitalityTrainingHint,
                    ),
                  ] else ...[
                    _section(l.vitalityGoals),
                    _goal(
                      'stepGoal',
                      l.vitalityStepsGoal,
                      _preferences.stepGoal,
                      500,
                      1000,
                      50000,
                    ),
                    _goal(
                      'activeMinutesGoal',
                      l.vitalityActiveGoal,
                      _preferences.activeGoal,
                      5,
                      5,
                      300,
                    ),
                  ],
                  _section(l.vitalityShowPage),
                  if (_recovery) ...[
                    _toggle(
                      'showFactors',
                      l.vitalityFactors,
                      l.vitalityFactorsHint,
                    ),
                    _toggle(
                      'showForecast',
                      l.vitalityShowForecast,
                      l.vitalityForecastExplanation,
                    ),
                  ] else ...[
                    _toggle(
                      'showWindows',
                      l.vitalityShowWindows,
                      l.vitalityWindowsHint,
                    ),
                    _toggle(
                      'energyShowForecast',
                      l.vitalityForecastEnergy,
                      l.vitalityForecastExplanation,
                    ),
                  ],
                  _section(l.vitalityNotices),
                  Text(l.vitalityNoticeHint, style: AppVitalityStyle.caption),
                  if (_recovery) ...[
                    _toggle('lowRecoveryNotice', l.vitalityLowNotice, ''),
                    _toggle('morningNotice', l.vitalityMorningNotice, ''),
                  ] else ...[
                    _toggle('movementNotice', l.vitalityMovementNotice, ''),
                    _toggle('goalNotice', l.vitalityGoalNotice, ''),
                  ],
                  _section(l.vitalityData),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      l.vitalityCalendar,
                      style: AppVitalityStyle.body,
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.pop(context, true),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l.vitalityShare, style: AppVitalityStyle.body),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _export('text'),
                  ),
                  Text(l.vitalityExport, style: AppVitalityStyle.body),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    children: [
                      AppGlassPill(
                        label: 'PDF',
                        onPressed: () => _export('pdf'),
                      ),
                      AppGlassPill(
                        label: 'CSV',
                        onPressed: () => _export('csv'),
                      ),
                    ],
                  ),
                  if (_exporting)
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: AppLoadingIndicator(),
                    ),
                ],
              ),
            ),
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                _error == 'save' ? l.vitalitySaveFailed : l.vitalityShareFailed,
                style: AppVitalityStyle.caption.copyWith(
                  color: AppColors.error,
                ),
              ),
            ),
          AppSheetSaveButton(
            label: l.vitalitySave,
            loading: _saving,
            onPressed: _busy ? null : _save,
          ),
        ],
      ),
    );
  }

  Widget _section(String text) => Padding(
    padding: const EdgeInsets.only(top: 30, bottom: 12),
    child: VitalityLabel(text),
  );
  Widget _toggle(String key, String title, String subtitle) => SwitchListTile(
    contentPadding: EdgeInsets.zero,
    title: Text(title, style: AppVitalityStyle.body),
    subtitle: subtitle.isEmpty
        ? null
        : Text(subtitle, style: AppVitalityStyle.caption),
    value: _preferences.flag(key),
    activeThumbColor: AppColors.textPrimary,
    activeTrackColor: AppColors.glass,
    onChanged: (v) =>
        setState(() => _preferences = _preferences.change(key, v)),
  );
  Widget _goal(
    String key,
    String title,
    int value,
    int step,
    int min,
    int max,
  ) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 10),
      Text(title, style: AppVitalityStyle.body),
      Row(
        children: [
          Expanded(
            child: Text(
              context.l10n.vitalityPerDay,
              style: AppVitalityStyle.caption,
            ),
          ),
          IconButton(
            tooltip: '−',
            onPressed: value <= min
                ? null
                : () => setState(
                    () => _preferences = _preferences.change(
                      key,
                      (value - step).clamp(min, max),
                    ),
                  ),
            icon: const Icon(Icons.remove),
          ),
          Text(
            vitalityNumber(context, value),
            style: AppVitalityStyle.value.copyWith(fontSize: 24),
          ),
          IconButton(
            tooltip: '+',
            onPressed: value >= max
                ? null
                : () => setState(
                    () => _preferences = _preferences.change(
                      key,
                      (value + step).clamp(min, max),
                    ),
                  ),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    ],
  );
}
