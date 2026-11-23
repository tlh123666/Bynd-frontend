import 'package:flutter/material.dart';

import '../../../core/network/api_client.dart';
import '../../../design_system/design_system.dart';
import '../../../l10n/app_localizations_context.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../data/remote_community_repository.dart';
import '../domain/community_models.dart';
import 'community_new_page.dart';
import 'community_style.dart';
import 'community_avatar.dart';
import 'day_strip.dart';
import 'group_chat_page.dart';

/// 社区主页 —— 逐屏复刻原型 `src/screens/comunidade/Comunidade.jsx`
/// （modelo B「Mural」）：封面轮播 → Para hoje → 打卡墙。
///
/// 版式、间距、颜色全部对齐 `comunidade.css`；「Dar força」依赖后端缺口
/// G-1（reactions），先占位提示；封面图依赖群封面上传，暂用渐变底。
class CommunityPage extends StatefulWidget {
  const CommunityPage({this.repository, super.key});

  final RemoteCommunityRepository? repository;

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  late final RemoteCommunityRepository _repo =
      widget.repository ?? RemoteCommunityRepository(ApiClient.configured());

  bool _loading = true;
  String? _error;
  int _day = 0; // 0 = Hoje, 1 = Ontem（原型 FaixaDias 的序）
  List<CommunityGroup> _groups = const [];
  List<CommunityInvitation> _invitations = const [];
  List<CuratedChallenge> _mine = const [];
  final Map<String, CommunityRankingEntry?> _myRank = {};
  List<CommunityMessage> _mural = const [];
  List<CommunityAtlasInsight> _atlas = const [];

  @override
  void initState() {
    super.initState();
    _reload();
  }

  Future<void> _reload() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final groups = await _repo.listGroups();
      final invitations = await _repo.listInvitations();
      final catalog = await _repo.listChallenges();
      // 目录接口可能不带逐日数据，报名中的挑战拉详情补齐。
      final mine = <CuratedChallenge>[];
      for (final challenge in catalog) {
        if (!challenge.enrolled) continue;
        try {
          mine.add(await _repo.challengeDetail(challenge.id));
        } catch (_) {
          mine.add(challenge);
        }
      }
      // 群列表会连同「可发现的公开群」一起返回（membershipState =
      // not_joined）。只有 joined 的群才允许读详情/消息，公开未加入的群
      // 详情会 403——这不是错误，是「还没加入」的正常状态，封面给
      // Entrar 按钮即可。打卡墙挂在第一个已加入的群上。
      final joinedGroups = groups
          .where((g) => g.membershipState == 'joined')
          .toList(growable: false);
      for (final group in joinedGroups) {
        try {
          final goals = await _repo.groupGoals(group.id);
          for (final goal in goals) {
            final ranking = await _repo.goalRanking(group.id, goal.id);
            _myRank[group.id] ??= ranking.where((r) => r.isMe).firstOrNull;
          }
        } catch (_) {}
      }
      var mural = <CommunityMessage>[];
      var atlas = <CommunityAtlasInsight>[];
      if (joinedGroups.isNotEmpty) {
        try {
          final messages = await _repo.listMessages(joinedGroups.first.id);
          messages.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          mural = messages;
          try {
            atlas = await _repo.groupAtlas(joinedGroups.first.id);
          } catch (_) {}
        } catch (_) {}
      }
      if (!mounted) return;
      setState(() {
        _groups = groups;
        _invitations = invitations;
        _mine = mine;
        _mural = mural;
        _atlas = atlas;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error.toString();
        _loading = false;
      });
    }
  }

  Future<void> _markDone(CuratedChallenge challenge) async {
    final today = challenge.today;
    if (today == null) return;
    try {
      await _repo.markChallengeDay(
        challenge.id,
        today.dayNumber,
        completed: true,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.communityMarkedDone)),
      );
      await _reload();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    }
  }

  Future<void> _respond(
    CommunityInvitation invitation, {
    required bool accept,
  }) async {
    await _repo.respondInvitation(invitation.id, accept: accept);
    if (!accept || !mounted) {
      await _reload();
      return;
    }
    Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => GroupChatPage(
          groupId: invitation.groupId,
          groupName: invitation.groupName,
          repository: _repo,
        ),
      ),
    );
  }

  Future<void> _join(CommunityGroup group) async {
    try {
      await _repo.joinGroup(group.id, consent: true);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.communityJoinedGroup)),
      );
      await _reload();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  void _openChat(CommunityGroup group) {
    Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => GroupChatPage(
          groupId: group.id,
          groupName: group.name,
          repository: _repo,
        ),
      ),
    );
  }

  void _openNew() {
    Navigator.of(context).push<void>(
      MaterialPageRoute(builder: (_) => CommunityNewPage(repository: _repo)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    final today = _day == 0;
    final joined = _groups
        .where((g) => g.membershipState == 'joined')
        .toList(growable: false);
    final main = joined.isEmpty ? null : joined.first;
    final mural =
        _mural.where((m) => _sameDay(m.createdAt, today)).toList();
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: _loading
            ? const Center(child: AppLoadingIndicator())
            : _error != null
                ? _CenterText(_error!)
                : RefreshIndicator(
                    onRefresh: _reload,
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        _header(strings),
                        const SizedBox(height: 10),
                        _dayStrip(strings),
                        const SizedBox(height: 4),
                        _covers(strings),
                        if (today) ...[
                          const SizedBox(height: 20),
                          ..._paraHoje(strings, main),
                        ],
                        if (main != null) ...[
                          const SizedBox(height: 8),
                          _muralSection(strings, main, mural, today),
                        ],
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
      ),
    );
  }

  bool _sameDay(DateTime date, bool today) {
    final now = DateTime.now();
    final diff = DateTime(now.year, now.month, now.day)
        .difference(DateTime(date.year, date.month, date.day))
        .inDays;
    return today ? diff == 0 : diff == 1;
  }

  // .cm-cab：grid 40/1fr/40，标题居中 17px w500；右侧 + 为纯图标钮
  // （源码 .cm-cab button 无底色）。
  Widget _header(AppLocalizations strings) {
    return SizedBox(
      height: 54,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            strings.community,
            style: AppTypography.listItem.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
              fontSize: 17,
            ),
          ),
          Positioned(
            right: 0,
            child: GestureDetector(
              onTap: _openNew,
              behavior: HitTestBehavior.opaque,
              child: const SizedBox(
                width: 40,
                height: 40,
                child: Icon(Icons.add_rounded, size: 22),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // FaixaDias：Ontem · Hoje 文字 tab + 固定居中 marca（源码 .hdx-*，
  // 与 Memória 页 tab 条同族；条带满幅出血 margin 0 -16px，同 _covers）。
  Widget _dayStrip(AppLocalizations strings) {
    // 源码渲染顺序：index 0 = Ontem（_day 1），index 1 = Hoje（_day 0）。
    final labels = [
      strings.communityDayYesterday,
      strings.communityDayToday,
    ];
    final screen = MediaQuery.sizeOf(context).width;
    return SizedBox(
      height: 52, // DayStrip 自身 46 + 顶部 6
      child: OverflowBox(
        maxWidth: screen,
        alignment: Alignment.topLeft,
        child: Transform.translate(
          offset: const Offset(-16, 0),
          child: SizedBox(
            width: screen,
            child: DayStrip(
              labels: labels,
              selectedIndex: _day == 0 ? 1 : 0,
              onSelect: (index) => setState(() => _day = index == 1 ? 0 : 1),
            ),
          ),
        ),
      ),
    );
  }

  // .cmb-capas：封面轮播（群 + 邀请 + 建群空位）；满幅出血、内衬 16。
  //
  // 出血实现：外层 ListView 有水平 16 内衬（tight 宽 = 屏幕-32），直接在里面
  // 放更宽的子项会拿到「水平视口高度无界」的布局异常（黑屏根因）。所以用
  // OverflowBox 放宽到屏幕宽、再 Transform 左移 16——布局有界、绘制出血。
  Widget _covers(AppLocalizations strings) {
    final screen = MediaQuery.sizeOf(context).width;
    final joined = _groups
        .where((g) => g.membershipState == 'joined')
        .toList(growable: false);
    CuratedChallenge? coverChallenge;
    if (joined.isNotEmpty && _mine.isNotEmpty) {
      coverChallenge = _mine.first;
    }
    return SizedBox(
      height: CommunityStyle.coverHeight,
      child: OverflowBox(
        maxWidth: screen,
        alignment: Alignment.centerLeft,
        child: Transform.translate(
          offset: const Offset(-16, 0),
          child: SizedBox(
            width: screen,
            height: CommunityStyle.coverHeight,
            child: ListView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                for (final group in _groups)
                  if (group.membershipState == 'joined')
                    _GroupCover(
                      name: group.name,
                      memberCount: group.memberCount,
                      members: group.members,
                      challenge:
                          group == joined.firstOrNull ? coverChallenge : null,
                      myRank: _myRank[group.id],
                      onTap: () => _openChat(group),
                    )
                  else
                    _PublicCover(
                      group: group,
                      onJoin: () => _join(group),
                    ),
                for (final invitation in _invitations)
                  _InviteCover(
                    invitation: invitation,
                    onAccept: () => _respond(invitation, accept: true),
                    onDecline: () => _respond(invitation, accept: false),
                  ),
                _NewCover(onTap: _openNew),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // .cmb-hoje：Para hoje。
  List<Widget> _paraHoje(AppLocalizations strings, CommunityGroup? main) {
    if (_mine.isEmpty) {
      return [
        Material(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(CommunityStyle.cardRadius),
          child: InkWell(
            borderRadius: BorderRadius.circular(CommunityStyle.cardRadius),
            onTap: _openNew,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: CommunityStyle.accentSoft,
                      border: Border.all(color: const Color(0x73EC7030)),
                    ),
                    child: const Icon(
                      Icons.add_rounded,
                      size: 20,
                      color: CommunityStyle.accent,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          strings.communityPickChallenge,
                          style: AppTypography.listItem.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          strings.communityPickChallengeSub,
                          style: AppTypography.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ];
    }
    return [
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(CommunityStyle.surfaceCardRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // .cmb-k：kicker 居左，群名居右
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  strings.communityParaHoje.toUpperCase(),
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
                    letterSpacing: 2.2,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (main != null)
                  Text(
                    main.name,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            for (final challenge in _mine)
              _TodayRow(
                challenge: challenge,
                onMark: () => _markDone(challenge),
              ),
          ],
        ),
      ),
    ];
  }

  // .cmb-sec：打卡墙。
  Widget _muralSection(
    AppLocalizations strings,
    CommunityGroup group,
    List<CommunityMessage> messages,
    bool today,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              today
                  ? strings.communityMuralToday
                  : strings.communityMuralYesterday,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 28,
                fontWeight: FontWeight.w300,
                letterSpacing: -0.7,
                height: 1.12,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
            child: Text(
              strings.communityMuralIntro,
              style: AppTypography.caption.copyWith(
                color: AppColors.textMuted,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 14),
          for (final insight in _atlas) _AtlasPost(insight: insight),
          if (messages.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12, left: 4),
              child: Text(
                today
                    ? strings.communityNoCheckinsToday
                    : strings.communityNoCheckinsYesterday,
                style: AppTypography.label.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            )
          else
            for (final message in messages)
              _CheckinPost(
                message: message,
                onCheer: () => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(strings.communityCheerSoon)),
                ),
                onRespond: () => _openChat(group),
              ),
          const SizedBox(height: 8),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _openChat(group),
              child: Container(
                padding: const EdgeInsets.fromLTRB(4, 14, 4, 14),
                decoration: const BoxDecoration(
                  border:
                      Border(top: BorderSide(color: CommunityStyle.stroke)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      strings.communityOpenGroupChat,
                      style: AppTypography.listItem.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      size: 18,
                      color: AppColors.textMuted,
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

// ---- 封面 ----

class _GroupCover extends StatelessWidget {
  const _GroupCover({
    required this.name,
    required this.memberCount,
    required this.members,
    required this.challenge,
    required this.myRank,
    required this.onTap,
  });

  final String name;
  final int memberCount;
  final List<CommunityMember> members;
  final CuratedChallenge? challenge;
  final CommunityRankingEntry? myRank;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final stack = members.take(5).toList();
    final rank = myRank;
    final showRank = rank != null && rank.rank > 0 && memberCount > 1;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: CommunityStyle.coverWidth,
        height: CommunityStyle.coverHeight,
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(CommunityStyle.coverRadius),
          gradient: CommunityStyle.coverFallback,
        ),
        child: Stack(
          children: [
            const DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(CommunityStyle.coverRadius),
                ),
                gradient: CommunityStyle.coverScrim,
              ),
              child: SizedBox.expand(),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // .cmb-t1：头像堆叠 + 人数
                Row(
                  children: [
                    Expanded(child: _AvatarStack(members: stack)),
                    Text(
                      context.l10n.communityMemberCount(memberCount),
                      style: AppTypography.caption.copyWith(
                        color: CommunityStyle.onImage,
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
                // .cmb-lin：左侧挑战进度，右侧 42px 细体排名
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 21,
                              fontWeight: FontWeight.w400,
                              letterSpacing: -0.01,
                            ),
                          ),
                          if (challenge != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              context.l10n.communityDayOfTotal(
                                challenge!.today?.dayNumber ?? 1,
                                challenge!.durationDays,
                              ),
                              style: const TextStyle(
                                color: CommunityStyle.onImage,
                                fontSize: 13,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (showRank)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${rank.rank}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 42,
                                  fontWeight: FontWeight.w200,
                                  height: 0.85,
                                  letterSpacing: -0.03,
                                ),
                              ),
                              Text(
                                'º',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 42 * 0.34,
                                  fontWeight: FontWeight.w300,
                                  height: 1,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            context
                                .l10n.communityRankOf(memberCount)
                                .toUpperCase(),
                            style: const TextStyle(
                              color: CommunityStyle.onImage,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1.6,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PublicCover extends StatelessWidget {
  const _PublicCover({required this.group, required this.onJoin});

  final CommunityGroup group;
  final VoidCallback onJoin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: CommunityStyle.coverWidth,
      height: CommunityStyle.coverHeight,
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(CommunityStyle.coverRadius),
        gradient: CommunityStyle.coverFallback,
      ),
      child: Stack(
        children: [
          const DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(CommunityStyle.coverRadius),
              ),
              gradient: CommunityStyle.coverScrim,
            ),
            child: SizedBox.expand(),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: _AvatarStack(members: group.members)),
                  Text(
                    context.l10n.communityMemberCount(group.memberCount),
                    style: AppTypography.caption.copyWith(
                      color: CommunityStyle.onImage,
                      fontSize: 12.5,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.communityPublicGroup,
                    style: const TextStyle(
                      color: CommunityStyle.onImage,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    group.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.01,
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerRight,
                child: _CoverButton(
                  label: context.l10n.communityJoin,
                  filled: true,
                  onTap: onJoin,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InviteCover extends StatelessWidget {
  const _InviteCover({
    required this.invitation,
    required this.onAccept,
    required this.onDecline,
  });

  final CommunityInvitation invitation;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: CommunityStyle.coverWidth,
      height: CommunityStyle.coverHeight,
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(CommunityStyle.coverRadius),
        gradient: CommunityStyle.coverFallback,
      ),
      child: Stack(
        children: [
          const DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(CommunityStyle.coverRadius),
              ),
              gradient: CommunityStyle.coverScrim,
            ),
            child: SizedBox.expand(),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // .cmb-t1：成员堆叠 + 「convite de {名}」
              Row(
                children: [
                  Expanded(
                    child: _AvatarStack(
                      members: const [],
                      extraInitial: invitation.inviterName,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      context.l10n.communityInviteFromShort(
                        invitation.inviterName,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: CommunityStyle.onImage,
                        fontSize: 12.5,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    invitation.groupName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.01,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    context.l10n.communityInviteFromShort(
                      invitation.inviterName,
                    ),
                    style: const TextStyle(
                      color: CommunityStyle.onImage,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
              // .cmb-bts：Depois / Entrar
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _CoverButton(
                    label: context.l10n.communityDecline,
                    filled: false,
                    onTap: onDecline,
                  ),
                  const SizedBox(width: 6),
                  _CoverButton(
                    label: context.l10n.communityAccept,
                    filled: true,
                    onTap: onAccept,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CoverButton extends StatelessWidget {
  const _CoverButton({
    required this.label,
    required this.filled,
    required this.onTap,
  });

  final String label;
  final bool filled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: filled ? const Color(0xFFF4F5F7) : const Color(0x1AFFFFFF),
        ),
        child: Text(
          label,
          style: AppTypography.caption.copyWith(
            color: filled ? const Color(0xFF14181D) : AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _NewCover extends StatelessWidget {
  const _NewCover({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // .cmb-capa.vazia：宽 180、居中、+ 为 44 圆（白 .08），无边框。
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 180,
        height: CommunityStyle.coverHeight,
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(CommunityStyle.coverRadius),
          color: AppColors.surface,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x14FFFFFF),
              ),
              child: const Icon(Icons.add_rounded, size: 22, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Text(
              context.l10n.communityNewCover,
              textAlign: TextAlign.center,
              style: AppTypography.label.copyWith(
                color: AppColors.textSecondary,
                fontSize: 13.5,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AvatarStack extends StatelessWidget {
  const _AvatarStack({required this.members, this.extraInitial});

  final List<CommunityMember> members;

  /// 邀请封面没有成员列表：只渲染邀请人一个头像（源码 Pilha 的单成员形态）。
  final String? extraInitial;

  @override
  Widget build(BuildContext context) {
    final stack = members.take(5).toList();
    return SizedBox(
      height: 26,
      child: Stack(
        children: [
          for (var i = stack.length - 1; i >= 0; i--)
            Positioned(
              left: i * 20.0,
              child: CommunityAvatar(
                name: stack[i].displayName,
                avatarUrl: stack[i].avatarUrl,
                size: 26,
              ),
            ),
          if (stack.isEmpty && extraInitial != null)
            CommunityAvatar(name: extraInitial!, size: 26),
        ],
      ),
    );
  }
}


// ---- Para hoje ----

class _TodayRow extends StatelessWidget {
  const _TodayRow({required this.challenge, required this.onMark});

  final CuratedChallenge challenge;
  final VoidCallback onMark;

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    final today = challenge.today;
    final allDone = today != null && today.completed;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: CommunityStyle.stroke)),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0x59FFFFFF)),
            ),
            child: const Icon(
              Icons.radio_button_unchecked_rounded,
              size: 15,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  today == null || today.action.isEmpty
                      ? challenge.title
                      : today.action,
                  style: AppTypography.listItem.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  strings.communityDayOfTotal(
                    today?.dayNumber ?? 0,
                    challenge.durationDays,
                  ),
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          if (allDone)
            Text(
              strings.communityDoneToday,
              style: AppTypography.caption.copyWith(color: AppColors.sage),
            )
          else
            GestureDetector(
              onTap: onMark,
              child: Container(
                height: 34,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: const Color(0x1AFFFFFF),
                ),
                child: Text(
                  strings.communityMarkDone,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ---- 打卡墙的帖子 ----

class _AtlasPost extends StatelessWidget {
  const _AtlasPost({required this.insight});

  final CommunityAtlasInsight insight;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(CommunityStyle.surfaceCardRadius),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0x1FF2C27F),
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              size: 16,
              color: CommunityStyle.gold,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.communityAtlasKicker,
                  style: AppTypography.caption.copyWith(
                    color: CommunityStyle.gold,
                    fontSize: 10.5,
                    letterSpacing: 1.8,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  insight.summary,
                  style: AppTypography.label.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckinPost extends StatelessWidget {
  const _CheckinPost({
    required this.message,
    required this.onCheer,
    required this.onRespond,
  });

  final CommunityMessage message;
  final VoidCallback onCheer;
  final VoidCallback onRespond;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(CommunityStyle.surfaceCardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CommunityAvatar(
                name: message.authorDisplayName,
                avatarUrl: message.authorAvatarUrl,
                size: 36,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message.authorDisplayName,
                      style: AppTypography.label.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                        fontSize: 14.5,
                      ),
                    ),
                    // 源码 cab small：{时间} · check-in
                    Text(
                      '${message.createdAt.hour.toString().padLeft(2, '0')}:${message.createdAt.minute.toString().padLeft(2, '0')}'
                      ' · ${context.l10n.communityCheckinLabel}',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            message.content,
            style: AppTypography.body.copyWith(
              color: AppColors.textPrimary,
              fontSize: 15,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.only(top: 10),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: CommunityStyle.stroke)),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: onCheer,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.favorite_border_rounded,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 7),
                      Text(
                        context.l10n.communityCheer,
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 18),
                GestureDetector(
                  onTap: onRespond,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.chat_bubble_outline_rounded,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 7),
                      Text(
                        context.l10n.communityRespond,
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CenterText extends StatelessWidget {
  const _CenterText(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
      ),
    );
  }
}
