import 'package:flutter/material.dart';
import '../../../../core/network/api_client.dart';
import '../../../../design_system/design_system.dart';
import '../../../diary/domain/diary_models.dart';
import '../sleep_copy.dart';
import 'sleep_widgets.dart';

/// The sleep page and Diary share the same workspace. Each answer starts with
/// a fresh revision and replaces only that habit, preserving all other entries.
class SleepHabitsCard extends StatefulWidget {
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
  State<SleepHabitsCard> createState() => _SleepHabitsCardState();
}

class _SleepHabitsCardState extends State<SleepHabitsCard> {
  DiaryDay? _day;
  List<DiaryTracker>? _catalog;
  Object? _error;
  bool _busy = false;
  final _questions = const [
    ('cafe15', 'Tomou café depois das 15h?', 'Did you have coffee after 3 pm?'),
    ('alc', 'Bebeu álcool?', 'Did you drink alcohol?'),
    ('tela', 'Usou tela na cama?', 'Did you use a screen in bed?'),
  ];
  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _error = null);
    try {
      final results = await Future.wait<dynamic>([
        widget.repository.load(widget.date),
        widget.repository.catalog(),
      ]);
      if (mounted) {
        setState(() {
          _day = results[0] as DiaryDay;
          _catalog = results[1] as List<DiaryTracker>;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  Future<void> _answer(String key, bool answer) async {
    if (_busy || _day?.editable != true) return;
    final tracker = _catalog!.where((t) => t.key == key).firstOrNull;
    if (tracker == null) return;
    setState(() => _busy = true);
    widget.onBusyChanged(true);
    try {
      final base = await widget.repository.load(widget.date);
      if (!base.editable) throw const ApiException('Day is read only');
      final existing = base.events
          .where((e) => diaryCanonicalKey(e.key) == key)
          .firstOrNull;
      final events = base.events
          .where((e) => diaryCanonicalKey(e.key) != key)
          .toList();
      if (existing == null || existing.happened != answer) {
        final record = existing ?? DiaryMoment.forTracker(tracker, widget.date);
        events.add(
          record.copy({
            'numericValue': null,
            'details': {...record.details, 'answer': answer},
          }),
        );
      }
      final saved = await widget.repository.save(
        base,
        events,
        base.note,
        diaryId(),
      );
      if (mounted) {
        setState(() {
          _day = saved;
          _error = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _error = e);
        AppNotice.show(
          context,
          kind: AppNoticeKind.error,
          message: sleepText(
            context,
            'Não foi possível salvar. Tente novamente.',
            'Could not save. Please try again.',
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _busy = false);
        widget.onBusyChanged(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) => SleepCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SleepLabel(sleepText(context, 'Seu Diário', 'Your diary')),
        const SizedBox(height: 14),
        if (_day == null && _error == null)
          const Center(child: AppLoadingIndicator())
        else if (_day == null)
          AppGlassPill(
            label: sleepText(context, 'Tentar novamente', 'Retry'),
            onPressed: _load,
          )
        else ...[
          for (final q in _questions) ...[
            const SizedBox(height: 14),
            Text(sleepText(context, q.$2, q.$3), style: AppSleepStyle.body),
            Wrap(
              alignment: WrapAlignment.end,
              spacing: 8,
              children: [
                for (final yes in [false, true])
                  TextButton(
                    key: ValueKey('sleep-habit-${q.$1}-$yes'),
                    onPressed: _busy || !_day!.editable
                        ? null
                        : () => _answer(q.$1, yes),
                    style: TextButton.styleFrom(
                      foregroundColor:
                          _day!.events.any(
                            (e) =>
                                diaryCanonicalKey(e.key) == q.$1 &&
                                e.happened == yes,
                          )
                          ? AppColors.textPrimary
                          : AppColors.textMuted,
                      backgroundColor:
                          _day!.events.any(
                            (e) =>
                                diaryCanonicalKey(e.key) == q.$1 &&
                                e.happened == yes,
                          )
                          ? AppColors.glass
                          : Colors.transparent,
                    ),
                    child: Text(
                      sleepText(
                        context,
                        yes ? 'Sim' : 'Não',
                        yes ? 'Yes' : 'No',
                      ),
                    ),
                  ),
              ],
            ),
          ],
          if (!_day!.editable)
            Text(
              sleepText(
                context,
                'Este dia está fechado para edição.',
                'This day is read only.',
              ),
              style: AppSleepStyle.caption,
            ),
          if (_busy)
            const LinearProgressIndicator(
              minHeight: 1,
              color: AppColors.textPrimary,
            ),
        ],
      ],
    ),
  );
}
