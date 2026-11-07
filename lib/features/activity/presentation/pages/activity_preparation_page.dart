import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../../../../design_system/tokens/app_colors.dart';
import '../../../../design_system/tokens/app_dimensions.dart';
import '../../../../design_system/tokens/app_typography.dart';
import '../../domain/models/activity_type.dart';
import '../localization/activity_type_names_pt_br.dart';
import '../widgets/activity_selection_sheet.dart';

/// 活动准备页的安全基础版：先复现主布局，不生成演示指标或会话。
class ActivityPreparationPage extends StatefulWidget {
  const ActivityPreparationPage({required this.initialActivity, super.key});

  final ActivityType initialActivity;

  @override
  State<ActivityPreparationPage> createState() =>
      _ActivityPreparationPageState();
}

class _ActivityPreparationPageState extends State<ActivityPreparationPage> {
  late ActivityType _activity = widget.initialActivity;
  bool _routeRecordingEnabled = false;

  Future<void> _changeActivity() async {
    final selected = await ActivitySelectionSheet.show(context);
    if (!mounted || selected == null) return;

    if (selected.id == 'musculacao') {
      await Navigator.of(context).push<void>(
        MaterialPageRoute<void>(
          builder: (_) => StrengthStartPage(activity: selected),
        ),
      );
      return;
    }

    setState(() {
      _activity = selected;
      _routeRecordingEnabled = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final activityName = activityTypeNamesPtBr[_activity.id] ?? _activity.id;
    final hero = Center(
      child: _StatusLine(
        icon: Icons.watch_outlined,
        title: 'Pulseira não integrada',
        detail: 'Frequência cardíaca e bateria indisponíveis',
      ),
    );
    final controls = const _PreparationControls();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF252A31), AppColors.background],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _PreparationHeader(
                activityName: activityName,
                onClose: () => Navigator.of(context).pop(),
                onChangeActivity: _changeActivity,
              ),
              if (_activity.hasRouteToggle)
                _RouteRecordingToggle(
                  enabled: _routeRecordingEnabled,
                  onChanged: (enabled) =>
                      setState(() => _routeRecordingEnabled = enabled),
                ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // 空间不足时整页可滚动；常规高度时面板固定贴底。
                    if (constraints.maxHeight < 680) {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: 200, child: hero),
                            controls,
                          ],
                        ),
                      );
                    }

                    return Column(
                      children: [
                        Expanded(child: hero),
                        controls,
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PreparationHeader extends StatelessWidget {
  const _PreparationHeader({
    required this.activityName,
    required this.onClose,
    required this.onChangeActivity,
  });

  final String activityName;
  final VoidCallback onClose;
  final VoidCallback onChangeActivity;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(
      AppSpacing.sm,
      AppSpacing.xs,
      AppSpacing.lg,
      AppSpacing.xs,
    ),
    child: Row(
      children: [
        IconButton(
          tooltip: 'Fechar preparação',
          onPressed: onClose,
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
        ),
        const Spacer(),
        TextButton.icon(
          onPressed: onChangeActivity,
          icon: const Icon(Icons.expand_more),
          label: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 210),
            child: Text(
              activityName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          style: TextButton.styleFrom(foregroundColor: AppColors.textPrimary),
        ),
      ],
    ),
  );
}

class _PreparationControls extends StatelessWidget {
  const _PreparationControls();

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: const BorderRadius.vertical(
      top: Radius.circular(AppRadii.sheet),
    ),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
      child: Container(
        key: const ValueKey('activity-preparation-controls'),
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.xl,
        ),
        decoration: BoxDecoration(
          color: AppColors.menuPanel,
          border: Border(top: AppBorders.glass),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 38,
                height: 4,
                decoration: const BoxDecoration(
                  color: AppColors.textMuted,
                  borderRadius: AppRadii.pillBorder,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _WeatherStatusCard(),
            const _LoadTargetStatus(),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: null,
                child: const Text('Iniciar atividade'),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Center(
              child: Text(
                'A sessão de atividade ainda não está disponível',
                textAlign: TextAlign.center,
                style: AppTypography.caption.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _RouteRecordingToggle extends StatelessWidget {
  const _RouteRecordingToggle({required this.enabled, required this.onChanged});

  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(
      AppSpacing.lg,
      AppSpacing.xxs,
      AppSpacing.lg,
      AppSpacing.xs,
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Registrar o percurso',
                style: AppTypography.body.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                'GPS indisponível; nenhum percurso será gravado',
                style: AppTypography.caption.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
        Switch.adaptive(
          key: const ValueKey('route-recording-switch'),
          value: enabled,
          onChanged: onChanged,
          activeTrackColor: AppColors.textPrimary,
          inactiveTrackColor: AppColors.textMuted,
        ),
      ],
    ),
  );
}

class _WeatherStatusCard extends StatelessWidget {
  const _WeatherStatusCard();

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
    padding: const EdgeInsets.all(AppSpacing.md),
    decoration: BoxDecoration(
      color: AppColors.glass,
      borderRadius: AppRadii.cardBorder,
      border: Border.fromBorderSide(AppBorders.glass),
    ),
    child: const _StatusLine(
      icon: Icons.cloud_outlined,
      title: 'Clima indisponível',
      detail: 'Localização e serviço meteorológico não integrados',
    ),
  );
}

class _LoadTargetStatus extends StatelessWidget {
  const _LoadTargetStatus();

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.textMuted, width: 2),
        ),
        child: const Icon(
          Icons.bolt_outlined,
          size: 18,
          color: AppColors.textMuted,
        ),
      ),
      const SizedBox(width: AppSpacing.sm),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Carga sugerida indisponível',
              style: AppTypography.body.copyWith(color: AppColors.textPrimary),
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              'Dados e cálculo da carga ainda não integrados',
              style: AppTypography.caption.copyWith(color: AppColors.textMuted),
            ),
          ],
        ),
      ),
      Semantics(
        label: 'Carga sugerida indisponível',
        child: Switch.adaptive(value: false, onChanged: null),
      ),
    ],
  );
}

class _StatusLine extends StatelessWidget {
  const _StatusLine({
    required this.icon,
    required this.title,
    required this.detail,
  });

  final IconData icon;
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, color: AppColors.textMuted),
      const SizedBox(width: AppSpacing.sm),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTypography.body.copyWith(color: AppColors.textPrimary),
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              detail,
              style: AppTypography.caption.copyWith(color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    ],
  );
}

/// 保留原型训练选择页的区块顺序，但不把 Clara 演示模板展示成用户数据。
class StrengthStartPage extends StatelessWidget {
  const StrengthStartPage({required this.activity, super.key});

  final ActivityType activity;

  @override
  Widget build(BuildContext context) {
    final activityName = activityTypeNamesPtBr[activity.id] ?? activity.id;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        centerTitle: true,
        leading: IconButton(
          tooltip: 'Fechar',
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close),
        ),
        title: Text(activityName),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Como deseja começar?',
                style: AppTypography.title.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              _StrengthOption(
                icon: Icons.play_arrow,
                title: 'Começar sem plano',
                detail: 'Os exercícios podem entrar depois',
                onTap: () => Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(
                    builder: (_) =>
                        ActivityPreparationPage(initialActivity: activity),
                  ),
                ),
              ),
              const _StrengthSectionHeading(title: 'Seus treinos'),
              const _StatusLine(
                icon: Icons.fitness_center,
                title: 'Treinos salvos ainda não disponíveis',
                detail: 'Os treinos salvos não estão conectados neste app',
              ),
              const _StrengthSectionHeading(title: 'Outras formas'),
              const _StrengthOption(
                icon: Icons.add,
                title: 'Montar treino novo',
                detail: 'Editor de exercícios, séries e carga não integrado',
                onTap: null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StrengthSectionHeading extends StatelessWidget {
  const _StrengthSectionHeading({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(4, AppSpacing.lg, 4, AppSpacing.xs),
    child: Text(
      title.toUpperCase(),
      style: AppTypography.caption.copyWith(
        color: AppColors.textMuted,
        letterSpacing: 1.5,
      ),
    ),
  );
}

class _StrengthOption extends StatelessWidget {
  const _StrengthOption({
    required this.icon,
    required this.title,
    required this.detail,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String detail;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: AppColors.surface,
    borderRadius: AppRadii.controlBorder,
    child: InkWell(
      onTap: onTap,
      borderRadius: AppRadii.controlBorder,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 68),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.textSecondary),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.body.copyWith(
                        color: onTap == null
                            ? AppColors.textMuted
                            : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      detail,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: onTap == null
                    ? AppColors.menuChevron
                    : AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
