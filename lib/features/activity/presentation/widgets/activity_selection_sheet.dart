import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../design_system/design_system.dart';
import '../../../../l10n/app_localizations_context.dart';
import '../../domain/models/activity_type.dart';
import '../../domain/models/activity_type_catalog.dart';
import '../localization/activity_type_localizations.dart';
import 'activity_type_icon.dart';

/// 活动选择面板，对应网页原型的 Modalidades 底部面板。
class ActivitySelectionSheet extends StatefulWidget {
  const ActivitySelectionSheet({super.key});

  /// 展示可拖动的全高活动面板，选中后将稳定活动类型返回调用方。
  static Future<ActivityType?> show(BuildContext context) {
    return Navigator.of(context).push<ActivityType>(
      _ActivitySelectionRoute(
        routeBarrierLabel: MaterialLocalizations.of(
          context,
        ).modalBarrierDismissLabel,
      ),
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
  double _dragOffset = 0;
  bool _isDragging = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 原型最小安全区为 20px，叶片再下移 34px；不能按屏幕比例缩放顶部留白。
    final media = MediaQuery.of(context);
    final safeTop = media.viewPadding.top < 20 ? 20.0 : media.viewPadding.top;
    final topInset = safeTop + 34;
    final height = (media.size.height - topInset).clamp(0.0, media.size.height);
    final dragProgress = height == 0 ? 0.0 : _dragOffset / height;
    final normalizedQuery = _normalize(_query.trim());
    final strings = context.l10n;
    final filtered = ActivityTypeCatalog.all
        .where((type) {
          return _normalize(
            activityTypeLocalizedName(type, strings),
          ).contains(normalizedQuery);
        })
        .toList(growable: false);

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: AnimatedSlide(
        offset: Offset(0, dragProgress),
        duration: _isDragging
            ? Duration.zero
            : const Duration(milliseconds: 260),
        curve: const Cubic(.32, .72, 0, 1),
        child: SizedBox(
          height: height,
          child: AppFrostedSurface(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppRadii.sheet),
            ),
            blurSigma: 14,
            saturation: 1.5,
            tintColor: AppColors.sheetGlassTint,
            borderColor: AppColors.sheetGlassBorder,
            borderFadeHeight: 240,
            boxShadow: const [
              BoxShadow(
                color: Color(0x59000000),
                blurRadius: 60,
                offset: Offset(0, 24),
              ),
            ],
            child: Material(
              type: MaterialType.transparency,
              child: SafeArea(
                top: false,
                child: Column(
                  children: [
                    _SheetHandle(
                      title: strings.startActivityTitle,
                      onClose: () => Navigator.of(context).pop(),
                      onDragStart: () => setState(() => _isDragging = true),
                      onDragUpdate: (delta) => setState(() {
                        _dragOffset = (_dragOffset + delta).clamp(
                          0.0,
                          height * 1.05,
                        );
                      }),
                      onDragEnd: (velocity) {
                        final projectedOffset = _dragOffset + velocity * .18;
                        if (projectedOffset > height * .35 ||
                            (velocity > 500 && _dragOffset > 0)) {
                          Navigator.of(context).pop();
                        } else {
                          setState(() {
                            _dragOffset = 0;
                            _isDragging = false;
                          });
                        }
                      },
                    ),
                    Padding(
                      // 原型固定搜索区为上下 4/8px，搜索框另有 8px 顶间距。
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                      child: _ActivitySearchField(
                        controller: _searchController,
                        onChanged: (value) => setState(() => _query = value),
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
          ),
        ),
      ),
    );
  }

  Widget _buildGroupedList() {
    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, AppSpacing.xl),
      children: [
        _SectionHeading(label: context.l10n.recent, topSpacing: 10),
        const SizedBox(height: 4),
        for (var index = 0; index < _recentActivityIds.length; index++)
          if (ActivityTypeCatalog.findById(_recentActivityIds[index])
              case final type?)
            _ActivityOption(
              type: type,
              subtitle: activityTypeLocalizedHint(type, context.l10n),
              showTopDivider: index > 0,
              onTap: () => Navigator.of(context).pop(type),
            ),
        ..._buildCategorySections(),
      ],
    );
  }

  Iterable<Widget> _buildCategorySections() sync* {
    for (final category in ActivityCategory.values) {
      final activities = ActivityTypeCatalog.all
          .where((type) => type.category == category)
          .toList(growable: false);
      if (activities.isEmpty) continue;

      yield _SectionHeading(
        label: activityCategoryLocalizedName(category, context.l10n),
        count: activities.length,
      );
      yield const SizedBox(height: 2);
      for (var index = 0; index < activities.length; index++) {
        final type = activities[index];
        yield _ActivityOption(
          type: type,
          subtitle: activityTypeLocalizedHint(type, context.l10n),
          showTopDivider: index > 0,
          onTap: () => Navigator.of(context).pop(type),
        );
      }
    }
  }

  Widget _buildSearchResults(List<ActivityType> results, String query) {
    if (results.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Text(
            context.l10n.noActivityMatches(query),
            textAlign: TextAlign.center,
            style: AppTypography.body.copyWith(color: AppColors.textMuted),
          ),
        ),
      );
    }

    return ListView.builder(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, AppSpacing.xl),
      itemCount: results.length,
      itemBuilder: (context, index) => _ActivityOption(
        type: results[index],
        subtitle: activityTypeLocalizedHint(results[index], context.l10n),
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

class _ActivitySelectionRoute extends PopupRoute<ActivityType> {
  _ActivitySelectionRoute({required this.routeBarrierLabel});

  final String routeBarrierLabel;

  static const _sheetCurve = Cubic(.32, .72, 0, 1);

  @override
  bool get barrierDismissible => true;

  @override
  Color get barrierColor => Colors.transparent;

  @override
  String get barrierLabel => routeBarrierLabel;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 450);

  @override
  Duration get reverseTransitionDuration => const Duration(milliseconds: 420);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final sheetAnimation = CurvedAnimation(
      parent: animation,
      curve: _sheetCurve,
      reverseCurve: _sheetCurve,
    );

    return Align(
      alignment: Alignment.bottomCenter,
      child: SlideTransition(
        // 原型移动的是叶片本身，位移距离应等于叶片高度，而不是整屏高度。
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(sheetAnimation),
        child: const ActivitySelectionSheet(),
      ),
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final veilAnimation = CurvedAnimation(
      parent: animation,
      curve: const Interval(0, .67, curve: Curves.easeInOut),
      // 原型遮罩淡出为 350ms；反向路由为 420ms，因此占其约 5/6。
      reverseCurve: const Interval(0, .833, curve: Curves.easeInOut),
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: IgnorePointer(
            child: FadeTransition(
              opacity: veilAnimation,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: const ColoredBox(color: Color(0x59080A0E)),
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle({
    required this.title,
    required this.onClose,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
  });

  final String title;
  final VoidCallback onClose;
  final VoidCallback onDragStart;
  final ValueChanged<double> onDragUpdate;
  final ValueChanged<double> onDragEnd;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onVerticalDragStart: (_) => onDragStart(),
      onVerticalDragUpdate: (details) => onDragUpdate(details.delta.dy),
      onVerticalDragEnd: (details) => onDragEnd(details.primaryVelocity ?? 0),
      child: SizedBox(
        height: 62,
        child: Stack(
          children: [
            const Positioned(
              top: 8,
              left: 0,
              right: 0,
              child: Center(child: _HandlePill()),
            ),
            Positioned(
              top: 12,
              left: 6,
              right: 6,
              height: 50,
              child: Row(
                children: [
                  SizedBox(
                    width: 44,
                    child: IconButton(
                      tooltip: context.l10n.close,
                      onPressed: onClose,
                      icon: const Icon(
                        Icons.close,
                        size: 22,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: AppTypography.title.copyWith(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 44),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HandlePill extends StatelessWidget {
  const _HandlePill();

  @override
  Widget build(BuildContext context) => Container(
    width: 38,
    height: 5,
    decoration: BoxDecoration(
      color: const Color(0x47FFFFFF),
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
      style: AppTypography.body.copyWith(
        fontSize: 15,
        color: AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        constraints: const BoxConstraints(minHeight: 44, maxHeight: 44),
        hintText: context.l10n.searchActivities(ActivityTypeCatalog.all.length),
        hintStyle: AppTypography.body.copyWith(
          fontSize: 15,
          color: AppColors.textPlaceholder,
        ),
        prefixIcon: const Icon(
          Icons.search,
          size: 18,
          color: AppColors.textHalf,
        ),
        // CSS 搜索框的布局为 14px 内边距 + 18px 图标 + 10px 间隔。
        prefixIconConstraints: const BoxConstraints(minWidth: 38),
        filled: true,
        fillColor: const Color(0x12FFFFFF),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(14)),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({
    required this.label,
    this.count,
    this.topSpacing = 24,
  });

  final String label;
  final int? count;
  final double topSpacing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(6, topSpacing, 6, 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label.toUpperCase(),
              style: AppTypography.kicker.copyWith(
                color: AppColors.textHalf,
                fontSize: 11,
                letterSpacing: 1.54,
              ),
            ),
          ),
          if (count != null)
            Text(
              '$count',
              style: AppTypography.caption.copyWith(
                color: AppColors.textInactive,
                fontSize: 12,
              ),
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
    this.showTopDivider = false,
    required this.onTap,
  });

  final ActivityType type;
  final String subtitle;
  final bool showTopDivider;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: activityTypeLocalizedName(type, context.l10n),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.controlBorder,
        // 原型仅在按下时显示极轻反馈，不保留桌面鼠标悬停底色。
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return const Color(0x08FFFFFF);
          }
          return Colors.transparent;
        }),
        child: Container(
          constraints: const BoxConstraints(minHeight: 72),
          decoration: showTopDivider
              ? const BoxDecoration(
                  border: Border(top: BorderSide(color: Color(0x12FFFFFF))),
                )
              : null,
          child: SizedBox(
            height: showTopDivider ? 71 : 72,
            child: Row(
              children: [
                SizedBox(
                  width: 24,
                  child: ActivityTypeIcon(
                    type: type,
                    fallback: _iconForType(type),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        activityTypeLocalizedName(type, context.l10n),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.listItem.copyWith(
                          fontSize: 15,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.caption.copyWith(
                          fontSize: 13,
                          color: AppColors.textHalf,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.textMuted,
                  size: 16,
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
