import 'package:flutter/material.dart';

import '../../../core/network/api_client.dart';
import '../../../design_system/design_system.dart';
import '../../../l10n/app_localizations_context.dart';
import '../data/remote_community_repository.dart';
import '../domain/community_models.dart';
import 'group_chat_page.dart';

/// 社区主页（原型 Comunidade.jsx 的「Mural」模型）：
/// 邀请横幅 → 我的群组 → 各挑战今天要做的事。
///
/// 原型里的「Dar força」和成员当日健康数据依赖后端缺口接口，
/// 见 deliverables/2026-11-11-community-gap-analysis.md；上线前先不做。
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
  List<CommunityGroup> _groups = const [];
  List<CommunityInvitation> _invitations = const [];
  List<CuratedChallenge> _challenges = const [];

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
      final results = await Future.wait([
        _repo.listGroups(),
        _repo.listInvitations(),
        _repo.listChallenges(),
      ]);
      if (!mounted) return;
      setState(() {
        _groups = results[0] as List<CommunityGroup>;
        _invitations = results[1] as List<CommunityInvitation>;
        _challenges = results[2] as List<CuratedChallenge>;
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
      await _repo.markChallengeDay(challenge.id, today.dayNumber, completed: true);
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

  Future<void> _respond(CommunityInvitation invitation, {required bool accept}) async {
    try {
      await _repo.respondInvitation(invitation.id, accept: accept);
      await _reload();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    }
  }

  void _openChat(CommunityGroup group) {
    Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => GroupChatPage(groupId: group.id, groupName: group.name),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          strings.community,
          style: AppTypography.listItem.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _loading
          ? const Center(child: AppLoadingIndicator())
          : _error != null
              ? _ErrorView(message: _error!, onRetry: _reload)
              : RefreshIndicator(
                  onRefresh: _reload,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    children: [
                      if (_invitations.isNotEmpty)
                        _InvitationBanner(
                          invitations: _invitations,
                          onRespond: _respond,
                        ),
                      const SizedBox(height: 12),
                      Text(
                        strings.communityMyGroups,
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (_groups.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            strings.communityEmptyGroups,
                            style: AppTypography.caption
                                .copyWith(color: AppColors.textMuted),
                          ),
                        )
                      else
                        ..._groups.map(
                          (group) => _GroupCard(
                            group: group,
                            onTap: () => _openChat(group),
                          ),
                        ),
                      const SizedBox(height: 20),
                      Text(
                        strings.communityToday,
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ..._challenges.where((c) => c.enrolled).map(
                            (challenge) => _ChallengeTodayCard(
                              challenge: challenge,
                              onMarkDone: () => _markDone(challenge),
                            ),
                          ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: onRetry,
            child: Text(
              context.l10n.communityRetry,
              style: AppTypography.listItem.copyWith(color: AppColors.sky),
            ),
          ),
        ],
      ),
    );
  }
}

class _InvitationBanner extends StatelessWidget {
  const _InvitationBanner({required this.invitations, required this.onRespond});

  final List<CommunityInvitation> invitations;
  final void Function(CommunityInvitation, {required bool accept}) onRespond;

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final invitation in invitations)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      strings.communityInvitationFrom(
                        invitation.inviterName,
                        invitation.groupName,
                      ),
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => onRespond(invitation, accept: true),
                    child: Text(
                      strings.communityAccept,
                      style: AppTypography.caption.copyWith(color: AppColors.sage),
                    ),
                  ),
                  TextButton(
                    onPressed: () => onRespond(invitation, accept: false),
                    child: Text(
                      strings.communityDecline,
                      style: AppTypography.caption.copyWith(color: AppColors.textMuted),
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

class _GroupCard extends StatelessWidget {
  const _GroupCard({required this.group, required this.onTap});

  final CommunityGroup group;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        group.name,
                        style: AppTypography.listItem.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        context.l10n.communityMemberCount(group.memberCount),
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                if (group.unreadCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.sky,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '${group.unreadCount}',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.background,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChallengeTodayCard extends StatelessWidget {
  const _ChallengeTodayCard({required this.challenge, required this.onMarkDone});

  final CuratedChallenge challenge;
  final VoidCallback onMarkDone;

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    final today = challenge.today;
    final allDone = today != null && today.completed;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${challenge.title} · ${strings.communityDaysTotal(challenge.durationDays)}',
              style: AppTypography.listItem.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (today != null) ...[
              const SizedBox(height: 4),
              Text(
                today.action.isEmpty ? today.title : today.action,
                style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
              ),
            ],
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: allDone
                  ? Text(
                      strings.communityDoneToday,
                      style: AppTypography.caption.copyWith(color: AppColors.sage),
                    )
                  : TextButton(
                      onPressed: onMarkDone,
                      child: Text(
                        strings.communityMarkDone,
                        style: AppTypography.caption.copyWith(color: AppColors.sky),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
