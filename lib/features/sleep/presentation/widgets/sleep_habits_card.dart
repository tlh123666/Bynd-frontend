import 'package:flutter/material.dart';
import '../../../../design_system/design_system.dart';
import '../../../diary/domain/diary_models.dart';
import '../../../diary/presentation/diary_quick_questions.dart';

class SleepHabitsCard extends StatelessWidget {
  const SleepHabitsCard({
    required this.repository,
    required this.date,
    required this.onBusyChanged,
    super.key,
  });
  final DiaryRepository repository;
  final DateTime date;
  final ValueChanged<bool> onBusyChanged;
  @override
  Widget build(BuildContext context) => DiaryQuickQuestions(
    repository: repository,
    date: date,
    onBusyChanged: onBusyChanged,
    keyPrefix: 'sleep-habit',
    bodyStyle: AppSleepStyle.body,
    captionStyle: AppSleepStyle.caption,
    kickerStyle: AppSleepStyle.kicker,
    questions: const [
      (
        'cafe15',
        'Tomou caf\u00e9 depois das 15h?',
        'Did you have coffee after 3 pm?',
      ),
      ('alc', 'Bebeu \u00e1lcool?', 'Did you drink alcohol?'),
      ('tela', 'Usou tela na cama?', 'Did you use a screen in bed?'),
    ],
  );
}
