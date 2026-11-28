import 'dart:async';
import 'package:new_jcvital/features/heart/data/demo_heart_repository.dart';
import 'package:new_jcvital/features/heart/data/heart_band_gateway.dart';
import 'package:new_jcvital/features/heart/domain/heart_models.dart';
import 'package:new_jcvital/features/device/domain/device_models.dart';
import 'package:new_jcvital/features/diary/data/demo_diary_repository.dart';
import 'package:new_jcvital/features/diary/domain/diary_models.dart';

HeartRecording heartRecordingFixture({
  String kind = 'ppg',
  String status = 'available',
}) => HeartRecording({
  'id': '00000000-0000-4000-8000-000000000001',
  'deviceSerial': 'B1',
  'clientRequestId': 'request-1',
  'measuredAt': '2026-11-14T07:00:00Z',
  'durationMillis': 30000,
  'sampleCount': 300,
  'waveformStatus': status,
  'waveformKind': kind,
  'heartRate': 64,
  'measurementContext': 'rest',
  'symptoms': <String>[],
  'samples': [for (var i = 0; i < 300; i++) i % 70],
});

/// 40 full oscillation cycles — passes the capture quality gate so tests
/// that complete a recording exercise the real save path.
List<int> validCaptureWaveform() => [
  for (var c = 0; c < 40; c++)
    for (var i = 0; i < 50; i++) (i < 25 ? i * 8 : (49 - i) * 8),
];
HeartSnapshot heartSnapshotFixture(
  DateTime date, {
  bool empty = false,
  HeartPreferences? preferences,
  HeartTrend? trend,
}) => HeartSnapshot(
  date: date,
  preferences: preferences ?? const HeartPreferences({}),
  experience: {
    'summary': empty
        ? {}
        : {
            'sampleCount': 3,
            'avgHeartRate': 70,
            'minHeartRate': 58,
            'maxHeartRate': 122,
            'restingHeartRate': 58,
          },
    'latestSample': empty
        ? {}
        : {'measuredAt': '${heartDate(date)}T15:30:00Z', 'bpm': 68},
    'hrvMs': empty ? null : 54,
    'spo2Percent': empty ? null : 97,
    'systolicBp': empty ? null : 119,
    'diastolicBp': empty ? null : 75,
    'recoveryOneMinute': empty ? null : 28,
    'baseline': {'days': 7, 'lower': 51, 'upper': 56},
    'alerts': {'aboveBaselineNights': 2, 'observedNights': 10},
  },
  points: empty
      ? []
      : [
          HeartPoint(DateTime(date.year, date.month, date.day, 1), 60),
          HeartPoint(DateTime(date.year, date.month, date.day, 1, 1), 64),
          HeartPoint(DateTime(date.year, date.month, date.day, 1, 2), 72),
        ],
  records: empty ? [] : [heartRecordingFixture()],
  trend:
      trend ??
      HeartTrend(
        days: [
          for (var i = 6; i >= 0; i--)
            {
              'statDate': heartDate(date.subtract(Duration(days: i))),
              'hasData': i != 2,
              'restingHeartRate': i == 2 ? null : 58,
              'avgHeartRate': i == 2 ? null : 70,
            },
        ],
      ),
  demo: true,
);

class MemoryHeartRepository extends DemoHeartRepository {
  int loads = 0, saves = 0, creates = 0, annotations = 0;
  bool empty = false,
      failSave = false,
      failCreate = false,
      failAnnotation = false;
  HeartPreferences preferences = const HeartPreferences({});
  HeartRecording savedRecord = heartRecordingFixture();
  HeartTrend? history;
  Future<HeartSnapshot> Function(DateTime)? onLoad;
  final payloads = <Map<String, dynamic>>[];
  final Map<String, HeartRecording> stored = {};
  @override
  Future<HeartSnapshot> load(DateTime date, String locale) async {
    loads++;
    return onLoad != null
        ? onLoad!(date)
        : heartSnapshotFixture(
            date,
            empty: empty,
            preferences: preferences,
            trend: history,
          );
  }

  @override
  Future<HeartTrend> trend(DateTime date, int days) async =>
      history ?? heartSnapshotFixture(date).trend;
  @override
  Future<HeartPreferences> savePreferences(HeartPreferences p) async {
    if (failSave) throw StateError('offline');
    saves++;
    return preferences = p;
  }

  @override
  Future<HeartRecording> recording(String id) async =>
      stored[id] ?? savedRecord;
  @override
  Future<HeartRecordPage> recordings({DateTime? date, String? cursor}) async =>
      HeartRecordPage([savedRecord]);
  @override
  Future<HeartRecording> createRecording(Map<String, dynamic> payload) async {
    creates++;
    payloads.add(Map.of(payload));
    if (failCreate) throw StateError('offline');
    return savedRecord = HeartRecording({
      ...payload,
      'id': 'created-record',
      'waveformStatus': 'available',
      'sampleCount': (payload['samples'] as List).length,
      'measurementContext': 'rest',
      'symptoms': <String>[],
    });
  }

  @override
  Future<HeartRecording> annotate(
    String id,
    String context,
    List<String> symptoms,
  ) async {
    if (failAnnotation) throw StateError('offline');
    annotations++;
    return savedRecord = HeartRecording({
      ...savedRecord.json,
      'measurementContext': context,
      'symptoms': symptoms,
    });
  }

  @override
  Future<void> deleteRecording(String id) async {
    stored.remove(id);
  }
}

class MemoryHeartDiary extends DemoDiaryRepository {
  DiaryDay day = DiaryDay(date: DateTime(2026, 11, 14), events: const []);
  @override
  Future<DiaryDay> load(DateTime date) async => DiaryDay(
    date: date,
    events: day.events,
    note: day.note,
    revision: day.revision,
  );
  @override
  Future<List<DiaryTracker>> catalog() async => [
    for (final k in ['c_palpit', 'c_sal', 'alc'])
      DiaryTracker({'key': k, 'label': k, 'kind': 'boolean'}),
  ];
  @override
  Future<DiaryDay> save(
    DiaryDay base,
    List<DiaryMoment> events,
    String note,
    String mutationId,
  ) async => day = DiaryDay(
    date: base.date,
    events: events,
    note: note,
    revision: base.revision + 1,
  );
}

class FakeHeartGateway implements HeartBandGateway {
  final stream = StreamController<Map<String, dynamic>>.broadcast(sync: true);
  int stops = 0;
  final startedDevices = <DeviceSnapshot>[];
  bool disposed = false;
  Completer<void>? startWait;
  Completer<void>? stopWait;
  Map<String, dynamic> history = {};
  @override
  bool get supported => true;
  @override
  Stream<Map<String, dynamic>> get events => stream.stream;
  void emit(Map<String, dynamic> event) {
    if (!disposed) stream.add(event);
  }

  @override
  Future<void> start(DeviceSnapshot device) async {
    startedDevices.add(device);
    if (startWait != null) await startWait!.future;
    emit({'event': 'ecg_started'});
  }

  @override
  Future<void> stop() async {
    stops++;
    if (stopWait != null) await stopWait!.future;
  }

  @override
  Future<Map<String, dynamic>> readHistory(DeviceSnapshot device) async =>
      history;
  @override
  Future<Map<String, dynamic>> measureSpo2Now(DeviceSnapshot device) async => {
    'spo2': 97,
    'heartRate': 64,
  };
  @override
  void dispose() {
    if (!disposed) {
      disposed = true;
      stream.close();
    }
  }
}
