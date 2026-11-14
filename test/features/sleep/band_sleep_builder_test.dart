import 'package:new_jcvital/features/sleep/domain/band_sleep_builder.dart';
import 'package:flutter_test/flutter_test.dart';

/// One band record: a window start plus one stage code per sample.
Map<String, dynamic> record(
  String date,
  String stageCodes, {
  int? unitMinutes,
}) {
  return {
    'date': date,
    'sleepUnitLength': unitMinutes,
    'arraySleep': stageCodes,
  };
}

/// [SleepStageSpan] carries no value equality, so comparisons go through the
/// fields that define a span.
List<(SleepStageType, int, int)> spanValues(SleepSessionDraft session) {
  return session.segments
      .map((span) => (span.stage, span.offsetMinutes, span.minutes))
      .toList(growable: false);
}

void main() {
  group('stage codes', () {
    test('maps 01/02/03 to deep/light/rem and everything else to awake', () {
      // The protocol only assigns meaning to 01, 02 and 03; 00 and 05 are both
      // "not asleep", and the band uses other codes the same way.
      final sessions = buildSleepSessions([
        record('2026-09-13 23:00:00', '01 02 03 00 05'),
      ], deviceSerial: 'B1');

      expect(sessions, hasLength(1));
      expect(sessions.single.segments.map((segment) => segment.stage), [
        SleepStageType.deep,
        SleepStageType.light,
        SleepStageType.rem,
        SleepStageType.awake,
      ]);
    });

    test('merges equal neighbours into one span', () {
      final sessions = buildSleepSessions([
        record('2026-09-13 23:00:00', '01 01 01 02 02'),
      ], deviceSerial: 'B1');

      final segments = sessions.single.segments;
      expect(segments, hasLength(2));
      expect(segments[0].stage, SleepStageType.deep);
      expect(segments[0].offsetMinutes, 0);
      expect(segments[0].minutes, 15);
      expect(segments[1].stage, SleepStageType.light);
      expect(segments[1].offsetMinutes, 15);
      expect(segments[1].minutes, 10);
    });

    test('reads the sample interval from the record, defaulting to 5', () {
      final five = buildSleepSessions([
        record('2026-09-13 23:00:00', '01 01 01'),
      ], deviceSerial: 'B1');
      expect(five.single.stageIntervalMinutes, 5);
      expect(five.single.duration, const Duration(minutes: 15));

      final one = buildSleepSessions([
        record('2026-09-13 23:00:00', '01 01 01', unitMinutes: 1),
      ], deviceSerial: 'B1');
      expect(one.single.stageIntervalMinutes, 1);
      expect(one.single.duration, const Duration(minutes: 3));
    });

    test('accepts the dotted timestamp form the band also sends', () {
      final sessions = buildSleepSessions([
        record('2026.09.13 23:00:00', '01 01'),
      ], deviceSerial: 'B1');

      expect(sessions.single.startAt.toLocal(), DateTime(2026, 9, 13, 23));
    });

    test('skips records without a usable date or stage array', () {
      final sessions = buildSleepSessions([
        record('', '01 01'),
        {'date': '2026-09-13 23:00:00', 'sleepUnitLength': 5},
        record('not a date', '01 01'),
        record('2026-09-13 23:00:00', '01 01'),
      ], deviceSerial: 'B1');

      expect(sessions, hasLength(1));
    });
  });

  group('stitching', () {
    test('joins records up to the gap tolerance into one session', () {
      // 23:00 + 4 samples is 23:20; the next record starts 23:30, a 10 minute
      // hole the band simply did not record.
      final sessions = buildSleepSessions([
        record('2026-09-13 23:00:00', '02 02 02 02'),
        record('2026-09-13 23:30:00', '01 01'),
      ], deviceSerial: 'B1');

      expect(sessions, hasLength(1));
      final session = sessions.single;
      expect(session.startAt.toLocal(), DateTime(2026, 9, 13, 23));
      expect(session.endAt.toLocal(), DateTime(2026, 9, 13, 23, 40));
      expect(session.duration, const Duration(minutes: 40));
    });

    test(
      'keeps the hole as an offset jump instead of inventing awake time',
      () {
        final sessions = buildSleepSessions([
          record('2026-09-13 23:00:00', '02 02 02 02'),
          record('2026-09-13 23:30:00', '01 01'),
        ], deviceSerial: 'B1');

        final segments = sessions.single.segments;
        expect(segments.map((segment) => segment.stage), [
          SleepStageType.light,
          SleepStageType.deep,
        ]);
        expect(segments[0].offsetMinutes, 0);
        expect(segments[0].minutes, 20);
        // 20 + 20 would be a lie; the 10 missing minutes stay missing.
        expect(segments[1].offsetMinutes, 30);
        expect(segments[1].minutes, 10);
      },
    );

    test('starts a new session once the gap exceeds the tolerance', () {
      final sessions = buildSleepSessions([
        record('2026-09-13 23:00:00', '02 02 02 02'),
        record('2026-09-14 00:00:00', '01 01'),
      ], deviceSerial: 'B1');

      expect(sessions, hasLength(2));
      expect(sessions[0].endAt.toLocal(), DateTime(2026, 9, 13, 23, 20));
      expect(sessions[1].startAt.toLocal(), DateTime(2026, 9, 14, 0));
    });

    test('treats a gap of exactly the tolerance as the same session', () {
      final sessions = buildSleepSessions([
        record('2026-09-13 23:00:00', '02 02 02 02'),
        record('2026-09-13 23:50:00', '01 01'),
      ], deviceSerial: 'B1');

      expect(sessions, hasLength(1));
    });

    test('orders sessions by start time regardless of record order', () {
      final sessions = buildSleepSessions([
        record('2026-09-14 01:00:00', '01 01'),
        record('2026-09-13 23:00:00', '02 02 02 02'),
      ], deviceSerial: 'B1');

      expect(sessions, hasLength(2));
      expect(sessions.first.startAt.toLocal(), DateTime(2026, 9, 13, 23));
    });

    test('counts a repeated record once', () {
      // A band that re-sends the same window mid-night must not double the
      // session: samples already covered by an emitted span are dropped.
      final single = buildSleepSessions([
        record('2026-09-13 23:00:00', '02 02 02 02'),
      ], deviceSerial: 'B1');
      final duplicated = buildSleepSessions([
        record('2026-09-13 23:00:00', '02 02 02 02'),
        record('2026-09-13 23:00:00', '02 02 02 02'),
      ], deviceSerial: 'B1');

      expect(spanValues(duplicated.single), spanValues(single.single));
      expect(duplicated.single.duration, const Duration(minutes: 20));
    });

    test('absorbs a record that overlaps one already counted', () {
      // The second window starts 10 minutes into the first, so half of it is
      // time already accounted for. Only its new tail may extend the run.
      final sessions = buildSleepSessions([
        record('2026-09-13 23:00:00', '02 02 02 02'),
        record('2026-09-13 23:10:00', '02 02 02 02'),
      ], deviceSerial: 'B1');

      expect(sessions, hasLength(1));
      expect(spanValues(sessions.single), [(SleepStageType.light, 0, 30)]);
      expect(sessions.single.duration, const Duration(minutes: 30));
    });

    test(
      'carries the truth for a non-sleeping record rather than hiding it',
      () {
        // Whether an all-awake window is worth storing is the server's call; the
        // client only reports what the band recorded.
        final sessions = buildSleepSessions([
          record('2026-09-13 23:00:00', '00 00'),
        ], deviceSerial: 'B1');

        expect(sessions.single.segments.single.stage, SleepStageType.awake);
      },
    );

    test('returns nothing for an empty history', () {
      expect(buildSleepSessions(const [], deviceSerial: 'B1'), isEmpty);
    });
  });

  group('clientRequestId', () {
    test('is derived from the device and the session start', () {
      final sessions = buildSleepSessions([
        record('2026-09-13 23:00:00', '01 01'),
      ], deviceSerial: 'B1');

      final start = DateTime(2026, 9, 13, 23).toUtc();
      expect(
        sessions.single.clientRequestId,
        sleepClientRequestId('B1', start),
      );
      expect(sessions.single.clientRequestId, 'B1:${start.toIso8601String()}');
    });

    test('is stable across rebuilds, so a re-sync lands on the same row', () {
      final first = buildSleepSessions([
        record('2026-09-13 23:00:00', '01 01'),
      ], deviceSerial: 'B1');
      final second = buildSleepSessions([
        record('2026-09-13 23:00:00', '01 01'),
      ], deviceSerial: 'B1');

      expect(first.single.clientRequestId, second.single.clientRequestId);
    });

    test('ignores surrounding whitespace in the serial', () {
      expect(
        sleepClientRequestId(' B1 ', DateTime.utc(2026, 9, 13, 23)),
        sleepClientRequestId('B1', DateTime.utc(2026, 9, 13, 23)),
      );
    });
  });

  group('sleepStageTotalsForLocalDate', () {
    test('sums the night that woke on that local date', () {
      // 23:20 + 50 minutes wakes at 00:10 the next day, which is the day the
      // backend attributes the night to.
      final sessions = buildSleepSessions([
        record('2026-09-13 23:20:00', '01 01 01 01 02 02 02 02 02 02'),
      ], deviceSerial: 'B1');

      final totals = sleepStageTotalsForLocalDate(
        sessions,
        DateTime(2026, 9, 14),
      );

      expect(totals, isNotNull);
      expect(totals!.deepSleepMinutes, 20);
      expect(totals.lightSleepMinutes, 30);
      expect(totals.remSleepMinutes, 0);
      expect(totals.awakeMinutes, 0);
      expect(totals.asleepMinutes, 50);
    });

    test('reports nothing for the day the night started on', () {
      final sessions = buildSleepSessions([
        record('2026-09-13 23:20:00', '01 01 01 01 02 02 02 02 02 02'),
      ], deviceSerial: 'B1');

      expect(
        sleepStageTotalsForLocalDate(sessions, DateTime(2026, 9, 13)),
        isNull,
      );
    });

    test('adds up every session that woke on the date', () {
      final sessions = buildSleepSessions([
        record('2026-09-13 23:00:00', '02 02 02 02'),
        record('2026-09-14 13:00:00', '01 01'),
        record('2026-09-14 22:00:00', '03 03'),
      ], deviceSerial: 'B1');

      expect(sessions, hasLength(3));
      final totals = sleepStageTotalsForLocalDate(
        sessions,
        DateTime(2026, 9, 14),
      );

      // The night that woke on the 13th is not part of the 14th's totals; the
      // nap and the following night are.
      expect(totals, isNotNull);
      expect(totals!.deepSleepMinutes, 10);
      expect(totals.remSleepMinutes, 10);
      expect(totals.lightSleepMinutes, 0);
    });

    test('reports nothing rather than zeroes when the day has no session', () {
      final sessions = buildSleepSessions([
        record('2026-09-13 23:00:00', '02 02'),
      ], deviceSerial: 'B1');

      expect(
        sleepStageTotalsForLocalDate(sessions, DateTime(2026, 9, 20)),
        isNull,
      );
    });
  });

  group('record shapes', () {
    test('finds the stage array under either of the band naming styles', () {
      final sessions = buildSleepSessions([
        {
          'date': '2026-09-13 23:00:00',
          'sleepUnitLength': 5,
          'arraySleepQuality': '01 01',
        },
      ], deviceSerial: 'B1');

      expect(sessions.single.segments.single.stage, SleepStageType.deep);
      expect(sessions.single.segments.single.minutes, 10);
    });
  });
}
