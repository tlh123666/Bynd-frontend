import 'package:flutter/material.dart';
import '../../../../design_system/design_system.dart';
import '../../../../shared/widgets/app_sheet_controls.dart';
import '../../application/sleep_controller.dart';
import '../../domain/sleep_models.dart';
import '../sleep_copy.dart';
import '../widgets/sleep_widgets.dart';

class SleepMetricSheet extends StatefulWidget {
  const SleepMetricSheet({
    required this.controller,
    required this.snapshot,
    required this.metric,
    super.key,
  });
  final SleepController controller;
  final SleepSnapshot snapshot;
  final SleepMetric metric;
  @override
  State<SleepMetricSheet> createState() => _SleepMetricSheetState();
}

class _SleepMetricSheetState extends State<SleepMetricSheet> {
  SleepPeriod _period = SleepPeriod.day;
  SleepTrend? _trend;
  Object? _error;
  bool _loading = false;
  int _request = 0;
  @override
  void dispose() {
    _request++;
    super.dispose();
  }

  Future<void> _change(SleepPeriod period) async {
    final request = ++_request;
    setState(() {
      _period = period;
      _error = null;
      _loading = period != SleepPeriod.day;
    });
    if (period == SleepPeriod.day) return;
    try {
      final data = await widget.controller.repository.trend(
        widget.snapshot.date,
        period == SleepPeriod.week ? 7 : 30,
      );
      if (mounted && request == _request) setState(() => _trend = data);
    } catch (e) {
      if (mounted && request == _request) setState(() => _error = e);
    } finally {
      if (mounted && request == _request) setState(() => _loading = false);
    }
  }

  String get _field => switch (widget.metric) {
    SleepMetric.duration => 'sleepMinutes',
    SleepMetric.score => 'sleepScore',
    SleepMetric.debt => 'sleepDebtMinutes',
    SleepMetric.nap => 'napMinutes',
    SleepMetric.restlessness => 'wakeCount',
    SleepMetric.efficiency => 'efficiencyPercent',
    SleepMetric.latency => 'sleepLatencyMinutes',
    SleepMetric.awake => 'awakeMinutes',
    SleepMetric.light => 'lightSleepMinutes',
    SleepMetric.deep => 'deepSleepMinutes',
    SleepMetric.rem => 'remSleepMinutes',
    SleepMetric.heartRate => 'avgHeartRate',
    SleepMetric.hrv => 'hrvMs',
    SleepMetric.oxygen || SleepMetric.respiration => 'avgSpo2Percent',
    SleepMetric.consistency => 'consistencyPercent',
    SleepMetric.temperature => 'temperature',
  };
  Future<void> _nap(SleepSession nap) async {
    await showAppContentSheet<void>(
      context,
      (_) => _NapDetail(repository: widget.controller.repository, id: nap.id),
      glass: true,
    );
  }

  String _historicalValue() {
    if (_loading || _error != null) return '—';
    final n = _trend?.average(_field);
    if (n == null) return '—';
    if (_field.endsWith('Minutes')) return sleepDuration(n);
    final unit = switch (_field) {
      'avgHeartRate' => ' bpm',
      'hrvMs' => ' ms',
      'avgSpo2Percent' || 'efficiencyPercent' || 'consistencyPercent' => '%',
      _ => '',
    };
    return '${n.toStringAsFixed(1)}$unit';
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.snapshot, metric = widget.metric, night = data.session;
    final historical = _period != SleepPeriod.day;
    final value = historical ? _historicalValue() : data.format(metric);
    return Column(
      children: [
        AppSheetHeader(title: sleepMetricTitle(context, metric)),
        SleepPeriodPicker(period: _period, onChanged: _change),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(22, 24, 22, 36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(value, style: AppSleepStyle.score),
                const SizedBox(height: 14),
                Text(
                  historical
                      ? sleepText(
                          context,
                          'média dos dias com leitura',
                          'average of measured days',
                        )
                      : sleepNightDate(context, data.date),
                  style: AppSleepStyle.caption,
                ),
                const SizedBox(height: 26),
                if (_loading)
                  const Center(child: AppLoadingIndicator())
                else if (_error != null)
                  Center(
                    child: AppGlassPill(
                      label: sleepText(context, 'Tentar novamente', 'Retry'),
                      onPressed: () => _change(_period),
                    ),
                  )
                else if (historical)
                  SleepHistoryChart(
                    trend: _trend ?? const SleepTrend(),
                    field: _field,
                    onDay: (date) => Navigator.pop(context, date),
                  )
                else ...[
                  if (night != null &&
                      [
                        SleepMetric.duration,
                        SleepMetric.awake,
                        SleepMetric.light,
                        SleepMetric.deep,
                        SleepMetric.rem,
                        SleepMetric.heartRate,
                      ].contains(metric))
                    SleepStageChart(session: night, vitals: data.vitals),
                  if (metric == SleepMetric.duration ||
                      [
                        SleepMetric.awake,
                        SleepMetric.light,
                        SleepMetric.deep,
                        SleepMetric.rem,
                      ].contains(metric)) ...[
                    const SizedBox(height: 24),
                    for (final m in [
                      SleepMetric.awake,
                      SleepMetric.rem,
                      SleepMetric.light,
                      SleepMetric.deep,
                      SleepMetric.efficiency,
                      SleepMetric.latency,
                    ])
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          sleepMetricTitle(context, m),
                          style: AppSleepStyle.body,
                        ),
                        trailing: Text(
                          data.format(m),
                          style: AppSleepStyle.body,
                        ),
                        onTap: () => showAppContentSheet<void>(
                          context,
                          (_) => SleepMetricSheet(
                            controller: widget.controller,
                            snapshot: data,
                            metric: m,
                          ),
                          glass: true,
                        ),
                      ),
                  ],
                  if (metric == SleepMetric.nap) ...[
                    if (data.naps.isEmpty)
                      Text(
                        data.unavailable.contains('naps')
                            ? sleepText(
                                context,
                                'Não foi possível carregar os cochilos.',
                                'Could not load naps.',
                              )
                            : sleepText(
                                context,
                                'Nenhum cochilo registrado neste dia.',
                                'No naps recorded on this day.',
                              ),
                        style: AppSleepStyle.body,
                      ),
                    for (final nap in data.naps)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          sleepDuration(nap.asleep),
                          style: AppSleepStyle.value,
                        ),
                        subtitle: Text(
                          '${nap.start?.toLocal() ?? ''}',
                          style: AppSleepStyle.caption,
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _nap(nap),
                      ),
                  ],
                  if (metric == SleepMetric.respiration) ...[
                    SleepCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SleepLabel(
                            sleepText(
                              context,
                              'Oxigênio médio',
                              'Average oxygen',
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            data.format(SleepMetric.oxygen),
                            style: AppSleepStyle.value,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      sleepText(
                        context,
                        'Frequência respiratória, ronco e movimentos não foram disponibilizados pela fonte desta noite.',
                        'Breathing rate, snoring and body movement were not supplied by this night’s data source.',
                      ),
                      style: AppSleepStyle.body,
                    ),
                  ],
                  if (metric == SleepMetric.restlessness)
                    Text(
                      sleepText(
                        context,
                        'Este valor representa despertares nas fases registradas. Não é uma contagem de viradas na cama.',
                        'This is the number of awakenings in the recorded stages, rather than measured body turns.',
                      ),
                      style: AppSleepStyle.body,
                    ),
                  if (data.value(metric) == null &&
                      ![
                        SleepMetric.nap,
                        SleepMetric.duration,
                        SleepMetric.respiration,
                      ].contains(metric))
                    Text(
                      sleepText(
                        context,
                        'Este sinal não está disponível para a noite selecionada. Não estimamos medições ausentes.',
                        'This signal is unavailable for the selected night. Missing measurements are not estimated.',
                      ),
                      style: AppSleepStyle.body,
                    ),
                  if (metric == SleepMetric.debt)
                    Text(
                      sleepText(
                        context,
                        'Diferença para sua meta diária de ${sleepDuration(data.preferences.target)}, usando apenas noites completas registradas dos últimos 7 dias. Os cochilos dessas datas já entram no total de sono.',
                        'Difference from your daily ${sleepDuration(data.preferences.target)} goal, using complete measured nights in the last 7 days. Naps on those dates are included in total sleep.',
                      ),
                      style: AppSleepStyle.body,
                    ),
                  if (metric == SleepMetric.consistency)
                    Text(
                      sleepText(
                        context,
                        'Regularidade dos horários registrada no resumo diário.',
                        'Schedule consistency recorded in the daily summary.',
                      ),
                      style: AppSleepStyle.body,
                    ),
                ],
                const SizedBox(height: 32),
                Text(
                  sleepText(context, 'Sobre esta leitura', 'About this view'),
                  style: AppSleepStyle.title,
                ),
                const SizedBox(height: 14),
                Text(
                  sleepText(
                    context,
                    'A pulseira estima as fases a partir dos sinais disponíveis. Registros parciais podem ter intervalos sem dados. Esta leitura não é um diagnóstico.',
                    'Your band estimates sleep stages from available signals. Partial records may contain gaps. This view is not a diagnosis.',
                  ),
                  style: AppSleepStyle.body,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _NapDetail extends StatefulWidget {
  const _NapDetail({required this.repository, required this.id});
  final SleepRepository repository;
  final String id;
  @override
  State<_NapDetail> createState() => _NapDetailState();
}

class _NapDetailState extends State<_NapDetail> {
  late Future<SleepSession> _future = widget.repository.session(widget.id);
  @override
  Widget build(BuildContext context) => Column(
    children: [
      AppSheetHeader(title: sleepText(context, 'Cochilo', 'Nap')),
      Expanded(
        child: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: AppGlassPill(
                  label: sleepText(context, 'Tentar novamente', 'Retry'),
                  onPressed: () => setState(
                    () => _future = widget.repository.session(widget.id),
                  ),
                ),
              );
            }
            if (!snapshot.hasData) {
              return const Center(child: AppLoadingIndicator());
            }
            final session = snapshot.data!;
            return ListView(
              padding: const EdgeInsets.all(22),
              children: [
                Text(sleepDuration(session.asleep), style: AppSleepStyle.score),
                SleepStageChart(session: session),
              ],
            );
          },
        ),
      ),
    ],
  );
}
