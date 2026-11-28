import 'dart:async';
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/network/api_client.dart';
import '../../../design_system/design_system.dart';
import '../../../l10n/app_localizations_context.dart';
import '../data/remote_community_repository.dart';
import '../domain/community_models.dart';
import 'community_avatar.dart';
import 'community_style.dart';

/// 群聊页面，视觉逐屏对齐对方的 `GrupoChat.jsx`：固定群资料头、
/// 目标玻璃条、日期分组气泡和双层玻璃输入框。
/// 现有 API 只支持文本消息，因此不会伪造原型中的图片、音频或引用消息。
class GroupChatPage extends StatefulWidget {
  const GroupChatPage({
    required this.groupId,
    required this.groupName,
    this.groupAvatarUrl,
    this.repository,
    super.key,
  });

  final String groupId;
  final String groupName;
  final String? groupAvatarUrl;
  final RemoteCommunityRepository? repository;

  @override
  State<GroupChatPage> createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
  late final RemoteCommunityRepository _repo =
      widget.repository ?? RemoteCommunityRepository(ApiClient.configured());
  final TextEditingController _draft = TextEditingController();
  final ScrollController _scroll = ScrollController();
  final FocusNode _draftFocus = FocusNode();

  bool _loading = true;
  bool _sending = false;
  bool _awayFromBottom = false;
  String? _error;
  List<CommunityMessage> _messages = const [];
  List<CommunityMember> _members = const [];
  List<CommunityGoal> _goals = const [];
  String? _groupAvatarUrl;
  String _groupDescription = '';
  String _groupRole = 'member';
  bool _uploadingAvatar = false;

  @override
  void initState() {
    super.initState();
    _groupAvatarUrl = widget.groupAvatarUrl;
    _scroll.addListener(_onScroll);
    _reload();
  }

  @override
  void dispose() {
    _draft.dispose();
    _draftFocus.dispose();
    _scroll
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scroll.hasClients) return;
    final away = _scroll.position.maxScrollExtent - _scroll.offset > 260;
    if (away != _awayFromBottom && mounted) {
      setState(() => _awayFromBottom = away);
    }
  }

  Future<void> _reload() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final results = await Future.wait<Object>([
        _repo.listMessages(widget.groupId),
        _repo.groupMembers(widget.groupId),
        _repo.groupGoals(widget.groupId).catchError((_) => <CommunityGoal>[]),
        _repo.groupDetail(widget.groupId),
      ]);
      final messages = results[0] as List<CommunityMessage>
        ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
      if (!mounted) return;
      setState(() {
        _messages = messages;
        _members = results[1] as List<CommunityMember>;
        _goals = results[2] as List<CommunityGoal>;
        final group = results[3] as CommunityGroup;
        _groupAvatarUrl = group.avatarUrl ?? _groupAvatarUrl;
        _groupDescription = group.description;
        _groupRole = group.role;
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

  void _jumpToBottom({bool smooth = false}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      final bottom = _scroll.position.maxScrollExtent;
      if (smooth) {
        _scroll.animateTo(
          bottom,
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOutCubic,
        );
      } else {
        _scroll.jumpTo(bottom);
      }
    });
  }

  Future<void> _send() async {
    final text = _draft.text.trim();
    if (text.isEmpty || _sending) return;
    setState(() => _sending = true);
    _draft.clear();
    try {
      final message = await _repo.sendMessage(widget.groupId, text);
      if (!mounted) return;
      setState(() => _messages = [..._messages, message]);
      _jumpToBottom(smooth: true);
    } catch (error) {
      if (!mounted) return;
      _draft.text = text;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _checkin() async {
    try {
      final message = await _repo.sendMessage(
        widget.groupId,
        context.l10n.communityCheckinText,
      );
      if (!mounted) return;
      setState(() => _messages = [..._messages, message]);
      _jumpToBottom(smooth: true);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  bool get _canEditGroup => _groupRole == 'owner' || _groupRole == 'admin';

  Future<void> _openGroupDetails() async {
    // Any action mutates state (upload/reload) the sheet cannot rebuild
    // with, so the sheet closes first and the page renders the result.
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => _GroupDetailsSheet(
        groupId: widget.groupId,
        groupName: widget.groupName,
        description: _groupDescription,
        avatarUrl: _groupAvatarUrl,
        memberCount: _members.length,
        canEditAvatar: _canEditGroup,
        uploadingAvatar: _uploadingAvatar,
        onChangeAvatar: () {
          Navigator.of(sheetContext).pop();
          _changeGroupAvatar();
        },
        onInvite: () {
          Navigator.of(sheetContext).pop();
          _inviteMember();
        },
        onViewRanking: () {
          Navigator.of(sheetContext).pop();
          _openRanking();
        },
      ),
    );
  }

  Future<void> _openMoreMenu() async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => _ChatMoreSheet(
        onGroupDetails: () {
          Navigator.of(sheetContext).pop();
          _openGroupDetails();
        },
        onRanking: () {
          Navigator.of(sheetContext).pop();
          _openRanking();
        },
      ),
    );
  }

  Future<void> _changeGroupAvatar() async {
    if (_uploadingAvatar || !_canEditGroup) return;
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 82,
      );
      if (image == null) return;
      final bytes = await image.readAsBytes();
      if (bytes.length > 5 * 1024 * 1024) {
        throw const ApiException('A foto deve ter no máximo 5 MB.');
      }
      if (!mounted) return;
      setState(() => _uploadingAvatar = true);
      final avatarUrl = await _repo.uploadGroupAvatar(
        widget.groupId,
        bytes: bytes,
        filename: image.name,
      );
      if (!mounted) return;
      setState(() => _groupAvatarUrl = avatarUrl);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    } finally {
      if (mounted) setState(() => _uploadingAvatar = false);
    }
  }

  Future<void> _inviteMember() async {
    final controller = TextEditingController();
    final email = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => _InviteMemberSheet(controller: controller),
    );
    controller.dispose();
    if (email == null || email.isEmpty) return;
    try {
      await _repo.inviteMember(widget.groupId, email);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.communityInviteSuccess)),
      );
      await _reload();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  Future<void> _openRanking() async {
    if (_goals.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Este grupo ainda não tem ranking.')),
      );
      return;
    }
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => _GroupRankingSheet(
        groupId: widget.groupId,
        goals: _goals,
        repository: _repo,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              children: [
                _header(),
                if (_goals.isNotEmpty) _goalStrip(_goals.first),
                Expanded(child: _conversation()),
              ],
            ),
            Align(alignment: Alignment.bottomCenter, child: _composer()),
            if (_awayFromBottom && !_loading)
              Positioned(right: 18, bottom: 148, child: _scrollButton()),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          height: 58,
          color: const Color(0x82121418),
          padding: const EdgeInsets.only(right: 10),
          child: Row(
            children: [
              IconButton(
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  size: 22,
                  color: CommunityStyle.textBright,
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: _openGroupDetails,
                  borderRadius: BorderRadius.circular(18),
                  child: Row(
                    children: [
                      CommunityAvatar(
                        name: widget.groupName,
                        avatarUrl: _groupAvatarUrl,
                        size: 36,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.groupName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: CommunityStyle.textBright,
                                fontFamily: 'Urbanist',
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                height: 21 / 17,
                              ),
                            ),
                            Text(
                              context.l10n.communityMemberCount(
                                _members.length,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: CommunityStyle.text50,
                                fontFamily: 'Urbanist',
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Mais opções',
                onPressed: _openMoreMenu,
                icon: const Icon(
                  Icons.more_vert_rounded,
                  color: CommunityStyle.text72,
                  size: 23,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _goalStrip(CommunityGoal goal) {
    final progress = goal.teamProgressPercent.clamp(0.0, 100.0);
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 2, 14, 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _openRanking,
          borderRadius: BorderRadius.circular(16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
              child: Container(
                height: 52,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: CommunityStyle.glass,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: CommunityStyle.stroke),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.track_changes_rounded,
                      color: CommunityStyle.text72,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            goal.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: CommunityStyle.textBright,
                              fontFamily: 'Urbanist',
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${progress.toStringAsFixed(0)}% ${goal.unit}',
                            style: const TextStyle(
                              color: CommunityStyle.text50,
                              fontFamily: 'Urbanist',
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${goal.participatingCount}',
                      style: const TextStyle(
                        color: CommunityStyle.textBright,
                        fontFamily: 'Urbanist',
                        fontSize: 17,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: CommunityStyle.text50,
                      size: 17,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _conversation() {
    if (_loading) return const Center(child: AppLoadingIndicator());
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
    if (_messages.isEmpty) {
      return RefreshIndicator(
        onRefresh: _reload,
        child: ListView(
          controller: _scroll,
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 124),
          children: [
            const _DatePill(label: 'TODAY'),
            const SizedBox(height: 28),
            Text(
              context.l10n.communityEmptyChat,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: CommunityStyle.text50,
                fontFamily: 'Urbanist',
                fontSize: 13,
              ),
            ),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _reload,
      child: ListView.builder(
        controller: _scroll,
        padding: const EdgeInsets.fromLTRB(12, 2, 12, 124),
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          final message = _messages[index];
          final previous = index == 0 ? null : _messages[index - 1];
          final next = index + 1 == _messages.length
              ? null
              : _messages[index + 1];
          final showDay =
              previous == null ||
              !_sameDay(previous.createdAt, message.createdAt);
          final startsCluster =
              previous == null ||
              previous.isMine != message.isMine ||
              previous.authorUserId != message.authorUserId ||
              !_sameDay(previous.createdAt, message.createdAt);
          final endsCluster =
              next == null ||
              next.isMine != message.isMine ||
              next.authorUserId != message.authorUserId ||
              !_sameDay(next.createdAt, message.createdAt);
          return Column(
            children: [
              if (showDay) _DatePill(label: _dayLabel(message.createdAt)),
              _MessageRow(
                message: message,
                startsCluster: startsCluster,
                endsCluster: endsCluster,
              ),
            ],
          );
        },
      ),
    );
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _dayLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(date.year, date.month, date.day);
    final difference = today.difference(day).inDays;
    if (difference == 0) return context.l10n.communityDayToday.toUpperCase();
    if (difference == 1) {
      return context.l10n.communityDayYesterday.toUpperCase();
    }
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Widget _composer() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        12,
        22,
        12,
        14 + MediaQuery.paddingOf(context).bottom,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x00121418), Color(0xF0121418)],
          stops: [0, 0.38],
        ),
      ),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(26)),
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 11, 10, 10),
          decoration: BoxDecoration(
            color: const Color(0xFF1E222A),
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: CommunityStyle.strokeStrong),
            boxShadow: const [
              BoxShadow(
                color: Color(0x4D000000),
                blurRadius: 30,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _draft,
                focusNode: _draftFocus,
                minLines: 1,
                maxLines: 4,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _send(),
                style: const TextStyle(
                  color: CommunityStyle.textBright,
                  fontFamily: 'Urbanist',
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  hintText: context.l10n.communitySendHint,
                  hintStyle: const TextStyle(
                    color: CommunityStyle.text50,
                    fontFamily: 'Urbanist',
                    fontSize: 16,
                  ),
                  border: InputBorder.none,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _ComposerAction(
                    tooltip: 'Check in',
                    icon: Icons.add_rounded,
                    onPressed: _checkin,
                  ),
                  const Spacer(),
                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _draft,
                    builder: (context, value, _) {
                      final hasText = value.text.trim().isNotEmpty;
                      return _ComposerAction(
                        tooltip: hasText ? 'Send message' : 'Voice message',
                        icon: hasText
                            ? Icons.arrow_upward_rounded
                            : Icons.mic_none_rounded,
                        filled: true,
                        onPressed: hasText ? _send : _draftFocus.requestFocus,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _scrollButton() {
    return Material(
      color: Colors.transparent,
      child: InkResponse(
        onTap: () => _jumpToBottom(smooth: true),
        radius: 28,
        child: Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(
            color: CommunityStyle.glass,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Color(0x52000000), blurRadius: 14)],
          ),
          child: const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 24,
            color: CommunityStyle.textBright,
          ),
        ),
      ),
    );
  }
}

class _ChatMoreSheet extends StatelessWidget {
  const _ChatMoreSheet({required this.onGroupDetails, required this.onRanking});

  final VoidCallback onGroupDetails;
  final VoidCallback onRanking;

  @override
  Widget build(BuildContext context) {
    return _ChatSheetFrame(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SheetAction(
            icon: Icons.groups_rounded,
            label: 'Dados do grupo',
            onTap: onGroupDetails,
          ),
          const Divider(height: 1, color: CommunityStyle.stroke),
          _SheetAction(
            icon: Icons.leaderboard_rounded,
            label: 'Ranking',
            onTap: onRanking,
          ),
        ],
      ),
    );
  }
}

class _GroupDetailsSheet extends StatelessWidget {
  const _GroupDetailsSheet({
    required this.groupId,
    required this.groupName,
    required this.description,
    required this.avatarUrl,
    required this.memberCount,
    required this.canEditAvatar,
    required this.uploadingAvatar,
    required this.onChangeAvatar,
    required this.onInvite,
    required this.onViewRanking,
  });

  final String groupId;
  final String groupName;
  final String description;
  final String? avatarUrl;
  final int memberCount;
  final bool canEditAvatar;
  final bool uploadingAvatar;
  final VoidCallback onChangeAvatar;
  final VoidCallback onInvite;
  final VoidCallback onViewRanking;

  @override
  Widget build(BuildContext context) {
    return _ChatSheetFrame(
      maxHeight: 0.78,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CommunityAvatar(
                  name: groupName,
                  avatarUrl: avatarUrl,
                  size: 86,
                ),
                if (canEditAvatar)
                  Material(
                    color: CommunityStyle.textBright,
                    shape: const CircleBorder(),
                    child: InkResponse(
                      onTap: uploadingAvatar ? null : onChangeAvatar,
                      radius: 22,
                      child: SizedBox(
                        width: 38,
                        height: 38,
                        child: uploadingAvatar
                            ? const Padding(
                                padding: EdgeInsets.all(10),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(
                                Icons.photo_camera_outlined,
                                size: 19,
                                color: Color(0xFF14181D),
                              ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              groupName,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: CommunityStyle.textBright,
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$memberCount ${memberCount == 1 ? 'membro' : 'membros'}',
              style: const TextStyle(
                color: CommunityStyle.text50,
                fontFamily: 'Urbanist',
                fontSize: 13,
              ),
            ),
            if (description.trim().isNotEmpty) ...[
              const SizedBox(height: 14),
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: CommunityStyle.text72,
                  fontFamily: 'Urbanist',
                  fontSize: 14,
                  height: 1.35,
                ),
              ),
            ],
            const SizedBox(height: 22),
            _SheetAction(
              icon: Icons.leaderboard_rounded,
              label: 'Ver ranking',
              onTap: onViewRanking,
            ),
            if (canEditAvatar) ...[
              const Divider(height: 1, color: CommunityStyle.stroke),
              _SheetAction(
                icon: Icons.person_add_alt_1_rounded,
                label: 'Convidar pessoas',
                onTap: onInvite,
              ),
              const Divider(height: 1, color: CommunityStyle.stroke),
              _SheetAction(
                icon: Icons.photo_outlined,
                label: 'Alterar foto do grupo',
                onTap: onChangeAvatar,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _GroupRankingSheet extends StatefulWidget {
  const _GroupRankingSheet({
    required this.groupId,
    required this.goals,
    required this.repository,
  });

  final String groupId;
  final List<CommunityGoal> goals;
  final RemoteCommunityRepository repository;

  @override
  State<_GroupRankingSheet> createState() => _GroupRankingSheetState();
}

class _GroupRankingSheetState extends State<_GroupRankingSheet> {
  int _selectedGoal = 0;
  bool _loading = true;
  String? _error;
  List<CommunityRankingEntry> _entries = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final entries = await widget.repository.goalRanking(
        widget.groupId,
        widget.goals[_selectedGoal].id,
      );
      if (mounted) setState(() => _entries = entries);
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final goal = widget.goals[_selectedGoal];
    return _ChatSheetFrame(
      maxHeight: 0.82,
      expand: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ranking',
            style: TextStyle(
              color: CommunityStyle.textBright,
              fontFamily: 'Urbanist',
              fontSize: 21,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          if (widget.goals.length > 1)
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: widget.goals.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (_, index) => ChoiceChip(
                  label: Text(widget.goals[index].title),
                  selected: index == _selectedGoal,
                  onSelected: (_) {
                    if (index == _selectedGoal) return;
                    setState(() => _selectedGoal = index);
                    _load();
                  },
                ),
              ),
            ),
          if (widget.goals.length > 1) const SizedBox(height: 14),
          Text(
            goal.title,
            style: const TextStyle(
              color: CommunityStyle.text72,
              fontFamily: 'Urbanist',
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Flexible(
            child: _loading
                ? const Center(child: AppLoadingIndicator())
                : _error != null
                ? Center(
                    child: Text(
                      _error!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: CommunityStyle.text72),
                    ),
                  )
                : _entries.isEmpty
                ? const Center(
                    child: Text(
                      'Ainda não há participantes neste ranking.',
                      style: TextStyle(color: CommunityStyle.text72),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    itemCount: _entries.length,
                    separatorBuilder: (_, _) =>
                        const Divider(height: 1, color: CommunityStyle.stroke),
                    itemBuilder: (_, index) {
                      final entry = _entries[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 28,
                              child: Text(
                                '${entry.rank}',
                                style: const TextStyle(
                                  color: CommunityStyle.text50,
                                  fontFamily: 'Urbanist',
                                ),
                              ),
                            ),
                            CommunityAvatar(name: entry.displayName, size: 34),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                entry.displayName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: entry.isMe
                                      ? CommunityStyle.accentText
                                      : CommunityStyle.textBright,
                                  fontFamily: 'Urbanist',
                                  fontWeight: entry.isMe
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                ),
                              ),
                            ),
                            Text(
                              '${entry.currentValue.toStringAsFixed(1)} ${goal.unit}',
                              style: const TextStyle(
                                color: CommunityStyle.text72,
                                fontFamily: 'Urbanist',
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _InviteMemberSheet extends StatelessWidget {
  const _InviteMemberSheet({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return _ChatSheetFrame(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Convidar pessoas',
            style: TextStyle(
              color: CommunityStyle.textBright,
              fontFamily: 'Urbanist',
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: controller,
            keyboardType: TextInputType.emailAddress,
            autofocus: true,
            style: const TextStyle(color: CommunityStyle.textBright),
            decoration: const InputDecoration(
              hintText: 'E-mail da pessoa',
              hintStyle: TextStyle(color: CommunityStyle.text50),
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () =>
                  Navigator.of(context).pop(controller.text.trim()),
              child: const Text('Enviar convite'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatSheetFrame extends StatelessWidget {
  const _ChatSheetFrame({
    required this.child,
    this.maxHeight = 0.5,
    this.expand = false,
  });

  final Widget child;
  final double maxHeight;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * maxHeight,
          ),
          child: Container(
            height: expand
                ? MediaQuery.sizeOf(context).height * maxHeight
                : null,
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
            decoration: BoxDecoration(
              color: const Color(0xFF1B2028),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: CommunityStyle.strokeStrong),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 34,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 18),
                  decoration: BoxDecoration(
                    color: CommunityStyle.text50,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                if (expand) Flexible(child: child) else child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SheetAction extends StatelessWidget {
  const _SheetAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 4),
        child: Row(
          children: [
            Icon(icon, color: CommunityStyle.text72, size: 21),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: CommunityStyle.textBright,
                  fontFamily: 'Urbanist',
                  fontSize: 16,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: CommunityStyle.text50,
            ),
          ],
        ),
      ),
    );
  }
}

class _DatePill extends StatelessWidget {
  const _DatePill({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: CommunityStyle.chip,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: CommunityStyle.text50,
              fontFamily: 'Urbanist',
              fontSize: 11,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.54,
            ),
          ),
        ),
      ),
    );
  }
}

class _MessageRow extends StatelessWidget {
  const _MessageRow({
    required this.message,
    required this.startsCluster,
    required this.endsCluster,
  });

  final CommunityMessage message;
  final bool startsCluster;
  final bool endsCluster;

  @override
  Widget build(BuildContext context) {
    final mine = message.isMine;
    final time =
        '${message.createdAt.hour.toString().padLeft(2, '0')}:${message.createdAt.minute.toString().padLeft(2, '0')}';
    final radius = BorderRadius.only(
      topLeft: const Radius.circular(18),
      topRight: const Radius.circular(18),
      bottomLeft: Radius.circular(!mine && endsCluster ? 6 : 18),
      bottomRight: Radius.circular(mine && endsCluster ? 6 : 18),
    );
    final bubble = Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.sizeOf(context).width * 0.76,
      ),
      padding: const EdgeInsets.fromLTRB(12, 8, 10, 7),
      decoration: BoxDecoration(
        color: mine ? const Color(0x26FFFFFF) : CommunityStyle.bubbleOther,
        borderRadius: radius,
        border: mine ? Border.all(color: const Color(0x12FFFFFF)) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!mine && startsCluster)
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(
                message.authorDisplayName,
                style: TextStyle(
                  color: CommunityStyle.avatarColor(message.authorUserId),
                  fontFamily: 'Urbanist',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          Text(
            message.isRecalled
                ? context.l10n.communityMessageRecalled
                : message.content,
            style: TextStyle(
              color: message.isRecalled
                  ? CommunityStyle.text50
                  : CommunityStyle.textBright,
              fontFamily: 'Urbanist',
              fontSize: 15,
              height: 1.32,
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Text(
                time,
                style: const TextStyle(
                  color: CommunityStyle.text50,
                  fontFamily: 'Urbanist',
                  fontSize: 10.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
    return Padding(
      padding: EdgeInsets.only(top: startsCluster ? 12 : 4),
      child: Row(
        mainAxisAlignment: mine
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!mine) ...[
            SizedBox(
              width: 28,
              child: endsCluster
                  ? _ChatAvatar(
                      name: message.authorDisplayName,
                      identity: message.authorUserId,
                      size: 28,
                    )
                  : null,
            ),
            const SizedBox(width: 8),
          ],
          Flexible(child: bubble),
        ],
      ),
    );
  }
}

class _ChatAvatar extends StatelessWidget {
  const _ChatAvatar({required this.name, required this.size, this.identity});
  final String name;
  final String? identity;
  final double size;

  @override
  Widget build(BuildContext context) {
    final initial = name.isNotEmpty ? name.characters.first.toUpperCase() : '?';
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: CommunityStyle.avatarColor(identity ?? name),
      ),
      child: Text(
        initial,
        style: TextStyle(
          color: const Color(0xFF1C2026),
          fontFamily: 'Urbanist',
          fontSize: size * 0.38,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ComposerAction extends StatelessWidget {
  const _ComposerAction({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
    this.filled = false,
  });
  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: filled ? CommunityStyle.textBright : const Color(0x0AFFFFFF),
        shape: const CircleBorder(),
        child: InkResponse(
          onTap: onPressed,
          radius: 22,
          child: SizedBox(
            width: filled ? 38 : 34,
            height: filled ? 38 : 34,
            child: Icon(
              icon,
              size: 18,
              color: filled ? const Color(0xFF14181D) : CommunityStyle.text72,
            ),
          ),
        ),
      ),
    );
  }
}
