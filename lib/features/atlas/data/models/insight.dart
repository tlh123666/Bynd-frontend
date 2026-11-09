import '../../../../core/network/json_read.dart';

/// `/me/insights` 列表的响应体（backend `dto.InsightListData`）。
class InsightList {
  const InsightList({required this.items});

  final List<Insight> items;

  bool get isEmpty => items.isEmpty;

  static const InsightList empty = InsightList(items: []);

  factory InsightList.fromJson(Map<String, dynamic> json) {
    return InsightList(items: readObjectList(json, 'items', Insight.fromJson));
  }
}

/// 一条完整洞察（backend `dto.InsightData`）。
///
/// 与 workspace 里的 `recentInsights` 摘要不同，这里带证据、基线上下文与
/// 建议动作。列表接口只返回**可以展示**的洞察（eligible / active 且未过期），
/// 候选态与已关闭的不会出现在这里，所以客户端不需要自己再过滤状态。
class Insight {
  const Insight({
    required this.legacy,
    required this.id,
    required this.type,
    required this.subtype,
    required this.severity,
    required this.status,
    required this.title,
    required this.summary,
    required this.objectiveData,
    required this.baselineContext,
    required this.possibleFactors,
    required this.actionableSteps,
    required this.seekMedicalHelp,
    required this.evidence,
    required this.confidence,
    required this.generatedBy,
    required this.generatedAt,
    required this.expiresAt,
    required this.disclaimer,
  });

  /// 产生于来源指纹机制之前，无法说明自己基于哪一版来源与授权。
  ///
  /// 它仍可以展示（历史就是历史），但不能拿去做新结论的依据。界面若需要
  /// 解释「为什么这条没有来源说明」，用这个字段，不要猜。
  final bool legacy;

  final String id;
  final String type;
  final String subtype;

  /// `info` / `attention` / `warning`。决定卡片配色，不要自己按 type 推断。
  final String severity;

  final String status;
  final String title;
  final String summary;
  final InsightObjectiveData objectiveData;
  final InsightBaselineContext baselineContext;
  final List<String> possibleFactors;
  final List<String> actionableSteps;
  final InsightSeekMedicalHelp seekMedicalHelp;
  final List<InsightEvidence> evidence;
  final double confidence;
  final String generatedBy;
  final String generatedAt;
  final String? expiresAt;

  /// 免责声明由后端下发，每个 type 的措辞不同，客户端不要自备文案。
  final String disclaimer;

  bool get isWarning => severity == 'warning';
  bool get isAttention => severity == 'attention';

  factory Insight.fromJson(Map<String, dynamic> json) {
    final baseline = readMap(json, 'baselineContext');
    final objective = readMap(json, 'objectiveData');
    final medical = readMap(json, 'seekMedicalHelp');

    return Insight(
      legacy: readBool(json, 'legacy'),
      // id 是拿来做路由与反馈的，缺了这条数据就没法用，按必需字段处理。
      id: requireString(json, 'id'),
      type: readString(json, 'type'),
      subtype: readString(json, 'subtype'),
      severity: readString(json, 'severity', fallback: 'info'),
      status: readString(json, 'status'),
      title: readString(json, 'title'),
      summary: readString(json, 'summary'),
      objectiveData: objective == null
          ? InsightObjectiveData.empty
          : InsightObjectiveData.fromJson(objective),
      baselineContext: baseline == null
          ? InsightBaselineContext.empty
          : InsightBaselineContext.fromJson(baseline),
      possibleFactors: readStringList(json, 'possibleFactors'),
      actionableSteps: readStringList(json, 'actionableSteps'),
      seekMedicalHelp: medical == null
          ? InsightSeekMedicalHelp.empty
          : InsightSeekMedicalHelp.fromJson(medical),
      evidence: readObjectList(json, 'evidence', InsightEvidence.fromJson),
      confidence: readDouble(json, 'confidence'),
      generatedBy: readString(json, 'generatedBy'),
      generatedAt: readString(json, 'generatedAt'),
      expiresAt: readNullableString(json, 'expiresAt'),
      disclaimer: readString(json, 'disclaimer'),
    );
  }
}

class InsightObjectiveData {
  const InsightObjectiveData({
    required this.metric,
    required this.value,
    required this.unit,
    required this.observedAt,
    required this.window,
    required this.source,
  });

  static const InsightObjectiveData empty = InsightObjectiveData(
    metric: '',
    value: null,
    unit: '',
    observedAt: '',
    window: '',
    source: '',
  );

  final String metric;

  /// 可能为 null：指标存在但当时没有可信数值。
  final double? value;

  final String unit;
  final String observedAt;
  final String window;
  final String source;

  factory InsightObjectiveData.fromJson(Map<String, dynamic> json) {
    return InsightObjectiveData(
      metric: readString(json, 'metric'),
      value: readNullableDouble(json, 'value'),
      unit: readString(json, 'unit'),
      observedAt: readString(json, 'observedAt'),
      window: readString(json, 'window'),
      source: readString(json, 'source'),
    );
  }
}

/// 基线上下文：这条结论是跟「什么」比的。
///
/// [sampleCount] 是关键字段。样本数低于门槛的结论本不该被展示（后端已有
/// 过滤），但界面仍应借助它说明「这条结论基于 N 天数据」，而不是把所有
/// 洞察说得一样肯定。
class InsightBaselineContext {
  const InsightBaselineContext({
    required this.baselineValue,
    required this.baselineWindowDays,
    required this.comparison,
    required this.changePercent,
    required this.sampleCount,
  });

  static const InsightBaselineContext empty = InsightBaselineContext(
    baselineValue: null,
    baselineWindowDays: 0,
    comparison: '',
    changePercent: null,
    sampleCount: 0,
  );

  final double? baselineValue;
  final int baselineWindowDays;
  final String comparison;
  final double? changePercent;
  final int sampleCount;

  factory InsightBaselineContext.fromJson(Map<String, dynamic> json) {
    return InsightBaselineContext(
      baselineValue: readNullableDouble(json, 'baselineValue'),
      baselineWindowDays: readInt(json, 'baselineWindowDays'),
      comparison: readString(json, 'comparison'),
      changePercent: readNullableDouble(json, 'changePercent'),
      sampleCount: readInt(json, 'sampleCount'),
    );
  }
}

class InsightSeekMedicalHelp {
  const InsightSeekMedicalHelp({
    required this.message,
    required this.urgentSymptoms,
  });

  static const InsightSeekMedicalHelp empty = InsightSeekMedicalHelp(
    message: '',
    urgentSymptoms: [],
  );

  final String message;
  final List<String> urgentSymptoms;

  bool get isRequired => message.isNotEmpty || urgentSymptoms.isNotEmpty;

  factory InsightSeekMedicalHelp.fromJson(Map<String, dynamic> json) {
    return InsightSeekMedicalHelp(
      message: readString(json, 'message'),
      urgentSymptoms: readStringList(json, 'urgentSymptoms'),
    );
  }
}

class InsightEvidence {
  const InsightEvidence({
    required this.source,
    required this.date,
    required this.metric,
    required this.value,
  });

  final String source;
  final String date;
  final String metric;
  final double? value;

  factory InsightEvidence.fromJson(Map<String, dynamic> json) {
    return InsightEvidence(
      source: readString(json, 'source'),
      date: readString(json, 'date'),
      metric: readString(json, 'metric'),
      value: readNullableDouble(json, 'value'),
    );
  }
}
