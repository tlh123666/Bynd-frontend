import 'package:flutter/material.dart';

import '../../../../design_system/design_system.dart';
import '../../application/atlas_scope.dart';
import '../../data/models/mapa.dart';

/// Mapa 页 —— 跨指标、沿时间的「关系」层。
///
/// 信息结构对齐设计稿（bynd-app · MapaNovo，Luiz 2026-11 第二版），
/// 但数据全部来自后端 `/mapa/overview`。设计稿里的演示数字（Clara 场景
/// 的 48/61、14 天阶梯图、"Café depois das 15:00"）在后端没有对应物，
/// 这里不做假数据填充：成熟度不够时显示 forming 空态，这是产品语义
/// （"O Mapa precisa de mais noites para confirmar"），不是缺陷。
class MapaPage extends StatefulWidget {
  const MapaPage({super.key});

  @override
  State<MapaPage> createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  Future<MapaOverview>? _future;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 取 InheritedWidget 只能在这里，不能在 initState：那时祖先还没挂好。
    _future ??= AtlasScope.of(context).fetchMapaOverview();
  }

  void _reload() {
    setState(() {
      _future = AtlasScope.of(context).fetchMapaOverview();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: false,
        title: Text('Mapa', style: AppTypography.title),
      ),
      body: FutureBuilder<MapaOverview>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: AppLoadingIndicator());
          }
          if (snapshot.hasError) {
            return _ErrorView(message: '${snapshot.error}', onRetry: _reload);
          }
          final overview = snapshot.data;
          if (overview == null) {
            return _ErrorView(message: 'sem dados', onRetry: _reload);
          }
          return RefreshIndicator(
            color: AppColors.action,
            backgroundColor: AppColors.surface,
            onRefresh: () async => _reload(),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                96,
              ),
              children: [
                _HeroSection(overview: overview),
                const SizedBox(height: AppSpacing.xl),
                _LearnedSection(
                  relationships: overview.displayRelationships,
                  forming: overview.maturity.isForming,
                ),
                const SizedBox(height: AppSpacing.xl),
                _NumbersSection(maturity: overview.maturity),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Não foi possível carregar o Mapa.',
            style: AppTypography.body.copyWith(color: AppColors.textPrimary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          AppButton(label: 'Tentar de novo', onPressed: onRetry),
        ],
      ),
    ),
  );
}

// ── Hero：当天状态 + 成熟度一句话 ─────────────────────────────────────────────

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.overview});

  final MapaOverview overview;

  static const _dimensionLabels = {
    'sleep': 'Sono',
    'recovery': 'Recuperação',
    'energy': 'Energia',
    'stress': 'Stresse',
  };

  static const _stateLabels = {
    'good': 'Estável',
    'ok': 'Estável',
    'fair': 'Atenção',
    'attention': 'Atenção',
    'warning': 'Atenção',
    'poor': 'Em queda',
    'bad': 'Em queda',
  };

  @override
  Widget build(BuildContext context) {
    final maturity = overview.maturity;
    final dimensions = _dimensionLabels.entries
        .map(
          (entry) => _StateTile(
            label: entry.value,
            state:
                _stateLabels[overview.currentState[entry.key]] ?? 'Sem dados',
          ),
        )
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: dimensions),
        const SizedBox(height: AppSpacing.md),
        Text(
          maturity.isForming
              ? 'O Mapa está observando seus dados há ${maturity.daysWithBynd} dias. Com mais noites e treinos registrados, ele passa a identificar padrões com evidência.'
              : 'O Mapa encontrou ${maturity.establishedRelationshipCount} padrão(ões) com evidência suficiente em ${maturity.daysWithBynd} dias de dados.',
          style: AppTypography.body.copyWith(color: AppColors.textSecondary),
        ),
        if (overview.latestDiscovery != null) ...[
          const SizedBox(height: AppSpacing.sm),
          AppCard(
            child: Row(
              children: [
                const AppSvgIcon(AppSvgAssets.atlas, size: 18),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    overview.latestDiscovery!.title,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _StateTile extends StatelessWidget {
  const _StateTile({required this.label, required this.state});

  final String label;
  final String state;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Padding(
      padding: const EdgeInsets.only(right: AppSpacing.xs),
      child: AppCard(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.sm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTypography.caption.copyWith(
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              state,
              style: AppTypography.label.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// ── 「O que o Mapa aprendeu」：关系列表 ───────────────────────────────────────

class _LearnedSection extends StatelessWidget {
  const _LearnedSection({required this.relationships, required this.forming});

  final List<MapaRelationship> relationships;

  /// forming 阶段连 established 都可能是小样本，标题要如实说明。
  final bool forming;

  @override
  Widget build(BuildContext context) {
    // insufficient 意味着样本不足被引擎压住：展示它只会让用户读噪音。
    final visible = relationships
        .where((item) => item.state != 'insufficient')
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'O que o Mapa aprendeu',
          style: AppTypography.section.copyWith(color: AppColors.textPrimary),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          forming
              ? 'Padrões que estão sendo observados. Toque para ver as evidências.'
              : 'O que se repete com você. Toque para ver as provas.',
          style: AppTypography.caption.copyWith(color: AppColors.textMuted),
        ),
        const SizedBox(height: AppSpacing.md),
        if (visible.isEmpty)
          AppCard(
            child: Text(
              'Ainda não há padrões com evidência suficiente. Continue usando a pulseira — o Mapa cruza sono, treino e ritmo cardiaco ao longo das semanas.',
              style: AppTypography.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          )
        else
          for (final relationship in visible) ...[
            _RelationshipCard(relationship: relationship),
            const SizedBox(height: AppSpacing.sm),
          ],
      ],
    );
  }
}

class _RelationshipCard extends StatefulWidget {
  const _RelationshipCard({required this.relationship});

  final MapaRelationship relationship;

  @override
  State<_RelationshipCard> createState() => _RelationshipCardState();
}

class _RelationshipCardState extends State<_RelationshipCard> {
  bool _open = false;

  static const _stateLabels = {
    'established': 'Confirmado',
    'intensifying': 'Confirmado',
    'emerging': 'Em análise',
    'exploring': 'Em análise',
  };

  @override
  Widget build(BuildContext context) {
    final relationship = widget.relationship;
    final confirmed = relationship.isEstablished;
    final evidence = relationship.evidence;
    return AppCard(
      onTap: () => setState(() => _open = !_open),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${relationship.source.label} → ${relationship.target.label}',
                  style: AppTypography.label.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xs,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: confirmed
                      ? AppColors.sage.withValues(alpha: 0.16)
                      : AppColors.glass,
                  borderRadius: AppRadii.pillBorder,
                  border: Border.all(
                    color: confirmed
                        ? AppColors.sage.withValues(alpha: 0.5)
                        : AppColors.glassBorderStrong,
                  ),
                ),
                child: Text(
                  _stateLabels[relationship.state] ?? relationship.state,
                  style: AppTypography.kicker.copyWith(
                    color: confirmed ? AppColors.sage : AppColors.textMuted,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxs),
          // 强度条：不给裸数字，和设计稿一致。
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: relationship.strength.clamp(0.0, 1.0),
              minHeight: 4,
              backgroundColor: AppColors.glassBorderStrong,
              valueColor: AlwaysStoppedAnimation<Color>(
                confirmed ? AppColors.sage : AppColors.brandBlue,
              ),
            ),
          ),
          if (_open) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              evidence.occurrences > 0
                  ? '${relationship.matches} de ${relationship.occurrences} ocorrências no período de ${evidence.periodDays} dias '
                        'apoiaram este padrão.'
                  : 'Ainda sem ocorrências suficientes no período de ${evidence.periodDays} dias.',
              style: AppTypography.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            if (evidence.firstSeenAt != null) ...[
              const SizedBox(height: AppSpacing.xxs),
              Text(
                'Observado desde ${evidence.firstSeenAt}.',
                style: AppTypography.caption.copyWith(color: AppColors.textMuted),
              ),
            ],
            Text(
              relationship.direction == 'negative'
                  ? 'Associação negativa: quando a origem sobe, o alvo tende a ficar abaixo da sua própria baseline.'
                  : 'Associação positiva: quando a origem sobe, o alvo tende a ficar acima da sua própria baseline.',
              style: AppTypography.caption.copyWith(color: AppColors.textMuted),
            ),
          ],
        ],
      ),
    );
  }
}

// ── 「Principais números」：成熟度 ────────────────────────────────────────────

class _NumbersSection extends StatelessWidget {
  const _NumbersSection({required this.maturity});

  final MapaMaturity maturity;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Principais números',
        style: AppTypography.section.copyWith(color: AppColors.textPrimary),
      ),
      const SizedBox(height: AppSpacing.xxs),
      Text(
        'O que o Mapa cruza para chegar nas leituras.',
        style: AppTypography.caption.copyWith(color: AppColors.textMuted),
      ),
      const SizedBox(height: AppSpacing.md),
      Row(
        children: [
          _NumberTile(
            label: 'Dias com dados',
            value: '${maturity.daysWithBynd}',
          ),
          const SizedBox(width: AppSpacing.xs),
          _NumberTile(
            label: 'Sinais observados',
            value: '${maturity.observedSignalCount}',
          ),
        ],
      ),
      const SizedBox(height: AppSpacing.xs),
      Row(
        children: [
          _NumberTile(
            label: 'Padrões ativos',
            value: '${maturity.activeRelationshipCount}',
          ),
          const SizedBox(width: AppSpacing.xs),
          _NumberTile(
            label: 'Confirmados',
            value: '${maturity.establishedRelationshipCount}',
          ),
        ],
      ),
    ],
  );
}

class _NumberTile extends StatelessWidget {
  const _NumberTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Expanded(
    child: AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.caption.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            value,
            style: AppTypography.section.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    ),
  );
}
