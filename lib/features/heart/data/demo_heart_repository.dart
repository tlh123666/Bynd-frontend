import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/network/api_client.dart';
import '../domain/heart_models.dart';

/// Reference persona fixtures only; never selected on real API failures.
class DemoHeartRepository implements HeartRepository {
  DemoHeartRepository({DateTime Function()? clock})
    : clock = clock ?? DateTime.now;
  final DateTime Function() clock;
  static const prefix = 'bynd.heart.demo.';
  List<Map<String, dynamic>>? _rows;
  Future<List<Map<String, dynamic>>> _data() async => _rows ??= heartMaps(
    jsonDecode(await rootBundle.loadString('assets/data/heart-demo.json')),
  );
  int _offset(DateTime date) {
    final n = clock();
    return DateTime.utc(
      n.year,
      n.month,
      n.day,
    ).difference(DateTime.utc(date.year, date.month, date.day)).inDays;
  }

  Future<HeartPreferences> _preferences() async {
    final raw = (await SharedPreferences.getInstance()).getString(
      '${prefix}preferences',
    );
    return HeartPreferences(
      raw == null
          ? {
              'showEstimatedPressure': true,
              'notifyHighResting': true,
              'notifyIrregularRhythm': true,
            }
          : heartMap(jsonDecode(raw)),
    );
  }

  @override
  Future<HeartSnapshot> load(DateTime date, String locale) async {
    final rows = await _data(),
        k = _offset(date),
        row = k >= 0 && k < rows.length ? rows[k] : <String, dynamic>{};
    final points = heartMaps(row['points'])
        .map(
          (p) => HeartPoint(
            DateTime(
              date.year,
              date.month,
              date.day,
            ).add(Duration(minutes: (p['minute'] as num).round())),
            (p['bpm'] as num).round(),
          ),
        )
        .toList();
    return HeartSnapshot(
      date: date,
      experience: {
        'summary': {...heartMap(row['summary']), 'sampleCount': points.length},
        'latestSample': points.isEmpty
            ? {}
            : {
                'bpm': points.last.bpm,
                'measuredAt': points.last.at.toIso8601String(),
              },
        'baseline': {'lower': 51, 'upper': 56, 'days': 28},
        'alerts': {
          'observedNights': 30,
          'aboveBaselineNights': 0,
          'rhythmClassificationAvailable': false,
        },
        ...heartMap(row['summary']),
        'systolicBp': heartMap(row['summary'])['avgSystolicBp'],
        'diastolicBp': heartMap(row['summary'])['avgDiastolicBp'],
      },
      preferences: await _preferences(),
      points: points,
      records: (await recordings(date: date)).items,
      trend: await trend(date, 7),
      demo: true,
    );
  }

  @override
  Future<HeartTrend> trend(DateTime date, int days) async {
    final rows = await _data(), start = _offset(date);
    return HeartTrend(
      days: [
        for (var i = days - 1; i >= 0; i--)
          {
            'statDate': heartDate(date.subtract(Duration(days: i))),
            'hasData': start + i >= 0 && start + i < rows.length,
            'hasHealthData': start + i >= 0 && start + i < rows.length,
            if (start + i >= 0 && start + i < rows.length) ...{
              ...heartMap(rows[start + i]['summary']),
              'systolicBp': heartMap(
                rows[start + i]['summary'],
              )['avgSystolicBp'],
              'diastolicBp': heartMap(
                rows[start + i]['summary'],
              )['avgDiastolicBp'],
            },
          },
      ],
    );
  }

  @override
  Future<HeartPreferences> savePreferences(HeartPreferences p) async {
    await (await SharedPreferences.getInstance()).setString(
      '${prefix}preferences',
      jsonEncode(p.toJson()),
    );
    return p;
  }

  Future<List<Map<String, dynamic>>> _records() async {
    final p = await SharedPreferences.getInstance(),
        raw = p.getString('${prefix}records');
    if (raw != null) return heartMaps(jsonDecode(raw));
    final now = clock();
    return [
      for (var i = 0; i < 8; i++)
        {
          'id': 'demo-ecg-$i',
          'deviceSerial': 'DEMONSTRATION',
          'measuredAt': DateTime(
            now.year,
            now.month,
            now.day - i * 6,
            11,
            20,
          ).toIso8601String(),
          'durationMillis': 30000,
          'sampleRateHz': 100,
          'sampleCount': 3000,
          'waveformStatus': 'available',
          'waveformKind': 'ecg',
          'measurementContext': 'rest',
          'symptoms': <String>[],
          'heartRate': i == 3 ? 104 : 64 + i % 4,
          'source': 'demo',
          'samples': demoHeartWaveform(),
        },
    ];
  }

  Future<void> _write(List<Map<String, dynamic>> rows) async {
    await (await SharedPreferences.getInstance()).setString(
      '${prefix}records',
      jsonEncode(rows),
    );
  }

  @override
  Future<HeartRecordPage> recordings({DateTime? date, String? cursor}) async {
    final rows = (await _records())
        .where(
          (r) =>
              date == null ||
              heartDate(DateTime.parse('${r['measuredAt']}')) ==
                  heartDate(date),
        )
        .toList();
    return HeartRecordPage(
      rows.map((r) => HeartRecording({...r}..remove('samples'))).toList(),
    );
  }

  @override
  Future<HeartRecording> recording(String id) async {
    final row = (await _records()).where((r) => r['id'] == id).firstOrNull;
    if (row == null) throw const ApiException('Recording not found');
    return HeartRecording(row);
  }

  @override
  Future<HeartRecording> createRecording(Map<String, dynamic> payload) async {
    final rows = await _records(),
        prior = rows
            .where((r) => r['clientRequestId'] == payload['clientRequestId'])
            .firstOrNull;
    if (prior != null) return HeartRecording(prior);
    final row = {
      ...payload,
      'id': 'demo-${payload['clientRequestId']}',
      'source': 'demo',
      'waveformStatus': 'available',
      'sampleCount': (payload['samples'] as List).length,
      'measurementContext': 'rest',
      'symptoms': <String>[],
    };
    await _write([row, ...rows]);
    return HeartRecording(row);
  }

  @override
  Future<HeartRecording> annotate(
    String id,
    String context,
    List<String> symptoms,
  ) async {
    final rows = await _records(),
        index = rows.indexWhere((r) => r['id'] == id);
    if (index < 0) throw const ApiException('Recording not found');
    rows[index] = {
      ...rows[index],
      'measurementContext': context,
      'symptoms': symptoms,
    };
    await _write(rows);
    return HeartRecording(rows[index]);
  }

  @override
  Future<void> deleteRecording(String id) async {
    final rows = await _records();
    rows.removeWhere((r) => r['id'] == id);
    await _write(rows);
  }

  @override
  void dispose() {}
}

/// Same P/QRS/T demonstration as the reference; never used by the real driver.
List<int> demoHeartWaveform() => List.generate(3000, (i) {
  final phase = (i / 100 % (60 / 64)) / (60 / 64);
  double g(double c, double w, double a) =>
      a * math.exp(-math.pow(phase - c, 2) / (2 * w * w));
  return ((g(.18, .025, 6) -
              g(.30, .008, 6) +
              g(.32, .01, 34) -
              g(.345, .01, 11) +
              g(.55, .045, 9)) *
          100)
      .round();
});
