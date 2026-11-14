import 'package:flutter/widgets.dart';
import '../domain/sleep_models.dart';

String sleepText(BuildContext c, String pt, String en) =>
    Localizations.localeOf(c).languageCode == 'pt' ? pt : en;

String sleepNightDate(BuildContext context, DateTime date) {
  const pt = [
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
  const en = [
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
  return sleepText(
    context,
    '${date.day} ${pt[date.month - 1]}',
    '${en[date.month - 1]} ${date.day}',
  );
}

String sleepMetricTitle(BuildContext c, SleepMetric m) {
  final labels = <SleepMetric, (String, String)>{
    SleepMetric.duration: ('Tempo de sono', 'Sleep duration'),
    SleepMetric.score: ('Desempenho do sono', 'Sleep performance'),
    SleepMetric.debt: ('Dívida de sono', 'Sleep debt'),
    SleepMetric.restlessness: ('Agitação', 'Awakenings'),
    SleepMetric.respiration: ('Respiração e oxigênio', 'Breathing and oxygen'),
    SleepMetric.nap: ('Cochilo', 'Naps'),
    SleepMetric.efficiency: ('Eficiência', 'Efficiency'),
    SleepMetric.latency: ('Latência', 'Sleep latency'),
    SleepMetric.awake: ('Acordado', 'Awake'),
    SleepMetric.light: ('Sono leve', 'Light sleep'),
    SleepMetric.deep: ('Sono profundo', 'Deep sleep'),
    SleepMetric.rem: ('Sono REM', 'REM sleep'),
    SleepMetric.heartRate: ('Frequência cardíaca', 'Heart rate'),
    SleepMetric.hrv: ('VFC', 'HRV'),
    SleepMetric.oxygen: ('Oxigênio', 'Oxygen'),
    SleepMetric.temperature: ('Temperatura', 'Temperature'),
    SleepMetric.consistency: ('Regularidade', 'Consistency'),
  };
  final t = labels[m]!;
  return sleepText(c, t.$1, t.$2);
}

String sleepPeriodTitle(BuildContext c, SleepPeriod p) => switch (p) {
  SleepPeriod.day => sleepText(c, 'Dia', 'Day'),
  SleepPeriod.week => sleepText(c, 'Semana', 'Week'),
  SleepPeriod.month => sleepText(c, 'Mês', 'Month'),
};
String sleepClock(int minute) =>
    '${(minute ~/ 60 % 24).toString().padLeft(2, '0')}:${(minute % 60).toString().padLeft(2, '0')}';
