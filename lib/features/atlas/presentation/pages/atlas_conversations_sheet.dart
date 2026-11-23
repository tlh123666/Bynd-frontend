import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations_context.dart';
import '../../data/models/conversation.dart';

/// Conversation history rendered as an in-place Atlas sub-screen.
class AtlasConversationsLayer extends StatefulWidget {
  const AtlasConversationsLayer({
    required this.loader,
    required this.onClose,
    required this.onSelected,
    super.key,
  });

  final Future<List<AtlasConversation>> Function() loader;
  final VoidCallback onClose;
  final Future<void> Function(AtlasConversation conversation) onSelected;

  @override
  State<AtlasConversationsLayer> createState() =>
      _AtlasConversationsLayerState();
}

class _AtlasConversationsLayerState extends State<AtlasConversationsLayer> {
  late final Future<List<AtlasConversation>> _conversations = widget.loader();

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          SizedBox(
            height: 64,
            child: Row(
              children: [
                SizedBox(
                  width: 56,
                  child: IconButton(
                    tooltip: MaterialLocalizations.of(
                      context,
                    ).backButtonTooltip,
                    onPressed: widget.onClose,
                    icon: const Icon(Icons.chevron_left_rounded, size: 30),
                    color: const Color(0xEAF4F5F7),
                  ),
                ),
                Expanded(
                  child: Text(
                    strings.chatHistoryTitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFFF4F5F7),
                      fontSize: 19,
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.45,
                    ),
                  ),
                ),
                const SizedBox(width: 56),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<AtlasConversation>>(
              future: _conversations,
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
                final conversations = _sorted(snapshot.data ?? const []);
                if (conversations.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text(
                        strings.chatHistoryEmpty,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0x8CF4F5F7),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                }
                final groups = _groupByDay(conversations);
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(30, 24, 30, 32),
                  itemCount: groups.length,
                  itemBuilder: (context, index) => _ConversationDayGroup(
                    group: groups[index],
                    untitled: strings.chatHistoryUntitled,
                    onSelected: widget.onSelected,
                  ),
                );
              },
            ),
          ),
        ],
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

  List<_ConversationDay> _groupByDay(List<AtlasConversation> conversations) {
    final groups = <_ConversationDay>[];
    for (final conversation in conversations) {
      final date = DateTime.tryParse(conversation.updatedAt)?.toLocal();
      final key = date == null
          ? conversation.updatedAt
          : '${date.year}-${date.month}-${date.day}';
      if (groups.isEmpty || groups.last.key != key) {
        groups.add(
          _ConversationDay(key, _dayLabel(date), <AtlasConversation>[]),
        );
      }
      groups.last.conversations.add(conversation);
    }
    return groups;
  }

  String _dayLabel(DateTime? date) {
    if (date == null) return 'CONVERSAS ANTERIORES';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(date.year, date.month, date.day);
    final difference = today.difference(day).inDays;
    if (difference == 0) return 'HOJE';
    final suffix =
        '${_weekday[date.weekday]}, ${date.day} ${_month[date.month]}';
    return difference == 1 ? 'ONTEM · $suffix' : suffix;
  }
}

class _ConversationDay {
  _ConversationDay(this.key, this.label, this.conversations);

  final String key;
  final String label;
  final List<AtlasConversation> conversations;
}

class _ConversationDayGroup extends StatelessWidget {
  const _ConversationDayGroup({
    required this.group,
    required this.untitled,
    required this.onSelected,
  });

  final _ConversationDay group;
  final String untitled;
  final Future<void> Function(AtlasConversation conversation) onSelected;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          group.label,
          style: const TextStyle(
            color: Color(0x8CF4F5F7),
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.7,
          ),
        ),
        const SizedBox(height: 9),
        for (final conversation in group.conversations)
          _ConversationRow(
            conversation: conversation,
            untitled: untitled,
            onSelected: onSelected,
          ),
      ],
    ),
  );
}

class _ConversationRow extends StatelessWidget {
  const _ConversationRow({
    required this.conversation,
    required this.untitled,
    required this.onSelected,
  });

  final AtlasConversation conversation;
  final String untitled;
  final Future<void> Function(AtlasConversation conversation) onSelected;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: const BoxDecoration(
      border: Border(top: BorderSide(color: Color(0x14FFFFFF))),
    ),
    child: InkWell(
      onTap: () => onSelected(conversation),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Text(
                conversation.title.isEmpty ? untitled : conversation.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFFF4F5F7),
                  fontSize: 15.5,
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.25,
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: Color(0x99F4F5F7),
            ),
          ],
        ),
      ),
    ),
  );
}

const _weekday = <int, String>{
  DateTime.monday: 'SEG',
  DateTime.tuesday: 'TER',
  DateTime.wednesday: 'QUA',
  DateTime.thursday: 'QUI',
  DateTime.friday: 'SEX',
  DateTime.saturday: 'SÁB',
  DateTime.sunday: 'DOM',
};

const _month = <int, String>{
  1: 'JAN',
  2: 'FEV',
  3: 'MAR',
  4: 'ABR',
  5: 'MAI',
  6: 'JUN',
  7: 'JUL',
  8: 'AGO',
  9: 'SET',
  10: 'OUT',
  11: 'NOV',
  12: 'DEZ',
};
