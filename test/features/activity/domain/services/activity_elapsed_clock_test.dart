import 'package:flutter_test/flutter_test.dart';

import 'package:new_jcvital/features/activity/domain/services/activity_elapsed_clock.dart';

void main() {
  group('ActivityElapsedClock', () {
    late _FakeMonotonicClock monotonicClock;
    late ActivityElapsedClock clock;

    setUp(() {
      monotonicClock = _FakeMonotonicClock();
      clock = ActivityElapsedClock(clock: monotonicClock);
    });

    test('未开始时用时为零，启动后按单调时间累计', () {
      expect(clock.elapsed, Duration.zero);
      expect(clock.start(), isTrue);
      monotonicClock.advance(const Duration(seconds: 12));

      expect(clock.elapsed, const Duration(seconds: 12));
      expect(clock.hasStarted, isTrue);
      expect(clock.isRunning, isTrue);
    });

    test('暂停期间冻结用时，继续后只累计运行区间', () {
      clock.start();
      monotonicClock.advance(const Duration(seconds: 8));
      expect(clock.pause(), isTrue);
      monotonicClock.advance(const Duration(minutes: 3));

      expect(clock.elapsed, const Duration(seconds: 8));

      expect(clock.resume(), isTrue);
      monotonicClock.advance(const Duration(seconds: 5));
      expect(clock.elapsed, const Duration(seconds: 13));
    });

    test('重复开始、暂停和继续不会重置或重复累计', () {
      clock.start();
      monotonicClock.advance(const Duration(seconds: 4));

      expect(clock.start(), isFalse);
      expect(clock.elapsed, const Duration(seconds: 4));
      expect(clock.pause(), isTrue);
      expect(clock.pause(), isFalse);
      expect(clock.resume(), isTrue);
      expect(clock.resume(), isFalse);
    });

    test('单调时间源异常倒退时不产生负用时', () {
      clock.start();
      monotonicClock.set(const Duration(seconds: 7));
      expect(clock.elapsed, const Duration(seconds: 7));

      monotonicClock.set(const Duration(seconds: 2));
      expect(clock.elapsed, const Duration(seconds: 2));
    });

    test('未开始的时钟不能继续', () {
      expect(clock.resume(), isFalse);
      expect(clock.pause(), isFalse);
      expect(clock.elapsed, Duration.zero);
    });
  });
}

class _FakeMonotonicClock implements ActivityMonotonicClock {
  Duration _elapsed = Duration.zero;

  @override
  Duration get elapsed => _elapsed;

  void advance(Duration duration) => _elapsed += duration;

  void set(Duration value) => _elapsed = value;
}
