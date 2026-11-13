import '../../../../core/network/json_read.dart';

/// `/mapa/overview` 与 `/mapa/relationships` 的响应体
/// （backend `internal/module/mapa/provider.go` 的 `response`）。
///
/// Mapa 是「跨指标、沿时间」的层：关系（谁影响谁）、发现（引擎确认了什么）、
/// 成熟度（数据够不够）。原型里的演示数字（Clara 场景）在这里一律没有——
/// 后端只给证据算出来的东西，缺数据时就是空列表加 forming 阶段，
/// 界面据此展示空态而不是编一个数。

class MapaOverview {
  const MapaOverview({
    required this.generatedAt,
    required this.currentState,
    required this.relationships,
    required this.displayRelationships,
    required this.latestDiscovery,
    required this.maturity,
    required this.dailySummaries,
  });

  final String generatedAt;

  /// 四个维度的当天状态标签（sleep/recovery/energy/stress）。
  /// 后端给的是状态词（如 "good" / "attention"），不是 0–100 分。
  final Map<String, String> currentState;

  /// 全量关系（含 insufficient），页面自己按状态过滤。
  final List<MapaRelationship> relationships;

  /// 服务端挑好的前 7 条可展示关系。
  final List<MapaRelationship> displayRelationships;

  final MapaDiscovery? latestDiscovery;
  final MapaMaturity maturity;

  /// Premium 档的每日 AI 摘要；Free 请求没有这个字段。
  final List<String> dailySummaries;

  factory MapaOverview.fromJson(Map<String, dynamic> json) {
    final state = json['current_state'];
    final discovery = json['latest_discovery'];
    final maturity = json['maturity'];
    final summaries = json['daily_summaries'];
    return MapaOverview(
      generatedAt: readString(json, 'generated_at'),
      currentState: state is Map
          ? state.cast<String, dynamic>().map(
              (key, value) => MapEntry(key, value?.toString() ?? ''),
            )
          : const <String, String>{},
      relationships: readObjectList(
        json,
        'relationships',
        MapaRelationship.fromJson,
      ),
      displayRelationships: readObjectList(
        json,
        'display_relationships',
        MapaRelationship.fromJson,
      ),
      latestDiscovery: discovery is Map
          ? MapaDiscovery.fromJson(discovery.cast<String, dynamic>())
          : null,
      maturity: maturity is Map
          ? MapaMaturity.fromJson(maturity.cast<String, dynamic>())
          : MapaMaturity.empty,
      dailySummaries: summaries is List
          ? summaries.map((item) => item?.toString() ?? '').toList()
          : const <String>[],
    );
  }
}

/// 关系条目（backend `RelationshipItem`）。
class MapaRelationship {
  const MapaRelationship({
    required this.id,
    required this.source,
    required this.target,
    required this.direction,
    required this.strength,
    required this.state,
    required this.confidence,
    required this.evidence,
  });

  final String id;
  final MapaNode source;
  final MapaNode target;

  /// `positive` / `negative`：正向是「伴随升高」，负向是「伴随降低」，
  /// 都不是因果——文案层必须保持「关联」语气。
  final String direction;

  /// 0–1。界面不展示裸数字，只画强度条。
  final double strength;

  /// insufficient / emerging / established / intensifying。
  final String state;
  final String confidence;
  final MapaEvidence evidence;

  /// 「n de m vezes」的 n。不足门槛的条目两个数都很小，界面据此弱化。
  int get matches => evidence.matchingOccurrences;
  int get occurrences => evidence.occurrences;

  bool get isEstablished => state == 'established' || state == 'intensifying';

  factory MapaRelationship.fromJson(Map<String, dynamic> json) {
    final source = json['source'];
    final target = json['target'];
    final evidence = json['evidence'];
    return MapaRelationship(
      id: readString(json, 'id'),
      source: source is Map
          ? MapaNode.fromJson(source.cast<String, dynamic>())
          : const MapaNode(key: '', name: '', category: ''),
      target: target is Map
          ? MapaNode.fromJson(target.cast<String, dynamic>())
          : const MapaNode(key: '', name: '', category: ''),
      direction: readString(json, 'direction'),
      strength: readNullableDouble(json, 'strength') ?? 0,
      state: readString(json, 'state'),
      confidence: readString(json, 'confidence'),
      evidence: evidence is Map
          ? MapaEvidence.fromJson(evidence.cast<String, dynamic>())
          : MapaEvidence.empty,
    );
  }
}

class MapaNode {
  const MapaNode({
    required this.key,
    required this.name,
    required this.category,
  });

  final String key;

  /// 后端已把下划线换成空格；界面只做首字母大写。
  final String name;
  final String category;

  factory MapaNode.fromJson(Map<String, dynamic> json) {
    return MapaNode(
      key: readString(json, 'key'),
      name: readString(json, 'name'),
      category: readString(json, 'category'),
    );
  }

  /// 展示名：`short sleep` → `Short sleep`。
  String get label {
    if (name.isEmpty) return key;
    return name[0].toUpperCase() + name.substring(1);
  }
}

class MapaEvidence {
  const MapaEvidence({
    required this.occurrences,
    required this.matchingOccurrences,
    required this.periodDays,
    required this.firstSeenAt,
    required this.lastSeenAt,
  });

  final int occurrences;
  final int matchingOccurrences;
  final int periodDays;
  final String? firstSeenAt;
  final String? lastSeenAt;

  static const MapaEvidence empty = MapaEvidence(
    occurrences: 0,
    matchingOccurrences: 0,
    periodDays: 0,
    firstSeenAt: null,
    lastSeenAt: null,
  );

  factory MapaEvidence.fromJson(Map<String, dynamic> json) {
    return MapaEvidence(
      occurrences: readInt(json, 'occurrences'),
      matchingOccurrences: readInt(json, 'matching_occurrences'),
      periodDays: readInt(json, 'period_days'),
      firstSeenAt: readNullableString(json, 'first_seen_at'),
      lastSeenAt: readNullableString(json, 'last_seen_at'),
    );
  }
}

class MapaDiscovery {
  const MapaDiscovery({required this.id, required this.title});

  final String id;
  final String title;

  factory MapaDiscovery.fromJson(Map<String, dynamic> json) {
    return MapaDiscovery(
      id: readString(json, 'id'),
      title: readString(json, 'title'),
    );
  }
}

/// `/mapa/relationships` 列表响应：`{items, next_cursor}`。
class MapaRelationshipPage {
  const MapaRelationshipPage({required this.items, required this.nextCursor});

  final List<MapaRelationship> items;
  final String? nextCursor;

  factory MapaRelationshipPage.fromJson(Map<String, dynamic> json) {
    return MapaRelationshipPage(
      items: readObjectList(json, 'items', MapaRelationship.fromJson),
      nextCursor: readNullableString(json, 'next_cursor'),
    );
  }
}

class MapaMaturity {
  const MapaMaturity({
    required this.stage,
    required this.daysWithBynd,
    required this.observedSignalCount,
    required this.activeRelationshipCount,
    required this.establishedRelationshipCount,
  });

  /// `forming`（数据还不够）/ `mature`（可以给出可靠读数）。
  /// 原型里「O Mapa precisa de mais 4 semanas」的判断依据就是它。
  final String stage;
  final int daysWithBynd;
  final int observedSignalCount;
  final int activeRelationshipCount;
  final int establishedRelationshipCount;

  bool get isForming => stage != 'mature';

  static const MapaMaturity empty = MapaMaturity(
    stage: 'forming',
    daysWithBynd: 0,
    observedSignalCount: 0,
    activeRelationshipCount: 0,
    establishedRelationshipCount: 0,
  );

  factory MapaMaturity.fromJson(Map<String, dynamic> json) {
    return MapaMaturity(
      stage: readString(json, 'stage', fallback: 'forming'),
      daysWithBynd: readInt(json, 'days_with_bynd'),
      observedSignalCount: readInt(json, 'observed_signal_count'),
      activeRelationshipCount: readInt(json, 'active_relationship_count'),
      establishedRelationshipCount: readInt(
        json,
        'established_relationship_count',
      ),
    );
  }
}
