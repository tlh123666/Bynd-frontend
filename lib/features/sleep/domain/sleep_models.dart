import 'dart:math' as math;

String sleepDate(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
String sleepDuration(num? minutes) {
  if (minutes == null) return '—';
  final m = minutes.round();
  return m >= 60
      ? '${m ~/ 60}h ${(m % 60).toString().padLeft(2, '0')}min'
      : '$m min';
}

Map<String, dynamic> sleepMap(dynamic raw) =>
    raw is Map ? Map<String, dynamic>.from(raw) : {};
List<Map<String, dynamic>> sleepMaps(dynamic raw) => raw is List
    ? raw.whereType<Map>().map((m) => Map<String, dynamic>.from(m)).toList()
    : [];

enum SleepPeriod { day, week, month }

enum SleepMetric {
  duration,
  score,
  debt,
  restlessness,
  respiration,
  nap,
  efficiency,
  latency,
  awake,
  light,
  deep,
  rem,
  heartRate,
  hrv,
  oxygen,
  temperature,
  consistency,
}

class SleepStage {
  const SleepStage({
    required this.stage,
    required this.offset,
    required this.minutes,
  });
  final String stage;
  final int offset, minutes;
  factory SleepStage.fromJson(Map<String, dynamic> j) => SleepStage(
    stage: '${j['stage']}',
    offset: (j['offset'] as num?)?.toInt() ?? 0,
    minutes: (j['minutes'] as num?)?.toInt() ?? 0,
  );
}

class SleepSession {
  const SleepSession(this.json);
  final Map<String, dynamic> json;
  String get id => '${json['id'] ?? ''}';
  String get type => '${json['sessionType'] ?? 'night'}';
  int? integer(String key) => (json[key] as num?)?.toInt();
  double? number(String key) => (json[key] as num?)?.toDouble();
  DateTime? get start => DateTime.tryParse('${json['startAt']}')?.toLocal();
  DateTime? get end => DateTime.tryParse('${json['endAt']}')?.toLocal();
  int? get asleep => integer('asleepMinutes');
  int? get duration => integer('durationMinutes');
  double? get score => number('sleepScore');
  String get quality => '${json['dataQuality'] ?? 'missing'}';
  List<SleepStage> get segments => sleepMaps(json['segments'])
      .map(SleepStage.fromJson)
      .where((s) => s.minutes > 0 && s.offset >= 0)
      .toList();
}

class SleepPreferences {
  const SleepPreferences(this.json);
  final Map<String, dynamic> json;
  int value(String key, int fallback) =>
      (json[key] as num?)?.toInt() ?? fallback;
  int get target => value('targetSleepMinutes', 480);
  int get bedtime =>
      value('targetBedtimeHour', 23) * 60 + value('targetBedtimeMinute', 0);
  int get wake =>
      value('targetWakeHour', 7) * 60 + value('targetWakeMinute', 30);
  int get windDown => value('windDownMinutes', 30);
  String get timezone => '${json['timezone'] ?? 'UTC'}';
  bool show(String key) => json[key] != false;
  SleepPreferences copy(Map<String, dynamic> patch) =>
      SleepPreferences({...toJson(), ...patch});
  Map<String, dynamic> toJson() => {
    'targetSleepMinutes': target,
    'targetBedtimeHour': bedtime ~/ 60,
    'targetBedtimeMinute': bedtime % 60,
    'targetWakeHour': wake ~/ 60,
    'targetWakeMinute': wake % 60,
    'windDownMinutes': windDown,
    'timezone': timezone,
    for (final key in ['showStages', 'showBiologicalClock', 'showRespiration'])
      key: show(key),
  };
}

class SleepTrend {
  const SleepTrend({this.days = const [], this.locked = false});
  final List<Map<String, dynamic>> days;
  final bool locked;
  num? average(String key) {
    final values = days
        .where((d) => d['hasData'] == true)
        .map((d) => d[key])
        .whereType<num>()
        .toList();
    return values.isEmpty
        ? null
        : values.reduce((a, b) => a + b) / values.length;
  }
}

class SleepSnapshot {
  const SleepSnapshot({
    required this.date,
    required this.preferences,
    this.session,
    this.summary = const {},
    this.vitals = const {},
    this.insight = const {},
    this.naps = const [],
    this.trend = const SleepTrend(),
    this.unavailable = const {},
  });
  final DateTime date;
  final SleepPreferences preferences;
  final SleepSession? session;
  final Map<String, dynamic> summary, vitals, insight;
  final List<SleepSession> naps;
  final SleepTrend trend;
  final Set<String> unavailable;
  bool get hasNight => session != null;
  num? value(SleepMetric metric) {
    final j = session?.json ?? const <String, dynamic>{};
    return switch (metric) {
      SleepMetric.duration => j['asleepMinutes'] as num?,
      SleepMetric.score => j['sleepScore'] as num?,
      SleepMetric.debt => summary['sleepDebtMinutes'] as num?,
      SleepMetric.consistency => summary['consistencyPercent'] as num?,
      SleepMetric.restlessness => j['wakeCount'] as num?,
      SleepMetric.nap =>
        unavailable.contains('naps')
            ? null
            : naps.fold<int>(0, (n, s) => n + (s.asleep ?? 0)),
      SleepMetric.efficiency => j['efficiencyPercent'] as num?,
      SleepMetric.latency => j['sleepLatencyMinutes'] as num?,
      SleepMetric.awake => j['awakeMinutes'] as num?,
      SleepMetric.light => j['lightSleepMinutes'] as num?,
      SleepMetric.deep => j['deepSleepMinutes'] as num?,
      SleepMetric.rem => j['remSleepMinutes'] as num?,
      SleepMetric.heartRate =>
        (vitals['averageBpm'] ?? j['avgHeartRate']) as num?,
      SleepMetric.hrv => j['hrvMs'] as num?,
      SleepMetric.oxygen => j['avgSpo2Percent'] as num?,
      SleepMetric.respiration || SleepMetric.temperature => null,
    };
  }

  String format(SleepMetric metric) {
    final n = value(metric);
    if (n == null) return '—';
    if ([
      SleepMetric.duration,
      SleepMetric.debt,
      SleepMetric.nap,
      SleepMetric.awake,
      SleepMetric.light,
      SleepMetric.deep,
      SleepMetric.rem,
    ].contains(metric)) {
      return sleepDuration(math.max(0, n));
    }
    final unit = switch (metric) {
      SleepMetric.efficiency ||
      SleepMetric.consistency ||
      SleepMetric.oxygen => '%',
      SleepMetric.heartRate => ' bpm',
      SleepMetric.hrv => ' ms',
      SleepMetric.latency => ' min',
      _ => '',
    };
    return '${n.round()}$unit';
  }

  SleepSnapshot withPreferences(SleepPreferences p) => SleepSnapshot(
    date: date,
    preferences: p,
    session: session,
    summary: summary,
    vitals: vitals,
    insight: insight,
    naps: naps,
    trend: trend,
    unavailable: unavailable,
  );
}

abstract interface class SleepRepository {
  Future<SleepSnapshot> load(DateTime date, String locale);
  Future<SleepTrend> trend(DateTime date, int days);
  Future<SleepSession> session(String id);
  Future<SleepPreferences> savePreferences(SleepPreferences preferences);
  Future<List<Map<String, dynamic>>> plans();
  Future<Map<String, dynamic>> savePlan(Map<String, dynamic> plan);
  Future<void> deletePlan(String id);
  void dispose();
}
