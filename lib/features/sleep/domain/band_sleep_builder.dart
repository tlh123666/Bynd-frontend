// Ported without algorithm changes from JCVital/shared/band/sleep_session_builder.dart.
enum SleepStageType { awake, rem, light, deep }

class SleepStageSpan {
  const SleepStageSpan({
    required this.stage,
    required this.offsetMinutes,
    required this.minutes,
  });
  final SleepStageType stage;
  final int offsetMinutes, minutes;
  int get endOffsetMinutes => offsetMinutes + minutes;
}

/// Turns the band's raw sleep history into stitched sleep sessions.
///
/// `GetDetailSleepData` returns records that each cover **at most two hours**, so
/// a whole night arrives as several records that have to be joined back into one
/// session before it can be uploaded — the backend stores sessions, not device
/// records, and says so in `user_sleep_sessions`' table comment ("app 端进行数据补偿").
///
/// Everything here is pure: no IO, no clock, no platform channels.

/// Fallback granularity when the record does not carry `sleepUnitLength`.
const int kDefaultSleepUnitMinutes = 5;

/// How large a hole between two device records may be before they stop being the
/// same session. A nightly sync that drops out for a few minutes is still one
/// night; a gap this wide means the band was not recording at all.
const Duration kSleepRecordGapTolerance = Duration(minutes: 30);

/// Whether a device record's `date` marks the **start** of its two-hour window
/// rather than its end.
///
/// The protocol doc does not say which, and the two readings shift every
/// timestamp by up to two hours. This follows the reading the rest of the app
/// already uses (`BandInsightsBuilder._sleepStartHour` takes `date` as bedtime),
/// and is isolated here so a single flip corrects it everywhere if a real device
/// proves otherwise.
const bool kSleepRecordDateIsWindowStart = true;

/// One stitched session, ready to be uploaded.
class SleepSessionDraft {
  const SleepSessionDraft({
    required this.clientRequestId,
    required this.startAt,
    required this.endAt,
    required this.stageIntervalMinutes,
    required this.segments,
  });

  /// Idempotency key, derived from `(deviceSerial, startAt)`.
  ///
  /// Deterministic on purpose: the server's unique key is
  /// `(user_id, device_serial, start_at)`, so a re-sync lands on the same row
  /// instead of inserting a second copy of last night.
  final String clientRequestId;

  /// UTC, inclusive.
  final DateTime startAt;

  /// UTC, exclusive.
  final DateTime endAt;

  /// Granularity the band reported stages at, in minutes.
  final int stageIntervalMinutes;

  /// Ordered by [SleepStageSpan.offsetMinutes]; offsets may jump over gaps.
  final List<SleepStageSpan> segments;

  Duration get duration => endAt.difference(startAt);
}

/// Per-stage minute totals, used to fill the daily health summary.
class SleepStageTotals {
  const SleepStageTotals({
    required this.lightSleepMinutes,
    required this.deepSleepMinutes,
    required this.remSleepMinutes,
    required this.awakeMinutes,
  });

  final int lightSleepMinutes;
  final int deepSleepMinutes;
  final int remSleepMinutes;
  final int awakeMinutes;

  int get asleepMinutes =>
      lightSleepMinutes + deepSleepMinutes + remSleepMinutes;
}

/// Decodes the band's sleep history and stitches records into sessions.
///
/// [records] is `BandDataSnapshot.history['sleep']`. Returns sessions ordered by
/// start time; an empty history yields an empty list.
List<SleepSessionDraft> buildSleepSessions(
  List<Map<String, dynamic>> records, {
  required String deviceSerial,
}) {
  final parsed = <_ParsedSleepRecord>[];
  for (final record in records) {
    final candidate = _ParsedSleepRecord.parse(record);
    if (candidate != null) parsed.add(candidate);
  }
  if (parsed.isEmpty) return const [];
  parsed.sort((a, b) => a.start.compareTo(b.start));

  final sessions = <SleepSessionDraft>[];
  var group = <_ParsedSleepRecord>[parsed.first];
  for (final record in parsed.skip(1)) {
    final previous = group.last;
    final gap = record.start.difference(previous.end);
    if (gap <= kSleepRecordGapTolerance) {
      group.add(record);
    } else {
      sessions.add(_stitchSession(group, deviceSerial));
      group = <_ParsedSleepRecord>[record];
    }
  }
  sessions.add(_stitchSession(group, deviceSerial));
  return List<SleepSessionDraft>.unmodifiable(sessions);
}

/// Sums the stages of every session that woke on [localDate].
///
/// Attribution follows the backend's rule — a night belongs to the day it ended
/// on — so the daily summary and the sleep screens agree on which night is
/// "today's" sleep. Returns null when nothing woke that day, rather than a set of
/// zeroes that would look like a recorded night.
SleepStageTotals? sleepStageTotalsForLocalDate(
  List<SleepSessionDraft> sessions,
  DateTime localDate,
) {
  var light = 0;
  var deep = 0;
  var rem = 0;
  var awake = 0;
  var matched = false;
  for (final session in sessions) {
    final end = session.endAt.toLocal();
    if (end.year != localDate.year ||
        end.month != localDate.month ||
        end.day != localDate.day) {
      continue;
    }
    matched = true;
    for (final segment in session.segments) {
      switch (segment.stage) {
        case SleepStageType.deep:
          deep += segment.minutes;
        case SleepStageType.light:
          light += segment.minutes;
        case SleepStageType.rem:
          rem += segment.minutes;
        case SleepStageType.awake:
          awake += segment.minutes;
      }
    }
  }
  if (!matched) return null;
  return SleepStageTotals(
    lightSleepMinutes: light,
    deepSleepMinutes: deep,
    remSleepMinutes: rem,
    awakeMinutes: awake,
  );
}

/// Joins a run of device records into a single session.
SleepSessionDraft _stitchSession(
  List<_ParsedSleepRecord> group,
  String deviceSerial,
) {
  final start = group.first.start;
  final end = group.last.end;
  return SleepSessionDraft(
    clientRequestId: sleepClientRequestId(deviceSerial, start),
    startAt: start.toUtc(),
    endAt: end.toUtc(),
    stageIntervalMinutes: group.first.unitMinutes,
    segments: _runLengthEncode(group, start),
  );
}

/// The idempotency key for a session, shared with the server's unique key's inputs.
String sleepClientRequestId(String deviceSerial, DateTime startAt) {
  return '${deviceSerial.trim()}:${startAt.toUtc().toIso8601String()}';
}

/// Walks the group's samples in time order, merging equal neighbours into spans.
///
/// A hole between records produces an offset jump instead of a fabricated stage:
/// the missing minutes are genuinely unknown, and calling them "awake" would
/// invent data. Samples that overlap time already covered are skipped, so a
/// record the band repeated mid-window cannot double-count.
List<SleepStageSpan> _runLengthEncode(
  List<_ParsedSleepRecord> group,
  DateTime sessionStart,
) {
  final segments = <SleepStageSpan>[];
  SleepStageType? openStage;
  var openOffset = 0;
  var openMinutes = 0;
  var coveredUntil = 0;

  void flush() {
    final stage = openStage;
    if (stage != null && openMinutes > 0) {
      segments.add(
        SleepStageSpan(
          stage: stage,
          offsetMinutes: openOffset,
          minutes: openMinutes,
        ),
      );
    }
    openStage = null;
    openMinutes = 0;
  }

  for (final record in group) {
    final recordOffset = record.start.difference(sessionStart).inMinutes;
    for (var index = 0; index < record.samples.length; index++) {
      final offset = recordOffset + index * record.unitMinutes;
      if (offset < coveredUntil) continue;
      final stage = record.samples[index];
      if (openStage == stage && openOffset + openMinutes == offset) {
        openMinutes += record.unitMinutes;
      } else {
        flush();
        openStage = stage;
        openOffset = offset;
        openMinutes = record.unitMinutes;
      }
      // Advanced per accepted sample, not per flushed span: a repeat of the
      // open span must be skipped too, and the span is still open here.
      coveredUntil = offset + record.unitMinutes;
    }
  }
  flush();
  return List<SleepStageSpan>.unmodifiable(segments);
}

/// One device record: a window start plus one stage code per sample.
class _ParsedSleepRecord {
  const _ParsedSleepRecord({
    required this.start,
    required this.unitMinutes,
    required this.samples,
  });

  final DateTime start;
  final int unitMinutes;
  final List<SleepStageType> samples;

  DateTime get end =>
      start.add(Duration(minutes: samples.length * unitMinutes));

  /// Returns null when the record carries no usable stage array or timestamp.
  static _ParsedSleepRecord? parse(Map<String, dynamic> record) {
    final samples = _stageSamples(record);
    if (samples.isEmpty) return null;
    final timestamp = _recordDate(record);
    if (timestamp == null) return null;
    final unitMinutes =
        _positiveInt(record['sleepUnitLength']) ?? kDefaultSleepUnitMinutes;
    final start = kSleepRecordDateIsWindowStart
        ? timestamp
        : timestamp.subtract(Duration(minutes: samples.length * unitMinutes));
    return _ParsedSleepRecord(
      start: start,
      unitMinutes: unitMinutes,
      samples: samples,
    );
  }
}

/// Maps a record's stage array onto [SleepStageType], or an empty list when the
/// record has no such array.
List<SleepStageType> _stageSamples(Map<String, dynamic> record) {
  final arrayKey = record.keys.firstWhere((key) {
    final normalized = key.toLowerCase();
    return normalized.contains('arraysleep') ||
        normalized.contains('sleepquality');
  }, orElse: () => '');
  if (arrayKey.isEmpty) return const [];
  final raw = record[arrayKey]?.toString() ?? '';
  return raw
      .split(RegExp(r'[\s,\[\]]+'))
      .where((item) => item.trim().isNotEmpty)
      .map(_stageFromCode)
      .toList(growable: false);
}

/// `01` deep, `02` light, `03` rem, every other code awake.
SleepStageType _stageFromCode(String code) {
  return switch (int.tryParse(code.trim())) {
    1 => SleepStageType.deep,
    2 => SleepStageType.light,
    3 => SleepStageType.rem,
    _ => SleepStageType.awake,
  };
}

/// Parses the record timestamp, tolerating the `yyyy.MM.dd HH:mm:ss` form the
/// band sends alongside ISO.
DateTime? _recordDate(Map<String, dynamic> record) {
  final raw = record['date']?.toString().trim();
  if (raw == null || raw.isEmpty) return null;
  return DateTime.tryParse(raw.replaceAll('.', '-'));
}

int? _positiveInt(Object? value) {
  final parsed = value is num ? value.round() : int.tryParse('$value');
  if (parsed == null || parsed <= 0) return null;
  return parsed;
}
