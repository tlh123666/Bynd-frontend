import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../../design_system/design_system.dart';
import '../../data/local_workout_store.dart';
import '../../../../l10n/app_localizations_context.dart';
import 'activity_frosted_sheet_header.dart';
import 'exercise_selection_sheet.dart';
import 'workout_exercise_row.dart';
import '../models/workout_draft_exercise.dart';

/// 新建训练草稿；默认组数和重量为示例，尚不代表完成的运动。
class WorkoutBuilderSheet extends StatefulWidget {
  const WorkoutBuilderSheet._({required this._draft, required this._store});
  final _WorkoutDraft _draft;
  final LocalWorkoutStore _store;

  static Future<LocalWorkoutPlan?> show(
    BuildContext context, {
    LocalWorkoutStore? store,
    LocalWorkoutPlan? initialPlan,
  }) async {
    final draft = _WorkoutDraft();
    if (initialPlan != null) {
      draft.name = initialPlan.name;
      draft.exercises = initialPlan.copy().exercises;
    }
    final localStore = store ?? LocalWorkoutStore(null);
    while (true) {
      if (!context.mounted) return null;
      final action = await AppFrostedModalSheet.show<_BuilderAction>(
        context,
        topInset: math.max(MediaQuery.viewPaddingOf(context).top, 20) + 34,
        showHandle: false,
        barrierColor: AppColors.contentSheetVeil,
        waitForExit: true,
        builder: (_) => WorkoutBuilderSheet._(draft: draft, store: localStore),
      );
      if (!context.mounted ||
          action == null ||
          action == _BuilderAction.saved) {
        return null;
      }
      if (action == _BuilderAction.start) {
        final name = draft.name.trim();
        return LocalWorkoutPlan(
          name: name.isEmpty ? _suggestedName(context, draft) : name,
          exercises: [for (final item in draft.exercises) item.copy()],
        );
      }
      final selected = await ExerciseSelectionSheet.show(
        context,
        initialIds: draft.exercises.map((e) => e.exercise.id).toSet(),
      );
      if (selected != null) {
        // 重新选择时保留已有动作的组数和用户调整的数值。
        final selectedIds = selected.map((e) => e.id).toSet();
        final existing = draft.exercises
            .where((e) => selectedIds.contains(e.exercise.id))
            .toList();
        final existingIds = existing.map((e) => e.exercise.id).toSet();
        draft.exercises = [
          ...existing,
          for (final item in selected)
            if (!existingIds.contains(item.id)) WorkoutDraftExercise(item),
        ];
      }
    }
  }

  @override
  State<WorkoutBuilderSheet> createState() => _WorkoutBuilderSheetState();
}

enum _BuilderAction { select, saved, start }

/// 跨叶片切换保留内存草稿，关闭编辑器时自然丢弃。
class _WorkoutDraft {
  String name = '';
  List<WorkoutDraftExercise> exercises = [];
}

String _suggestedName(BuildContext context, _WorkoutDraft draft) {
  if (draft.exercises.isEmpty) return context.l10n.workoutBuilderNameHint;
  return context.l10n.workoutSuggestedName(
    draft.exercises.first.exercise.group.toLowerCase(),
  );
}

class _WorkoutBuilderSheetState extends State<WorkoutBuilderSheet> {
  late final _name = TextEditingController(text: widget._draft.name);
  bool _saving = false;
  bool _saveError = false;
  bool _reordering = false;

  Future<void> _save() async {
    if (_saving || widget._draft.exercises.isEmpty) return;
    setState(() {
      _saving = true;
      _saveError = false;
    });
    final name = _name.text.trim();
    final plan = LocalWorkoutPlan(
      name: name.isEmpty ? _suggestedName(context, widget._draft) : name,
      exercises: [for (final item in widget._draft.exercises) item.copy()],
    );
    try {
      await widget._store.add(plan);
      // 用户可能已通过系统返回离开，不能误关闭后来打开的页面。
      if (mounted && ModalRoute.of(context)?.isCurrent == true) {
        Navigator.pop(context, _BuilderAction.saved);
      }
    } catch (_) {
      if (mounted) setState(() => _saveError = true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  void dispose() {
    widget._draft.name = _name.text;
    _name.dispose();
    super.dispose();
  }

  String _setSummary(BuildContext context, WorkoutDraftExercise item) {
    final first = item.sets.first;
    final locale = Localizations.localeOf(context).languageCode;
    final unit = switch (item.exercise.unit) {
      'seg' => '${first.amount} s',
      'min' => '${first.amount} min',
      _ when item.exercise.bodyweight =>
        '${first.amount} ${locale == 'pt' ? 'repetições' : 'reps'}',
      _ =>
        '${first.amount} × ${NumberFormat.decimalPattern(locale).format(first.weight)} kg',
    };
    final label = locale == 'pt'
        ? (item.sets.length == 1 ? 'série' : 'séries')
        : (item.sets.length == 1 ? 'set' : 'sets');
    return '${item.sets.length} $label · $unit';
  }

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final media = MediaQuery.of(context);
    final exercises = widget._draft.exercises;
    final sets = exercises.fold<int>(0, (sum, item) => sum + item.sets.length);
    final weight = exercises.fold<double>(
      0,
      (sum, item) => sum + item.liftedWeight,
    );
    final format = NumberFormat.decimalPattern(
      Localizations.localeOf(context).toString(),
    );
    final height = math.max(
      0.0,
      media.size.height -
          math.max(media.viewPadding.top, 20) -
          34 -
          media.viewPadding.bottom -
          media.viewInsets.bottom,
    );
    return SizedBox(
      height: height,
      child: AbsorbPointer(
        absorbing: _saving,
        child: Column(
          children: [
            ActivityFrostedSheetHeader(
              title: s.workoutBuilderTitle,
              height: math.min(62, height),
              trailing: exercises.isEmpty
                  ? null
                  : IconButton(
                      onPressed: () =>
                          setState(() => _reordering = !_reordering),
                      icon: Semantics(
                        label: _reordering ? s.workoutDone : s.workoutReorder,
                        child: Icon(
                          _reordering ? Icons.check : Icons.edit_outlined,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                children: [
                  if (_saveError && height < 250)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        s.workoutSaveError,
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 18),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(0x14ffffff)),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          format.format(weight),
                          style: AppTypography.page.copyWith(
                            fontSize: 48,
                            height: 1,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                s.workoutBuilderWeight,
                                style: AppTypography.caption.copyWith(
                                  color: AppColors.textMuted,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget._draft.exercises.isEmpty
                                    ? s.workoutBuilderEmptyCount
                                    : s
                                          .strengthExerciseCount(
                                            exercises.length,
                                            sets,
                                          )
                                          .toUpperCase(),
                                style: AppTypography.caption.copyWith(
                                  color: AppColors.textMuted,
                                  fontSize: 11,
                                  letterSpacing: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    s.workoutBuilderName,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textHalf,
                      fontSize: 11,
                      letterSpacing: 1.3,
                    ),
                  ),
                  TextField(
                    controller: _name,
                    onChanged: (value) => widget._draft.name = value,
                    inputFormatters: [LengthLimitingTextInputFormatter(40)],
                    style: AppTypography.page.copyWith(fontSize: 26),
                    decoration: InputDecoration(
                      hintText: _suggestedName(context, widget._draft),
                      hintStyle: AppTypography.page.copyWith(
                        fontSize: 26,
                        color: AppColors.textMuted,
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.only(top: 8, bottom: 16),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0x14ffffff)),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.textMuted),
                      ),
                    ),
                  ),
                  if (widget._draft.exercises.isEmpty) ...[
                    SizedBox(height: media.size.height * .08),
                    Center(
                      child: Semantics(
                        label: s.workoutBuilderAdd,
                        button: true,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(44),
                          onTap: () =>
                              Navigator.pop(context, _BuilderAction.select),
                          child: Container(
                            width: 88,
                            height: 88,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0x29ffffff),
                              ),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: AppColors.textPrimary,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      s.workoutBuilderEmptyTitle,
                      textAlign: TextAlign.center,
                      style: AppTypography.section.copyWith(
                        fontSize: 23,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      s.workoutBuilderEmptyHint,
                      textAlign: TextAlign.center,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 13,
                      ),
                    ),
                  ] else ...[
                    Padding(
                      padding: const EdgeInsets.only(top: 12, bottom: 4),
                      child: Text(
                        s.workoutDefaultsNote,
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                    for (final item in exercises)
                      WorkoutExerciseRow(
                        reorderMode: _reordering,
                        canMoveUp: exercises.indexOf(item) > 0,
                        canMoveDown:
                            exercises.indexOf(item) < exercises.length - 1,
                        onMoveUp: () => setState(() {
                          final i = exercises.indexOf(item);
                          if (i > 0) {
                            exercises.removeAt(i);
                            exercises.insert(i - 1, item);
                          }
                        }),
                        onMoveDown: () => setState(() {
                          final i = exercises.indexOf(item);
                          if (i >= 0 && i < exercises.length - 1) {
                            exercises.removeAt(i);
                            exercises.insert(i + 1, item);
                          }
                        }),
                        key: ObjectKey(item),
                        item: item,
                        summary: _setSummary(context, item),
                        onChanged: () => setState(() {}),
                        onRemove: () => setState(() => exercises.remove(item)),
                        onDuplicate: () => setState(
                          () => exercises.insert(
                            exercises.indexOf(item) + 1,
                            item.copy(),
                          ),
                        ),
                      ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: () =>
                            Navigator.pop(context, _BuilderAction.select),
                        icon: const Icon(Icons.add),
                        label: Text(s.exerciseAddMore),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.textSecondary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (_saveError && height >= 250)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 4,
                ),
                child: Text(
                  s.workoutSaveError,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            // 极小临时视口无法容纳固定底栏，等待窗口恢复后再显示。
            if (height >= 144 && media.size.width >= 100)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 26),
                child: SizedBox(
                  width: 272,
                  height: 48,
                  child: Row(
                    children: [
                      Expanded(
                        child: FilledButton(
                          onPressed: exercises.isEmpty || _saving
                              ? null
                              : _save,
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xff1a1d22),
                            foregroundColor: AppColors.textPrimary,
                            disabledBackgroundColor: const Color(0x1fffffff),
                            disabledForegroundColor: AppColors.textMuted,
                            padding: EdgeInsets.zero,
                          ),
                          child: Text(s.registrationSave),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FilledButton(
                          onPressed: exercises.isEmpty || _saving
                              ? null
                              : () => Navigator.pop(
                                  context,
                                  _BuilderAction.start,
                                ),
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xfff4f5f7),
                            foregroundColor: const Color(0xff121418),
                            disabledBackgroundColor: const Color(0x59f4f5f7),
                            disabledForegroundColor: const Color(0xff121418),
                            padding: EdgeInsets.zero,
                          ),
                          child: Text(s.workoutBuilderStart),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
