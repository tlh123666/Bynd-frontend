import 'heart_models.dart';

/// Timestamped V8 facts only. Cached top-level metrics have no measurement
/// time and must not be stamped as today's HRV, oxygen or blood pressure.
Map<String, List<Map<String, dynamic>>> heartVitalsFromHistory(
  Map<String, dynamic> history,
) {
  final unique = <String, Map<String, dynamic>>{};
  int? integer(Object? v) => v is num ? v.round() : num.tryParse('$v')?.round();
  void put(
    String type,
    DateTime at, {
    num? value,
    String? unit,
    Map<String, dynamic>? payload,
  }) {
    final record = <String, dynamic>{
      'metricType': type,
      'valueType': 'sample',
      'statDate': heartDate(at),
      'measuredAt': at.toUtc().toIso8601String(),
      'unit': unit,
      'value': ?value,
      'payload': ?payload,
    };
    unique['${at.toUtc().toIso8601String()}:$type'] = record;
  }

  for (final r in heartMaps(history['hrv'])) {
    final at = DateTime.tryParse('${r['date']}'.replaceAll('.', '-'));
    if (at == null) continue;
    final hrv = integer(r['hrv']);
    if (hrv != null && hrv > 0 && hrv <= 500) {
      put('hrv', at, value: hrv, unit: 'ms');
    }
    final high = integer(r['highBP'] ?? r['highPressure']),
        low = integer(r['lowBP'] ?? r['lowPressure']);
    if (high != null &&
        low != null &&
        high >= 50 &&
        high <= 260 &&
        low >= 30 &&
        low <= 180 &&
        high > low) {
      put(
        'blood_pressure',
        at,
        unit: 'mmHg',
        payload: {'systolic': high, 'diastolic': low},
      );
    }
  }
  for (final r in heartMaps(history['bloodOxygen'])) {
    final at = DateTime.tryParse('${r['date']}'.replaceAll('.', '-')),
        oxygen = integer(r['Blood_oxygen']);
    if (at != null && oxygen != null && oxygen >= 50 && oxygen <= 100) {
      put('spo2', at, value: oxygen, unit: '%');
    }
  }
  final rows = unique.values.toList()
    ..sort((a, b) {
      final time = '${a['measuredAt']}'.compareTo('${b['measuredAt']}');
      return time != 0
          ? time
          : '${a['metricType']}'.compareTo('${b['metricType']}');
    });
  final grouped = <String, List<Map<String, dynamic>>>{};
  for (final r in rows) {
    grouped.putIfAbsent('${r['statDate']}', () => []).add(r);
  }
  return grouped;
}
