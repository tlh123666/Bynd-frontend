import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_jcvital/features/heart/application/heart_exports.dart';
import 'package:new_jcvital/features/heart/domain/heart_models.dart';
import 'heart_test_support.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('PDF embeds the bundled font and actual waveform', () async {
    final data = await HeartExports.recordingPdf(
      heartRecordingFixture(),
      portuguese: true,
    );
    expect(ascii.decode(data.take(5).toList()), '%PDF-');
    expect(data.length, greaterThan(5000));
    expect(latin1.decode(data), contains('/FontFile2'));
  });
  test('CSV retains raw values and never invents sample timing', () {
    final r = heartRecordingFixture();
    final csv = utf8.decode(HeartExports.recordingCsv(r));
    expect(csv, contains('"signal","ppg"'));
    expect(csv, contains('"0","0"'));
    expect(csv, isNot(contains('offsetSeconds')));
    final calibrated = HeartRecording({...r.json, 'sampleRateHz': 100});
    expect(
      utf8.decode(HeartExports.recordingCsv(calibrated)),
      contains('"offsetSeconds"'),
    );
    expect(
      utf8.decode(
        HeartExports.csvBytes([
          ['a,"b', null],
        ]),
      ),
      contains('"a,""b",""'),
    );
  });
}
