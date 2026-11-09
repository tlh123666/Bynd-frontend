/// The reference's 13 Home signals. A missing measurement stays null, including
/// metrics not yet collected by a device or uploaded by its source.
enum HomeSignal {
  sleep('Sono', 'Sleep', 'sleepMinutes', '', 'sleep'),
  steps('Passos', 'Steps', 'steps', '', 'steps'),
  rhr('FC repouso', 'Resting HR', 'restingHeartRate', 'bpm', 'rhr'),
  hrv('VFC', 'HRV', 'hrvMs', 'ms', 'hrv'),
  oxygen('Oxigênio', 'Oxygen', 'spo2Percent', '%', 'spo2'),
  vo2('VO₂ máx.', 'VO₂ max', 'vo2Max', '', 'vo2'),
  distance('Distância', 'Distance', 'distanceMeters', 'km', 'distance'),
  calories('Calorias', 'Calories', 'calories', 'kcal', 'calories'),
  activeMinutes(
    'Min. ativos',
    'Active min.',
    'activeMinutes',
    'min',
    'activeMinutes',
  ),
  basal('Gasto basal', 'Basal energy', 'basalCalories', 'kcal', 'basal'),
  activeCalories(
    'Cal. ativas',
    'Active calories',
    'activeCalories',
    'kcal',
    'activeCalories',
  ),
  respiration(
    'Respiração',
    'Respiration',
    'respiratoryRate',
    'rpm',
    'respiration',
  ),
  temperature(
    'Temperatura',
    'Temperature',
    'skinTemperatureDeviationCelsius',
    '°C',
    'temperature',
  );

  const HomeSignal(this.pt, this.en, this.jsonKey, this.unit, this.icon);
  final String pt, en, jsonKey, unit, icon;
  String label(String locale) => locale.startsWith('en') ? en : pt;
  String get iconAsset => 'assets/icons/site/home-$icon.svg';
  static const defaults = [sleep, steps, rhr, hrv, oxygen, vo2];

  String format(num? value, String locale) {
    if (value == null || !value.isFinite) return '—';
    if (this == sleep) {
      final minutes = value.round();
      return '${minutes ~/ 60}h${(minutes % 60).toString().padLeft(2, '0')}';
    }
    final english = locale.startsWith('en');
    if (this == distance || this == respiration || this == temperature) {
      final number = this == distance ? value / 1000 : value;
      final result =
          '${this == temperature && number > 0 ? '+' : ''}${number.toStringAsFixed(1)}';
      return english ? result : result.replaceAll('.', ',');
    }
    return value.round().toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (_) => english ? ',' : '.',
    );
  }
}

enum HomeSignalStatus { neutral, good, attention }

class HomeMeasurement {
  const HomeMeasurement(
    this.signal, {
    this.value,
    this.caption = '',
    this.status = HomeSignalStatus.neutral,
  });
  final HomeSignal signal;
  final num? value;
  final String caption;
  final HomeSignalStatus status;
}

class HomeSnapshot {
  HomeSnapshot({
    required this.date,
    required this.title,
    required this.paragraphs,
    required this.measurements,
    this.userId = '',
    this.firstName = '',
    this.avatarUrl,
    this.patterns,
    this.recommendation = '',
    this.partial = false,
  });
  final DateTime date;
  final String userId, firstName, title, recommendation;
  final String? avatarUrl;
  final List<String> paragraphs;
  final Map<HomeSignal, HomeMeasurement> measurements;
  final int? patterns;
  final bool partial;
  HomeMeasurement measurement(HomeSignal signal) =>
      measurements[signal] ?? HomeMeasurement(signal);
}

class HomeHistoryPoint {
  const HomeHistoryPoint(this.date, this.value);
  final DateTime date;
  final num? value;
}

class HomeDiaryEvent {
  const HomeDiaryEvent({
    required this.id,
    required this.label,
    required this.category,
    this.note = '',
    this.occurredAt,
  });
  final String id, label, category, note;
  final DateTime? occurredAt;
  factory HomeDiaryEvent.fromJson(Map<String, dynamic> json) => HomeDiaryEvent(
    id: json['id'] as String? ?? '',
    label: json['label'] as String? ?? '',
    category: json['category'] as String? ?? 'custom',
    note: json['note'] as String? ?? '',
    occurredAt: DateTime.tryParse(json['occurredAt'] as String? ?? ''),
  );
}

String homeDateKey(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-'
    '${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

DateTime homeDay(DateTime date, [int daysAgo = 0]) =>
    DateTime(date.year, date.month, date.day - daysAgo);
