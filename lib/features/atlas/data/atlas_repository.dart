import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import 'models/capabilities.dart';
import 'models/conversation.dart';
import 'models/insight.dart';
import 'models/mapa.dart';
import 'models/workspace.dart';

/// ATLAS 读接口。
///
/// 一个仓储而不是每个页面各调一次：workspace、能力、洞察共享同一套
/// locale/timezone 约定，分散出去后必然出现某个页面传 `pt_BR`、另一个传
/// `pt-BR`，后端按不同的 locale 返回不同文案，用户来回切页就看到两种说法。
///
/// 语言头由 [ApiClient] 统一加（`Accept-Language` 取自 AppLocaleController），
/// 所以这里不重复传 —— mapa 的解读文案正是按这个头选语言的。
class AtlasRepository {
  AtlasRepository(
    this._client, {
    this.defaultTimezone = 'America/Sao_Paulo',
    this.defaultLocale = 'pt-BR',
  });

  final ApiClient _client;

  /// 默认时区。后端在 `statDate` 为空时按它计算「用户那边的今天」：
  /// 用 UTC 日期会让巴西用户在晚上 21 点后看到次日的方向。
  final String defaultTimezone;

  final String defaultLocale;

  Future<Map<String, dynamic>> _get(
    String path, {
    Map<String, dynamic>? query,
  }) {
    // ApiClient 的 query 只收字符串：把 null 摘掉、其余转成字符串，
    // 否则请求会带上 "null" 字面量，后端按非法枚举拒绝。
    final parameters = query == null
        ? null
        : <String, String>{
            for (final entry in query.entries)
              if (entry.value != null) entry.key: '${entry.value}',
          };
    return _client.request('GET', path, queryParameters: parameters);
  }

  Future<AtlasWorkspace> fetchWorkspace({
    String? statDate,
    String? timezone,
    String? locale,
    bool compact = false,
    String? platform,
    String? appVersion,
    String? screen,
  }) async {
    final data = await _get(
      ApiEndpoints.assistantWorkspace,
      query: {
        'statDate': statDate,
        'timezone': timezone ?? defaultTimezone,
        'locale': locale ?? defaultLocale,
        // 只在 true 时传，避免所有请求都多一个无意义的参数。
        'compact': compact ? true : null,
        'platform': platform,
        'appVersion': appVersion,
        'screen': screen,
      },
    );
    // 后端没给快照时 data 为空。ApiClient 已把 `data:null` 归一成空 map，
    // 与「空工作台」无法再区分，所以按空工作台解析（每个字段都有默认值），
    // 界面显示空态而不是抛错。
    return AtlasWorkspace.fromJson(data);
  }

  Future<AiCapabilities> fetchCapabilities() async {
    final data = await _get(ApiEndpoints.assistantCapabilities);
    return AiCapabilities.fromJson(data);
  }

  /// 读取 Mapa 总览：当前状态、前 7 条可展示关系、最新发现与成熟度。
  Future<MapaOverview> fetchMapaOverview() async {
    final data = await _get(ApiEndpoints.mapaOverview);
    return MapaOverview.fromJson(data);
  }

  /// 读取关系列表（分页）。[state] 过滤 insufficient / exploring / emerging /
  /// established / intensifying；不传则返回全部。
  /// [period] 只接受 7d / 30d / 60d / 90d（后端枚举校验）。
  Future<MapaRelationshipPage> fetchMapaRelationships({
    String? state,
    String? category,
    String period = '90d',
    int limit = 20,
    String? cursor,
  }) async {
    final data = await _get(
      ApiEndpoints.mapaRelationships,
      query: {
        'state': state,
        'category': category,
        'period': period,
        'limit': limit,
        'cursor': cursor,
      },
    );
    return MapaRelationshipPage.fromJson(data);
  }

  /// 读取可展示的洞察列表。
  ///
  /// 后端已在服务端过滤掉候选态与过期条目，并隐藏「读取窗口」参数
  /// （窗口长度是权益的一部分，不能让客户端通过参数放大）。
  /// 所以这里不要试图传 windowDays —— 传了也会被忽略。
  Future<InsightList> fetchInsights({
    String? statDate,
    String? timezone,
    String? locale,
    String? type,
    String? severity,
    int? limit,
  }) async {
    final data = await _get(
      ApiEndpoints.insights,
      query: {
        'statDate': statDate,
        'timezone': timezone ?? defaultTimezone,
        'locale': locale ?? defaultLocale,
        'type': type,
        'severity': severity,
        'limit': limit,
      },
    );
    // 没有任何洞察时后端返回 `data: {"items":[]}`；data 缺失属于契约外的
    // 响应，按空列表处理而不是抛错——列表页空着比报错好。
    if (data.isEmpty) return InsightList.empty;
    return InsightList.fromJson(data);
  }

  // ── 对话（ATLAS chat）──────────────────────────────────────────
  //
  // 发送走 SSE：调用方拿到原始事件行自行解析（start/status/delta/
  // content_done/done/error）。这里只负责传输，不做状态机——状态机在
  // chat controller，换界面的代价才不会拖上协议层。

  Future<AtlasConversation> createConversation({String? scope}) async {
    final data = await _client.request(
      'POST',
      ApiEndpoints.assistantConversations,
      body: {'locale': defaultLocale, 'scope': ?scope},
    );
    return AtlasConversation.fromJson(data);
  }

  Future<AtlasConversationPage> fetchConversations({int limit = 20}) async {
    final data = await _get(
      ApiEndpoints.assistantConversations,
      query: {'locale': defaultLocale, 'limit': limit},
    );
    if (data.isEmpty) {
      return const AtlasConversationPage(items: [], hasMore: false);
    }
    return AtlasConversationPage.fromJson(data);
  }

  Future<List<AtlasMessage>> fetchMessages(String conversationId) async {
    final data = await _get(ApiEndpoints.assistantMessages(conversationId));
    final items = data['items'] as List<Object?>? ?? const [];
    return items
        .whereType<Map<String, dynamic>>()
        .map(AtlasMessage.fromJson)
        .toList();
  }

  Stream<String> sendMessageSse({
    required String conversationId,
    required String content,
    required String clientRequestId,
  }) {
    return _client.postSseLines(
      ApiEndpoints.assistantMessages(conversationId),
      body: {
        'content': content,
        'locale': defaultLocale,
        'timezone': defaultTimezone,
        'stream': true,
        'clientRequestId': clientRequestId,
      },
    );
  }

  Future<void> cancelGeneration(
    String conversationId,
    String generationId,
  ) async {
    await _client.request(
      'POST',
      ApiEndpoints.assistantCancelGeneration(conversationId),
      body: {'generationId': generationId},
    );
  }

  /// 关闭底层 HTTP 连接池。仓储独占一个 [ApiClient]，所以可以直接关。
  void dispose() => _client.close();
}
