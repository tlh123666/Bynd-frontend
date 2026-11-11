import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/network/api_client.dart';
import '../../../design_system/design_system.dart';
import '../../../l10n/app_localizations_context.dart';
import '../data/remote_community_repository.dart';
import '../domain/community_models.dart';

/// 群聊（原型 GrupoChat.jsx）：按日分段的对话流 + 底部发送框。
///
/// 进入即把未读标记为已读；错误横幅沿用 ApiException 的客户端消息。
class GroupChatPage extends StatefulWidget {
  const GroupChatPage({
    required this.groupId,
    required this.groupName,
    this.repository,
    super.key,
  });

  final String groupId;
  final String groupName;
  final RemoteCommunityRepository? repository;

  @override
  State<GroupChatPage> createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
  late final RemoteCommunityRepository _repo =
      widget.repository ?? RemoteCommunityRepository(ApiClient.configured());

  final TextEditingController _draft = TextEditingController();
  final ScrollController _scroll = ScrollController();

  bool _loading = true;
  String? _error;
  List<CommunityMessage> _messages = const [];
  String? _sending;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  @override
  void dispose() {
    _draft.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _reload() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final messages = await _repo.listMessages(widget.groupId);
      // 后进先出接口，正序展示；已读上报不阻塞渲染。
      messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      if (!mounted) return;
      setState(() {
        _messages = messages;
        _loading = false;
      });
      unawaited(_repo.markMessagesRead(widget.groupId));
      _jumpToBottom();
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error.toString();
        _loading = false;
      });
    }
  }

  void _jumpToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.jumpTo(_scroll.position.maxScrollExtent);
    });
  }

  Future<void> _send() async {
    final text = _draft.text.trim();
    if (text.isEmpty || _sending != null) return;
    setState(() => _sending = text);
    _draft.clear();
    try {
      final message = await _repo.sendMessage(widget.groupId, text);
      if (!mounted) return;
      setState(() {
        _messages = [..._messages, message];
        _sending = null;
      });
      _jumpToBottom();
    } catch (error) {
      if (!mounted) return;
      setState(() => _sending = null);
      _draft.text = text;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.groupName,
              style: AppTypography.listItem.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: _buildBody(context)),
            _buildComposer(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_loading) {
      return const Center(child: AppLoadingIndicator());
    }
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            _error!,
            textAlign: TextAlign.center,
            style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
          ),
        ),
      );
    }
    return ListView.builder(
      controller: _scroll,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: _messages.length + (_messages.isEmpty ? 1 : 0),
      itemBuilder: (context, index) {
        if (_messages.isEmpty) {
          return Padding(
            padding: const EdgeInsets.only(top: 32),
            child: Text(
              context.l10n.communityEmptyChat,
              textAlign: TextAlign.center,
              style: AppTypography.caption.copyWith(color: AppColors.textMuted),
            ),
          );
        }
        final message = _messages[index];
        final showDayDivider = index == 0 ||
            message.createdAt.difference(_messages[index - 1].createdAt).inDays != 0;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showDayDivider)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: Text(
                    _dayLabel(context, message.createdAt),
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
              ),
            _MessageBubble(message: message),
          ],
        );
      },
    );
  }

  String _dayLabel(BuildContext context, DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final that = DateTime(date.year, date.month, date.day);
    final days = today.difference(that).inDays;
    if (days == 0) return context.l10n.communityDayToday;
    if (days == 1) return context.l10n.communityDayYesterday;
    return '${date.day}/${date.month}';
  }

  Widget _buildComposer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _draft,
              minLines: 1,
              maxLines: 4,
              style: AppTypography.listItem.copyWith(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: context.l10n.communitySendHint,
                hintStyle: AppTypography.caption.copyWith(color: AppColors.textMuted),
                filled: true,
                fillColor: AppColors.surface,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (_) => _send(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filled(
            onPressed: _send,
            icon: const Icon(Icons.send_rounded, size: 20),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.sky,
              foregroundColor: AppColors.background,
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final CommunityMessage message;

  @override
  Widget build(BuildContext context) {
    final time =
        '${message.createdAt.hour.toString().padLeft(2, '0')}:${message.createdAt.minute.toString().padLeft(2, '0')}';
    final initial = message.authorDisplayName.isNotEmpty
        ? message.authorDisplayName.characters.first.toUpperCase()
        : '?';
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isMine) ...[
            CircleAvatar(
              radius: 14,
              backgroundColor: AppColors.brandBlue,
              child: Text(
                initial,
                style: AppTypography.caption.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 11,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Align(
              alignment: message.isMine ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.72,
                ),
                decoration: BoxDecoration(
                  color: message.isMine ? AppColors.sky : AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!message.isMine)
                      Text(
                        message.authorDisplayName,
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    Text(
                      message.isRecalled
                          ? context.l10n.communityMessageRecalled
                          : message.content,
                      style: AppTypography.listItem.copyWith(
                        color: message.isMine
                            ? AppColors.background
                            : message.isRecalled
                                ? AppColors.textMuted
                                : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      time,
                      style: AppTypography.caption.copyWith(
                        color: message.isMine
                            ? AppColors.background.withValues(alpha: 0.6)
                            : AppColors.textMuted,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
