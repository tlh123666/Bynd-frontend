import 'package:flutter/material.dart';
import '../../../../design_system/design_system.dart';
import '../../../../shared/widgets/app_sheet_controls.dart';
import '../../domain/heart_models.dart';
import '../heart_copy.dart';
import '../widgets/heart_charts.dart';
import '../widgets/heart_widgets.dart';

class HeartDetailSheet extends StatefulWidget {
  const HeartDetailSheet({
    required this.repository,
    required this.snapshot,
    required this.metric,
    super.key,
  });
  final HeartRepository repository;
  final HeartSnapshot snapshot;
  final HeartMetric metric;
  @override
  State<HeartDetailSheet> createState() => _HeartDetailSheetState();
}

class _HeartDetailSheetState extends State<HeartDetailSheet> {
  HeartPeriod _period = HeartPeriod.day;
  HeartTrend? _trend;
  bool _loading = false;
  Object? _error;
  int _request = 0;
  Future<void> _change(HeartPeriod period) async {
    final request = ++_request;
    setState(() {
      _period = period;
      _loading = period != HeartPeriod.day;
      _error = null;
      _trend = null;
    });
    if (period == HeartPeriod.day) return;
    try {
      final result = await widget.repository.trend(
        widget.snapshot.date,
        period == HeartPeriod.week ? 7 : 30,
      );
      if (mounted && request == _request) setState(() => _trend = result);
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
    final m = widget.metric,
        s = widget.snapshot,
        history = _period != HeartPeriod.day,
        values = _trend?.values(m) ?? [],
        summary = s.summary;
    final pressureLow =
        _trend?.days
            .where((d) => d['diastolicBp'] is num)
            .map((d) => d['diastolicBp'] as num)
            .toList() ??
        <num>[];
    final number =
        history &&
            m == HeartMetric.pressure &&
            !_loading &&
            _error == null &&
            pressureLow.isNotEmpty
        ? '${heartNumber(_trend?.average(m))}/${heartNumber(pressureLow.reduce((a, b) => a + b) / pressureLow.length)}'
        : history
        ? (_loading || _error != null
              ? '—'
              : heartNumber(
                  _trend?.average(m),
                  digits: m == HeartMetric.respiration ? 1 : 0,
                ))
        : s.format(m);
    return Column(
      children: [
        AppSheetHeader(title: heartMetricTitle(context, m)),
        Row(
          children: [
            for (final period
                in m == HeartMetric.recovery
                    ? [HeartPeriod.day]
                    : HeartPeriod.values.reversed)
              Expanded(
                child: TextButton(
                  key: ValueKey('heart-period-${period.name}'),
                  onPressed: () => _change(period),
                  style: TextButton.styleFrom(
                    foregroundColor: _period == period
                        ? AppColors.textPrimary
                        : AppHeartStyle.muted,
                    side: _period == period
                        ? const BorderSide(color: AppColors.glassBorderStrong)
                        : BorderSide.none,
                  ),
                  child: Text(
                    heartText(
                      context,
                      switch (period) {
                        HeartPeriod.day => 'Dia',
                        HeartPeriod.week => 'Semana',
                        HeartPeriod.month => 'Mês',
                      },
                      switch (period) {
                        HeartPeriod.day => 'Day',
                        HeartPeriod.week => 'Week',
                        HeartPeriod.month => 'Month',
                      },
                    ),
                  ),
                ),
              ),
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(22, 28, 22, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(number, style: AppHeartStyle.number),
                const SizedBox(height: 12),
                Text(
                  '${m.unit} · ${history ? heartText(context, 'média dos dias com leitura', 'average of measured days') : heartShortDate(context, s.date)}',
                  style: AppHeartStyle.caption,
                ),
                const SizedBox(height: 26),
                if (_loading)
                  const Center(child: AppLoadingIndicator())
                else if (_error != null)
                  Center(
                    child: AppGlassPill(
                      label: heartText(context, 'Tentar novamente', 'Retry'),
                      onPressed: () => _change(_period),
                    ),
                  )
                else if (history)
                  HeartTrendChart(
                    trend: _trend ?? const HeartTrend(),
                    metric: m,
                    onDay: (date) => Navigator.pop(context, date),
                  )
                else if (m == HeartMetric.pulse || m == HeartMetric.resting)
                  HeartLineChart(points: s.points, date: s.date),
                if (!history && m == HeartMetric.pulse) ...[
                  const SizedBox(height: 26),
                  HeartStats([
                    (
                      heartText(context, 'Mínima', 'Minimum'),
                      heartNumber(summary['minHeartRate'] as num?),
                    ),
                    (
                      heartText(context, 'Média', 'Average'),
                      heartNumber(summary['avgHeartRate'] as num?),
                    ),
                    (
                      heartText(context, 'Máxima', 'Maximum'),
                      heartNumber(summary['maxHeartRate'] as num?),
                    ),
                  ]),
                  const SizedBox(height: 18),
                  Text(
                    heartText(
                      context,
                      'As interrupções da curva representam intervalos sem amostras.',
                      'Gaps in the curve represent intervals without samples.',
                    ),
                    style: AppHeartStyle.caption,
                  ),
                ],
                if (history && values.isNotEmpty) ...[
                  const SizedBox(height: 26),
                  HeartStats([
                    (
                      heartText(context, 'Mínima', 'Minimum'),
                      heartNumber(values.reduce((a, b) => a < b ? a : b)),
                    ),
                    (
                      heartText(context, 'Média', 'Average'),
                      heartNumber(_trend?.average(m)),
                    ),
                    (
                      heartText(context, 'Máxima', 'Maximum'),
                      heartNumber(values.reduce((a, b) => a > b ? a : b)),
                    ),
                  ]),
                ],
                if (m == HeartMetric.resting) ...[
                  const SizedBox(height: 24),
                  HeartLabel(heartText(context, 'Seu normal', 'Your baseline')),
                  const SizedBox(height: 10),
                  Text(
                    s.baseline['lower'] == null
                        ? heartText(
                            context,
                            'Precisamos de pelo menos 7 noites anteriores com leituras válidas para calcular seu intervalo pessoal.',
                            'At least 7 previous nights with valid readings are needed to calculate your personal range.',
                          )
                        : '${s.baseline['lower']}–${s.baseline['upper']} bpm · ${s.baseline['days']} ${heartText(context, 'noites', 'nights')}',
                    style: AppHeartStyle.body,
                  ),
                ],
                if (m == HeartMetric.pressure) ...[
                  const SizedBox(height: 24),
                  Text(
                    heartText(
                      context,
                      'Valores estimados fornecidos pelo dispositivo. Se não houve leitura, o valor permanece vazio.',
                      'Estimated values supplied by your device. No reading means no displayed value.',
                    ),
                    style: AppHeartStyle.body,
                  ),
                ],
                if (m == HeartMetric.recovery) ...[
                  const SizedBox(height: 24),
                  Text(
                    heartText(
                      context,
                      'Diferença entre a última amostra ao terminar o treino e a leitura cerca de um minuto depois. Só aparece quando há amostras nos dois momentos.',
                      'Difference between the heart rate at the end of exercise and the reading about one minute later. Both measurements are required.',
                    ),
                    style: AppHeartStyle.body,
                  ),
                ],
                if (m != HeartMetric.pulse &&
                    m != HeartMetric.resting &&
                    s.value(m) == null &&
                    !history) ...[
                  const SizedBox(height: 20),
                  Text(
                    heartText(
                      context,
                      'Este sinal não foi registrado na data selecionada.',
                      'This signal was not recorded on the selected date.',
                    ),
                    style: AppHeartStyle.body,
                  ),
                ],
                const SizedBox(height: 32),
                Text(
                  heartText(
                    context,
                    'Entenda esta leitura',
                    'About this reading',
                  ),
                  style: AppHeartStyle.title,
                ),
                const SizedBox(height: 14),
                Text(
                  heartText(
                    context,
                    'As medições dependem do sinal recebido da pulseira. O traçado de pulso não confirma nem exclui arritmias. Compare leituras registradas, sem preencher lacunas com estimativas.',
                    'Measurements depend on the signal received from your band. A pulse trace does not confirm or rule out arrhythmias. Missing readings are left empty.',
                  ),
                  style: AppHeartStyle.body,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
