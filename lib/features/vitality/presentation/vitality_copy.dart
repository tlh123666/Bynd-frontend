import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import '../../../l10n/app_localizations_context.dart';
import '../domain/vitality_models.dart';

String vitalityTitle(BuildContext c, VitalityKind kind) =>
    kind == VitalityKind.recovery
    ? c.l10n.vitalityRecovery
    : c.l10n.vitalityEnergy;
String vitalityNumber(BuildContext c, num? value, {int decimals = 0}) =>
    value == null || !value.isFinite
    ? '—'
    : NumberFormat.decimalPatternDigits(
        locale: Localizations.localeOf(c).toLanguageTag(),
        decimalDigits: decimals,
      ).format(value);
String vitalityStatus(BuildContext c, double? score) {
  final l = c.l10n;
  return score == null
      ? l.vitalityMissing
      : score >= 85
      ? l.vitalityGreat
      : score >= 67
      ? l.vitalityGood
      : score >= 34
      ? l.vitalityLow
      : l.vitalityAttention;
}

String vitalityDateLabel(BuildContext c, DateTime date) => DateFormat(
  'd MMM',
  Localizations.localeOf(c).toLanguageTag(),
).format(date).replaceAll('.', '');
String vitalityMetricName(BuildContext c, String key) => switch (key) {
  'trainingLoad' => _label(c, 'Carga de ontem', 'Yesterday’s load'),
  'todayTrainingLoad' => _label(c, 'Carga de hoje', 'Today’s load'),
  'sleepDebtMinutes' => _label(c, 'Dívida de sono', 'Sleep debt'),
  'yesterdayStress' => _label(c, 'Estresse ontem', 'Yesterday’s stress'),
  'stressScore' => c.l10n.vitalityStress,
  'hrvMs' => c.l10n.vitalityHRV,
  'restingHeartRate' => c.l10n.vitalityRHR,
  'vo2Max' => c.l10n.vitalityVO2,
  'sleepMinutes' => c.l10n.vitalitySleep,
  'temperatureDeviation' => c.l10n.vitalityTemperature,
  'respiratoryRate' => c.l10n.vitalityBreathing,
  'steps' => c.l10n.vitalitySteps,
  'activeMinutes' => c.l10n.vitalityActiveMinutes,
  'calories' => c.l10n.vitalityCalories,
  _ => key,
};
String vitalityMetricValue(BuildContext c, String key, Object? value) {
  final number = vitalityValue(value);
  if (number == null) return '—';
  if (key == 'sleepMinutes' || key == 'sleepDebtMinutes') {
    return '${number.toInt() ~/ 60}h${(number.toInt() % 60).toString().padLeft(2, '0')}';
  }
  return vitalityNumber(
    c,
    number,
    decimals: ['temperatureDeviation', 'respiratoryRate'].contains(key) ? 1 : 0,
  );
}

String vitalityMetricUnit(String key) => switch (key) {
  'hrvMs' => 'ms',
  'restingHeartRate' => 'bpm',
  'temperatureDeviation' => '°C',
  'respiratoryRate' => 'rpm',
  'activeMinutes' => 'min',
  'calories' => 'kcal',
  'vo2Max' => 'ml/kg/min',
  _ => '',
};

String vitalityDelta(BuildContext c, double value) =>
    '${value >= 0 ? '+' : '−'}${vitalityNumber(c, value.abs())}';

String _label(BuildContext c, String pt, String en) =>
    Localizations.localeOf(c).languageCode == 'en' ? en : pt;
