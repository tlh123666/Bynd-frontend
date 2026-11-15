import 'package:flutter/widgets.dart';
import '../domain/heart_models.dart';

String heartText(BuildContext c, String pt, String en) =>
    Localizations.localeOf(c).languageCode == 'pt' ? pt : en;
String heartMetricTitle(BuildContext c, HeartMetric m) {
  final pair = switch (m) {
    HeartMetric.pulse => ('Frequência cardíaca', 'Heart rate'),
    HeartMetric.resting => ('FC em repouso', 'Resting heart rate'),
    HeartMetric.hrv => ('VFC', 'HRV'),
    HeartMetric.oxygen => ('Oxigênio', 'Oxygen'),
    HeartMetric.pressure => ('Pressão estimada', 'Estimated blood pressure'),
    HeartMetric.recovery => ('Queda após o esforço', 'Heart rate recovery'),
    HeartMetric.respiration => ('Respiração', 'Respiration'),
  };
  return heartText(c, pair.$1, pair.$2);
}

String heartShortDate(BuildContext c, DateTime d) {
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
  return heartText(
    c,
    '${d.day} ${pt[d.month - 1]}',
    '${en[d.month - 1]} ${d.day}',
  );
}

String heartClock(DateTime? d) => d == null
    ? '—'
    : '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
String heartNumber(num? n, {int digits = 0}) =>
    n == null ? '—' : n.toStringAsFixed(digits);
const heartSymptoms = <String, (String, String)>{
  'none': ('Nada', 'None'),
  'palpitations': ('Coração acelerado', 'Racing heart'),
  'skipped_beats': ('Batida falhando', 'Skipped beat'),
  'dizziness': ('Tontura', 'Dizziness'),
  'breathlessness': ('Falta de ar', 'Shortness of breath'),
  'chest_pain': ('Dor no peito', 'Chest pain'),
  'fatigue': ('Cansaço', 'Fatigue'),
};
const heartContexts = <String, (String, String)>{
  'rest': ('Repouso', 'At rest'),
  'after_coffee': ('Após café', 'After coffee'),
  'after_workout': ('Após treino', 'After exercise'),
};
