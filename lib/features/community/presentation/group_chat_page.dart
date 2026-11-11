import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/network/api_client.dart';
import '../../../design_system/design_system.dart';
import '../../../l10n/app_localizations_context.dart';
import '../data/remote_community_repository.dart';
import '../domain/community_models.dart';
import 'community_style.dart';
import 'group_detail_page.dart';

/// 群聊 —— 逐屏复刻原型 `GrupoChat.jsx`：
/// 头部（群名 + 成员数，点头像进入 Ajustes）、对话流、+ 打卡、发送框。
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
  List<CommunityMember> _members = const [];

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
      final results = await Future.wait([
        _repo.listMessages(widget.groupId),
        _repo.groupMembers(widget.groupId),
      ]);
      final messages = results[0] as List<CommunityMessage>;
      messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      final members = results[1] as List<CommunityMember>;
      if (!mounted) return;
      setState(() {
        _messages = messages;
        _members = members;
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
    if (text.isEmpty) return;
    _draft.clear();
    try {
      final message = await _repo.sendMessage(widget.groupId, text);
      if (!mounted) return;
      setState(() => _messages = [..._messages, message]);
      _jumpToBottom();
    } catch (error) {
      if (!mounted) return;
      _draft.text = text;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  /// 打卡（原型的 +）：后端还没有结构化数据字段（缺口 G-2），
  /// 先把打卡以「✓ 」前缀的文本发进群，流程与视觉保持一致。
  Future<void> _checkin() async {
    try {
      final message = await _repo.sendMessage(
        widget.groupId,
        context.l10n.communityCheckinText,
      );
      if (!mounted) return;
      setState(() => _messages = [..._messages, message]);
      _jumpToBottom();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  void _openAjustes() {
    Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => GroupDetailPage(
          groupId: widget.groupId,
          groupName: widget.groupName,
          repository: _repo,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _header(context),
            Expanded(child: _buildBody(context)),
            _buildComposer(context),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    final stack = _members.take(3).toList();
    return SizedBox(
      height: 52,
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.arrow_back_rounded,
                size: 22, color: AppColors.textPrimary),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.groupName,
                  style: AppTypography.listItem.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  context.l10n.communityMemberCount(_members.length),
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: _openAjustes,
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: SizedBox(
                width: (stack.length * 18.0 + 8).clamp(26.0, 80.0),
                height: 26,
                child: Stack(
                  children: [
                    for (var i = stack.length - 1; i >= 0; i--)
                      Positioned(
                        left: i * 18.0,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF121418),
                              width: 2,
                            ),
                          ),
                          child: _BubbleAvatar(
                            name: stack[i].displayName,
                            size: 24,
                          ),
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
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      );
    }
    return ListView.builder(
      controller: _scroll,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _messages.length + (_messages.isEmpty ? 1 : 0),
      itemBuilder: (context, index) {
        if (_messages.isEmpty) {
          return Padding(
            padding: const EdgeInsets.only(top: 32),
            child: Text(
              context.l10n.communityEmptyChat,
              textAlign: TextAlign.center,
              style: AppTypography.caption.copyWith(
                color: AppColors.textMuted,
              ),
            ),
          );
        }
        final message = _messages[index];
        final showDay = index == 0 ||
            message.createdAt
                    .difference(_messages[index - 1].createdAt)
                    .inDays !=
                0;
        return Column(
          children: [
            if (showDay)
              Padding(
                padding: const EdgeInsets.only(top: 18, bottom: 4),
                child: Text(
                  _dayLabel(context, message.createdAt),
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            _MessageRow(message: message),
          ],
        );
      },
    );
  }

  String _dayLabel(BuildContext context, DateTime date) {
    final now = DateTime.now();
    final days = DateTime(now.year, now.month, now.day)
        .difference(DateTime(date.year, date.month, date.day))
        .inDays;
    if (days == 0) return context.l10n.communityDayToday;
    if (days == 1) return context.l10n.communityDayYesterday;
    return '${date.day}/${date.month}';
  }

  // .gc-escr：+ 打卡、胶囊输入、圆形发送。
  Widget _buildComposer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 14),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x00121418), Color(0xFF121418)],
          stops: [0, 0.3],
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: _checkin,
            child: Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: CommunityStyle.surface2,
              ),
              child:
                  const Icon(Icons.add_rounded, color: AppColors.textPrimary),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _draft,
              onSubmitted: (_) => _send(),
              style: AppTypography.listItem.copyWith(
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: context.l10n.communitySendHint,
                hintStyle: AppTypography.caption.copyWith(
                  color: AppColors.textMuted,
                ),
                filled: true,
                fillColor: CommunityStyle.bubbleOther,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(999),
                  borderSide: const BorderSide(
                    color: CommunityStyle.strokeStrong,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(999),
                  borderSide: const BorderSide(
                    color: CommunityStyle.strokeStrong,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _send,
            child: Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: CommunityStyle.surface2,
              ),
              child: const Icon(
                Icons.send_rounded,
                size: 19,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageRow extends StatelessWidget {
  const _MessageRow({required this.message});

  final CommunityMessage message;

  @override
  Widget build(BuildContext context) {
    final time =
        '${message.createdAt.hour.toString().padLeft(2, '0')}:${message.createdAt.minute.toString().padLeft(2, '0')}';
    if (message.isMine) {
      return Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(child: _Bubble(message: message, time: time, mine: true)),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _BubbleAvatar(name: message.authorDisplayName, size: 34),
          const SizedBox(width: 8),
          Flexible(child: _Bubble(message: message, time: time, mine: false)),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.message, required this.time, required this.mine});

  final CommunityMessage message;
  final String time;
  final bool mine;

  @override
  Widget build(BuildContext context) {
    final borderRadius = mine
        ? const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(18),
            bottomRight: Radius.circular(6),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(6),
            bottomRight: Radius.circular(18),
          );
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.78,
      ),
      padding: const EdgeInsets.fromLTRB(12, 9, 12, 18),
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: mine ? CommunityStyle.bubbleMine : CommunityStyle.bubbleOther,
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!mine)
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(
                    message.authorDisplayName,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              Text(
                message.isRecalled
                    ? context.l10n.communityMessageRecalled
                    : message.content,
                style: AppTypography.listItem.copyWith(
                  color: message.isRecalled
                      ? AppColors.textMuted
                      : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Text(
              time,
              style: AppTypography.caption.copyWith(
                color: AppColors.textMuted,
                fontSize: 10.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BubbleAvatar extends StatelessWidget {
  const _BubbleAvatar({required this.name, required this.size});

  final String name;
  final double size;

  @override
  Widget build(BuildContext context) {
    final initial =
        name.isNotEmpty ? name.characters.first.toUpperCase() : '?';
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: CommunityStyle.surface2,
      ),
      child: Text(
        initial,
        style: AppTypography.caption.copyWith(
          color: AppColors.textSecondary,
          fontSize: size * 0.38,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
