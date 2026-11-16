import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../design_system/design_system.dart';
import '../../../../l10n/app_localizations_context.dart';
import '../models/workout_draft_exercise.dart';
import 'exercise_anatomy.dart';
import 'exercise_detail_sheet.dart';

/// 动作行复用目录插图和动作详情；编辑始终作用于当前训练草稿。
class WorkoutExerciseRow extends StatefulWidget {
  const WorkoutExerciseRow({
    required this.item,
    required this.summary,
    required this.onChanged,
    required this.onRemove,
    required this.onDuplicate,
    required this.reorderMode,
    required this.canMoveUp,
    required this.canMoveDown,
    required this.onMoveUp,
    required this.onMoveDown,
    super.key,
  });
  final WorkoutDraftExercise item;
  final String summary;
  final VoidCallback onChanged, onRemove, onDuplicate, onMoveUp, onMoveDown;
  final bool reorderMode, canMoveUp, canMoveDown;

  @override
  State<WorkoutExerciseRow> createState() => _WorkoutExerciseRowState();
}

enum _Action { edit, detail, duplicate, remove }

class _WorkoutExerciseRowState extends State<WorkoutExerciseRow> {
  bool _expanded = false;

  Future<void> _editSet(int index) async {
    final set = widget.item.sets[index];
    final result = await AppFrostedModalSheet.show<(int, double)>(
      context,
      barrierColor: AppColors.contentSheetVeil,
      builder: (_) => _EditSetDialog(item: widget.item, set: set),
    );
    if (!mounted || result == null) return;
    setState(() {
      set.amount = result.$1;
      set.weight = result.$2;
    });
    widget.onChanged();
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.exercise.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.listItem.copyWith(fontSize: 15),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      widget.summary,
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
              if (widget.reorderMode) ...[
                IconButton(
                  icon: Semantics(
                    label: s.workoutMoveUp,
                    child: const Icon(Icons.keyboard_arrow_up),
                  ),
                  onPressed: widget.canMoveUp ? widget.onMoveUp : null,
                ),
                IconButton(
                  icon: Semantics(
                    label: s.workoutMoveDown,
                    child: const Icon(Icons.keyboard_arrow_down),
                  ),
                  onPressed: widget.canMoveDown ? widget.onMoveDown : null,
                ),
              ] else
                PopupMenuButton<_Action>(
                  tooltip: '',
                  icon: Semantics(
                    label: s.strengthOptions(item.exercise.name),
                    child: const Icon(
                      Icons.more_horiz,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  onSelected: (action) {
                    switch (action) {
                      case _Action.edit:
                        setState(() => _expanded = !_expanded);
                      case _Action.detail:
                        ExerciseDetailSheet.show(
                          context,
                          item.exercise,
                          selected: true,
                        );
                      case _Action.duplicate:
                        widget.onDuplicate();
                      case _Action.remove:
                        widget.onRemove();
                    }
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: _Action.edit,
                      child: Text(s.workoutEditSets),
                    ),
                    PopupMenuItem(
                      value: _Action.detail,
                      child: Text(s.workoutShowExercise),
                    ),
                    PopupMenuItem(
                      value: _Action.duplicate,
                      child: Text(s.workoutDuplicateExercise),
                    ),
                    PopupMenuItem(
                      value: _Action.remove,
                      child: Text(s.workoutRemoveExercise),
                    ),
                  ],
                ),
            ],
          ),
        ),
        if (_expanded && !widget.reorderMode) ...[
          for (var i = 0; i < item.sets.length; i++)
            ListTile(
              dense: true,
              contentPadding: const EdgeInsets.only(left: 8),
              title: Text('${s.workoutSet} ${i + 1}'),
              subtitle: Text(
                '${item.sets[i].amount}${item.exercise.unit == 'seg'
                    ? ' s'
                    : item.exercise.unit == 'min'
                    ? ' min'
                    : item.exercise.bodyweight
                    ? ''
                    : ' × ${item.sets[i].weight.toStringAsFixed(item.sets[i].weight.truncateToDouble() == item.sets[i].weight ? 0 : 1)} kg'}',
              ),
              onTap: () => _editSet(i),
              trailing: item.sets.length > 1
                  ? IconButton(
                      icon: Semantics(
                        label: s.workoutRemoveSet,
                        child: const Icon(Icons.remove_circle_outline),
                      ),
                      onPressed: () {
                        setState(() => item.sets.removeAt(i));
                        widget.onChanged();
                      },
                    )
                  : null,
            ),
          Align(
            alignment: Alignment.centerLeft,
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
              icon: const Icon(Icons.add),
              label: Text(s.workoutAddSet),
            ),
          ),
        ],
      ],
    );
  }
}

class _EditSetDialog extends StatefulWidget {
  const _EditSetDialog({required this.item, required this.set});
  final WorkoutDraftExercise item;
  final WorkoutDraftSet set;
  @override
  State<_EditSetDialog> createState() => _EditSetDialogState();
}

class _EditSetDialogState extends State<_EditSetDialog> {
  late final _amount = TextEditingController(text: '${widget.set.amount}');
  late final _weight = TextEditingController(text: '${widget.set.weight}');
  bool _invalid = false;

  @override
  void dispose() {
    _amount.dispose();
    _weight.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final usesWeight =
        widget.item.exercise.unit == 'reps' && !widget.item.exercise.bodyweight;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              s.workoutEditSets,
              textAlign: TextAlign.center,
              style: AppTypography.title,
            ),
            TextField(
              controller: _amount,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(labelText: s.workoutAmount),
            ),
            if (usesWeight)
              TextField(
                controller: _weight,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(labelText: s.workoutWeightKg),
              ),
            if (_invalid) Text(s.workoutInvalidSet),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(s.workoutCancel),
                ),
                TextButton(
                  onPressed: () {
                    final amount = int.tryParse(_amount.text);
                    final weight = usesWeight
                        ? double.tryParse(_weight.text.replaceAll(',', '.'))
                        : 0.0;
                    final max = widget.item.exercise.unit == 'seg'
                        ? 300
                        : widget.item.exercise.unit == 'min'
                        ? 120
                        : 50;
                    if (amount == null ||
                        amount < 1 ||
                        amount > max ||
                        weight == null ||
                        !weight.isFinite ||
                        weight < 0 ||
                        weight > 300) {
                      setState(() => _invalid = true);
                      return;
                    }
                    Navigator.pop(context, (amount, weight));
                  },
                  child: Text(s.workoutDone),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
