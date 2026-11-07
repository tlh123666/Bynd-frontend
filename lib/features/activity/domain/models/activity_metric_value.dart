/// 指标值的来源；演示值和客户端估算必须与实测值区分。
enum ActivityMetricSource {
  heartRateSensor,
  location,
  wearableDevice,
  userInput,
  server,
  clientEstimate,
  demo,
}

/// 指标当前的可用状态。
enum ActivityMetricStatus {
  available,
  estimated,
  demo,
  connecting,
  unavailable,
  permissionDenied,
  disconnected,
  stale,
}

/// 一个可选的数值指标及其单位、来源和采样时间。
///
/// 缺少数据应使用 [ActivityMetricValue.missing]，不应伪造数值 0；显示格式化
/// 和单位换算留在展示层。时间统一要求为 UTC。
class ActivityMetricValue {
  const ActivityMetricValue._({
    required this.status,
    required this.unitCode,
    this.value,
    this.source,
    this.sampledAtUtc,
  });

  factory ActivityMetricValue.measured({
    required double value,
    required String unitCode,
    required ActivityMetricSource source,
    required DateTime sampledAtUtc,
  }) {
    _validateSample(value, sampledAtUtc);
    if (source == ActivityMetricSource.demo ||
        source == ActivityMetricSource.clientEstimate) {
      throw ArgumentError.value(source, 'source', '必须使用演示或估算构造方法');
    }
    return ActivityMetricValue._(
      status: ActivityMetricStatus.available,
      unitCode: unitCode,
      value: value,
      source: source,
      sampledAtUtc: sampledAtUtc,
    );
  }

  factory ActivityMetricValue.estimated({
    required double value,
    required String unitCode,
    required DateTime sampledAtUtc,
  }) {
    _validateSample(value, sampledAtUtc);
    return ActivityMetricValue._(
      status: ActivityMetricStatus.estimated,
      unitCode: unitCode,
      value: value,
      source: ActivityMetricSource.clientEstimate,
      sampledAtUtc: sampledAtUtc,
    );
  }

  factory ActivityMetricValue.demo({
    required double value,
    required String unitCode,
    required DateTime sampledAtUtc,
  }) {
    _validateSample(value, sampledAtUtc);
    return ActivityMetricValue._(
      status: ActivityMetricStatus.demo,
      unitCode: unitCode,
      value: value,
      source: ActivityMetricSource.demo,
      sampledAtUtc: sampledAtUtc,
    );
  }

  factory ActivityMetricValue.stale({
    required double value,
    required String unitCode,
    required ActivityMetricSource source,
    required DateTime sampledAtUtc,
  }) {
    _validateSample(value, sampledAtUtc);
    return ActivityMetricValue._(
      status: ActivityMetricStatus.stale,
      unitCode: unitCode,
      value: value,
      source: source,
      sampledAtUtc: sampledAtUtc,
    );
  }

  factory ActivityMetricValue.missing({
    required ActivityMetricStatus status,
    required String unitCode,
  }) {
    if (status == ActivityMetricStatus.available ||
        status == ActivityMetricStatus.estimated ||
        status == ActivityMetricStatus.demo ||
        status == ActivityMetricStatus.stale) {
      throw ArgumentError.value(status, 'status', '该状态需要数值样本');
    }
    return ActivityMetricValue._(status: status, unitCode: unitCode);
  }

  final double? value;
  final String unitCode;
  final ActivityMetricStatus status;
  final ActivityMetricSource? source;
  final DateTime? sampledAtUtc;

  bool get hasValue => value != null;

  static void _validateSample(double value, DateTime sampledAtUtc) {
    if (!value.isFinite || value < 0) {
      throw ArgumentError.value(value, 'value', '指标必须是有限的非负数');
    }
    if (!sampledAtUtc.isUtc) {
      throw ArgumentError.value(sampledAtUtc, 'sampledAtUtc', '时间必须为 UTC');
    }
  }
}
