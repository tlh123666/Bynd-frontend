import 'package:flutter/material.dart';

import '../../../../design_system/tokens/app_colors.dart';
import '../../../../design_system/tokens/app_dimensions.dart';
import '../../../../design_system/tokens/app_typography.dart';
import '../../domain/models/activity_type.dart';
import '../../domain/models/activity_type_catalog.dart';
import '../localization/activity_type_hints_pt_br.dart';
import '../localization/activity_type_names_pt_br.dart';

/// 活动选择面板，对应网页原型的 Modalidades 底部面板。
class ActivitySelectionSheet extends StatefulWidget {
  const ActivitySelectionSheet({super.key});

  /// 展示可拖动的全高活动面板，选中后将稳定活动类型返回调用方。
  static Future<ActivityType?> show(BuildContext context) {
    return showModalBottomSheet<ActivityType>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: AppColors.menuVeil,
      builder: (_) => const ActivitySelectionSheet(),
    );
  }

  @override
  State<ActivitySelectionSheet> createState() => _ActivitySelectionSheetState();
}

class _ActivitySelectionSheetState extends State<ActivitySelectionSheet> {
  static const _recentActivityIds = [
    'corrida',
    'musculacao',
    'caminhada',
    'ciclismo',
  ];

  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * .9;
    final normalizedQuery = _normalize(_query.trim());
    final filtered = ActivityTypeCatalog.all
        .where((type) {
          return _normalize(
            activityTypeNamesPtBr[type.id] ?? type.id,
          ).contains(normalizedQuery);
        })
        .toList(growable: false);

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Container(
        height: height,
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadii.sheet),
          ),
          border: Border.fromBorderSide(AppBorders.glass),
        ),
        clipBehavior: Clip.antiAlias,
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              _SheetHandle(onClose: () => Navigator.of(context).pop()),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.xs,
                  AppSpacing.lg,
                  AppSpacing.md,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Iniciar atividade',
                      style: AppTypography.title.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _ActivitySearchField(
                      controller: _searchController,
                      onChanged: (value) => setState(() => _query = value),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: normalizedQuery.isEmpty
                    ? _buildGroupedList()
                    : _buildSearchResults(filtered, _query.trim()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGroupedList() {
    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.xl,
      ),
      children: [
        _SectionHeading(label: 'Recentes'),
        for (final id in _recentActivityIds)
          if (ActivityTypeCatalog.findById(id) case final type?)
            _ActivityOption(
              type: type,
              subtitle: activityTypeHintPtBr(type),
              onTap: () => Navigator.of(context).pop(type),
            ),
        for (final category in ActivityCategory.values) ...[
          _SectionHeading(
            label: activityCategoryNamesPtBr[category.name] ?? category.name,
            count: ActivityTypeCatalog.all
                .where((type) => type.category == category)
                .length,
          ),
          for (final type in ActivityTypeCatalog.all)
            if (type.category == category)
              _ActivityOption(
                type: type,
                subtitle: activityTypeHintPtBr(type),
                onTap: () => Navigator.of(context).pop(type),
              ),
        ],
      ],
    );
  }

  Widget _buildSearchResults(List<ActivityType> results, String query) {
    if (results.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Text(
            'Nenhuma modalidade com “$query”. Use “Outro”.',
            textAlign: TextAlign.center,
            style: AppTypography.body.copyWith(color: AppColors.textMuted),
          ),
        ),
      );
    }

    return ListView.builder(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.xl,
      ),
      itemCount: results.length,
      itemBuilder: (context, index) => _ActivityOption(
        type: results[index],
        subtitle: activityTypeHintPtBr(results[index]),
        onTap: () => Navigator.of(context).pop(results[index]),
      ),
    );
  }

  String _normalize(String value) {
    const replacements = {
      'á': 'a',
      'à': 'a',
      'â': 'a',
      'ã': 'a',
      'é': 'e',
      'ê': 'e',
      'í': 'i',
      'ó': 'o',
      'ô': 'o',
      'õ': 'o',
      'ú': 'u',
      'ü': 'u',
      'ç': 'c',
    };
    var normalized = value.toLowerCase();
    for (final entry in replacements.entries) {
      normalized = normalized.replaceAll(entry.key, entry.value);
    }
    return normalized;
  }
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.md,
        0,
      ),
      child: Row(
        children: [
          const Expanded(child: Center(child: _HandlePill())),
          IconButton(
            tooltip: 'Fechar',
            onPressed: onClose,
            icon: const Icon(Icons.close, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _HandlePill extends StatelessWidget {
  const _HandlePill();

  @override
  Widget build(BuildContext context) => Container(
    width: 38,
    height: 4,
    decoration: BoxDecoration(
      color: AppColors.textMuted,
      borderRadius: AppRadii.pillBorder,
    ),
  );
}

class _ActivitySearchField extends StatelessWidget {
  const _ActivitySearchField({
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      style: AppTypography.body.copyWith(color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: 'Buscar entre ${ActivityTypeCatalog.all.length} modalidades',
        hintStyle: AppTypography.body.copyWith(color: AppColors.textMuted),
        prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
        filled: true,
        fillColor: AppColors.glass,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadii.controlBorder,
          borderSide: AppBorders.glass,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadii.controlBorder,
          borderSide: AppBorders.selected,
        ),
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.label, this.count});

  final String label;
  final int? count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.xs),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label.toUpperCase(),
              style: AppTypography.caption.copyWith(
                color: AppColors.textMuted,
                letterSpacing: 1.5,
              ),
            ),
          ),
          if (count != null)
            Text(
              '$count',
              style: AppTypography.caption.copyWith(color: AppColors.textMuted),
            ),
        ],
      ),
    );
  }
}

class _ActivityOption extends StatelessWidget {
  const _ActivityOption({
    required this.type,
    required this.subtitle,
    required this.onTap,
  });

  final ActivityType type;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: activityTypeNamesPtBr[type.id] ?? type.id,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.controlBorder,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 72),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            child: Row(
              children: [
                SizedBox(
                  width: 42,
                  height: 42,
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      color: AppColors.glass,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _iconForType(type),
                      size: 19,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        activityTypeNamesPtBr[type.id] ?? type.id,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.body.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.textMuted,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _iconForType(ActivityType type) {
    final specificIcon = switch (type.id) {
      'corrida' || 'corrida-trilha' || 'atletismo' => Icons.directions_run,
      'caminhada' ||
      'trilha' ||
      'passear-cao' ||
      'carrinho-bebe' ||
      'carregar-bebe' ||
      'trajeto' => Icons.directions_walk,
      'ciclismo' || 'mountain-bike' => Icons.directions_bike,
      'natacao' || 'natacao-aberta' || 'hidroginastica' => Icons.pool,
      'musculacao' || 'powerlifting' || 'strongman' => Icons.fitness_center,
      'futebol' || 'futsal' || 'futebol-society' => Icons.sports_soccer,
      'tenis' ||
      'padel' ||
      'beach-tennis' ||
      'pickleball' ||
      'squash' => Icons.sports_tennis,
      'boxe' || 'box-fitness' || 'mma' || 'muay-thai' => Icons.sports_mma,
      'remo' || 'remo-ergometro' => Icons.rowing,
      'yoga' ||
      'yoga-quente' ||
      'meditacao' ||
      'tai-chi' => Icons.self_improvement,
      'sauna' => Icons.hot_tub,
      _ => null,
    };
    if (specificIcon != null) return specificIcon;

    return _iconForCategory(type.category);
  }

  IconData _iconForCategory(ActivityCategory category) => switch (category) {
    ActivityCategory.cardio => Icons.directions_run,
    ActivityCategory.strength => Icons.fitness_center,
    ActivityCategory.sports => Icons.sports_soccer,
    ActivityCategory.combat => Icons.sports_mma,
    ActivityCategory.aquatic => Icons.pool,
    ActivityCategory.mindBody => Icons.self_improvement,
    ActivityCategory.recovery => Icons.spa,
    ActivityCategory.other => Icons.more_horiz,
  };
}
