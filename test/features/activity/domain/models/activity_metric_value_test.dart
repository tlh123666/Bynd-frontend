import 'package:flutter_test/flutter_test.dart';

import 'package:new_jcvital/features/activity/domain/models/activity_metric_value.dart';

void main() {
  group('ActivityMetricValue', () {
    test('缺失值保留明确状态，且不伪装成零', () {
      final metric = ActivityMetricValue.missing(
        status: ActivityMetricStatus.permissionDenied,
        unitCode: 'bpm',
      );

      expect(metric.value, isNull);
      expect(metric.hasValue, isFalse);
      expect(metric.status, ActivityMetricStatus.permissionDenied);
    });

    test('测量、估算和演示数据有不同来源标记', () {
      final sampledAtUtc = DateTime.utc(2026, 11, 7);
      const unit = 'bpm';
      final measured = ActivityMetricValue.measured(
        value: 120,
        unitCode: unit,
        source: ActivityMetricSource.heartRateSensor,
        sampledAtUtc: sampledAtUtc,
      );
      final estimated = ActivityMetricValue.estimated(
        value: 120,
        unitCode: unit,
        sampledAtUtc: sampledAtUtc,
      );
      final demo = ActivityMetricValue.demo(
        value: 120,
        unitCode: unit,
        sampledAtUtc: sampledAtUtc,
      );

      expect(measured.status, ActivityMetricStatus.available);
      expect(measured.source, ActivityMetricSource.heartRateSensor);
      expect(estimated.status, ActivityMetricStatus.estimated);
      expect(estimated.source, ActivityMetricSource.clientEstimate);
      expect(demo.status, ActivityMetricStatus.demo);
      expect(demo.source, ActivityMetricSource.demo);
    });

    test('过期样本保留原值与采样时间，并显式标记过期', () {
      final sampledAtUtc = DateTime.utc(2026, 11, 7);
      final metric = ActivityMetricValue.stale(
        value: 120,
        unitCode: 'bpm',
        source: ActivityMetricSource.wearableDevice,
        sampledAtUtc: sampledAtUtc,
      );

      expect(metric.hasValue, isTrue);
      expect(metric.status, ActivityMetricStatus.stale);
      expect(metric.sampledAtUtc, sampledAtUtc);
    });

    test('拒绝负值、非有限值、非 UTC 时间和相互矛盾的来源状态', () {
      final sampledAtUtc = DateTime.utc(2026, 11, 7);

      expect(
        () => ActivityMetricValue.measured(
          value: -1,
          unitCode: 'bpm',
          source: ActivityMetricSource.heartRateSensor,
          sampledAtUtc: sampledAtUtc,
        ),
        throwsArgumentError,
      );
      expect(
        () => ActivityMetricValue.estimated(
          value: double.infinity,
          unitCode: 'm',
          sampledAtUtc: sampledAtUtc,
        ),
        throwsArgumentError,
      );
      expect(
        () => ActivityMetricValue.demo(
          value: 72,
          unitCode: 'bpm',
          sampledAtUtc: DateTime(2026, 11, 7),
        ),
        throwsArgumentError,
      );
      expect(
        () => ActivityMetricValue.measured(
          value: 72,
          unitCode: 'bpm',
          source: ActivityMetricSource.demo,
          sampledAtUtc: sampledAtUtc,
        ),
        throwsArgumentError,
      );
      expect(
        () => ActivityMetricValue.missing(
          status: ActivityMetricStatus.available,
          unitCode: 'bpm',
        ),
        throwsArgumentError,
      );
    });
  });
}
