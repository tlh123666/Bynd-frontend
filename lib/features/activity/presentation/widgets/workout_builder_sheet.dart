import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../../design_system/design_system.dart';
import '../../../../l10n/app_localizations_context.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../data/local_workout_store.dart';
import 'activity_frosted_sheet_header.dart';
import 'exercise_selection_sheet.dart';
import 'workout_exercise_row.dart';
import 'workout_delete_confirmation_sheet.dart';
import '../models/workout_draft_exercise.dart';

/// 新建训练草稿；默认组数和重量为示例，尚不代表完成的运动。
class WorkoutBuilderSheet extends StatefulWidget {
  const WorkoutBuilderSheet._({
    required this._draft,
    required this._store,
    this._initialId,
    this._initialName,
  });
  final _WorkoutDraft _draft;
  final LocalWorkoutStore _store;
  final String? _initialId;
  final String? _initialName;

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
        builder: (_) => WorkoutBuilderSheet._(
          draft: draft,
          store: localStore,
          initialId: initialPlan?.id,
          initialName: initialPlan?.name,
        ),
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
  String? _errorMessage;
  bool _reordering = false;
  bool _setPickerOpen = false;
  WorkoutDraftExercise? _expandedExercise;

  Future<void> _save() async {
    if (_saving || widget._draft.exercises.isEmpty) return;
    setState(() {
      _saving = true;
      _errorMessage = null;
    });
    final name = _name.text.trim();
    final plan = LocalWorkoutPlan(
      id: widget._initialId,
      name: name.isEmpty ? _suggestedName(context, widget._draft) : name,
      exercises: [for (final item in widget._draft.exercises) item.copy()],
    );
    try {
      if (widget._initialId == null) {
        await widget._store.add(plan);
      } else {
        await widget._store.update(plan);
      }
      // 用户可能已通过系统返回离开，不能误关闭后来打开的页面。
      if (mounted && ModalRoute.of(context)?.isCurrent == true) {
        Navigator.pop(context, _BuilderAction.saved);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _errorMessage = context.l10n.workoutSaveError);
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _delete() async {
    final id = widget._initialId;
    if (id == null || _saving) return;
    final s = context.l10n;
    final confirmed = await WorkoutDeleteConfirmationSheet.show(
      context,
      name: widget._initialName ?? '',
    );
    if (!mounted || !confirmed || _saving) return;
    setState(() {
      _saving = true;
      _errorMessage = null;
    });
    try {
      await widget._store.delete(id);
      // 确认弹窗退出及存储完成后，才能关闭当前编辑器。
      if (mounted && ModalRoute.of(context)?.isCurrent == true) {
        Navigator.pop(context, _BuilderAction.saved);
      }
    } catch (_) {
      if (mounted) setState(() => _errorMessage = s.workoutActionError);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _toggleReordering() => setState(() {
    _reordering = !_reordering;
    _expandedExercise = null;
  });

  Widget _reorderButton(AppLocalizations s) => IconButton(
    onPressed: _toggleReordering,
    icon: Semantics(
      label: _reordering ? s.workoutDone : s.workoutReorder,
      child: Icon(
        _reordering ? Icons.check : Icons.edit_outlined,
        color: AppColors.textPrimary,
      ),
    ),
  );

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
              title: widget._initialId == null
                  ? s.workoutBuilderTitle
                  : s.workoutBuilderNameHint,
              height: math.min(62, height),
              trailing: widget._initialId != null
                  ? IconButton(
                      onPressed: _delete,
                      icon: Semantics(
                        label: s.workoutDeleteTitle,
                        child: const Icon(
                          Icons.delete_outline,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    )
                  : exercises.isEmpty
                  ? null
                  : _reorderButton(s),
            ),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                    sliver: SliverList.list(
                      children: [
                        if (_errorMessage != null && height < 250)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              _errorMessage!,
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
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(40),
                          ],
                          style: AppTypography.page.copyWith(fontSize: 26),
                          decoration: InputDecoration(
                            hintText: _suggestedName(context, widget._draft),
                            hintStyle: AppTypography.page.copyWith(
                              fontSize: 26,
                              color: AppColors.textMuted,
                            ),
                            isDense: true,
                            contentPadding: const EdgeInsets.only(
                              top: 8,
                              bottom: 16,
                            ),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0x14ffffff)),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.textMuted,
                              ),
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
                                onTap: () => Navigator.pop(
                                  context,
                                  _BuilderAction.select,
                                ),
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
                          if (widget._initialId == null)
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 12,
                                bottom: 4,
                              ),
                              child: Text(
                                s.workoutDefaultsNote,
                                style: AppTypography.caption.copyWith(
                                  color: AppColors.textMuted,
                                ),
                              ),
                            )
                          else
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      s.workoutExercisesLabel,
                                      style: AppTypography.caption.copyWith(
                                        color: AppColors.textHalf,
                                        fontSize: 11,
                                        letterSpacing: 1.3,
                                      ),
                                    ),
                                  ),
                                  _reorderButton(s),
                                ],
                              ),
                            ),
                        ],
                      ],
                    ),
                  ),
                  // 共用外层滚动视口，使拖拽靠近边缘时可以自动滚动。
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverReorderableList(
                      itemCount: exercises.length,
                      // 拖动行进入独立浮层后仍需 Material 供行内控件使用。
                      proxyDecorator: (child, index, animation) =>
                          Material(color: Colors.transparent, child: child),
                      onReorderItem: (oldIndex, newIndex) => setState(() {
                        exercises.insert(
                          newIndex,
                          exercises.removeAt(oldIndex),
                        );
                      }),
                      itemBuilder: (context, index) {
                        final item = exercises[index];
                        return WorkoutExerciseRow(
                          dragIndex: index,
                          reorderMode: _reordering,
                          expanded: identical(_expandedExercise, item),
                          onPickerVisibilityChanged: (open) =>
                              setState(() => _setPickerOpen = open),
                          onToggleExpanded: () => setState(() {
                            _expandedExercise =
                                identical(_expandedExercise, item)
                                ? null
                                : item;
                          }),
                          key: ObjectKey(item),
                          item: item,
                          summary: _setSummary(context, item),
                          onChanged: () => setState(() {}),
                          onReplace: (next) => setState(() {
                            final index = exercises.indexOf(item);
                            if (index >= 0) {
                              final replacement = item.replaceWith(next);
                              exercises[index] = replacement;
                              if (identical(_expandedExercise, item)) {
                                _expandedExercise = replacement;
                              }
                            }
                          }),
                          onRemove: () => setState(() {
                            exercises.remove(item);
                            if (identical(_expandedExercise, item)) {
                              _expandedExercise = null;
                            }
                          }),
                          onDuplicate: () => setState(
                            () => exercises.insert(
                              exercises.indexOf(item) + 1,
                              item.copy(),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  if (exercises.isNotEmpty)
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      sliver: SliverToBoxAdapter(
                        child: Align(
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
                      ),
                    ),
                ],
              ),
            ),
            if (_errorMessage != null && height >= 250)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 4,
                ),
                child: Text(
                  _errorMessage!,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            // 极小临时视口无法容纳固定底栏，等待窗口恢复后再显示。
            if (height >= 144 && media.size.width >= 100)
              Visibility(
                key: const ValueKey('workout-builder-footer'),
                visible: !_setPickerOpen,
                maintainState: true,
                maintainAnimation: true,
                maintainSize: true,
                child: Padding(
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
              ),
          ],
        ),
      ),
    );
  }
}
