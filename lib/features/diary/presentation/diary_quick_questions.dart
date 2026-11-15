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
    this.ratingKey,
    this.ratingQuestion,
    this.ratingLowLabel,
    this.ratingHighLabel,
    this.onOpenDiary,
    super.key,
  });
  final List<(String, String, String)> questions;
  final TextStyle? bodyStyle, captionStyle, kickerStyle;
  final String keyPrefix;
  final bool iconAnswers;
  final String? ratingKey, ratingQuestion, ratingLowLabel, ratingHighLabel;
  final VoidCallback? onOpenDiary;
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
  double? _ratingChoice(double? value) {
    if (value == null || !value.isFinite || value < 1 || value > 10) {
      return null;
    }
    return const [1.0, 3.0, 5.0, 8.0, 10.0][((value - 1) / 2).floor().clamp(
      0,
      4,
    )];
  }

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

  Future<void> _answer(String key, bool answer, {double? score}) async {
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
      if (existing == null ||
          existing.happened != answer ||
          (score != null && _ratingChoice(existing.value) != score)) {
        final record = existing ?? DiaryMoment.forTracker(tracker, widget.date);
        events.add(
          record.copy({
            'numericValue': score,
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
        Row(
          children: [
            Expanded(
              child: Text(
                context.l10n.diaryUiYourDiary.toUpperCase(),
                style: widget.kickerStyle ?? AppTypography.caption,
              ),
            ),
            if (widget.onOpenDiary != null)
              TextButton(
                onPressed: _busy ? null : widget.onOpenDiary,
                child: Text(context.l10n.diary),
              ),
          ],
        ),
        const SizedBox(height: 14),
        if (_day == null && _error == null)
          const Center(child: AppLoadingIndicator())
        else if (_day == null)
          AppGlassPill(label: context.l10n.diaryUiRetry, onPressed: _load)
        else ...[
          if (widget.ratingKey != null) ...[
            Text(
              widget.ratingQuestion ?? '',
              style: widget.bodyStyle ?? AppTypography.body,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                for (final (index, score) in const [
                  1.0,
                  3.0,
                  5.0,
                  8.0,
                  10.0,
                ].indexed)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: OutlinedButton(
                        key: ValueKey(
                          '${widget.keyPrefix}-rating-${index + 1}',
                        ),
                        onPressed: _busy || !_day!.editable
                            ? null
                            : () => _answer(
                                widget.ratingKey!,
                                true,
                                score: score,
                              ),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 40),
                          backgroundColor:
                              _day!.events.any(
                                (e) =>
                                    e.key == widget.ratingKey &&
                                    e.happened &&
                                    _ratingChoice(e.value) == score,
                              )
                              ? AppColors.glass
                              : Colors.transparent,
                        ),
                        child: Text('${index + 1}'),
                      ),
                    ),
                  ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.ratingLowLabel ?? '',
                  style: widget.captionStyle ?? AppTypography.caption,
                ),
                Text(
                  widget.ratingHighLabel ?? '',
                  style: widget.captionStyle ?? AppTypography.caption,
                ),
              ],
            ),
          ],
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
