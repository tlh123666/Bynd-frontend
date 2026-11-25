import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../../../core/network/api_client.dart';
import '../../../design_system/design_system.dart';
import '../../../l10n/app_localizations_context.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../data/remote_community_repository.dart';
import '../domain/community_models.dart';
import 'community_new_page.dart';
import 'community_style.dart';
import 'group_chat_page.dart';

/// 社区主页 —— 对齐客户 11-22 设计源码 `src/screens/comunidade/Comunidade.jsx`
/// （Luiz 11-20/21 的「modelo Whoop Teams com a cara da BYND」清单式改版，
/// 含 11-24 渲染核对）：
///
/// 头图是**全出血背景层**（.cmb > .cmb-foto：absolute top 0，高约 90% 屏高，
/// cover 50% 30%，65% 处 mask 渐隐；再叠暗化渐变 .25/.05@25%/.55@62%/.85），
/// 头部与内容行浮在照片上，随内容一起滚动。之后是邀请玻璃条（仅一条 +
/// 计数徽章）→「Seus times」行（名 + 人数 + 我的名次）→「Seus desafios」行
/// （dia X de Y + 今日 selo 三色）→ 底部「玻璃 + 白」双按钮；邀请/菜单/
/// 完成列表走底部弹层。
///
/// 版式与颜色逐项对齐 `styles/comunidade.css` 的 `.cmm` 块与 `.cmb-ln`；字体
/// Urbanist 已在全局。数据逻辑沿用原实现（群 / 邀请 / 精选挑战 / 排名）；
/// 旧「封面轮播 + Para hoje + 打卡墙」按新设计移除，打卡动作收进挑战行弹层。
class CommunityPage extends StatefulWidget {
  const CommunityPage({this.repository, super.key});

  final RemoteCommunityRepository? repository;

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  late final RemoteCommunityRepository _repo =
      widget.repository ?? RemoteCommunityRepository(ApiClient.configured());

  final ScrollController _scroll = ScrollController();
  double _glass = 0;
  bool _loading = true;
  String? _error;
  List<CommunityGroup> _groups = const [];
  List<CommunityInvitation> _invitations = const [];
  List<CuratedChallenge> _mine = const [];
  final Map<String, CommunityRankingEntry?> _myRank = {};

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
    _reload();
  }

  // 标题和操作栏始终固定，滚动距离只驱动下方玻璃背景的渐进叠加。
  void _onScroll() {
    final glass = (_scroll.offset / 80).clamp(0.0, 1.0);
    if ((glass - _glass).abs() > 0.01 && mounted) {
      setState(() => _glass = glass);
    }
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
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
      // 群列表会连同「可发现的公开群」一起返回；排名挂在第一个已加入的群上。
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
      if (!mounted) return;
      setState(() {
        _groups = groups;
        _invitations = invitations;
        _mine = mine;
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.communityMarkedDone)));
      await _reload();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
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

  // 挑战今日状态 → (文案, 颜色)，对应源码 seloHoje：Feito hoje(绿) /
  // Não contou(灰) / Falta hoje(黄)。未开始的挑战没有开始日期字段，
  // 用「Não começou」灰标兜底。
  (String, Color) _seloHoje(CuratedChallenge challenge, AppLocalizations s) {
    final today = challenge.today;
    if (today == null) return (s.communityNotStarted, CommunityStyle.seloApaga);
    return today.completed
        ? (s.communityDoneToday, CommunityStyle.seloVerde)
        : (s.communityPendingToday, CommunityStyle.seloAmarelo);
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    final joined = _groups
        .where((g) => g.membershipState == 'joined')
        .toList(growable: false);
    final concluded = _mine.where(
      (c) => (c.today?.dayNumber ?? 0) >= c.durationDays,
    );
    final active = _mine
        .where((c) => (c.today?.dayNumber ?? 0) < c.durationDays)
        .toList(growable: false);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          _loading
              ? const Center(child: AppLoadingIndicator())
              : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      _error!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: CommunityStyle.text72,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _reload,
                  child: ListView(
                    controller: _scroll,
                    padding: EdgeInsets.zero,
                    children: [
                      // 照片层 + 内容同栈：照片随内容一起滚动（原型里
                      // .cmb-foto 是滚动内容内的 absolute 层）。
                      Stack(
                        children: [
                          _heroBackdrop(),
                          SafeArea(
                            bottom: false,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 54),
                                  if (_invitations.isNotEmpty) ...[
                                    const SizedBox(height: 12),
                                    _invitesRow(strings),
                                  ],
                                  _sectionTitle(
                                    strings,
                                    icon: Icons.groups_rounded,
                                    title: strings.communityMyTeams,
                                    marginTop: _invitations.isNotEmpty
                                        ? 24
                                        : 36,
                                  ),
                                  if (joined.isEmpty)
                                    Padding(
                                      padding: EdgeInsets.zero,
                                      child: _EmptyText(
                                        strings.communityTeamsEmpty,
                                      ),
                                    )
                                  else
                                    ...joined.map((g) => _teamRow(strings, g)),
                                  _sectionTitle(
                                    strings,
                                    icon: Icons.emoji_events_outlined,
                                    title: strings.communityMyChallenges,
                                    marginTop: 36,
                                  ),
                                  if (active.isEmpty && concluded.isEmpty)
                                    Padding(
                                      padding: EdgeInsets.zero,
                                      child: _EmptyText(
                                        strings.communityChallengesEmpty,
                                      ),
                                    )
                                  else ...[
                                    ...active.map(
                                      (c) => _challengeRow(strings, c),
                                    ),
                                    if (concluded.isNotEmpty)
                                      _concludedRow(strings, concluded.length),
                                  ],
                                  _bottomButtons(strings),
                                  const SizedBox(height: 72),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
          Positioned(top: 0, left: 0, right: 0, child: _pinnedHeader(strings)),
        ],
      ),
    );
  }

  // .sn-cab：吸顶头部（sticky top 0, z 5/6）。滚动后 .rolou：玻璃 =
  // blur(16px) + 渐变纱 rgba(34,44,56,.96) 70% → 透明，内容从下面滚过时
  // 被模糊化（与原型一致）。
  Widget _pinnedHeader(AppLocalizations strings) {
    final header = SizedBox(
      height: 54,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            strings.community,
            style: const TextStyle(
              color: CommunityStyle.textBright,
              fontSize: 17,
              fontWeight: FontWeight.w500,
              fontFamily: 'Urbanist',
            ),
          ),
          Positioned(
            right: 8,
            child: IconButton(
              onPressed: _openMenu,
              icon: const Icon(Icons.more_horiz, size: 22),
              color: CommunityStyle.text72,
            ),
          ),
        ],
      ),
    );
    return SafeArea(
      bottom: false,
      child: SizedBox(
        height: 54,
        child: Stack(
          fit: StackFit.expand,
          children: [
            IgnorePointer(
              child: Opacity(
                opacity: _glass,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                    child: const SizedBox.expand(),
                  ),
                ),
              ),
            ),
            header,
          ],
        ),
      ),
    );
  }

  // .cmb > .cmb-foto：全出血照片背景层。高约 90% 屏高（原型 --foto-topo-h
  // 760px / 844 视口），background-position 50% 30%；65% 处开始 mask 渐隐；
  // 内叠暗化渐变 rgba(18,20,24,.25)→.05@25%→.55@62%→.85。
  Widget _heroBackdrop() {
    final height = MediaQuery.sizeOf(context).height * 0.90;
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: height,
      child: ShaderMask(
        shaderCallback: (bounds) => const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black, Colors.black, Colors.transparent],
          stops: [0, 0.60, 1],
        ).createShader(bounds),
        blendMode: BlendMode.dstIn,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/comunidade-maos.webp',
              fit: BoxFit.cover,
              alignment: const Alignment(0, 0.3),
              errorBuilder: (_, _, _) => const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: CommunityStyle.coverFallback,
                ),
              ),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0, 0.30, 0.60, 1],
                  colors: [
                    Color(0x80121418), // rgba(18,20,24,.50)
                    Color(0x94121418), // rgba(18,20,24,.58)
                    Color(0xC7121418), // rgba(18,20,24,.78)
                    Color(0xEB121418), // rgba(18,20,24,.92)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // .cmt-cvl：邀请玻璃条（一条，计数徽章），点开邀请弹层。
  Widget _invitesRow(AppLocalizations strings) {
    final n = _invitations.length;
    final subtitle = n == 1
        ? strings.communityInviteFromShort(_invitations.first.inviterName)
        : '${_invitations.where((i) => i.groupId.isNotEmpty).length} ${strings.communityInviteTeam}';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: CommunityStyle.glass,
      ),
      child: _cmbRow(
        leading: Icon(
          Icons.notifications_none_rounded,
          size: 22,
          color: CommunityStyle.text72,
        ),
        title: n == 1 ? strings.communityInviteOne : strings.communityInvites,
        subtitle: subtitle,
        trailing: _countBadge(n),
        onTap: _openInvitesSheet,
      ),
    );
  }

  // .cmm-st：20/300 字重，图标 18，间距 10；cmb 作用域 margin 36/14。
  Widget _sectionTitle(
    AppLocalizations strings, {
    required IconData icon,
    required String title,
    required double marginTop,
  }) {
    return Padding(
      padding: EdgeInsets.fromLTRB(4, marginTop, 4, 14),
      child: Row(
        children: [
          Icon(icon, size: 18, color: CommunityStyle.text72),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: CommunityStyle.textBright,
                fontSize: 20,
                fontWeight: FontWeight.w300,
                height: 25 / 20,
                letterSpacing: -0.01,
                fontFamily: 'Urbanist',
              ),
            ),
          ),
        ],
      ),
    );
  }

  // .cmb-ln：一行（72 高，底部细线到右缘）：ft 32 + 名/副行 + 徽章 + chevron。
  Widget _teamRow(AppLocalizations strings, CommunityGroup group) {
    final rank = _myRank[group.id];
    final showRank = rank != null && rank.rank > 0 && group.memberCount > 1;
    final members = strings.communityMemberCount(group.memberCount);
    final subtitle = showRank
        ? '$members · ${rank.rank}º ${strings.communityRankOf(group.memberCount)}'
        : members;
    return _cmbRow(
      onTap: () => _openChat(group),
      leading: ClipOval(
        child: Image.asset(
          'assets/images/comunidade-maos.webp',
          width: 32,
          height: 32,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => Container(
            width: 32,
            height: 32,
            color: CommunityStyle.chip,
            alignment: Alignment.center,
            child: Text(
              group.name.isEmpty ? '' : group.name[0].toUpperCase(),
              style: const TextStyle(
                color: CommunityStyle.textBright,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                fontFamily: 'Urbanist',
              ),
            ),
          ),
        ),
      ),
      title: group.name,
      subtitle: subtitle,
      trailing: group.unreadCount > 0 ? _countBadge(group.unreadCount) : null,
    );
  }

  // .cmb-ln：挑战行（图标 + 名 + dia X de Y + 今日 selo）。
  Widget _challengeRow(AppLocalizations strings, CuratedChallenge challenge) {
    final (label, color) = _seloHoje(challenge, strings);
    final started = challenge.today != null;
    final subtitle = started
        ? strings.communityDayOfTotal(
            challenge.today!.dayNumber,
            challenge.durationDays,
          )
        : strings.communityDurationDays(challenge.durationDays);
    return _cmbRow(
      onTap: () => _openChallengeSheet(challenge),
      leading: SizedBox(
        width: 32,
        child: Icon(
          Icons.track_changes_rounded,
          size: 20,
          color: CommunityStyle.text72,
        ),
      ),
      title: challenge.title,
      subtitle: subtitle,
      trailing: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.4,
          fontFamily: 'Urbanist',
        ),
      ),
    );
  }

  // 「Desafios concluídos」行：结果计数。
  Widget _concludedRow(AppLocalizations strings, int count) {
    return _cmbRow(
      leading: SizedBox(
        width: 32,
        child: Icon(
          Icons.flag_outlined,
          size: 20,
          color: CommunityStyle.text72,
        ),
      ),
      title: strings.communityConcluded,
      subtitle: strings.communityConcludedSub,
      trailing: Text(
        '$count',
        style: const TextStyle(
          color: CommunityStyle.text72,
          fontSize: 14,
          fontFamily: 'Urbanist',
        ),
      ),
      onTap: _openConcludedSheet,
    );
  }

  // .cmb-ln 行通用结构：min-height 72，底部 1px 细线，行尾固定 chevron。
  Widget _cmbRow({
    required Widget leading,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    final row = Container(
      constraints: const BoxConstraints(minHeight: 72),
      padding: const EdgeInsets.fromLTRB(4, 12, 0, 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: CommunityStyle.stroke)),
      ),
      child: Row(
        children: [
          leading,
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: CommunityStyle.textBright,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Urbanist',
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: CommunityStyle.text72,
                    fontSize: 13,
                    height: 1.3,
                    fontFamily: 'Urbanist',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          if (trailing != null) ...[trailing, const SizedBox(width: 8)],
          const Icon(
            Icons.chevron_right_rounded,
            size: 18,
            color: CommunityStyle.text50,
          ),
        ],
      ),
    );
    if (onTap == null) return row;
    return InkWell(onTap: onTap, child: row);
  }

  // .nl：未读/计数徽章（浅底深字 20px 胶囊）。
  Widget _countBadge(int count) {
    return Container(
      constraints: const BoxConstraints(minWidth: 20),
      height: 20,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: CommunityStyle.textBright,
      ),
      child: Text(
        '$count',
        style: const TextStyle(
          color: Color(0xFF121418),
          fontSize: 12,
          fontFamily: 'Urbanist',
        ),
      ),
    );
  }

  // .cmm-pe：底部双按钮（玻璃左「Entrar com código」+ 白右「Criar time」，
  // 132 + 8 + 132）。
  Widget _bottomButtons(AppLocalizations strings) {
    return Padding(
      padding: const EdgeInsets.only(top: 36),
      child: Row(
        children: [
          Expanded(
            child: _pillButton(
              label: strings.communityJoinWithCode,
              glass: true,
              onTap: _openNew,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _pillButton(
              label: strings.communityCreateTeam,
              glass: false,
              onTap: _openNew,
            ),
          ),
        ],
      ),
    );
  }

  Widget _pillButton({
    required String label,
    required bool glass,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 132,
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: glass ? CommunityStyle.glass : CommunityStyle.textBright,
          border: glass ? Border.all(color: CommunityStyle.strokeStrong) : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: glass ? CommunityStyle.textBright : const Color(0xFF121418),
            fontSize: 13,
            fontWeight: glass ? FontWeight.w400 : FontWeight.w500,
            fontFamily: 'Urbanist',
          ),
        ),
      ),
    );
  }

  // ---- 弹层 ----

  void _openMenu() {
    final strings = context.l10n;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: CommunityStyle.sheet,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _sheetItem(
              sheetContext,
              icon: Icons.groups_rounded,
              label: strings.communityCreateTeam,
              onTap: () {
                Navigator.of(sheetContext).pop();
                _openNew();
              },
            ),
            _sheetItem(
              sheetContext,
              icon: Icons.link_rounded,
              label: strings.communityJoinWithCode,
              onTap: () {
                Navigator.of(sheetContext).pop();
                _openNew();
              },
            ),
            _sheetItem(
              sheetContext,
              icon: Icons.flag_outlined,
              label: strings.communityConcluded,
              onTap: () {
                Navigator.of(sheetContext).pop();
                _openConcludedSheet();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _openInvitesSheet() {
    final strings = context.l10n;
    final invites = _invitations;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: CommunityStyle.sheet,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (sheetContext) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
          children: [
            Text(
              strings.communityInvites,
              style: const TextStyle(
                color: CommunityStyle.textBright,
                fontSize: 17,
                fontWeight: FontWeight.w500,
                fontFamily: 'Urbanist',
              ),
            ),
            const SizedBox(height: 8),
            for (final invite in invites) ...[
              const SizedBox(height: 8),
              Text(
                invite.groupName,
                style: const TextStyle(
                  color: CommunityStyle.textBright,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Urbanist',
                ),
              ),
              Text(
                '${strings.communityInviteTeam} · ${strings.communityInviteFromShort(invite.inviterName)}',
                style: const TextStyle(
                  color: CommunityStyle.text72,
                  fontSize: 13,
                  fontFamily: 'Urbanist',
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _pillButton(
                    label: strings.communityDecline,
                    glass: true,
                    onTap: () {
                      Navigator.of(sheetContext).pop();
                      _respond(invite, accept: false);
                    },
                  ),
                  const SizedBox(width: 8),
                  _pillButton(
                    label: strings.communityAccept,
                    glass: false,
                    onTap: () {
                      Navigator.of(sheetContext).pop();
                      _respond(invite, accept: true);
                    },
                  ),
                ],
              ),
            ],
            if (invites.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  strings.communityInviteNone,
                  style: const TextStyle(
                    color: CommunityStyle.text50,
                    fontSize: 13,
                    fontFamily: 'Urbanist',
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _openChallengeSheet(CuratedChallenge challenge) {
    final strings = context.l10n;
    final (label, color) = _seloHoje(challenge, strings);
    final done = challenge.today?.completed ?? false;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: CommunityStyle.sheet,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                challenge.title,
                style: const TextStyle(
                  color: CommunityStyle.textBright,
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Urbanist',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                challenge.today != null
                    ? strings.communityDayOfTotal(
                        challenge.today!.dayNumber,
                        challenge.durationDays,
                      )
                    : strings.communityDurationDays(challenge.durationDays),
                style: const TextStyle(
                  color: CommunityStyle.text72,
                  fontSize: 13,
                  fontFamily: 'Urbanist',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.4,
                  fontFamily: 'Urbanist',
                ),
              ),
              if (challenge.today != null) ...[
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: TextButton(
                    onPressed: done
                        ? null
                        : () {
                            Navigator.of(sheetContext).pop();
                            _markDone(challenge);
                          },
                    style: TextButton.styleFrom(
                      backgroundColor: done
                          ? CommunityStyle.chip
                          : CommunityStyle.textBright,
                      shape: const StadiumBorder(),
                    ),
                    child: Text(
                      done
                          ? strings.communityDoneToday
                          : strings.communityMarkDay,
                      style: TextStyle(
                        color: done
                            ? CommunityStyle.text72
                            : const Color(0xFF121418),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Urbanist',
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _openConcludedSheet() {
    final strings = context.l10n;
    final concluded = _mine.where(
      (c) => (c.today?.dayNumber ?? 0) >= c.durationDays,
    );
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: CommunityStyle.sheet,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (sheetContext) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
          children: [
            Text(
              strings.communityConcluded,
              style: const TextStyle(
                color: CommunityStyle.textBright,
                fontSize: 17,
                fontWeight: FontWeight.w500,
                fontFamily: 'Urbanist',
              ),
            ),
            const SizedBox(height: 8),
            for (final challenge in concluded)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      challenge.title,
                      style: const TextStyle(
                        color: CommunityStyle.textBright,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Urbanist',
                      ),
                    ),
                    Text(
                      strings.communityDurationDays(challenge.durationDays),
                      style: const TextStyle(
                        color: CommunityStyle.text72,
                        fontSize: 13,
                        fontFamily: 'Urbanist',
                      ),
                    ),
                  ],
                ),
              ),
            if (concluded.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  strings.communityConcludedEmpty,
                  style: const TextStyle(
                    color: CommunityStyle.text50,
                    fontSize: 13,
                    fontFamily: 'Urbanist',
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _sheetItem(
    BuildContext sheetContext, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, size: 20, color: CommunityStyle.text72),
      title: Text(
        label,
        style: const TextStyle(
          color: CommunityStyle.textBright,
          fontSize: 15,
          fontFamily: 'Urbanist',
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        size: 18,
        color: CommunityStyle.text50,
      ),
    );
  }
}

class _EmptyText extends StatelessWidget {
  const _EmptyText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 14, 0, 0),
      child: Text(
        text,
        style: const TextStyle(
          color: CommunityStyle.text50,
          fontSize: 13,
          height: 1.5,
          fontFamily: 'Urbanist',
        ),
      ),
    );
  }
}
