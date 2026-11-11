import 'package:flutter/material.dart';

import '../../../core/network/api_client.dart';
import '../../../design_system/design_system.dart';
import '../../../l10n/app_localizations_context.dart';
import '../data/remote_community_repository.dart';
import '../domain/community_models.dart';
import 'community_style.dart';
import 'group_chat_page.dart';

/// 「Novo」页 —— 逐屏复刻原型 `ComunidadeNovo.jsx`：
/// Desafios（目录、卡片内展开详情）/ Criar grupo / Código。
///
/// 「Código」依赖后端缺口 G-6（按邀请码加群），提交先给出「em breve」；
/// 「Criar grupo」的联系人选择依赖 G-5，先按邮箱邀请。
class CommunityNewPage extends StatefulWidget {
  const CommunityNewPage({this.repository, super.key});

  final RemoteCommunityRepository? repository;

  @override
  State<CommunityNewPage> createState() => _CommunityNewPageState();
}

class _CommunityNewPageState extends State<CommunityNewPage> {
  late final RemoteCommunityRepository _repo =
      widget.repository ?? RemoteCommunityRepository(ApiClient.configured());
  int _tab = 0; // 0 desafios · 1 criar grupo · 2 código（原型 cn-seg 的序）

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            SizedBox(
              height: 48,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    strings.communityNewTitle,
                    style: AppTypography.listItem.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                    ),
                  ),
                  Positioned(
                    left: 0,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).maybePop(),
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        size: 22,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            _Segmented(
              labels: [
                strings.communityTabChallenges,
                strings.communityTabCreateGroup,
                strings.communityTabCode,
              ],
              index: _tab,
              onChanged: (i) => setState(() => _tab = i),
            ),
            const SizedBox(height: 16),
            if (_tab == 0)
              _ChallengesSection(repository: _repo)
            else if (_tab == 1)
              _CreateGroupSection(repository: _repo)
            else
              _CodeSection(repository: _repo),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// .cn-seg：三段切换。
class _Segmented extends StatelessWidget {
  const _Segmented({
    required this.labels,
    required this.index,
    required this.onChanged,
  });

  final List<String> labels;
  final int index;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < labels.length; i++) ...[
          if (i > 0) const SizedBox(width: 6),
          GestureDetector(
            onTap: () => onChanged(i),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                color: index == i
                    ? const Color(0xFFC9D6EA)
                    : const Color(0x1AFFFFFF),
              ),
              child: Text(
                labels[i],
                style: AppTypography.caption.copyWith(
                  color: index == i
                      ? const Color(0xFF14181D)
                      : AppColors.textSecondary,
                  fontWeight: index == i ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// ---- Desafios ----

class _ChallengesSection extends StatefulWidget {
  const _ChallengesSection({required this.repository});

  final RemoteCommunityRepository repository;

  @override
  State<_ChallengesSection> createState() => _ChallengesSectionState();
}

class _ChallengesSectionState extends State<_ChallengesSection> {
  bool _loading = true;
  String? _error;
  List<CuratedChallenge> _challenges = const [];
  String? _expanded;

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
      final challenges = await widget.repository.listChallenges();
      if (!mounted) return;
      setState(() {
        _challenges = challenges;
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

  Future<void> _toggleMembership(CuratedChallenge challenge) async {
    try {
      if (challenge.enrolled) {
        await widget.repository.leaveChallenge(challenge.id);
      } else {
        await widget.repository.joinChallenge(challenge.id);
      }
      await _reload();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.all(40),
        child: Center(child: AppLoadingIndicator()),
      );
    }
    if (_error != null) {
      return Text(
        _error!,
        style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
      );
    }
    // 按 domain 分组（原型按「Leve/Moderado/Pesado」分级，后端目录暂无
    // level 字段，用 domain 分组呈现同一版式）。
    final byDomain = <String, List<CuratedChallenge>>{};
    for (final challenge in _challenges) {
      byDomain.putIfAbsent(challenge.domain, () => []).add(challenge);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          strings.communityChallengesIntro,
          style: AppTypography.label.copyWith(
            color: AppColors.textSecondary,
            height: 1.45,
          ),
        ),
        const SizedBox(height: 14),
        for (final domain in byDomain.keys) ...[
          Text(
            domain,
            style: AppTypography.listItem.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          for (final challenge in byDomain[domain]!)
            _ChallengeCard(
              challenge: challenge,
              expanded: _expanded == challenge.id,
              onToggle: () => setState(
                () => _expanded =
                    _expanded == challenge.id ? null : challenge.id,
              ),
              onMembership: () => _toggleMembership(challenge),
            ),
          const SizedBox(height: 16),
        ],
      ],
    );
  }
}

class _ChallengeCard extends StatelessWidget {
  const _ChallengeCard({
    required this.challenge,
    required this.expanded,
    required this.onToggle,
    required this.onMembership,
  });

  final CuratedChallenge challenge;
  final bool expanded;
  final VoidCallback onToggle;
  final VoidCallback onMembership;

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    final today = challenge.today;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(CommunityStyle.cardRadius),
        child: InkWell(
          onTap: onToggle,
          borderRadius: BorderRadius.circular(CommunityStyle.cardRadius),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  strings.communityDaysTotal(challenge.durationDays),
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  challenge.title,
                  style: AppTypography.listItem.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  challenge.summary,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  expanded
                      ? strings.communityDetailsClose
                      : strings.communityDetailsOpen,
                  style: AppTypography.caption.copyWith(
                    color: CommunityStyle.accentText,
                  ),
                ),
                if (expanded) ...[
                  const SizedBox(height: 12),
                  if (challenge.description.isNotEmpty)
                    _DetailLine(
                      label: strings.communityChallengeWhy,
                      text: challenge.description,
                    ),
                  if (today != null)
                    _DetailLine(
                      label: strings.communityChallengeDaily,
                      text: today.action.isEmpty ? today.title : today.action,
                    ),
                  const SizedBox(height: 10),
                  challenge.enrolled
                      ? Text(
                          strings.communityEnrolledBadge,
                          style: AppTypography.caption.copyWith(
                            color: CommunityStyle.green,
                          ),
                        )
                      : TextButton(
                          onPressed: onMembership,
                          child: Text(
                            strings.communityStartToday,
                            style: AppTypography.label.copyWith(
                              color: CommunityStyle.accentText,
                            ),
                          ),
                        ),
                  if (challenge.enrolled)
                    TextButton(
                      onPressed: onMembership,
                      child: Text(
                        strings.communityChallengeLeave,
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailLine extends StatelessWidget {
  const _DetailLine({required this.label, required this.text});

  final String label;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: AppTypography.caption.copyWith(
              color: AppColors.textMuted,
              fontSize: 10.5,
              letterSpacing: 1.6,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            text,
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

// ---- Criar grupo ----

class _CreateGroupSection extends StatefulWidget {
  const _CreateGroupSection({required this.repository});

  final RemoteCommunityRepository repository;

  @override
  State<_CreateGroupSection> createState() => _CreateGroupSectionState();
}

class _CreateGroupSectionState extends State<_CreateGroupSection> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _emails = TextEditingController();
  bool _creating = false;

  @override
  void dispose() {
    _name.dispose();
    _emails.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    final name = _name.text.trim();
    if (name.isEmpty || _creating) return;
    setState(() => _creating = true);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    try {
      final group = await widget.repository.createGroup(name: name);
      final emails = _emails.text
          .split(RegExp(r'[;,，；\s]+'))
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
      var invited = 0;
      for (final email in emails) {
        try {
          await widget.repository.inviteMember(group.id, email);
          invited++;
        } catch (_) {}
      }
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text(context.l10n.communityGroupCreated(invited))),
        );
      }
      navigator.pushReplacement<void, void>(
        MaterialPageRoute(
          builder: (_) => GroupChatPage(
            groupId: group.id,
            groupName: group.name,
            repository: widget.repository,
          ),
        ),
      );
    } catch (error) {
      messenger.showSnackBar(SnackBar(content: Text(error.toString())));
    } finally {
      if (mounted) setState(() => _creating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          strings.communityCreateIntro,
          style: AppTypography.label.copyWith(
            color: AppColors.textSecondary,
            height: 1.45,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          strings.communityStepName,
          style: AppTypography.caption.copyWith(color: AppColors.textMuted),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _name,
          maxLength: 120,
          style: AppTypography.listItem.copyWith(color: AppColors.textPrimary),
          decoration: _decoration(strings.communityGroupNameHint),
        ),
        const SizedBox(height: 14),
        Text(
          strings.communityStepInvite,
          style: AppTypography.caption.copyWith(color: AppColors.textMuted),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _emails,
          keyboardType: TextInputType.emailAddress,
          style: AppTypography.listItem.copyWith(color: AppColors.textPrimary),
          decoration: _decoration(strings.communityInviteEmailsHint),
        ),
        const SizedBox(height: 14),
        Text(
          strings.communityCreateNote,
          style: AppTypography.caption.copyWith(
            color: AppColors.textMuted,
            height: 1.45,
          ),
        ),
        const SizedBox(height: 18),
        SizedBox(
          width: double.infinity,
          height: 46,
          child: FilledButton(
            onPressed: _creating ? null : _create,
            style: FilledButton.styleFrom(
              backgroundColor: CommunityStyle.accent,
              foregroundColor: const Color(0xFF1A120C),
            ),
            child: Text(
              _creating
                  ? strings.communityCreating
                  : strings.communityGroupCreate,
            ),
          ),
        ),
      ],
    );
  }
}

// ---- Código ----

class _CodeSection extends StatefulWidget {
  const _CodeSection({required this.repository});

  final RemoteCommunityRepository repository;

  @override
  State<_CodeSection> createState() => _CodeSectionState();
}

class _CodeSectionState extends State<_CodeSection> {
  final TextEditingController _code = TextEditingController();

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          strings.communityCodeIntro,
          style: AppTypography.label.copyWith(
            color: AppColors.textSecondary,
            height: 1.45,
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _code,
          maxLength: 9,
          textCapitalization: TextCapitalization.characters,
          style: AppTypography.listItem.copyWith(
            color: AppColors.textPrimary,
            letterSpacing: 2,
          ),
          decoration: _decoration(strings.communityCodeHint),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 46,
          child: FilledButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(strings.communityCodeSoon)),
            ),
            style: FilledButton.styleFrom(
              backgroundColor: CommunityStyle.accent,
              foregroundColor: const Color(0xFF1A120C),
            ),
            child: Text(strings.communityCodeGo),
          ),
        ),
      ],
    );
  }
}

InputDecoration _decoration(String hint) => InputDecoration(
      hintText: hint,
      hintStyle: AppTypography.caption.copyWith(color: AppColors.textMuted),
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      counterText: '',
    );
