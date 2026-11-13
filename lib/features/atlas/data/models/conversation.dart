// ATLAS 对话的传输模型，逐字段对齐后端 assistant DTO
// （ConversationData / ConversationSummary / MessageData）。
//
// 与 insight.dart 同一约定：未知字段忽略、缺省字段给安全默认值——
// 后端加字段不应弄坏旧构建。

class AtlasConversation {
  const AtlasConversation({
    required this.id,
    required this.title,
    required this.updatedAt,
    this.pinned = false,
  });

  factory AtlasConversation.fromJson(Map<String, dynamic> json) =>
      AtlasConversation(
        id: (json['id'] as String?) ?? '',
        title: (json['title'] as String?) ?? '',
        updatedAt: (json['updatedAt'] as String?) ?? '',
        pinned: json['pinnedAt'] != null,
      );

  final String id;
  final String title;
  final String updatedAt;
  final bool pinned;
}

class AtlasConversationPage {
  const AtlasConversationPage({
    required this.items,
    required this.hasMore,
    this.nextCursor,
  });

  factory AtlasConversationPage.fromJson(Map<String, dynamic> json) =>
      AtlasConversationPage(
        items: (json['items'] as List<Object?>? ?? const [])
            .whereType<Map<String, dynamic>>()
            .map(AtlasConversation.fromJson)
            .toList(),
        hasMore: json['hasMore'] as bool? ?? false,
        nextCursor: json['nextCursor'] as String?,
      );

  final List<AtlasConversation> items;
  final bool hasMore;
  final String? nextCursor;
}

class AtlasMessage {
  const AtlasMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.status,
    required this.createdAt,
  });

  factory AtlasMessage.fromJson(Map<String, dynamic> json) => AtlasMessage(
    id: (json['id'] as String?) ?? '',
    // role 是 user/assistant；sender 是模型名（deepseek/gemini），不用于 UI。
    role: (json['role'] as String?) ?? 'assistant',
    content: (json['content'] as String?) ?? (json['text'] as String?) ?? '',
    status: (json['status'] as String?) ?? '',
    createdAt: (json['createdAt'] as String?) ?? '',
  );

  final String id;
  final String role;
  final String content;
  final String status;
  final String createdAt;

  bool get isUser => role == 'user';
}

/// 一次对话回合的最终落库结果（SSE `done` 事件的负载）。
class AtlasTurnResult {
  const AtlasTurnResult({
    required this.conversationId,
    required this.assistantMessage,
    required this.title,
  });

  factory AtlasTurnResult.fromJson(Map<String, dynamic> json) =>
      AtlasTurnResult(
        conversationId: (json['conversationId'] as String?) ?? '',
        assistantMessage: AtlasMessage.fromJson(
          (json['message'] as Map?)?.cast<String, dynamic>() ?? {},
        ),
        title: (json['title'] as String?) ?? '',
      );

  final String conversationId;
  final AtlasMessage assistantMessage;
  final String title;
}
