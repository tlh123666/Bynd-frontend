/// 提供单调递增的时间，避免系统日期或时区调整改变活动用时。
abstract interface class ActivityMonotonicClock {
  Duration get elapsed;
}

/// 生产环境使用的单调时钟实现。
class StopwatchActivityClock implements ActivityMonotonicClock {
  StopwatchActivityClock() : _stopwatch = Stopwatch()..start();

  final Stopwatch _stopwatch;

  @override
  Duration get elapsed => _stopwatch.elapsed;
}

/// 只累计活动真正运行的时长；暂停时间不计入活动用时。
///
/// 本类不负责会话持久化和应用生命周期恢复，生命周期策略确定后由上层协调。
class ActivityElapsedClock {
  ActivityElapsedClock({ActivityMonotonicClock? clock})
    : _clock = clock ?? StopwatchActivityClock();

  final ActivityMonotonicClock _clock;
  Duration _accumulated = Duration.zero;
  Duration? _segmentStartedAt;
  bool _hasStarted = false;
  bool _isRunning = false;

  bool get hasStarted => _hasStarted;
  bool get isRunning => _isRunning;

  /// 当前累计用时；暂停时返回冻结值，未开始时返回零。
  Duration get elapsed {
    final segmentStart = _segmentStartedAt;
    if (!_isRunning || segmentStart == null) return _accumulated;

    final current = _clock.elapsed;
    final segment = current >= segmentStart
        ? current - segmentStart
        : Duration.zero;
    return _accumulated + segment;
  }

  /// 首次启动时开始计时；重复启动不会重置已有用时。
  bool start() {
    if (_hasStarted) return false;

    _hasStarted = true;
    _isRunning = true;
    _segmentStartedAt = _clock.elapsed;
    return true;
  }

  /// 冻结当前用时；未运行时返回 false，避免重复暂停产生副作用。
  bool pause() {
    if (!_isRunning) return false;

    _accumulated = elapsed;
    _segmentStartedAt = null;
    _isRunning = false;
    return true;
  }

  /// 从冻结时长继续累计；尚未开始或已经运行时返回 false。
  bool resume() {
    if (!_hasStarted || _isRunning) return false;

    _segmentStartedAt = _clock.elapsed;
    _isRunning = true;
    return true;
  }
}
