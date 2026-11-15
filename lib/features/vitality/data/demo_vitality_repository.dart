import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/vitality_models.dart';

/// Original reference values, explicitly confined to DEMO_DATA.
class DemoVitalityRepository implements VitalityRepository {
  DemoVitalityRepository({DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;
  final DateTime Function() _clock;
  static const _key = 'bynd.vitality.demo.preferences.v1';
  @override
  Future<VitalitySnapshot> load(
    VitalityKind kind,
    DateTime date, {
    int days = 7,
  }) async {
    final raw =
        jsonDecode(
              await rootBundle.loadString('assets/data/vitality-demo.json'),
            )
            as List;
    final prefs = await SharedPreferences.getInstance();
    final settings = VitalityPreferences(
      jsonDecode(prefs.getString(_key) ?? '{}') as Map<String, dynamic>,
    );
    final now = _clock(), today = DateTime(now.year, now.month, now.day);
    final offset = vitalityDayDistance(today, date);
    double? value(int day) {
      if (day < 0 || day >= raw.length) return null;
      final row = raw[day] as Map;
      final score = vitalityValue(row[kind.name]);
      if (score == null) return null;
      return kind == VitalityKind.recovery && !settings.flag('considerTraining')
          ? (score + (vitalityValue(row['trainingLoad']) ?? 0) * .15)
                .clamp(0, 100)
                .toDouble()
          : score;
    }

    final row = offset < 0 || offset >= raw.length
        ? <String, dynamic>{}
        : Map<String, dynamic>.from(raw[offset] as Map);
    final score = value(offset);
    double? mean(int start) {
      final values = List.generate(
        7,
        (i) => value(start + i),
      ).whereType<double>().toList();
      return values.isEmpty
          ? null
          : values.reduce((a, b) => a + b) / values.length;
    }

    final curve = (row['energyCurve'] as List? ?? []).map((r) {
      final hour = (r['hour'] as num).toDouble();
      return VitalityPoint(
        DateTime(
          date.year,
          date.month,
          date.day,
          hour.floor(),
          ((hour % 1) * 60).round(),
        ),
        vitalityValue(r['score']),
      );
    }).toList();
    final until = DateTime(date.year, date.month, date.day, 15, 30);
    final metrics = Map<String, dynamic>.from(row['metrics'] as Map? ?? {});
    if (metrics['respiratoryRate'] is String) {
      metrics['respiratoryRate'] = double.tryParse(
        (metrics['respiratoryRate'] as String).replaceAll(',', '.'),
      );
    }
    return VitalitySnapshot(
      kind: kind,
      date: date,
      score: score,
      yesterday: value(offset + 1),
      average: mean(offset),
      previousAverage: mean(offset + 7),
      baselineLow: score == null ? null : 67,
      baselineHigh: score == null ? null : 85,
      baselineDays: score == null ? 0 : 28,
      trainingLoad: vitalityValue(row['trainingLoad']),
      metrics: metrics,
      trend: List.generate(days, (i) {
        final n = days - 1 - i;
        return VitalityPoint(vitalityShiftDay(date, -n), value(offset + n));
      }),
      observations: kind == VitalityKind.energy
          ? curve.where((p) => !p.at.isAfter(until)).toList()
          : [],
      forecast: kind == VitalityKind.energy
          ? curve
                .where(
                  (p) =>
                      !p.at.isBefore(until) &&
                      [15.5, 18.0, 21.0].contains(p.at.hour + p.at.minute / 60),
                )
                .toList()
          : [
              for (final (i, v)
                  in (row['forecastRecovery'] as List? ?? []).indexed)
                VitalityPoint(
                  vitalityShiftDay(date, i),
                  vitalityValue(v) == null
                      ? null
                      : (vitalityValue(v)! +
                                (score ?? 0) -
                                (vitalityValue(row[kind.name]) ?? 0))
                            .clamp(0, 100)
                            .toDouble(),
                ),
            ],
      preferences: settings,
      demo: true,
      lastSyncAt: score == null ? null : until,
    );
  }

  @override
  Future<VitalityPreferences> savePreferences(VitalityPreferences p) async {
    await (await SharedPreferences.getInstance()).setString(
      _key,
      jsonEncode(p.toJson()),
    );
    return p;
  }

  @override
  void dispose() {}
}
