import 'package:new_jcvital/features/diary/data/demo_diary_repository.dart';
import 'package:new_jcvital/features/diary/domain/diary_models.dart';
import 'package:new_jcvital/features/sleep/data/demo_sleep_repository.dart';
import 'package:new_jcvital/features/sleep/domain/sleep_models.dart';

Map<String, dynamic> sleepSessionFixture() => {
  'id': '00000000-0000-4000-8000-000000000001',
  'sessionType': 'night',
  'statDate': '2026-11-14',
  'startAt': '2026-11-13T23:00:00Z',
  'endAt': '2026-11-14T07:00:00Z',
  'durationMinutes': 480,
  'asleepMinutes': 450,
  'awakeMinutes': 30,
  'lightSleepMinutes': 240,
  'deepSleepMinutes': 100,
  'remSleepMinutes': 110,
  'sleepLatencyMinutes': 10,
  'wakeCount': 2,
  'efficiencyPercent': 93.75,
  'sleepScore': 82,
  'avgHeartRate': 62,
  'hrvMs': 54,
  'avgSpo2Percent': 97,
  'dataQuality': 'normal',
  'segments': [
    {'stage': 'awake', 'offset': 0, 'minutes': 10},
    {'stage': 'deep', 'offset': 10, 'minutes': 100},
    {'stage': 'light', 'offset': 110, 'minutes': 120},
    {'stage': 'rem', 'offset': 250, 'minutes': 110},
    {'stage': 'light', 'offset': 360, 'minutes': 120},
  ],
};
SleepSnapshot sleepSnapshotFixture(
  DateTime date, {
  bool empty = false,
  SleepTrend? history,
}) => SleepSnapshot(
  date: date,
  preferences: const SleepPreferences({
    'targetBedtimeHour': 23,
    'targetBedtimeMinute': 0,
    'targetWakeHour': 7,
    'targetWakeMinute': 0,
    'timezone': 'UTC',
  }),
  session: empty ? null : SleepSession(sleepSessionFixture()),
  summary: empty ? {} : {'sleepDebtMinutes': 90, 'sleepDebtNights': 2},
  insight: {'title': 'Sua noite', 'body': 'Seu descanso registrado.'},
  trend:
      history ??
      SleepTrend(
        days: [
          for (var i = 6; i >= 0; i--)
            {
              'statDate': sleepDate(date.subtract(Duration(days: i))),
              'hasData': i != 3,
              'sleepScore': i == 3 ? null : 82,
              'sleepMinutes': i == 3 ? null : 450,
            },
        ],
      ),
);

class MemorySleepRepository extends DemoSleepRepository {
  int loads = 0, saves = 0;
  bool failSave = false, empty = false;
  SleepPreferences? saved;
  SleepTrend? history;
  Future<SleepSnapshot> Function(DateTime date)? onLoad;
  @override
  Future<SleepSnapshot> load(DateTime date, String locale) async {
    loads++;
    return onLoad == null
        ? sleepSnapshotFixture(date, empty: empty, history: history)
        : onLoad!(date);
  }

  @override
  Future<SleepTrend> trend(DateTime date, int days) async =>
      history ?? sleepSnapshotFixture(date).trend;
  @override
  Future<SleepSession> session(String id) async =>
      SleepSession(sleepSessionFixture());
  @override
  Future<SleepPreferences> savePreferences(SleepPreferences p) async {
    if (failSave) throw StateError('offline');
    saves++;
    saved = p;
    return p;
  }

  final planRows = <Map<String, dynamic>>[];
  @override
  Future<List<Map<String, dynamic>>> plans() async => planRows;
  @override
  Future<Map<String, dynamic>> savePlan(Map<String, dynamic> plan) async {
    final out = {...plan, 'id': plan['id'] ?? 'test-plan'};
    planRows.removeWhere((p) => p['id'] == out['id']);
    planRows.add(out);
    return out;
  }

  @override
  Future<void> deletePlan(String id) async {
    planRows.removeWhere((p) => p['id'] == id);
  }
}

class MemorySleepDiary extends DemoDiaryRepository {
  @override
  Future<DiaryDay> load(DateTime d) async => DiaryDay(date: d, events: []);
  @override
  Future<List<DiaryTracker>> catalog() async => [
    for (final key in ['cafe15', 'alc', 'tela'])
      DiaryTracker({
        'key': key,
        'label': key,
        'kind': 'boolean',
        'category': 'custom',
      }),
  ];
}
