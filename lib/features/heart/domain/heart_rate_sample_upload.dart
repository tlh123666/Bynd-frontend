/// One timestamped heart-rate reading ready for the heart-rate time series.
class HeartRateSampleUpload {
  const HeartRateSampleUpload({
    required this.measuredAt,
    required this.bpm,
    required this.context,
  });

  final DateTime measuredAt;
  final int bpm;
  final String context;

  Map<String, dynamic> toJson() => {
    'measuredAt': measuredAt.toUtc().toIso8601String(),
    'bpm': bpm,
    'context': context,
  };
}

/// A single, idempotent batch of readings from a bound wearable.
class HeartRateSampleUploadCommand {
  const HeartRateSampleUploadCommand({
    required this.timezone,
    required this.deviceSerial,
    required this.samples,
    this.deviceId,
  });

  final String timezone;
  final String deviceSerial;
  final String? deviceId;
  final List<HeartRateSampleUpload> samples;

  bool get isEmpty => samples.isEmpty;

  Map<String, dynamic> toJson() => {
    'timezone': timezone,
    'deviceSerial': deviceSerial,
    if (deviceId != null && deviceId!.trim().isNotEmpty) 'deviceId': deviceId,
    'source': 'device',
    'samples': [for (final sample in samples) sample.toJson()],
  };
}

/// Expands the V8 SDK's compact history records into timestamped readings.
///
/// Dynamic history records contain a starting local timestamp and consecutive
/// 10-second values. One-time history is retained separately as `manual`, so a
/// reading at the same moment cannot collide with a continuous sample.
List<HeartRateSampleUpload> heartRateSamplesFromHistory(
  Map<String, List<Map<String, dynamic>>> history,
) {
  final samples = <HeartRateSampleUpload>[];
  final seen = <String>{};

  void add(DateTime at, int bpm, String context) {
    if (bpm < 20 || bpm > 250) return;
    final measuredAt = at.toUtc();
    final key = '${measuredAt.microsecondsSinceEpoch}:$context';
    if (!seen.add(key)) return;
    samples.add(
      HeartRateSampleUpload(measuredAt: measuredAt, bpm: bpm, context: context),
    );
  }

  for (final record in history['dynamicHeartRate'] ?? const []) {
    final start = _bandLocalDate(record['date']);
    if (start == null) continue;
    final values = _numbers(record['arrayDynamicHR']);
    for (var index = 0; index < values.length; index++) {
      add(
        start.add(Duration(seconds: index * 10)),
        values[index],
        'continuous',
      );
    }
  }

  for (final record in history['staticHeartRate'] ?? const []) {
    final measuredAt = _bandLocalDate(record['date']);
    final bpm = _number(record['staticHR']);
    if (measuredAt != null && bpm != null) add(measuredAt, bpm, 'manual');
  }

  samples.sort((left, right) => left.measuredAt.compareTo(right.measuredAt));
  return List<HeartRateSampleUpload>.unmodifiable(samples);
}

DateTime? _bandLocalDate(Object? value) {
  final text = value?.toString().trim();
  if (text == null || text.isEmpty) return null;
  // V8 exposes `yyyy.MM.dd HH:mm:ss` without a zone; it is the band/phone's
  // local clock, so DateTime parses it as local before we convert to UTC.
  return DateTime.tryParse(text.replaceAll('.', '-'));
}

List<int> _numbers(Object? value) {
  if (value is Iterable) return value.map((v) => _number(v) ?? 0).toList();
  return value
          ?.toString()
          .split(RegExp(r'[\s,\[\]]+'))
          .where((v) => v.isNotEmpty)
          .map((v) => _number(v) ?? 0)
          .toList() ??
      const [];
}

int? _number(Object? value) => int.tryParse(value?.toString().trim() ?? '');
