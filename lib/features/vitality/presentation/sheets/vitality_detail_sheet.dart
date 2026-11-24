import 'package:flutter/material.dart';
import '../../../../core/network/api_client.dart';
import '../../../../design_system/design_system.dart';
import '../../../../l10n/app_localizations_context.dart';
import '../../../../shared/widgets/app_sheet_controls.dart';
import '../../application/vitality_controller.dart';
import '../../domain/vitality_models.dart';
import '../widgets/vitality_widgets.dart';
import '../vitality_copy.dart';
import '../widgets/vitality_charts.dart';

class VitalityDetailSheet extends StatefulWidget {
  const VitalityDetailSheet({
    required this.controller,
    required this.snapshot,
    required this.color,
    this.metric,
    super.key,
  });
  final VitalityController controller;
  final VitalitySnapshot snapshot;
  final Color color;
  final String? metric;
  @override
  State<VitalityDetailSheet> createState() => _VitalityDetailSheetState();
}

class _VitalityDetailSheetState extends State<VitalityDetailSheet> {
  int _period = 1, _request = 0;
  bool _loading = false;
  Object? _error;
  VitalitySnapshot? _history;
  Future<void> _change(int days) async {
    final request = ++_request;
    setState(() {
      _period = days;
      _error = null;
      _history = null;
      _loading = days != 1;
    });
    if (days == 1) return;
    try {
      final data = await widget.controller.repository.load(
        widget.snapshot.kind,
        widget.snapshot.date,
        days: days,
      );
      if (mounted && request == _request && !widget.controller.accountChanged) {
        setState(() => _history = data);
      }
    } catch (e) {
      if (mounted && request == _request) setState(() => _error = e);
    } finally {
      if (mounted && request == _request) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _request++;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n, s = widget.snapshot, metric = widget.metric;
    final history = _history ?? s;
    final scores =
        _history?.trend.map((p) => p.score).whereType<double>().toList() ??
        <double>[];
    final average = scores.isEmpty
        ? null
        : scores.reduce((a, b) => a + b) / scores.length;
    final value = metric == null
        ? vitalityNumber(context, _period == 1 ? s.score : average)
        : vitalityMetricValue(
            context,
            metric,
            metric == 'trainingLoad' ? s.trainingLoad : s.metrics[metric],
          );
    return Column(
      children: [
        AppSheetHeader(
          title: metric == null
              ? vitalityTitle(context, s.kind)
              : vitalityMetricName(context, metric),
        ),
        if (metric == null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: SegmentedButton<int>(
              segments: [
                ButtonSegment(value: 1, label: Text(l.vitalityDay)),
                ButtonSegment(value: 7, label: Text(l.vitalityWeek)),
                ButtonSegment(value: 30, label: Text(l.vitalityMonth)),
              ],
              selected: {_period},
              onSelectionChanged: (v) => _change(v.single),
            ),
          ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(22, 18, 22, 28),
            children: [
              Text(
                vitalityDateLabel(context, s.date),
                style: AppVitalityStyle.caption,
              ),
              const SizedBox(height: 12),
              Text(value, style: AppVitalityStyle.number),
              if (metric == null && _period != 1)
                Text(l.vitalityAverage, style: AppVitalityStyle.caption),
              if (metric != null)
                Text(
                  vitalityMetricUnit(metric),
                  style: AppVitalityStyle.caption,
                ),
              const SizedBox(height: 16),
              Text(
                metric == null
                    ? l.vitalityEstimateExplanation
                    : (value == '—'
                          ? l.vitalityMissingMetric
                          : l.vitalityMetricDetails),
                style: AppVitalityStyle.body,
              ),
              if (s.demo)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(l.vitalityDemo, style: AppVitalityStyle.caption),
                ),
              const SizedBox(height: 24),
              if (metric == null) ...[
                if (_loading)
                  const SizedBox(
                    height: 220,
                    child: Center(child: AppLoadingIndicator()),
                  )
                else if (_error != null)
                  Column(
                    children: [
                      Text(
                        _error is ApiException &&
                                ((_error as ApiException).serverCode ==
                                        100011 ||
                                    (_error as ApiException).statusCode == 403)
                            ? l.vitalityPremium
                            : l.vitalityLoadingFailed,
                        style: AppVitalityStyle.body,
                      ),
                      AppGlassPill(
                        label: l.vitalityRetry,
                        onPressed: () => _change(_period),
                      ),
                    ],
                  )
                else if (_period == 1 && s.kind == VitalityKind.recovery)
                  RecoveryArc(score: s.score)
                else
                  VitalityChart(
                    points: _period == 1 ? s.observations : history.trend,
                    color: widget.color,
                    intraday: _period == 1,
                    forecast:
                        _period == 1 &&
                            s.kind == VitalityKind.energy &&
                            s.preferences.forecastFor(s.kind)
                        ? s.forecast
                        : const [],
                    low: history.baselineLow,
                    high: history.baselineHigh,
                  ),
                const SizedBox(height: 18),
                Text(
                  _period == 1
                      ? l.vitalityCurveExplanation
                      : l.vitalityWeekExplanation,
                  style: AppVitalityStyle.caption,
                ),
                const SizedBox(height: 24),
                VitalityLabel(l.vitalityFactors),
                for (final key
                    in (s.kind == VitalityKind.recovery
                        ? [
                            'hrvMs',
                            'restingHeartRate',
                            'sleepMinutes',
                            'stressScore',
                          ]
                        : ['stressScore', 'sleepMinutes', 'hrvMs', 'steps']))
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      vitalityMetricName(context, key),
                      style: AppVitalityStyle.body,
                    ),
                    trailing: Text(
                      '${vitalityMetricValue(context, key, s.metrics[key])}${vitalityMetricUnit(key)}',
                      style: AppVitalityStyle.body,
                    ),
                  ),
                const SizedBox(height: 20),
                Text(
                  s.baselineLow == null
                      ? l.vitalityNoBaseline
                      : '${l.vitalityNormal}: ${vitalityNumber(context, s.baselineLow)}–${vitalityNumber(context, s.baselineHigh)}',
                  style: AppVitalityStyle.caption,
                ),
                if (s.preferences.forecastFor(s.kind)) ...[
                  const SizedBox(height: 24),
                  VitalityForecast(snapshot: s, color: widget.color),
                ],
              ],
            ],
          ),
        ),
      ],
    );
  }
}
