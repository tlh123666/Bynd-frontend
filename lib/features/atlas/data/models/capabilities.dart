import '../../../../core/network/json_read.dart';

/// `/me/ai/capabilities` 的响应体（backend `dto.CapabilitiesData`）。
///
/// 它回答的是「这个用户能读到哪些数据、读到多深」，与 workspace 里那份
/// [CapabilitySlice] 不是同一件事：后者是「界面上该出现哪些入口」。
class AiCapabilities {
  const AiCapabilities({
    required this.tier,
    required this.tierLabel,
    required this.policyVersion,
    required this.algorithmVersion,
    required this.rawHistoryDays,
    required this.baselineWindows,
    required this.sources,
  });

  final String tier;

  /// 用「信息范围」表述档位，不是「智能强弱」。界面直接用这个文案，
  /// 不要自己拼「Free / Premium」之类后端没给的措辞。
  final String tierLabel;

  final String policyVersion;
  final String algorithmVersion;
  final int rawHistoryDays;
  final List<int> baselineWindows;
  final List<CapabilitySource> sources;

  factory AiCapabilities.fromJson(Map<String, dynamic> json) {
    return AiCapabilities(
      tier: readString(json, 'tier'),
      tierLabel: readString(json, 'tierLabel'),
      policyVersion: readString(json, 'policyVersion'),
      algorithmVersion: readString(json, 'algorithmVersion'),
      rawHistoryDays: readInt(json, 'rawHistoryDays'),
      baselineWindows: _intList(json['baselineWindows']),
      sources: readObjectList(json, 'sources', CapabilitySource.fromJson),
    );
  }

  static List<int> _intList(dynamic value) {
    if (value is! List) return const [];
    return value
        .map((item) => item is int ? item : (item is num ? item.toInt() : null))
        .whereType<int>()
        .toList(growable: false);
  }
}

/// 单个数据来源的可读状态（backend `dto.CapabilitySource`）。
///
/// 三个布尔量必须分开看，界面才能说清「为什么读不到」：
/// - [available] 为 false：这个来源还没接通，与用户无关；
/// - [entitled] 为 false：当前档位不自动读取，升级可用；
/// - [consentRequired] 且 [consentGranted] 为 false：需要用户先去授权。
/// 把三者合成一句「暂无数据」会让用户以为是自己没数据。
class CapabilitySource {
  const CapabilitySource({
    required this.key,
    required this.available,
    required this.enabled,
    required this.autoRead,
    required this.entitled,
    required this.consentRequired,
    required this.consentGranted,
    required this.consentCategory,
    required this.historyDays,
    required this.unit,
    required this.evidence,
  });

  final String key;
  final bool available;
  final bool enabled;
  final bool autoRead;
  final bool entitled;
  final bool consentRequired;
  final bool consentGranted;

  /// 需要授权时对应的同意类别，用于跳转到具体授权项。
  final String? consentCategory;

  final int historyDays;
  final String unit;

  /// 来源说明，可能为空。
  final String? evidence;

  /// 用户现在到底能不能读到这个来源。
  bool get isReadable => available && enabled && entitled && (!consentRequired || consentGranted);

  /// 不能读取时，最该让用户做的一件事。
  CapabilitySourceBlocker get blocker {
    if (!available) return CapabilitySourceBlocker.unavailable;
    if (consentRequired && !consentGranted) return CapabilitySourceBlocker.consent;
    if (!entitled) return CapabilitySourceBlocker.entitlement;
    return CapabilitySourceBlocker.none;
  }

  factory CapabilitySource.fromJson(Map<String, dynamic> json) {
    return CapabilitySource(
      key: readString(json, 'key'),
      available: readBool(json, 'available'),
      enabled: readBool(json, 'enabled'),
      autoRead: readBool(json, 'autoRead'),
      entitled: readBool(json, 'entitled'),
      consentRequired: readBool(json, 'consentRequired'),
      consentGranted: readBool(json, 'consentGranted'),
      consentCategory: readNullableString(json, 'consentCategory'),
      historyDays: readInt(json, 'historyDays'),
      unit: readString(json, 'unit'),
      evidence: readNullableString(json, 'evidence'),
    );
  }
}

enum CapabilitySourceBlocker { none, unavailable, consent, entitlement }

/// workspace 下发的能力切片（backend `policy.CapabilitySlice`）。
///
/// 客户端据此隐藏自己版本里不存在的入口：界面和模型都不该承诺对方做不到的事。
class CapabilitySlice {
  const CapabilitySlice({
    required this.version,
    required this.tier,
    required this.platform,
    required this.capabilities,
    required this.omitted,
  });

  final String version;
  final String tier;
  final String? platform;
  final List<AiCapability> capabilities;

  /// 被省略的能力与原因。**不要拿它渲染「即将上线」列表**：
  /// 后端只给 key 与原因，刻意不给详情，就是因为不该让用户看见
  /// 一个自己根本用不到的功能长什么样。
  final List<OmittedCapability> omitted;

  static const CapabilitySlice empty = CapabilitySlice(
    version: '',
    tier: '',
    platform: null,
    capabilities: [],
    omitted: [],
  );

  bool has(String key) => capabilities.any((item) => item.key == key);

  AiCapability? byKey(String key) {
    for (final item in capabilities) {
      if (item.key == key) return item;
    }
    return null;
  }

  /// 界面上可导航的入口。
  List<AiCapability> get visibleCapabilities =>
      capabilities.where((item) => item.isNavigable).toList(growable: false);

  factory CapabilitySlice.fromJson(Map<String, dynamic> json) {
    return CapabilitySlice(
      version: readString(json, 'version'),
      tier: readString(json, 'tier'),
      platform: readNullableString(json, 'platform'),
      capabilities: readObjectList(json, 'capabilities', AiCapability.fromJson),
      omitted: readObjectList(json, 'omitted', OmittedCapability.fromJson),
    );
  }
}

class OmittedCapability {
  const OmittedCapability({required this.key, required this.reason});

  final String key;

  /// `tier` / `consent` / `platform` / `appVersion` / `rollout` / `status`。
  final String reason;

  factory OmittedCapability.fromJson(Map<String, dynamic> json) {
    return OmittedCapability(
      key: readString(json, 'key'),
      reason: readString(json, 'reason'),
    );
  }
}

/// 能力的一个导航入口（backend `policy.CapabilityNavigation`）。
///
/// 一条能力可以有多个入口，而且入口不是同一个页面。例如 `home.daily_direction`
/// 同时指向首页、完整方向页、洞察列表——只读顶层 `route` 会让用户只看到其中
/// 一个，另外两个连文案都拿不到。
class CapabilityNavigation {
  const CapabilityNavigation({
    required this.route,
    required this.label,
    this.precondition,
  });

  final String route;

  /// 入口文案，后端下发，界面直接用，不要自己拼。
  final String label;

  /// 跳转前提，例如「当天已生成方向」。为空表示无条件。
  final String? precondition;

  /// 有条件才能进。界面应据此置灰或先解释原因，而不是点进去再报错。
  bool get isConditional => (precondition ?? '').isNotEmpty;

  factory CapabilityNavigation.fromJson(Map<String, dynamic> json) {
    return CapabilityNavigation(
      route: readString(json, 'route'),
      label: readString(json, 'label'),
      precondition: readNullableString(json, 'precondition'),
    );
  }
}

/// 能力支持的一个动作（backend `policy.CapabilityAction`）。
///
/// 这是动作链的客户端一半：`requiresConfirmation` 决定是否先弹确认，
/// `reversible` 为 false 时必须把后果说清楚。
class CapabilityAction {
  const CapabilityAction({
    required this.id,
    required this.label,
    required this.kind,
    required this.requiresConfirmation,
    required this.reversible,
    required this.params,
  });

  final String id;
  final String label;

  /// `navigate` 是纯跳转；其余值会改变用户设置，必须走提案 → 确认。
  final String kind;

  /// 为 true 时必须先提案再确认，不能直接执行。
  final bool requiresConfirmation;

  /// 为 false 表示执行后不可撤销。
  final bool reversible;

  final List<CapabilityActionParam> params;

  /// 纯跳转类动作不需要确认。
  bool get isNavigation => kind == 'navigate';

  factory CapabilityAction.fromJson(Map<String, dynamic> json) {
    return CapabilityAction(
      id: readString(json, 'id'),
      label: readString(json, 'label'),
      kind: readString(json, 'kind'),
      requiresConfirmation: readBool(json, 'requiresConfirmation'),
      reversible: readBool(json, 'reversible'),
      params: readObjectList(json, 'params', CapabilityActionParam.fromJson),
    );
  }
}

/// 动作参数的声明（backend `policy.ActionParam`）。
///
/// 服务端会按这份声明校验参数，不看模型说了什么。客户端据此做表单约束。
class CapabilityActionParam {
  const CapabilityActionParam({
    required this.name,
    required this.type,
    required this.required,
    required this.enumValues,
    this.min,
    this.max,
  });

  final String name;
  final String type;
  final bool required;
  final List<String> enumValues;
  final int? min;
  final int? max;

  factory CapabilityActionParam.fromJson(Map<String, dynamic> json) {
    return CapabilityActionParam(
      name: readString(json, 'name'),
      type: readString(json, 'type'),
      required: readBool(json, 'required'),
      enumValues: readStringList(json, 'enum'),
      min: readNullableInt(json, 'min'),
      max: readNullableInt(json, 'max'),
    );
  }
}

/// 单条能力定义（backend `policy.Capability`）。
///
/// 只映射客户端用得上的部分。`data` / `analyzable` / `limitations` 是后端与
/// 模型对账用的口径，界面不直接渲染，所以留在 [raw] 里供排障。
///
/// 但 [navigation] 与 [actions] 必须解析——它们是界面直接消费的内容：
/// 入口文案与跳转前提、动作是否要确认、执行后能否撤销。这两块漏掉，能力
/// 卡片就只能显示一行 `purpose`。
class AiCapability {
  const AiCapability({
    required this.key,
    required this.version,
    required this.screen,
    required this.route,
    required this.status,
    required this.purpose,
    required this.tiers,
    required this.consentCategory,
    required this.platforms,
    required this.minAppVersion,
    required this.navigation,
    required this.actions,
    required this.raw,
  });

  final String key;
  final String version;

  /// 该能力所在的界面标识。
  final String screen;

  /// 该能力的默认入口。多入口见 [navigation]。
  final String route;

  /// `active` 之外的值都不该出现在导航里。
  final String status;

  /// 面向用户的一段说明。
  final String purpose;

  final List<String> tiers;
  final String? consentCategory;
  final List<String> platforms;
  final String? minAppVersion;

  /// 该能力的全部入口。至少有一条时，界面应按它渲染，而不是只看 [route]。
  final List<CapabilityNavigation> navigation;

  /// 该能力支持的动作。
  final List<CapabilityAction> actions;

  /// 原始定义，仅排障用。
  final Map<String, dynamic> raw;

  /// 界面可以点进去的入口。
  ///
  /// 取值与 backend `policy.CapabilityStatus*` 一致：
  /// - `available` 正式可用；
  /// - `preview` 灰度可见（能出现在切片里说明该用户已在名单内）；
  /// - `deprecated` / `removed` 仍留在切片里，但后端已经把 navigation 与
  ///   actions 裁掉了——它们只用于解释「用户记得的那个功能去哪了」，
  ///   不能出现在导航里。
  ///
  /// 注意不是判断 `status == 'active'`：状态机里根本没有 active 这个值，
  /// 写错会让所有入口静默消失，且后端不会报错。
  bool get isNavigable => status == 'available' || status == 'preview';

  /// 仅作为历史记录存在，当前不可用。
  bool get isRetired => status == 'deprecated' || status == 'removed';

  factory AiCapability.fromJson(Map<String, dynamic> json) {
    final gating = readMap(json, 'gating') ?? const <String, dynamic>{};
    return AiCapability(
      key: readString(json, 'key'),
      version: readString(json, 'version'),
      screen: readString(json, 'screen'),
      route: readString(json, 'route'),
      status: readString(json, 'status'),
      purpose: readString(json, 'purpose'),
      tiers: readStringList(gating, 'tiers'),
      consentCategory: readNullableString(gating, 'consentCategory'),
      platforms: readStringList(gating, 'platforms'),
      minAppVersion: readNullableString(gating, 'minAppVersion'),
      navigation:
          readObjectList(json, 'navigation', CapabilityNavigation.fromJson),
      actions: readObjectList(json, 'actions', CapabilityAction.fromJson),
      raw: json,
    );
  }
}
