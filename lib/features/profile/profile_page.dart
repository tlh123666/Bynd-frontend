import 'package:flutter/material.dart';

import '../../design_system/design_system.dart';
import '../activity/presentation/pages/activity_overview_page.dart';

/// Profile page reached from the side menu's Ajustes entry.
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey _moreButtonKey = GlobalKey();
  bool _quickActionsOpen = false;
  Rect? _quickActionOrigin;

  void _openQuickActions() {
    final box = _moreButtonKey.currentContext?.findRenderObject();
    if (box is! RenderBox || !box.hasSize) return;
    setState(() {
      _quickActionOrigin = box.localToGlobal(Offset.zero) & box.size;
      _quickActionsOpen = true;
    });
  }

  Future<void> _handleQuickAction(AppQuickAction action) async {
    setState(() => _quickActionsOpen = false);
    if (action == AppQuickAction.startActivity) {
      await Navigator.of(context).push<void>(
        MaterialPageRoute<void>(
          builder: (_) => const ActivityOverviewPage(openSelectorOnEnter: true),
        ),
      );
      return;
    }
    _showComingSoon(action.label.replaceAll('\n', ' '));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          extendBody: true,
          backgroundColor: AppColors.background,
          body: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.profileTop,
                  AppColors.profileMiddle,
                  AppColors.profileBottom,
                  AppColors.profileBottom,
                ],
                stops: [0, 0.32, 0.69, 1],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(22, 10, 22, 110),
                children: [
                  Row(
                    children: [
                      IconButton(
                        tooltip: 'Voltar',
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const AppSvgIcon(AppSvgAssets.back, size: 21),
                      ),
                      const Expanded(
                        child: Text(
                          'Perfil',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: AppFontFamilies.geist,
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Editar perfil',
                        onPressed: () => AppNotice.show(
                          context,
                          kind: AppNoticeKind.info,
                          message: 'Edição de perfil em breve.',
                        ),
                        icon: const AppSvgIcon(AppSvgAssets.edit, size: 21),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  const Center(
                    child: CircleAvatar(
                      radius: 42,
                      backgroundImage: AssetImage('assets/images/avatar.webp'),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Clara Nunes',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppFontFamilies.geist,
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.48,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Brasília · com a BYND há 2 meses',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: AppFontFamilies.geist,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textHalf,
                    ),
                  ),
                  const SizedBox(height: 68),
                  const Row(
                    children: [
                      Expanded(
                        child: _Stat(label: 'Idade', value: '34', unit: 'anos'),
                      ),
                      _StatDivider(),
                      Expanded(
                        child: _Stat(label: 'Altura', value: '1,68', unit: 'm'),
                      ),
                      _StatDivider(),
                      Expanded(
                        child: _Stat(label: 'Peso', value: '62', unit: 'kg'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 65),
                  const _SectionTitle('SEUS DADOS'),
                  const SizedBox(height: 8),
                  const _InfoRow('Data de nascimento', '17 abr 1992'),
                  const _InfoRow('Sexo biológico', 'Feminino'),
                  const _InfoRow('Cidade', 'Brasília (Asa Sul)'),
                  _InfoRow(
                    'Objetivo',
                    '',
                    subtitle: 'Perder gordura sem perder massa magra',
                    onTap: () => _showComingSoon('Objetivo'),
                  ),
                  const _InfoRow('Unidades', 'Métrico'),
                  const SizedBox(height: 36),
                  const _SectionTitle('CONTA'),
                  const SizedBox(height: 8),
                  _InfoRow(
                    'Pulseira',
                    '',
                    subtitle: 'BYND ONE · conectada desde 9 set 2026',
                    onTap: () => _showComingSoon('Pulseira'),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: AppBottomNav(
            selectedIndex: 0,
            moreButtonKey: _moreButtonKey,
            moreOpen: _quickActionsOpen,
            onDestinationSelected: (index) => Navigator.of(context).pop(index),
            onMorePressed: _openQuickActions,
          ),
        ),
        if (_quickActionsOpen)
          Positioned.fill(
            child: AppQuickActionsOverlay(
              origin: _quickActionOrigin!,
              onClose: () => setState(() => _quickActionsOpen = false),
              onActionSelected: _handleQuickAction,
            ),
          ),
      ],
    );
  }

  void _showComingSoon(String label) => AppNotice.show(
    context,
    kind: AppNoticeKind.info,
    message: '$label: em breve.',
  );
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value, required this.unit});
  final String label;
  final String value;
  final String unit;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(
        label,
        style: const TextStyle(
          fontFamily: AppFontFamilies.geist,
          fontSize: 11.5,
          fontWeight: FontWeight.w400,
          color: AppColors.textHalf,
        ),
      ),
      const SizedBox(height: 3),
      Text.rich(
        TextSpan(
          text: value,
          style: const TextStyle(
            fontFamily: AppFontFamilies.urbanist,
            fontSize: 24,
            fontWeight: FontWeight.w300,
            color: AppColors.textPrimary,
          ),
          children: [
            TextSpan(
              text: ' $unit',
              style: const TextStyle(
                fontFamily: AppFontFamilies.urbanist,
                fontSize: 13,
                fontWeight: FontWeight.w300,
                color: AppColors.textHalf,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) =>
      const SizedBox(height: 48, child: VerticalDivider(width: 1));
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);
  final String title;

  @override
  Widget build(BuildContext context) => Text(
    title,
    style: AppTypography.kicker.copyWith(color: AppColors.textDim),
  );
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.label, this.value, {this.subtitle, this.onTap});
  final String label;
  final String value;
  final String? subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 50),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: const BoxDecoration(
          border: Border(top: AppBorders.divider),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTypography.listItem.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        fontFamily: AppFontFamilies.geist,
                        fontSize: 12.5,
                        height: 1.4,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textDim,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (value.isNotEmpty)
              Text(
                value,
                style: const TextStyle(
                  fontFamily: AppFontFamilies.geist,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textHalf,
                ),
              ),
            if (onTap != null)
              const Icon(
                Icons.chevron_right,
                size: 17,
                color: AppColors.menuChevron,
              ),
          ],
        ),
      ),
    ),
  );
}
