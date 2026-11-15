import '../../../l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';
import '../../../core/network/api_client.dart';
import '../../../design_system/design_system.dart';
import '../domain/diary_models.dart';
import 'diary_widgets.dart' show diaryText;

/// The sleep page and Diary share the same workspace. Each answer starts with
/// a fresh revision and replaces only that habit, preserving all other entries.
class DiaryQuickQuestions extends StatefulWidget {
  const DiaryQuickQuestions({
    required this.repository,
    required this.date,
    required this.onBusyChanged,
    required this.questions,
    this.bodyStyle,
    this.captionStyle,
    this.kickerStyle,
    this.keyPrefix = 'diary-habit',
    this.iconAnswers = false,
    super.key,
  });
  final List<(String, String, String)> questions;
  final TextStyle? bodyStyle, captionStyle, kickerStyle;
  final String keyPrefix;
  final bool iconAnswers;
  final DiaryRepository repository;
  final DateTime date;
  final ValueChanged<bool> onBusyChanged;
  @override
  State<DiaryQuickQuestions> createState() => _DiaryQuickQuestionsState();
}

class _DiaryQuickQuestionsState extends State<DiaryQuickQuestions> {
  DiaryDay? _day;
  List<DiaryTracker>? _catalog;
  Object? _error;
  bool _busy = false;
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
          message: context.l10n.diaryUiCouldNotSavePleaseTryAgain,
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
  Widget build(BuildContext context) => AppMetricCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.l10n.diaryUiYourDiary.toUpperCase(),
          style: widget.kickerStyle ?? AppTypography.caption,
        ),
        const SizedBox(height: 14),
        if (_day == null && _error == null)
          const Center(child: AppLoadingIndicator())
        else if (_day == null)
          AppGlassPill(label: context.l10n.diaryUiRetry, onPressed: _load)
        else ...[
          for (final q in widget.questions) ...[
            const SizedBox(height: 14),
            Text(
              diaryText(context, q.$2, q.$3),
              style: widget.bodyStyle ?? AppTypography.body,
            ),
            Wrap(
              alignment: WrapAlignment.end,
              spacing: 8,
              children: [
                for (final yes in [false, true])
                  TextButton(
                    key: ValueKey('${widget.keyPrefix}-${q.$1}-$yes'),
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
                    child: widget.iconAnswers
                        ? Icon(
                            yes
                                ? Icons.check_circle_outline
                                : Icons.cancel_outlined,
                            size: 22,
                            semanticLabel: diaryText(
                              context,
                              yes ? 'Sim' : 'Não',
                              yes ? 'Yes' : 'No',
                            ),
                          )
                        : Text(
                            diaryText(
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
              context.l10n.diaryUiThisDayIsReadOnly,
              style: widget.captionStyle ?? AppTypography.caption,
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
