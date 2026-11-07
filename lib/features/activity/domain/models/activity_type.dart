/// 活动目录使用的稳定分类，与界面上显示的本地化名称分离。
enum ActivityCategory {
  cardio,
  strength,
  sports,
  combat,
  aquatic,
  mindBody,
  recovery,
  other,
}

/// 实时页第三屏的内容家族；前两屏由活动流程统一提供。
enum ActivityLivePageFamily {
  map,
  eventStages,
  pool,
  match,
  cardio,
  calm,
  stress,
  daily,
  strength,
  overview,
}

/// 一个可选活动及其页面能力。
///
/// [id] 是持久化和接口使用的稳定键，不能使用翻译后的名称代替。
/// [hasRouteToggle] 表示原型准备页会显示路线开关；它不代表设备已授权或
/// 已经采集到 GPS 数据。地图页的展示还受 [resolveLivePageFamily] 控制。
class ActivityType {
  const ActivityType({
    required this.id,
    required this.category,
    required this.livePageFamily,
    this.hasRouteToggle = false,
    this.usesStrengthSets = false,
  });

  final String id;
  final ActivityCategory category;
  final ActivityLivePageFamily livePageFamily;
  final bool hasRouteToggle;
  final bool usesStrengthSets;

  /// 本地化资源键由稳定 ID 派生；ARB 文件需在接入本地化时补齐。
  String get localizationKey => 'activity_type_${id.replaceAll('-', '_')}';

  /// 原型把恢复、日常及压力会话与训练区分，结束时不要求主观 RPE。
  bool get isTraining =>
      category != ActivityCategory.recovery &&
      category != ActivityCategory.other &&
      livePageFamily != ActivityLivePageFamily.stress;

  /// GPS 能力活动只有在路线记录打开时显示地图页；否则沿用原型概览页。
  /// 赛事页优先级高于 GPS 地图，保持 `hyrox`、两项/三项赛事的原型行为。
  ActivityLivePageFamily resolveLivePageFamily({
    required bool routeRecordingEnabled,
  }) {
    if (livePageFamily == ActivityLivePageFamily.map &&
        !routeRecordingEnabled) {
      return ActivityLivePageFamily.overview;
    }
    return livePageFamily;
  }
}
