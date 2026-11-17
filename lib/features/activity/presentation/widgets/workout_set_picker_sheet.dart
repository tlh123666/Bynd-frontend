import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../design_system/design_system.dart';
import '../../../../l10n/app_localizations_context.dart';
import '../models/workout_draft_exercise.dart';

/// 系列滚轮面板：滚动立即更新草稿，关闭遮罩保留已选择的数值。
class WorkoutSetPickerSheet extends StatelessWidget {
  const WorkoutSetPickerSheet({
    required this.item,
    required this.set,
    required this.number,
    required this.onChanged,
    super.key,
  });
  final WorkoutDraftExercise item;
  final WorkoutDraftSet set;
  final int number;
  final VoidCallback onChanged;

  // 原型数据存在非标准值时也可显示原值，避免打开面板就悄悄改变数据。
  List<double> _values(double start, double end, double step, double current) {
    final values = List<double>.generate(
      ((end - start) / step).round() + 1,
      (i) => start + i * step,
    );
    if (!values.contains(current)) {
      values.add(current);
      values.sort();
    }
    return values;
  }

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final unit = item.exercise.unit;
    final usesWeight = unit == 'reps' && !item.exercise.bodyweight;
    final min = unit == 'seg' ? 5.0 : 1.0;
    final max = unit == 'seg'
        ? 300.0
        : unit == 'min'
        ? 120.0
        : 50.0;
    final step = unit == 'seg' ? 5.0 : 1.0;
    final amountValues = _values(min, max, step, set.amount.toDouble());
    final weightValues = _values(0, 300, 2.5, set.weight);
    final formatter = NumberFormat.decimalPattern(
      Localizations.localeOf(context).toString(),
    );
    final label = unit == 'seg'
        ? s.exerciseDetailSeconds
        : unit == 'min'
        ? s.exerciseDetailMinutes
        : item.exercise.bodyweight
        ? s.exerciseDetailRepsBody
        : s.exerciseDetailRepsWeight;
    final shortUnit = unit == 'seg'
        ? 's'
        : unit == 'min'
        ? 'min'
        : 'rep.';
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 44,
              child: Row(
                children: [
                  SizedBox(
                    width: 48,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context, true),
                      icon: Semantics(
                        label: s.workoutRemoveSet,
                        child: const Icon(
                          Icons.delete_outline,
                          color: AppColors.textPrimary,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${s.workoutSet} $number',
                      textAlign: TextAlign.center,
                      style: AppTypography.listItem.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 48,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context, false),
                      icon: Semantics(
                        label: s.workoutDone,
                        child: const Icon(
                          Icons.check,
                          color: AppColors.textPrimary,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            SizedBox(
              height: 160,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Center(
                        child: Container(
                          height: 32,
                          decoration: BoxDecoration(
                            color: const Color(0x12ffffff),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: AppNumberWheel(
                          values: amountValues,
                          initialValue: set.amount.toDouble(),
                          label: label,
                          unit: shortUnit,
                          format: formatter.format,
                          onChanged: (value) {
                            set.amount = value.toInt();
                            onChanged();
                          },
                        ),
                      ),
                      if (usesWeight) ...[
                        const SizedBox(width: 6),
                        Expanded(
                          child: AppNumberWheel(
                            values: weightValues,
                            initialValue: set.weight,
                            label: s.workoutWeightKg,
                            unit: 'kg',
                            format: formatter.format,
                            onChanged: (value) {
                              set.weight = value;
                              onChanged();
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
