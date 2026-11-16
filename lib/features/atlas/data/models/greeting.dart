/// Atlas 弹窗按页面上下文生成的开场白（后端 `/me/ai/greeting`）。
///
/// `data` 为 null（新用户 / 当日无记录）时前端不渲染问候，这不是错误。
class AtlasGreeting {
  const AtlasGreeting({
    required this.context,
    required this.title,
    required this.summary,
  });

  final String context;
  final String title;
  final String summary;

  static AtlasGreeting? fromJson(Map<String, dynamic> json) {
    final title = (json['title'] as String?) ?? '';
    final summary = (json['summary'] as String?) ?? '';
    if (title.isEmpty && summary.isEmpty) return null;
    return AtlasGreeting(
      context: (json['context'] as String?) ?? 'home',
      title: title,
      summary: summary,
    );
  }

  /// 作为第一条助手消息并入对话历史的完整文本。
  String get asMessageText =>
      title.isEmpty ? summary : (summary.isEmpty ? title : '$title\n\n$summary');
}
