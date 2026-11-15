import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../design_system/design_system.dart';
import '../../../../l10n/app_localizations_context.dart';
import '../models/exercise_catalog_item.dart';
import 'activity_frosted_sheet_header.dart';
import 'exercise_anatomy.dart';
import 'exercise_detail_sheet.dart';

/// 动作目录叶片：搜索、筛选和多选只作用于当前草稿。
class ExerciseSelectionSheet extends StatefulWidget {
  const ExerciseSelectionSheet({this.initialIds = const {}, super.key});
  final Set<String> initialIds;

  static Future<List<ExerciseCatalogItem>?> show(
    BuildContext context, {
    Set<String> initialIds = const {},
  }) => AppFrostedModalSheet.show<List<ExerciseCatalogItem>>(
    context,
    topInset: math.max(MediaQuery.viewPaddingOf(context).top, 20) + 34,
    showHandle: false,
    barrierColor: AppColors.contentSheetVeil,
    waitForExit: true,
    builder: (_) => ExerciseSelectionSheet(initialIds: initialIds),
  );

  @override
  State<ExerciseSelectionSheet> createState() => _ExerciseSelectionSheetState();
}

class _ExerciseSelectionSheetState extends State<ExerciseSelectionSheet> {
  late Future<List<ExerciseCatalogItem>> _catalog = ExerciseCatalogItem.load();
  late final Set<String> _selected = {...widget.initialIds};
  String _query = '';
  String? _group;

  String _normalize(String input) {
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
    var value = input.trim().toLowerCase();
    for (final e in replacements.entries) {
      value = value.replaceAll(e.key, e.value);
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final media = MediaQuery.of(context);
    final height = math.max(
      0.0,
      media.size.height -
          math.max(media.viewPadding.top, 20) -
          34 -
          media.viewPadding.bottom -
          media.viewInsets.bottom,
    );
    // 浏览器初始化或键盘占满屏幕时，避免固定搜索栏挤压到负高度。
    if (height < 180 || media.size.width < 120) {
      return SizedBox(height: height);
    }
    return SizedBox(
      height: height,
      child: Column(
        children: [
          ActivityFrostedSheetHeader(
            title: s.exerciseSelectorTitle,
            height: math.min(62, height),
          ),
          Expanded(
            child: FutureBuilder<List<ExerciseCatalogItem>>(
              future: _catalog,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(s.exerciseLoadError),
                        TextButton(
                          onPressed: () => setState(
                            () => _catalog = ExerciseCatalogItem.load(),
                          ),
                          child: Text(s.exerciseRetry),
                        ),
                      ],
                    ),
                  );
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final items = snapshot.data!;
                final groups = items.map((e) => e.group).toSet().toList();
                final query = _normalize(_query);
                final filtered = items
                    .where(
                      (e) =>
                          (_group == null || e.group == _group) &&
                          _normalize(
                            '${e.name} ${e.equipment} ${e.muscles.join(' ')}',
                          ).contains(query),
                    )
                    .toList();
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                      child: TextField(
                        onChanged: (v) => setState(() => _query = v),
                        style: AppTypography.body,
                        decoration: InputDecoration(
                          hintText: s.exerciseSearch,
                          hintStyle: AppTypography.body.copyWith(
                            color: AppColors.textHalf,
                            fontSize: 15,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            size: 20,
                            color: AppColors.textSecondary,
                          ),
                          filled: true,
                          fillColor: const Color(0x12ffffff),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 42,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: [
                          _chip(
                            s.exerciseAll,
                            _group == null,
                            () => setState(() => _group = null),
                          ),
                          for (final group in groups)
                            _chip(
                              group,
                              _group == group,
                              () => setState(() => _group = group),
                            ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          ListView.builder(
                            padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
                            itemCount: filtered.length + 1,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    4,
                                    0,
                                    4,
                                    10,
                                  ),
                                  child: Text(
                                    filtered.isEmpty
                                        ? s.exerciseEmpty
                                        : s.exerciseCount(filtered.length),
                                    style: AppTypography.caption.copyWith(
                                      color: AppColors.textMuted,
                                      fontSize: 13,
                                    ),
                                  ),
                                );
                              }
                              final item = filtered[index - 1];
                              final selected = _selected.contains(item.id);
                              return _ExerciseRow(
                                item: item,
                                selected: selected,
                                onDetails: () async {
                                  // 从搜索进入详情时先收起键盘，避免遮挡动作示意。
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  final marked = await ExerciseDetailSheet.show(
                                    context,
                                    item,
                                    selected: _selected.contains(item.id),
                                  );
                                  if (!context.mounted || !marked) return;
                                  setState(() => _selected.add(item.id));
                                },
                                onTap: () => setState(() {
                                  if (selected) {
                                    _selected.remove(item.id);
                                  } else {
                                    _selected.add(item.id);
                                  }
                                }),
                              );
                            },
                          ),
                          if (height >= 180)
                            Positioned(
                              left: 16,
                              right: 16,
                              bottom: 16,
                              child: Center(
                                child: SizedBox(
                                  width: 272,
                                  height: 48,
                                  child: FilledButton(
                                    // 允许清空之前的选择；全新草稿仍须先选择动作。
                                    onPressed:
                                        _selected.isEmpty &&
                                            widget.initialIds.isEmpty
                                        ? null
                                        : () => Navigator.pop(
                                            context,
                                            items
                                                .where(
                                                  (e) =>
                                                      _selected.contains(e.id),
                                                )
                                                .toList(growable: false),
                                          ),
                                    style: FilledButton.styleFrom(
                                      backgroundColor: const Color(0xfff4f5f7),
                                      foregroundColor: const Color(0xff121418),
                                      disabledBackgroundColor: const Color(
                                        0xff1b1e23,
                                      ),
                                      disabledForegroundColor:
                                          AppColors.textMuted,
                                    ),
                                    child: Text(
                                      _selected.isEmpty
                                          ? (widget.initialIds.isEmpty
                                                ? s.exerciseMark
                                                : s.exerciseConfirmEmpty)
                                          : s.exerciseAdd(_selected.length),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, bool selected, VoidCallback onTap) => Padding(
    padding: const EdgeInsets.only(right: 6),
    child: ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: const Color(0xfff4f5f7),
      backgroundColor: const Color(0x12ffffff),
      side: BorderSide.none,
      labelStyle: TextStyle(
        fontSize: 13,
        color: selected ? const Color(0xff121418) : AppColors.textPrimary,
      ),
      shape: const StadiumBorder(),
    ),
  );
}

class _ExerciseRow extends StatelessWidget {
  const _ExerciseRow({
    required this.item,
    required this.selected,
    required this.onTap,
    required this.onDetails,
  });
  final ExerciseCatalogItem item;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onDetails;
  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    selected: selected,
    child: InkWell(
      onTap: onTap,
      child: Container(
        height: 72,
        decoration: BoxDecoration(
          color: selected ? const Color(0x0affffff) : null,
          border: const Border(bottom: BorderSide(color: Color(0x14ffffff))),
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.check_circle : Icons.circle_outlined,
              size: 22,
              color: selected ? AppColors.textPrimary : AppColors.textMuted,
            ),
            const SizedBox(width: 12),
            Semantics(
              label: context.l10n.exerciseDetailHow(item.name),
              button: true,
              child: InkWell(
                onTap: onDetails,
                child: SizedBox(
                  width: 40,
                  height: 48,
                  child: Center(
                    child: ExerciseAnatomy(exercise: item, size: 40),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.listItem.copyWith(fontSize: 15),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${item.muscles.take(3).join(' · ')} · ${item.equipment.toLowerCase()}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
