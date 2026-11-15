import 'dart:math' as math;

Map<String, dynamic> heartMap(dynamic v) =>
    v is Map ? Map<String, dynamic>.from(v) : {};
List<Map<String, dynamic>> heartMaps(dynamic v) => v is List
    ? v.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList()
    : [];
String heartDate(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

enum HeartMetric {
  pulse,
  resting,
  hrv,
  oxygen,
  pressure,
  recovery,
  respiration,
}

enum HeartPeriod { day, week, month }

extension HeartMetricField on HeartMetric {
  String get field => switch (this) {
    HeartMetric.pulse => 'avgHeartRate',
    HeartMetric.resting => 'restingHeartRate',
    HeartMetric.hrv => 'hrvMs',
    HeartMetric.oxygen => 'spo2Percent',
    HeartMetric.pressure => 'systolicBp',
    HeartMetric.recovery => 'recoveryOneMinute',
    HeartMetric.respiration => 'respiratoryRate',
  };
  String get unit => switch (this) {
    HeartMetric.hrv => 'ms',
    HeartMetric.oxygen => '%',
    HeartMetric.pressure => 'mmHg',
    HeartMetric.respiration => 'rpm',
    _ => 'bpm',
  };
}

class HeartPreferences {
  const HeartPreferences(this.json);
  final Map<String, dynamic> json;
  bool get pressure => json['showEstimatedPressure'] != false;
  bool get high => json['notifyHighResting'] != false;
  bool get irregular => json['notifyIrregularRhythm'] == true;
  Map<String, dynamic> toJson() => {
    'showEstimatedPressure': pressure,
    'notifyHighResting': high,
    'notifyIrregularRhythm': irregular,
  };
  HeartPreferences copy(String key, bool v) =>
      HeartPreferences({...toJson(), key: v});
}

class HeartPoint {
  const HeartPoint(this.at, this.bpm);
  final DateTime at;
  final int bpm;
  factory HeartPoint.fromJson(Map<String, dynamic> j) => HeartPoint(
    DateTime.parse('${j['measuredAt']}').toLocal(),
    (j['bpm'] as num).round(),
  );
}

class HeartTrend {
  const HeartTrend({this.days = const [], this.locked = false});
  final List<Map<String, dynamic>> days;
  final bool locked;
  List<num> values(HeartMetric m) => days
      .where((d) => d['hasData'] == true || d['hasHealthData'] == true)
      .map((d) => d[m.field])
      .whereType<num>()
      .toList();
  num? average(HeartMetric m) {
    final v = values(m);
    return v.isEmpty ? null : v.reduce((a, b) => a + b) / v.length;
  }
}

class HeartRecording {
  const HeartRecording(this.json);
  final Map<String, dynamic> json;
  String get id => '${json['id'] ?? ''}';
  DateTime get measuredAt => DateTime.parse('${json['measuredAt']}').toLocal();
  int? number(String k) => (json[k] as num?)?.round();
  int get duration => number('durationMillis') ?? 0;
  String get kind => '${json['waveformKind'] ?? 'unknown'}';
  String get context => '${json['measurementContext'] ?? 'rest'}';
  List<String> get symptoms => (json['symptoms'] as List? ?? []).cast<String>();
  String get status => '${json['waveformStatus'] ?? 'unavailable'}';
  List<int> get samples => (json['samples'] as List? ?? [])
      .whereType<num>()
      .map((n) => n.round())
      .toList();
  bool get available => status == 'available' && samples.isNotEmpty;
  String get label => kind == 'ppg'
      ? 'PPG'
      : kind == 'ecg'
      ? 'ECG'
      : 'SENSOR';
}

class HeartRecordPage {
  const HeartRecordPage(this.items, {this.next});
  final List<HeartRecording> items;
  final String? next;
}

class HeartSnapshot {
  const HeartSnapshot({
    required this.date,
    required this.experience,
    required this.preferences,
    this.points = const [],
    this.records = const [],
    this.trend = const HeartTrend(),
    this.unavailable = const {},
    this.demo = false,
  });
  final DateTime date;
  final Map<String, dynamic> experience;
  final HeartPreferences preferences;
  final List<HeartPoint> points;
  final List<HeartRecording> records;
  final HeartTrend trend;
  final Set<String> unavailable;
  final bool demo;
  Map<String, dynamic> get summary => heartMap(experience['summary']);
  Map<String, dynamic> get baseline => heartMap(experience['baseline']);
  Map<String, dynamic> get alerts => heartMap(experience['alerts']);
  Map<String, dynamic> get latest => heartMap(experience['latestSample']);
  bool get hasData =>
      summary['sampleCount'] is num && (summary['sampleCount'] as num) > 0 ||
      points.isNotEmpty;
  DateTime? get latestAt =>
      DateTime.tryParse('${latest['measuredAt']}')?.toLocal();
  bool fresh(DateTime now) =>
      latestAt != null &&
      now.difference(latestAt!).inSeconds >= 0 &&
      now.difference(latestAt!).inMinutes < 5;
  num? value(HeartMetric metric) => switch (metric) {
    HeartMetric.pulse => (latest['bpm'] ?? summary['avgHeartRate']) as num?,
    HeartMetric.resting => summary['restingHeartRate'] as num?,
    HeartMetric.hrv => (experience['hrvMs'] ?? summary['hrvMs']) as num?,
    HeartMetric.oxygen => experience['spo2Percent'] as num?,
    HeartMetric.pressure => experience['systolicBp'] as num?,
    HeartMetric.recovery => experience['recoveryOneMinute'] as num?,
    HeartMetric.respiration => experience['respiratoryRate'] as num?,
  };
  String format(HeartMetric metric) {
    final n = value(metric);
    if (n == null) return '—';
    if (metric == HeartMetric.pressure) {
      final d = experience['diastolicBp'];
      return d == null ? '—' : '${n.round()}/${(d as num).round()}';
    }
    if (metric == HeartMetric.recovery) {
      return n >= 0 ? '−${n.round()}' : '+${n.abs().round()}';
    }
    return metric == HeartMetric.respiration
        ? n.toStringAsFixed(1)
        : n.round().toString();
  }

  HeartSnapshot withPreferences(HeartPreferences p) => HeartSnapshot(
    date: date,
    experience: experience,
    preferences: p,
    points: points,
    records: records,
    trend: trend,
    unavailable: unavailable,
    demo: demo,
  );
}

abstract interface class HeartRepository {
  Future<HeartSnapshot> load(DateTime date, String locale);
  Future<HeartTrend> trend(DateTime date, int days);
  Future<HeartPreferences> savePreferences(HeartPreferences p);
  Future<HeartRecordPage> recordings({DateTime? date, String? cursor});
  Future<HeartRecording> recording(String id);
  Future<HeartRecording> createRecording(Map<String, dynamic> payload);
  Future<HeartRecording> annotate(
    String id,
    String context,
    List<String> symptoms,
  );
  Future<void> deleteRecording(String id);
  void dispose();
}

List<HeartPoint> downsampleHeartPoints(List<HeartPoint> points, int limit) {
  if (points.length <= limit) return points;
  return [
    for (var i = 0; i < limit; i++)
      points[(i * (points.length - 1) / math.max(1, limit - 1)).round()],
  ];
}
