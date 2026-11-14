import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/sleep_models.dart';

/// Only installed by the explicit demo configuration. Source fixtures never
/// serve as fallback for an empty or failed real sleep API.
class DemoSleepRepository implements SleepRepository {
  DemoSleepRepository({DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;
  final DateTime Function() _clock;
  List<Map<String, dynamic>>? _rows;
  Future<List<Map<String, dynamic>>> _data() async => _rows ??= sleepMaps(
    jsonDecode(await rootBundle.loadString('assets/data/sleep-demo.json')),
  );
  int _offset(DateTime date) {
    final now = _clock();
    return DateTime.utc(
      now.year,
      now.month,
      now.day,
    ).difference(DateTime.utc(date.year, date.month, date.day)).inDays;
  }

  Future<SleepPreferences> _preferences() async {
    final raw = (await SharedPreferences.getInstance()).getString(
      'bynd.sleep.demo.preferences',
    );
    return SleepPreferences(
      raw == null
          ? {
              'targetBedtimeHour': 23,
              'targetWakeHour': 7,
              'targetWakeMinute': 0,
              'timezone': 'America/Sao_Paulo',
            }
          : sleepMap(jsonDecode(raw)),
    );
  }

  @override
  Future<SleepSnapshot> load(DateTime date, String locale) async {
    final data = await _data();
    final index = _offset(date);
    final row = index < 0 || index >= data.length
        ? <String, dynamic>{}
        : data[index];
    final j = sleepMap(row['session']);
    // Preserve source wall-clock times while mapping the demo to the requested day.
    final shift = DateTime.tryParse('${j['statDate']}');
    if (shift != null) {
      final delta =
          date.difference(DateTime(date.year, date.month, date.day)).inDays +
          DateTime(date.year, date.month, date.day).difference(shift).inDays;
      for (final key in ['startAt', 'endAt']) {
        final t = DateTime.tryParse('${j[key]}');
        if (t != null) j[key] = t.add(Duration(days: delta)).toIso8601String();
      }
    }
    return SleepSnapshot(
      date: date,
      preferences: await _preferences(),
      session: j.isEmpty ? null : SleepSession(j),
      summary: sleepMap(row['summary']),
      vitals: sleepMap(row['vitals']),
      insight: locale.startsWith('pt')
          ? sleepMap(row['insight'])
          : {
              'title': 'A night in perspective',
              'body':
                  'This is the reference app’s demonstration night. Your own sleep will appear after your band synchronizes.',
            },
      trend: await trend(date, 7),
    );
  }

  @override
  Future<SleepTrend> trend(DateTime date, int days) async {
    final data = await _data(), start = _offset(date);
    return SleepTrend(
      days: [
        for (var i = days - 1; i >= 0; i--)
          {
            'statDate': sleepDate(date.subtract(Duration(days: i))),
            if (start + i >= 0 && start + i < data.length)
              ...sleepMap(data[start + i]['summary'])
            else
              'hasData': false,
          },
      ],
    );
  }

  @override
  Future<SleepSession> session(String id) async => SleepSession(
    sleepMap(
      (await _data()).firstWhere(
        (r) => sleepMap(r['session'])['id'] == id,
      )['session'],
    ),
  );
  @override
  Future<SleepPreferences> savePreferences(SleepPreferences p) async {
    await (await SharedPreferences.getInstance()).setString(
      'bynd.sleep.demo.preferences',
      jsonEncode(p.toJson()),
    );
    return p;
  }

  @override
  Future<List<Map<String, dynamic>>> plans() async {
    final raw = (await SharedPreferences.getInstance()).getString(
      'bynd.sleep.demo.plans',
    );
    return raw == null ? [] : sleepMaps(jsonDecode(raw));
  }

  @override
  Future<Map<String, dynamic>> savePlan(Map<String, dynamic> p) async {
    final rows = await plans();
    final out = {
      ...p,
      'id': p['id'] ?? 'demo-${DateTime.now().microsecondsSinceEpoch}',
    };
    rows.removeWhere((r) => r['id'] == out['id']);
    rows.add(out);
    await (await SharedPreferences.getInstance()).setString(
      'bynd.sleep.demo.plans',
      jsonEncode(rows),
    );
    return out;
  }

  @override
  Future<void> deletePlan(String id) async {
    final rows = await plans();
    rows.removeWhere((r) => r['id'] == id);
    await (await SharedPreferences.getInstance()).setString(
      'bynd.sleep.demo.plans',
      jsonEncode(rows),
    );
  }

  @override
  void dispose() {}
}
