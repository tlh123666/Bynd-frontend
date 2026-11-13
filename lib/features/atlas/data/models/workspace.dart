import '../../../../core/network/json_read.dart';
import 'capabilities.dart';

/// `/me/ai/workspace` 的响应体（backend `dto.WorkspaceData`）。
///
/// 这是 ATLAS 首屏的唯一数据来源：方向、洞察摘要、训练建议、早期信号
/// 都在同一份快照里，客户端不要为了拼首页再分别请求四个接口——
/// 那样会出现「方向说的是今天、洞察说的是昨天」这种自相矛盾的页面。
class AtlasWorkspace {
  const AtlasWorkspace({
    required this.generatedAt,
    required this.analysisDate,
    required this.dataDate,
    required this.context,
    required this.quickPrompts,
    required this.recentInsights,
    required this.conversations,
    required this.readiness,
    required this.trainingReadiness,
    required this.earlySignal,
    required this.dailyDirection,
    required this.capabilities,
  });

  final String generatedAt;

  /// 「用户问的是哪天」。
  final String analysisDate;

  /// 「实际有数据的那天」。
  ///
  /// 与 [analysisDate] 必须分别展示、不能互相替代：把旧数据当成今天的状态作答
  /// 是已经修掉过的缺陷。任一为空时界面显示「未知」，不要回落到另一个。
  final String dataDate;

  final WorkspaceContext? context;
  final List<QuickPrompt> quickPrompts;
  final List<WorkspaceInsightBrief> recentInsights;
  final List<ConversationSummary> conversations;
  final WorkspaceReadiness readiness;
  final TrainingReadiness? trainingReadiness;
  final EarlySignal? earlySignal;

  /// 今天唯一的、已记账的方向。compact 与非 compact 请求读到的是同一行
  /// （同一 directionId + version），首页与详情页据此判断「是不是在讲同一件事」，
  /// 而不是比对两段自然语言。
  final DailyDirection? dailyDirection;

  /// 本次请求可见的能力切片。
  final CapabilitySlice capabilities;

  factory AtlasWorkspace.fromJson(Map<String, dynamic> json) {
    final context = readMap(json, 'context');
    final training = readMap(json, 'trainingReadiness');
    final early = readMap(json, 'earlySignal');
    final direction = readMap(json, 'dailyDirection');
    final capabilities = readMap(json, 'capabilities');

    return AtlasWorkspace(
      generatedAt: readString(json, 'generatedAt'),
      analysisDate: readString(json, 'analysisDate'),
      dataDate: readString(json, 'dataDate'),
      context: context == null ? null : WorkspaceContext.fromJson(context),
      quickPrompts: readObjectList(json, 'quickPrompts', QuickPrompt.fromJson),
      recentInsights: readObjectList(
        json,
        'recentInsights',
        WorkspaceInsightBrief.fromJson,
      ),
      conversations: readObjectList(
        json,
        'conversations',
        ConversationSummary.fromJson,
      ),
      readiness: WorkspaceReadiness.fromJson(
        readMap(json, 'readiness') ?? const <String, dynamic>{},
      ),
      trainingReadiness: training == null
          ? null
          : TrainingReadiness.fromJson(training),
      earlySignal: early == null ? null : EarlySignal.fromJson(early),
      dailyDirection: direction == null
          ? null
          : DailyDirection.fromJson(direction),
      capabilities: capabilities == null
          ? CapabilitySlice.empty
          : CapabilitySlice.fromJson(capabilities),
    );
  }
}

class WorkspaceContext {
  const WorkspaceContext({
    required this.title,
    required this.summary,
    required this.direction,
    required this.metrics,
    required this.change,
  });

  final String title;
  final String summary;
  final String direction;
  final List<WorkspaceMetric> metrics;
  final WorkspaceChange? change;

  factory WorkspaceContext.fromJson(Map<String, dynamic> json) {
    final change = readMap(json, 'change');
    return WorkspaceContext(
      title: readString(json, 'title'),
      summary: readString(json, 'summary'),
      direction: readString(json, 'direction'),
      metrics: readObjectList(json, 'metrics', WorkspaceMetric.fromJson),
      change: change == null ? null : WorkspaceChange.fromJson(change),
    );
  }
}

class WorkspaceMetric {
  const WorkspaceMetric({
    required this.metric,
    required this.label,
    required this.value,
    required this.unit,
    required this.direction,
  });

  final String metric;
  final String label;

  /// 可能为 null：指标存在但没有可信数值时不能伪造 0。
  final double? value;

  final String unit;
  final String direction;

  factory WorkspaceMetric.fromJson(Map<String, dynamic> json) {
    return WorkspaceMetric(
      metric: readString(json, 'metric'),
      label: readString(json, 'label'),
      value: readNullableDouble(json, 'value'),
      unit: readString(json, 'unit'),
      direction: readString(json, 'direction'),
    );
  }
}

class WorkspaceChange {
  const WorkspaceChange({
    required this.metric,
    required this.label,
    required this.direction,
    required this.changePercent,
    required this.baselineWindowDays,
    required this.confidence,
    required this.relatedSignals,
  });

  final String metric;
  final String label;
  final String direction;
  final double? changePercent;
  final int baselineWindowDays;
  final double confidence;
  final List<WorkspaceChangeSignal> relatedSignals;

  factory WorkspaceChange.fromJson(Map<String, dynamic> json) {
    return WorkspaceChange(
      metric: readString(json, 'metric'),
      label: readString(json, 'label'),
      direction: readString(json, 'direction'),
      changePercent: readNullableDouble(json, 'changePercent'),
      baselineWindowDays: readInt(json, 'baselineWindowDays'),
      confidence: readDouble(json, 'confidence'),
      relatedSignals: readObjectList(
        json,
        'relatedSignals',
        WorkspaceChangeSignal.fromJson,
      ),
    );
  }
}

class WorkspaceChangeSignal {
  const WorkspaceChangeSignal({
    required this.metric,
    required this.label,
    required this.direction,
    required this.changePercent,
  });

  final String metric;
  final String label;
  final String direction;
  final double? changePercent;

  factory WorkspaceChangeSignal.fromJson(Map<String, dynamic> json) {
    return WorkspaceChangeSignal(
      metric: readString(json, 'metric'),
      label: readString(json, 'label'),
      direction: readString(json, 'direction'),
      changePercent: readNullableDouble(json, 'changePercent'),
    );
  }
}

/// workspace 里的洞察摘要。只有四个字段，完整内容要去 `/me/insights` 取。
class WorkspaceInsightBrief {
  const WorkspaceInsightBrief({
    required this.id,
    required this.title,
    required this.summary,
    required this.severity,
  });

  final String id;
  final String title;
  final String summary;

  /// `info` / `attention` / `warning`。
  final String severity;

  factory WorkspaceInsightBrief.fromJson(Map<String, dynamic> json) {
    return WorkspaceInsightBrief(
      id: readString(json, 'id'),
      title: readString(json, 'title'),
      summary: readString(json, 'summary'),
      severity: readString(json, 'severity', fallback: 'info'),
    );
  }
}

class WorkspaceReadiness {
  const WorkspaceReadiness({
    required this.historyDays,
    required this.hasTodaySummary,
    required this.readyForInsights,
  });

  final int historyDays;
  final bool hasTodaySummary;
  final bool readyForInsights;

  factory WorkspaceReadiness.fromJson(Map<String, dynamic> json) {
    return WorkspaceReadiness(
      historyDays: readInt(json, 'historyDays'),
      hasTodaySummary: readBool(json, 'hasTodaySummary'),
      readyForInsights: readBool(json, 'readyForInsights'),
    );
  }
}

/// 追问建议。点击后应作为一条用户消息发出去，而不是由客户端自己拼答案。
class QuickPrompt {
  const QuickPrompt({required this.id, required this.text});

  final String id;
  final String text;

  factory QuickPrompt.fromJson(Map<String, dynamic> json) {
    return QuickPrompt(
      id: readString(json, 'id'),
      text: readString(json, 'text'),
    );
  }
}

class ConversationSummary {
  const ConversationSummary({
    required this.id,
    required this.title,
    required this.scope,
    required this.locale,
    required this.updatedAt,
    required this.pinnedAt,
  });

  final String id;
  final String title;
  final String scope;
  final String locale;
  final String updatedAt;
  final String? pinnedAt;

  bool get isPinned => pinnedAt != null;

  factory ConversationSummary.fromJson(Map<String, dynamic> json) {
    return ConversationSummary(
      id: readString(json, 'id'),
      title: readString(json, 'title'),
      scope: readString(json, 'scope'),
      locale: readString(json, 'locale'),
      updatedAt: readString(json, 'updatedAt'),
      pinnedAt: readNullableString(json, 'pinnedAt'),
    );
  }
}

class TrainingReadiness {
  const TrainingReadiness({
    required this.level,
    required this.score,
    required this.recommendedIntensity,
    required this.confidence,
    required this.reasons,
    required this.plan,
    required this.disclaimer,
  });

  final String level;

  /// 可能为 null：分数算不出来时不能显示 0 分（会被读成「状态极差」）。
  final int? score;

  final String recommendedIntensity;
  final double confidence;
  final List<TrainingReadinessReason> reasons;
  final TrainingPlan? plan;

  /// 免责声明由后端下发，客户端不要自己写一份。
  final String disclaimer;

  factory TrainingReadiness.fromJson(Map<String, dynamic> json) {
    final plan = readMap(json, 'plan');
    return TrainingReadiness(
      level: readString(json, 'level'),
      score: readNullableInt(json, 'score'),
      recommendedIntensity: readString(json, 'recommendedIntensity'),
      confidence: readDouble(json, 'confidence'),
      reasons: readObjectList(
        json,
        'reasons',
        TrainingReadinessReason.fromJson,
      ),
      plan: plan == null ? null : TrainingPlan.fromJson(plan),
      disclaimer: readString(json, 'disclaimer'),
    );
  }
}

class TrainingReadinessReason {
  const TrainingReadinessReason({
    required this.metric,
    required this.label,
    required this.impact,
    required this.scoreImpact,
    required this.direction,
    required this.changePercent,
    required this.windowDays,
  });

  final String metric;
  final String label;
  final String impact;
  final int scoreImpact;
  final String direction;
  final double? changePercent;
  final int windowDays;

  factory TrainingReadinessReason.fromJson(Map<String, dynamic> json) {
    return TrainingReadinessReason(
      metric: readString(json, 'metric'),
      label: readString(json, 'label'),
      impact: readString(json, 'impact'),
      scoreImpact: readInt(json, 'scoreImpact'),
      direction: readString(json, 'direction'),
      changePercent: readNullableDouble(json, 'changePercent'),
      windowDays: readInt(json, 'windowDays'),
    );
  }
}

class TrainingPlan {
  const TrainingPlan({required this.primary, required this.alternatives});

  final TrainingPlanOption primary;
  final List<TrainingPlanOption> alternatives;

  factory TrainingPlan.fromJson(Map<String, dynamic> json) {
    final primary = readMap(json, 'primary');
    return TrainingPlan(
      primary: primary == null
          ? TrainingPlanOption.empty
          : TrainingPlanOption.fromJson(primary),
      alternatives: readObjectList(
        json,
        'alternatives',
        TrainingPlanOption.fromJson,
      ),
    );
  }
}

class TrainingPlanOption {
  const TrainingPlanOption({
    required this.id,
    required this.activityType,
    required this.title,
    required this.durationMinutes,
    required this.intensity,
    required this.target,
    required this.steps,
    required this.phases,
    required this.caution,
  });

  static const TrainingPlanOption empty = TrainingPlanOption(
    id: '',
    activityType: '',
    title: '',
    durationMinutes: 0,
    intensity: '',
    target: '',
    steps: [],
    phases: [],
    caution: null,
  );

  final String id;
  final String activityType;
  final String title;
  final int durationMinutes;
  final String intensity;
  final String target;
  final List<String> steps;
  final List<TrainingPlanPhase> phases;
  final String? caution;

  factory TrainingPlanOption.fromJson(Map<String, dynamic> json) {
    return TrainingPlanOption(
      id: readString(json, 'id'),
      activityType: readString(json, 'activityType'),
      title: readString(json, 'title'),
      durationMinutes: readInt(json, 'durationMinutes'),
      intensity: readString(json, 'intensity'),
      target: readString(json, 'target'),
      steps: readStringList(json, 'steps'),
      phases: readObjectList(json, 'phases', TrainingPlanPhase.fromJson),
      caution: readNullableString(json, 'caution'),
    );
  }
}

class TrainingPlanPhase {
  const TrainingPlanPhase({
    required this.id,
    required this.title,
    required this.durationMinutes,
    required this.instruction,
  });

  final String id;
  final String title;
  final int durationMinutes;
  final String instruction;

  factory TrainingPlanPhase.fromJson(Map<String, dynamic> json) {
    return TrainingPlanPhase(
      id: readString(json, 'id'),
      title: readString(json, 'title'),
      durationMinutes: readInt(json, 'durationMinutes'),
      instruction: readString(json, 'instruction'),
    );
  }
}

/// 「今天的唯一方向」（backend `dto.DailyDirection`）。
///
/// 客户端与聊天引用它时用 [directionId] + [version] + [evidenceSnapshotId]
/// 这组三元组，而不是自己拿文案再拼一遍：只有这样才能证明首页显示的和
/// 聊天里说的是同一条记录，也才能在方向被修订时解释「你之前看到的是哪一版」。
class DailyDirection {
  const DailyDirection({
    required this.directionId,
    required this.version,
    required this.effectiveDate,
    required this.status,
    required this.action,
    required this.reason,
    required this.basis,
    required this.recheck,
    required this.stopIf,
    required this.evidenceSnapshotId,
    required this.algorithmVersion,
    required this.policyVersion,
    required this.revised,
    required this.revisionReason,
    required this.generatedAt,
  });

  final String directionId;
  final int version;
  final String effectiveDate;
  final String status;
  final String action;
  final String reason;
  final List<String> basis;
  final String? recheck;
  final String? stopIf;
  final String evidenceSnapshotId;
  final String algorithmVersion;
  final String policyVersion;

  /// 今天这条方向在生成后发生过修订（version > 1）。
  final bool revised;

  final String? revisionReason;
  final String generatedAt;

  factory DailyDirection.fromJson(Map<String, dynamic> json) {
    return DailyDirection(
      directionId: readString(json, 'directionId'),
      version: readInt(json, 'version', fallback: 1),
      effectiveDate: readString(json, 'effectiveDate'),
      status: readString(json, 'status'),
      action: readString(json, 'action'),
      reason: readString(json, 'reason'),
      basis: readStringList(json, 'basis'),
      recheck: readNullableString(json, 'recheck'),
      stopIf: readNullableString(json, 'stopIf'),
      evidenceSnapshotId: readString(json, 'evidenceSnapshotId'),
      algorithmVersion: readString(json, 'algorithmVersion'),
      policyVersion: readString(json, 'policyVersion'),
      revised: readBool(json, 'revised'),
      revisionReason: readNullableString(json, 'revisionReason'),
      generatedAt: readString(json, 'generatedAt'),
    );
  }
}

/// 早期信号（backend `dto.WorkspaceEarlySignal`）。
///
/// 它有独立的 [limitations] 与 [algorithmVersion]：这条信号比常规洞察更容易
/// 受数据缺口影响，界面必须能说清「这个结论建立在几天数据上」。
class EarlySignal {
  const EarlySignal({
    required this.level,
    required this.state,
    required this.analysisDate,
    required this.dataThrough,
    required this.headline,
    required this.changedSignals,
    required this.contextExplanation,
    required this.direction,
    required this.recheckAt,
    required this.limitations,
    required this.episodeId,
    required this.algorithmVersion,
    required this.baselineVersion,
    required this.generatedAt,
  });

  final int level;
  final String state;
  final String analysisDate;
  final String dataThrough;
  final String headline;
  final List<EarlySignalMetric> changedSignals;
  final String? contextExplanation;
  final String direction;
  final String? recheckAt;
  final List<String> limitations;
  final String? episodeId;
  final String algorithmVersion;
  final String baselineVersion;
  final String generatedAt;

  factory EarlySignal.fromJson(Map<String, dynamic> json) {
    return EarlySignal(
      level: readInt(json, 'level'),
      state: readString(json, 'state'),
      analysisDate: readString(json, 'analysisDate'),
      dataThrough: readString(json, 'dataThrough'),
      headline: readString(json, 'headline'),
      changedSignals: readObjectList(
        json,
        'changedSignals',
        EarlySignalMetric.fromJson,
      ),
      contextExplanation: readNullableString(json, 'contextExplanation'),
      direction: readString(json, 'direction'),
      recheckAt: readNullableString(json, 'recheckAt'),
      limitations: readStringList(json, 'limitations'),
      episodeId: readNullableString(json, 'episodeId'),
      algorithmVersion: readString(json, 'algorithmVersion'),
      baselineVersion: readString(json, 'baselineVersion'),
      generatedAt: readString(json, 'generatedAt'),
    );
  }
}

class EarlySignalMetric {
  const EarlySignalMetric({
    required this.metricKey,
    required this.label,
    required this.direction,
    required this.value,
    required this.unit,
    required this.baseline,
    required this.percentChange,
    required this.robustScore,
    required this.sampleCount,
    required this.baselineId,
    required this.baselineVersion,
  });

  final String metricKey;
  final String label;
  final String direction;
  final double value;
  final String unit;
  final double baseline;
  final double percentChange;
  final double robustScore;

  /// 这条信号实际用到的样本数。样本少时界面要标注，不能与充足样本同样表述。
  final int sampleCount;

  final String baselineId;
  final String baselineVersion;

  factory EarlySignalMetric.fromJson(Map<String, dynamic> json) {
    return EarlySignalMetric(
      metricKey: readString(json, 'metricKey'),
      label: readString(json, 'label'),
      direction: readString(json, 'direction'),
      value: readDouble(json, 'value'),
      unit: readString(json, 'unit'),
      baseline: readDouble(json, 'baseline'),
      percentChange: readDouble(json, 'percentChange'),
      robustScore: readDouble(json, 'robustScore'),
      sampleCount: readInt(json, 'sampleCount'),
      baselineId: readString(json, 'baselineId'),
      baselineVersion: readString(json, 'baselineVersion'),
    );
  }
}
