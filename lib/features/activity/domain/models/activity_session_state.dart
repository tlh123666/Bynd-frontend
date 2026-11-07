/// 活动会话从创建到保存/放弃的显式生命周期状态。
enum ActivitySessionState {
  preparing,
  countdown,
  running,
  paused,
  interrupted,
  finishing,
  saveFailed,
  saved,
  cancelled,
  discarded,
}

extension ActivitySessionStateTransitions on ActivitySessionState {
  /// 判断单次状态转换是否符合活动生命周期约束。
  ///
  /// 此方法只校验状态边界，不执行持久化或计时副作用；副作用应由应用层
  /// 用例负责，并在保存失败时保留会话数据以便重试。
  bool canTransitionTo(ActivitySessionState next) {
    return switch (this) {
      ActivitySessionState.preparing =>
        next == ActivitySessionState.countdown ||
            next == ActivitySessionState.cancelled ||
            next == ActivitySessionState.interrupted,
      ActivitySessionState.countdown =>
        next == ActivitySessionState.running ||
            next == ActivitySessionState.cancelled ||
            next == ActivitySessionState.interrupted,
      ActivitySessionState.running =>
        next == ActivitySessionState.paused ||
            next == ActivitySessionState.finishing ||
            next == ActivitySessionState.interrupted,
      ActivitySessionState.paused =>
        next == ActivitySessionState.running ||
            next == ActivitySessionState.finishing ||
            next == ActivitySessionState.interrupted,
      ActivitySessionState.interrupted =>
        next == ActivitySessionState.running ||
            next == ActivitySessionState.paused ||
            next == ActivitySessionState.finishing ||
            next == ActivitySessionState.cancelled ||
            next == ActivitySessionState.discarded,
      ActivitySessionState.finishing =>
        next == ActivitySessionState.saved ||
            next == ActivitySessionState.saveFailed ||
            next == ActivitySessionState.discarded,
      ActivitySessionState.saveFailed =>
        next == ActivitySessionState.finishing ||
            next == ActivitySessionState.discarded,
      ActivitySessionState.saved ||
      ActivitySessionState.cancelled ||
      ActivitySessionState.discarded => false,
    };
  }
}
