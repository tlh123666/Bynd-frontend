import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../design_system/design_system.dart';
import '../../../../l10n/app_localizations_context.dart';
import 'activity_frosted_sheet_header.dart';
import 'exercise_selection_sheet.dart';
import '../models/exercise_catalog_item.dart';

/// 新建训练的空状态；动作目录和保存能力接入前只保留当前表单草稿。
class WorkoutBuilderSheet extends StatefulWidget {
  const WorkoutBuilderSheet._({required this._draft});
  final _WorkoutDraft _draft;

  static Future<void> show(BuildContext context) async {
    final draft = _WorkoutDraft();
    while (true) {
      if (!context.mounted) return;
      final action = await AppFrostedModalSheet.show<_BuilderAction>(
        context,
        topInset: math.max(MediaQuery.viewPaddingOf(context).top, 20) + 34,
        showHandle: false,
        barrierColor: AppColors.contentSheetVeil,
        waitForExit: true,
        builder: (_) => WorkoutBuilderSheet._(draft: draft),
      );
      if (!context.mounted || action != _BuilderAction.select) return;
      final selected = await ExerciseSelectionSheet.show(
        context,
        initialIds: draft.exercises.map((e) => e.id).toSet(),
      );
      if (selected != null) draft.exercises = selected;
    }
  }

  @override
  State<WorkoutBuilderSheet> createState() => _WorkoutBuilderSheetState();
}

enum _BuilderAction { select }

/// 跨叶片切换保留内存草稿，关闭编辑器时自然丢弃。
class _WorkoutDraft {
  String name = '';
  List<ExerciseCatalogItem> exercises = [];
}

class _WorkoutBuilderSheetState extends State<WorkoutBuilderSheet> {
  late final _name = TextEditingController(text: widget._draft.name);

  @override
  void dispose() {
    widget._draft.name = _name.text;
    _name.dispose();
    super.dispose();
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
    return SizedBox(
      height: height,
      child: Column(
        children: [
          ActivityFrostedSheetHeader(
            title: s.workoutBuilderTitle,
            height: math.min(62, height),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
              children: [
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
                        '0',
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
                                  : s.exerciseSelectedCount(
                                      widget._draft.exercises.length,
                                    ),
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
                    hintText: s.workoutBuilderNameHint,
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
                            border: Border.all(color: const Color(0x29ffffff)),
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
                  const SizedBox(height: 18),
                  Text(
                    s.exerciseDraftNote,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                  for (final exercise in widget._draft.exercises)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(
                        Icons.fitness_center,
                        color: AppColors.textSecondary,
                      ),
                      title: Text(exercise.name, style: AppTypography.body),
                      subtitle: Text(
                        exercise.muscles.join(' · '),
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                  TextButton.icon(
                    onPressed: () =>
                        Navigator.pop(context, _BuilderAction.select),
                    icon: const Icon(Icons.add),
                    label: Text(s.exerciseAddMore),
                  ),
                ],
              ],
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
                        onPressed: null,
                        style: FilledButton.styleFrom(
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
                        onPressed: null,
                        style: FilledButton.styleFrom(
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
    );
  }
}
