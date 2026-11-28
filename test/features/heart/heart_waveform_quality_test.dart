import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:new_jcvital/features/heart/domain/heart_waveform_quality.dart';

List<int> pulseWave({
  int cycles = 30,
  int perCycle = 100,
  int base = 2048,
  int amp = 300,
}) => [
  for (var c = 0; c < cycles; c++)
    for (var i = 0; i < perCycle; i++)
      (base +
              amp *
                  (0.5 - 0.5 * math_cos(2 * 3.141592653589793 * i / perCycle)))
          .round(),
];

double math_cos(double x) {
  var term = 1.0, sum = 1.0;
  for (var k = 1; k <= 12; k++) {
    term *= -x * x / ((2 * k - 1) * (2 * k));
    sum += term;
  }
  return sum;
}

void main() {
  test('valid pulse wave passes', () {
    expect(heartWaveformLooksValid(pulseWave()), isTrue);
  });

  test('flatline is rejected', () {
    expect(heartWaveformLooksValid(List<int>.filled(3000, 2048)), isFalse);
  });

  test('stuck value trace is rejected', () {
    final samples = List<int>.filled(3000, 2048);
    for (var i = 0; i < 60; i++) {
      samples[i * 50] = 2100;
    }
    expect(heartWaveformLooksValid(samples), isFalse);
  });

  test('no-contact zeros are rejected', () {
    final samples = pulseWave();
    for (var i = 0; i < samples.length; i++) {
      if (i % 10 < 7) samples[i] = 0;
    }
    expect(heartWaveformLooksValid(samples), isFalse);
  });

  test('short capture is rejected', () {
    expect(
      heartWaveformLooksValid(pulseWave(cycles: 1, perCycle: 100)),
      isFalse,
    );
  });

  test('slow but real pulse still passes', () {
    // 10 cycles over 3000 samples ≈ 20 bpm floor.
    expect(heartWaveformLooksValid(pulseWave(cycles: 10)), isTrue);
    // 8 cycles ≈ 16 bpm — no usable pulse.
    expect(heartWaveformLooksValid(pulseWave(cycles: 8)), isFalse);
  });

  test('a single motion artifact does not hide the pulse', () {
    final samples = pulseWave()..removeRange(1500, 1512);
    samples
      ..insertAll(1500, List<int>.filled(12, 4095))
      ..shuffle(Random(42));
    expect(heartWaveformLooksValid(samples), isTrue);
  });
}
