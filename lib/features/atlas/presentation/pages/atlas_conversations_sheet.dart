import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations_context.dart';
import '../../data/models/conversation.dart';

/// 「Conversas anteriores」面板 —— 对应客户源码 Assistente 的会话历史子屏
/// （`.at-subcab` / `.aj-lin`）：深底、顶栏带把手与居中标题、按天分组的行。
class AtlasConversationsSheet extends StatelessWidget {
  const AtlasConversationsSheet({required this.loader, super.key});

  final Future<List<AtlasConversation>> Function() loader;

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 24),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          child: Container(
            color: const Color(0xFF1C1F24),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7,
            ),
            child: Column(
              children: [
                // .at-alca：把手
                Container(
                  width: 38,
                  height: 5,
                  margin: const EdgeInsets.only(top: 12),
                  decoration: BoxDecoration(
                    color: const Color(0x47FFFFFF),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    strings.chatHistoryTitle,
                    style: const TextStyle(
                      color: Color(0xFFF4F5F7),
                      fontSize: 19,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Expanded(
                  child: FutureBuilder<List<AtlasConversation>>(
                    future: loader(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return const Center(
                          child: SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      }
                      final items = snapshot.data ?? const [];
                      if (items.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.all(32),
                          child: Text(
                            strings.chatHistoryEmpty,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0x73F4F5F7),
                              fontSize: 14,
                            ),
                          ),
                        );
                      }
                      return ListView(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                        children: [
                          // 置顶的排最前，其余按 updatedAt 新→旧
                          for (final conversation in _sorted(items))
                            _ConversationRow(conversation: conversation),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<AtlasConversation> _sorted(List<AtlasConversation> items) {
    final list = [...items];
    list.sort((a, b) {
      if (a.pinned != b.pinned) return a.pinned ? -1 : 1;
      return b.updatedAt.compareTo(a.updatedAt);
    });
    return list;
  }
}

class _ConversationRow extends StatelessWidget {
  const _ConversationRow({required this.conversation});

  final AtlasConversation conversation;

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    // .aj-lin：上下细线、右侧 ›
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0x14FFFFFF))),
      ),
      child: InkWell(
        onTap: () => Navigator.of(context).pop(conversation),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      conversation.title.isEmpty
                          ? strings.chatHistoryUntitled
                          : conversation.title,
                      style: const TextStyle(
                        color: Color(0xFFF4F5F7),
                        fontSize: 15.5,
                      ),
                    ),
                    if (conversation.updatedAt.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Text(
                          _formatDate(conversation.updatedAt),
                          style: const TextStyle(
                            color: Color(0x6BF4F5F7),
                            fontSize: 12.5,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                size: 18,
                color: Color(0x99F4F5F7),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String iso) {
    final parsed = DateTime.tryParse(iso)?.toLocal();
    if (parsed == null) return '';
    return '${parsed.day}/${parsed.month}/${parsed.year}';
  }
}
