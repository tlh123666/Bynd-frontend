enum VitalityKind { recovery, energy }

DateTime vitalityShiftDay(DateTime date, int days) =>
    DateTime(date.year, date.month, date.day + days);
int vitalityDayDistance(DateTime a, DateTime b) => DateTime.utc(
  a.year,
  a.month,
  a.day,
).difference(DateTime.utc(b.year, b.month, b.day)).inDays;

String vitalityDate(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
double? vitalityValue(Object? v) =>
    v is num && v.isFinite ? v.toDouble() : null;

class VitalityPoint {
  const VitalityPoint(this.at, this.score);
  final DateTime at;
  final double? score;
  factory VitalityPoint.fromJson(Map<String, dynamic> json) => VitalityPoint(
    DateTime.parse('${json['date'] ?? json['at']}'),
    vitalityValue(json['score']),
  );
}

class VitalityPreferences {
  const VitalityPreferences([this.values = const {}]);
  final Map<String, dynamic> values;
  bool flag(String key) =>
      values[key] as bool? ??
      [
        'considerTraining',
        'showFactors',
        'showForecast',
        'energyShowForecast',
        'showWindows',
      ].contains(key);
  bool forecastFor(VitalityKind kind) => flag(
    kind == VitalityKind.recovery ? 'showForecast' : 'energyShowForecast',
  );
  int get stepGoal => (values['stepGoal'] as num?)?.toInt() ?? 8000;
  int get activeGoal => (values['activeMinutesGoal'] as num?)?.toInt() ?? 30;
  VitalityPreferences change(String key, Object value) =>
      VitalityPreferences({...toJson(), key: value});
  Map<String, dynamic> toJson() => {
    for (final key in [
      'considerTraining',
      'showFactors',
      'showForecast',
      'energyShowForecast',
      'showWindows',
      'lowRecoveryNotice',
      'morningNotice',
      'movementNotice',
      'goalNotice',
    ])
      key: flag(key),
    'stepGoal': stepGoal,
    'activeMinutesGoal': activeGoal,
  };
}

class VitalitySnapshot {
  const VitalitySnapshot({
    required this.kind,
    required this.date,
    this.score,
    this.yesterday,
    this.average,
    this.previousAverage,
    this.baselineLow,
    this.baselineHigh,
    this.baselineDays = 0,
    this.trainingLoad,
    this.metrics = const {},
    this.trend = const [],
    this.observations = const [],
    this.forecast = const [],
    this.preferences = const VitalityPreferences(),
    this.demo = false,
    this.lastSyncAt,
  });
  final VitalityKind kind;
  final DateTime date;
  final double? score,
      yesterday,
      average,
      previousAverage,
      baselineLow,
      baselineHigh,
      trainingLoad;
  final int baselineDays;
  final Map<String, dynamic> metrics;
  final List<VitalityPoint> trend, observations, forecast;
  final VitalityPreferences preferences;
  final bool demo;
  final DateTime? lastSyncAt;
  factory VitalitySnapshot.fromJson(Map<String, dynamic> json) =>
      VitalitySnapshot(
        kind: VitalityKind.values.byName(json['kind'] as String),
        date: DateTime.parse(json['date'] as String),
        score: vitalityValue(json['score']),
        yesterday: vitalityValue(json['yesterday']),
        average: vitalityValue(json['average']),
        previousAverage: vitalityValue(json['previousAverage']),
        baselineLow: vitalityValue(json['baselineLow']),
        baselineHigh: vitalityValue(json['baselineHigh']),
        trainingLoad: vitalityValue(json['trainingLoad']),
        baselineDays: (json['baselineDays'] as num?)?.toInt() ?? 0,
        metrics: Map<String, dynamic>.from(json['metrics'] as Map? ?? {}),
        preferences: VitalityPreferences(
          Map<String, dynamic>.from(json['preferences'] as Map? ?? {}),
        ),
        trend: _points(json['trend']),
        observations: _points(json['observations']),
        forecast: _points(json['forecast']),
        lastSyncAt: DateTime.tryParse('${json['lastSyncAt']}'),
      );
  static List<VitalityPoint> _points(Object? data) => (data as List? ?? [])
      .map((v) => VitalityPoint.fromJson(Map<String, dynamic>.from(v as Map)))
      .toList();
}

abstract interface class VitalityRepository {
  Future<VitalitySnapshot> load(
    VitalityKind kind,
    DateTime date, {
    int days = 7,
  });
  Future<VitalityPreferences> savePreferences(VitalityPreferences preferences);
  void dispose();
}
