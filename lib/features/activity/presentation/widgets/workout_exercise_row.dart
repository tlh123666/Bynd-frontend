import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../design_system/design_system.dart';
import '../../../../l10n/app_localizations_context.dart';
import '../models/workout_draft_exercise.dart';
import 'exercise_anatomy.dart';
import 'exercise_detail_sheet.dart';
import 'exercise_selection_sheet.dart';
import 'workout_set_picker_sheet.dart';
import '../models/exercise_catalog_item.dart';

/// 动作行复用目录插图和动作详情；编辑始终作用于当前训练草稿。
class WorkoutExerciseRow extends StatefulWidget {
  const WorkoutExerciseRow({
    required this.item,
    required this.summary,
    required this.onChanged,
    required this.onRemove,
    required this.onDuplicate,
    required this.onReplace,
    required this.expanded,
    required this.onToggleExpanded,
    required this.onPickerVisibilityChanged,
    required this.reorderMode,
    required this.dragIndex,
    super.key,
  });
  final WorkoutDraftExercise item;
  final ValueChanged<ExerciseCatalogItem> onReplace;
  final ValueChanged<bool> onPickerVisibilityChanged;
  final String summary;
  final VoidCallback onChanged, onRemove, onDuplicate, onToggleExpanded;
  final bool expanded, reorderMode;
  final int dragIndex;

  @override
  State<WorkoutExerciseRow> createState() => _WorkoutExerciseRowState();
}

enum _Action { edit, replace, duplicate, detail, remove }

class _WorkoutExerciseRowState extends State<WorkoutExerciseRow> {
  Future<void> _editSet(int index) async {
    final set = widget.item.sets[index];
    widget.onPickerVisibilityChanged(true);
    bool? removed;
    try {
      removed = await AppFrostedModalSheet.show<bool>(
        context,
        barrierColor: const Color(0x4d080a0e),
        barrierBlurSigma: 0,
        // 加深仅此面板的玻璃底色，避免底层文字穿透影响阅读。
        surfaceTint: const Color(0xe614181e),
        waitForExit: true,
        builder: (_) => WorkoutSetPickerSheet(
          item: widget.item,
          set: set,
          number: index + 1,
          onChanged: () {
            if (mounted) widget.onChanged();
          },
        ),
      );
    } finally {
      if (mounted) widget.onPickerVisibilityChanged(false);
    }
    if (!mounted || removed != true) return;
    // 原型允许移除最后一组；此时同时移除动作。
    if (widget.item.sets.length == 1) {
      widget.onRemove();
    } else {
      setState(() => widget.item.sets.remove(set));
      widget.onChanged();
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final item = widget.item;
    return Column(
      children: [
        Container(
          height: 72,
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0x14ffffff))),
          ),
          child: Row(
            children: [
              InkWell(
                onTap: () => ExerciseDetailSheet.show(
                  context,
                  item.exercise,
                  selected: true,
                ),
                child: ExerciseAnatomy(exercise: item.exercise, size: 56),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InkWell(
                  onTap: widget.expanded && !widget.reorderMode
                      ? widget.onToggleExpanded
                      : null,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        // 与原型一致隐藏动作名称中的计时单位后缀。
                        item.exercise.name.replaceFirst(
                          RegExp(
                            r'\s*\((segundos|minutos)\)$',
                            caseSensitive: false,
                          ),
                          '',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.listItem.copyWith(fontSize: 15),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        widget.expanded && !widget.reorderMode
                            ? item.exercise.muscles.take(2).join(' · ')
                            : widget.summary,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textMuted,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (widget.reorderMode)
                Semantics(
                  label: s.workoutReorder,
                  child: ReorderableDragStartListener(
                    index: widget.dragIndex,
                    child: const SizedBox(
                      width: 48,
                      height: 48,
                      child: Icon(
                        Icons.drag_handle,
                        size: 20,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                )
              else
                Builder(
                  builder: (buttonContext) => IconButton(
                    icon: Semantics(
                      label: s.strengthOptions(item.exercise.name),
                      child: const Icon(
                        Icons.more_horiz,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    onPressed: () async {
                      final box = buttonContext.findRenderObject() as RenderBox;
                      final overlay =
                          Navigator.of(
                                buttonContext,
                              ).overlay!.context.findRenderObject()
                              as RenderBox;
                      final anchor = MatrixUtils.transformRect(
                        box.getTransformTo(overlay),
                        Offset.zero & box.size,
                      );
                      final action = await AppFrostedContextMenu.show<_Action>(
                        buttonContext,
                        anchor: anchor,
                        items: [
                          AppFrostedMenuItem(
                            value: _Action.edit,
                            label: widget.expanded
                                ? s.workoutCloseSets
                                : s.workoutEditSets,
                            icon: Icons.edit_outlined,
                          ),
                          AppFrostedMenuItem(
                            value: _Action.replace,
                            label: s.workoutReplaceExercise,
                            icon: Icons.swap_horiz,
                          ),
                          AppFrostedMenuItem(
                            value: _Action.duplicate,
                            label: s.workoutDuplicateExercise,
                            icon: Icons.copy_outlined,
                          ),
                          AppFrostedMenuItem(
                            value: _Action.detail,
                            label: s.workoutShowExercise,
                            icon: Icons.play_circle_outline,
                          ),
                          AppFrostedMenuItem(
                            value: _Action.remove,
                            label: s.workoutRemoveExercise,
                            icon: Icons.delete_outline,
                            destructive: true,
                          ),
                        ],
                      );
                      if (!mounted || action == null) return;
                      switch (action) {
                        case _Action.edit:
                          widget.onToggleExpanded();
                        case _Action.replace:
                          final selected = await ExerciseSelectionSheet.show(
                            this.context,
                            replaceMode: true,
                          );
                          if (!mounted ||
                              selected == null ||
                              selected.isEmpty) {
                            return;
                          }
                          widget.onReplace(selected.first);
                        case _Action.duplicate:
                          widget.onDuplicate();
                        case _Action.detail:
                          ExerciseDetailSheet.show(
                            this.context,
                            item.exercise,
                            selected: true,
                          );
                        case _Action.remove:
                          widget.onRemove();
                      }
                    },
                  ),
                ),
            ],
          ),
        ),
        if (widget.expanded && !widget.reorderMode) ...[
          for (var i = 0; i < item.sets.length; i++)
            _WorkoutSetRow(
              label: '${s.workoutSet} ${i + 1}',
              item: item,
              set: item.sets[i],
              onTap: () => _editSet(i),
            ),
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () {
                final last = item.sets.last;
                setState(
                  () => item.sets.add(
                    WorkoutDraftSet(amount: last.amount, weight: last.weight),
                  ),
                );
                widget.onChanged();
              },
              icon: const Icon(Icons.add, size: 18),
              label: Text(s.workoutAddSet),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}

/// 与原型一致：每组占一行，数值和单位保持不同层级。
class _WorkoutSetRow extends StatelessWidget {
  const _WorkoutSetRow({
    required this.label,
    required this.item,
    required this.set,
    required this.onTap,
  });
  final String label;
  final WorkoutDraftExercise item;
  final WorkoutDraftSet set;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final numberStyle = AppTypography.page.copyWith(
      fontSize: 17,
      fontWeight: FontWeight.w300,
      height: 1,
    );
    final unitStyle = AppTypography.caption.copyWith(
      fontSize: 13,
      color: AppColors.textMuted,
    );
    final number = NumberFormat.decimalPattern(
      Localizations.localeOf(context).toString(),
    ).format(set.weight);
    final unit = item.exercise.unit;
    final spans = <InlineSpan>[
      TextSpan(text: '${set.amount}', style: numberStyle),
      if (unit == 'seg' || unit == 'min')
        TextSpan(text: unit == 'seg' ? ' s' : ' min', style: unitStyle)
      else if (item.exercise.bodyweight)
        TextSpan(
          text:
              ' ${Localizations.localeOf(context).languageCode == 'pt' ? 'repetições' : 'reps'}',
          style: unitStyle,
        )
      else ...[
        TextSpan(text: ' × ', style: unitStyle),
        TextSpan(text: number, style: numberStyle),
        TextSpan(text: ' kg', style: unitStyle),
      ],
    ];
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0x0fffffff))),
      ),
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 46,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: AppTypography.listItem.copyWith(fontSize: 15),
                ),
              ),
              Text.rich(TextSpan(children: spans), maxLines: 1),
            ],
          ),
        ),
      ),
    );
  }
}
