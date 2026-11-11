import 'package:flutter/material.dart';

import '../../../core/network/api_client.dart';
import '../../../design_system/design_system.dart';
import '../../../l10n/app_localizations_context.dart';
import '../data/remote_community_repository.dart';
import '../domain/community_models.dart';
import 'community_style.dart';

/// 群设置 —— 逐屏复刻原型 GrupoChat.jsx 里的 `Ajustes` 面板：
/// 成员头像区、+Convidar、挑战排名（Placar）、成员列表、通知开关、退群。
///
/// 「Copiar código」依赖后端缺口 G-6（群还没有 code 概念），先不渲染。
class GroupDetailPage extends StatefulWidget {
  const GroupDetailPage({
    required this.groupId,
    required this.groupName,
    this.repository,
    super.key,
  });

  final String groupId;
  final String groupName;
  final RemoteCommunityRepository? repository;

  @override
  State<GroupDetailPage> createState() => _GroupDetailPageState();
}

class _GroupDetailPageState extends State<GroupDetailPage> {
  late final RemoteCommunityRepository _repo =
      widget.repository ?? RemoteCommunityRepository(ApiClient.configured());

  bool _loading = true;
  String? _error;
  bool _muted = false;
  bool _leaving = false;
  List<CommunityMember> _members = const [];
  List<CommunityGoal> _goals = const [];
  Map<String, List<CommunityRankingEntry>> _rankings = const {};

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
      final members = await _repo.groupMembers(widget.groupId);
      final goals = await _repo.groupGoals(widget.groupId);
      final rankings = <String, List<CommunityRankingEntry>>{};
      for (final goal in goals) {
        try {
          rankings[goal.id] = await _repo.goalRanking(widget.groupId, goal.id);
        } catch (_) {}
      }
      if (!mounted) return;
      setState(() {
        _members = members;
        _goals = goals;
        _rankings = rankings;
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

  Future<void> _toggleMuted() async {
    final next = !_muted;
    setState(() => _muted = next);
    try {
      await _repo.updateNotificationSettings(widget.groupId, muted: next);
    } catch (error) {
      if (!mounted) return;
      setState(() => _muted = !next);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  Future<void> _invite() async {
    final controller = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          context.l10n.communityInviteTitle,
          style:
              AppTypography.listItem.copyWith(color: AppColors.textPrimary),
        ),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          style:
              AppTypography.listItem.copyWith(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: context.l10n.communityInviteEmailHint,
            hintStyle:
                AppTypography.caption.copyWith(color: AppColors.textMuted),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.communityDecline),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.communityInviteSend),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final email = controller.text.trim();
    if (email.isEmpty) return;
    try {
      await _repo.inviteMember(widget.groupId, email);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.communityInviteSuccess)),
      );
      await _reload();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  // 原型的退群：第一次点变成「Toque de novo para sair」，再点才退。
  Future<void> _leave() async {
    if (_leaving) {
      try {
        await _repo.leaveGroup(widget.groupId);
        if (!mounted) return;
        Navigator.of(context).pop();
      } catch (error) {
        if (!mounted) return;
        setState(() => _leaving = false);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      }
      return;
    }
    setState(() => _leaving = true);
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          strings.communityAjustesTitle,
          style: AppTypography.listItem.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
            fontSize: 17,
          ),
        ),
      ),
      body: _loading
          ? const Center(child: AppLoadingIndicator())
          : _error != null
              ? Center(
                  child: Text(
                    _error!,
                    textAlign: TextAlign.center,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // .gc-aj-topo
                    Column(
                      children: [
                        SizedBox(
                          height: 34,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              for (var i =
                                      _members.take(6).length - 1;
                                  i >= 0;
                                  i--)
                                Positioned(
                                  left: MediaQuery.of(context).size.width / 2 -
                                      _members.length * 10 +
                                      i * 24.0,
                                  child: _Avatar(
                                    name: _members[i].displayName,
                                    size: 34,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.groupName,
                          style: AppTypography.section.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w300,
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
                    const SizedBox(height: 16),
                    // .gc-aj-acoes
                    Row(
                      children: [
                        Expanded(
                          child: _ActionBox(
                            label: strings.communityAjustesInvite,
                            onTap: _invite,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    if (_goals.isNotEmpty) ...[
                      _SectionKicker(strings.communityPlacarTitle),
                      for (final goal in _goals)
                        _PlacarCard(
                          goal: goal,
                          rankings: _rankings[goal.id] ?? const [],
                        ),
                      const SizedBox(height: 20),
                    ],
                    _SectionKicker(strings.communityMembersTitle(_members.length)),
                    const SizedBox(height: 6),
                    _RowCard(
                      children: [
                        for (final member in _members)
                          _MemberRow(
                            name: member.displayName,
                            subtitle: member.role == 'admin'
                                ? strings.communityRoleAdmin
                                : null,
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _SectionKicker(strings.communityNotifTitle),
                    const SizedBox(height: 6),
                    _RowCard(
                      children: [
                        _ToggleRow(
                          label: strings.communityNotifMessages,
                          value: !_muted,
                          onToggle: _toggleMuted,
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    _RowCard(
                      children: [
                        InkWell(
                          onTap: _leave,
                          child: SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Text(
                                _leaving
                                    ? strings.communityLeaveDoubleTap
                                    : strings.communityLeaveGroup,
                                style: AppTypography.listItem.copyWith(
                                  color: const Color(0xFFFF8A80),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
    );
  }
}

// .gc-aj-k
class _SectionKicker extends StatelessWidget {
  const _SectionKicker(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTypography.caption.copyWith(
        color: AppColors.textMuted,
        letterSpacing: 1.4,
      ),
    );
  }
}

class _ActionBox extends StatelessWidget {
  const _ActionBox({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0x14FFFFFF),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 42,
          child: Center(
            child: Text(
              label,
              style: AppTypography.label.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RowCard extends StatelessWidget {
  const _RowCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(CommunityStyle.cardRadius),
      ),
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0)
              const Divider(height: 1, color: CommunityStyle.stroke),
            children[i],
          ],
        ],
      ),
    );
  }
}

class _MemberRow extends StatelessWidget {
  const _MemberRow({required this.name, this.subtitle});

  final String name;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          _Avatar(name: name, size: 30),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTypography.listItem.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textMuted,
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

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.label,
    required this.value,
    required this.onToggle,
  });

  final String label;
  final bool value;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTypography.listItem.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Switch(value: value, onChanged: (_) => onToggle()),
        ],
      ),
    );
  }
}

class _PlacarCard extends StatelessWidget {
  const _PlacarCard({required this.goal, required this.rankings});

  final CommunityGoal goal;
  final List<CommunityRankingEntry> rankings;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(CommunityStyle.cardRadius),
        ),
        child: Column(
          children: [
            for (final entry in rankings)
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    SizedBox(
                      width: 18,
                      child: Text(
                        '${entry.rank}',
                        style: AppTypography.listItem.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                    _Avatar(name: entry.displayName, size: 30),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        entry.displayName,
                        style: AppTypography.listItem.copyWith(
                          color: entry.isMe
                              ? CommunityStyle.accentText
                              : AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Text(
                      entry.currentValue.toStringAsFixed(1),
                      style: AppTypography.listItem.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.name, required this.size});

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
