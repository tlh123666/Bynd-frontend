import '../../../l10n/app_localizations_context.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../core/auth/auth_session.dart';
import '../../../core/network/api_client.dart';
import '../../../design_system/design_system.dart';
import '../../../design_system/tokens/app_diary_style.dart';
import '../../../shared/widgets/app_sheet_controls.dart';
import '../domain/diary_models.dart';
import 'diary_widgets.dart';
import 'diary_page.dart';
import 'diary_catalog_sheet.dart';
import 'diary_moment_editor.dart';
import 'diary_capture_sheet.dart';

class DiaryRecordSheet extends StatefulWidget {
  const DiaryRecordSheet({
    required this.repository,
    required this.day,
    this.embedded = false,
    this.onSaved,
    this.onPendingChanged,
    this.selected,
    this.initialTracker,
    super.key,
  });
  final DiaryRepository repository;
  final DiaryDay day;
  final bool embedded;
  final ValueChanged<DiaryDay>? onSaved;
  final ValueChanged<bool>? onPendingChanged;
  final DiaryMoment? selected;
  final String? initialTracker;
  @override
  State<DiaryRecordSheet> createState() => _DiaryRecordSheetState();
}

class _DiaryRecordSheetState extends State<DiaryRecordSheet> {
  late final List<DiaryMoment> _events = [...widget.day.events];
  late String _note = widget.day.note;
  List<DiaryTracker>? _catalog;
  Object? _error;
  bool _saving = false, _dirty = false;
  bool _openedInitialEditor = false;
  late DiaryDay _base = widget.day;
  String _mutation = diaryId();
  String? _submitted;
  final _token = AuthSession.instance.accessToken;
  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    try {
      final items = await widget.repository.catalog();
      if (!mounted) return;
      setState(() {
        _catalog = diaryDisplayCatalog(items);
        _error = null;
      });
      if (_openedInitialEditor) return;
      _openedInitialEditor = true;
      if (widget.selected != null) {
        await _edit(widget.selected!);
      } else if (widget.initialTracker != null) {
        final t = items
            .where((e) => e.key == widget.initialTracker)
            .firstOrNull;
        if (t != null) await _edit(DiaryMoment.forTracker(t, widget.day.date));
      }
    } catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  Future<T?> _sheet<T>(Widget child, {double height = .936}) =>
      showAppContentSheet<T>(
        context,
        (_) => DiarySessionGuard(token: _token, child: child),
        glass: true,
        heightFactor: height,
      );
  void _mark() {
    _dirty =
        jsonEncode(_events.map((e) => e.json).toList()) !=
            jsonEncode(_base.events.map((e) => e.json).toList()) ||
        _note != _base.note;
    if (widget.embedded) {
      widget.onPendingChanged?.call(_dirty);
      if (_dirty) {
        scheduleMicrotask(() {
          if (mounted) unawaited(_save());
        });
      }
    }
  }

  void _put(DiaryMoment event) {
    setState(() {
      final i = _events.indexWhere((e) => e.id == event.id);
      if (i < 0) {
        _events.add(event);
      } else {
        _events[i] = event;
      }
      _mark();
    });
  }

  Future<void> _edit(DiaryMoment event) async {
    final tracker = _catalog?.where((e) => e.key == event.key).firstOrNull;
    final result = await _sheet<DiaryMoment>(
      DiaryMomentEditor(
        moment: event,
        tracker: tracker,
        repository: widget.repository,
        date: widget.day.date,
        canDelete: _events.any((e) => e.id == event.id),
      ),
      height: event.kind == 'scale' ? .62 : .936,
    );
    if (!mounted || result == null) return;
    if (result.json['deleted'] == true) {
      setState(() {
        _events.removeWhere((e) => e.id == event.id);
        _mark();
      });
    } else {
      _put(
        result.kind == 'quantity' || result.kind == 'meal'
            ? result.copy({
                'details': {...result.details, 'answer': true},
              })
            : result,
      );
    }
  }

  void _answer(DiaryTracker t, bool yes) {
    if (_saving || !widget.day.editable) return;
    final found = _events
        .where((e) => diaryCanonicalKey(e.key) == t.key)
        .firstOrNull;
    if (found != null && found.happened == yes) {
      setState(() {
        _events.removeWhere((e) => diaryCanonicalKey(e.key) == t.key);
        _mark();
      });
    } else if (!yes || t.kind == 'boolean') {
      final event = found ?? DiaryMoment.forTracker(t, widget.day.date);
      _put(
        event.copy({
          'numericValue': null,
          'details': {...event.details, 'answer': yes},
        }),
      );
    } else {
      final event = found ?? DiaryMoment.forTracker(t, widget.day.date);
      unawaited(
        _edit(
          event.copy({
            'details': {...event.details, 'answer': true},
          }),
        ),
      );
    }
  }

  void _toggle(DiaryTracker t) => _answer(t, true);

  Future<void> _reviewDay() async {
    final result = await _sheet<DiaryReviewResult>(
      DiaryDayReviewSheet(
        repository: widget.repository,
        date: widget.day.date,
        catalog: _catalog!
            .where((t) => t.enabled && t.kind == 'scale')
            .toList(),
        events: _events,
        note: _note,
        readOnly: !widget.day.editable,
      ),
    );
    if (!mounted || result == null) return;
    setState(() {
      _events.removeWhere((e) => e.kind == 'scale');
      _events.addAll(result.scores);
      _note = result.note;
      _mark();
    });
  }

  Future<void> _catalogSheet() async {
    await _sheet<void>(DiaryCatalogSheet(repository: widget.repository));
    if (mounted) {
      setState(() => _catalog = null);
      await _load();
    }
  }

  Future<void> _capture({bool voice = false}) async {
    final result = await _sheet<List<DiaryMoment>>(
      DiaryCaptureSheet(
        repository: widget.repository,
        date: widget.day.date,
        startVoice: voice,
      ),
    );
    if (!mounted || result == null) return;
    setState(() {
      _events.addAll(result);
      _mark();
    });
  }

  Future<void> _save() async {
    if (_saving || !_dirty || !widget.day.editable) return;
    final payload = jsonEncode({
      'events': _events.map((e) => e.json).toList(),
      'note': _note,
    });
    if (_submitted != payload) {
      _submitted = payload;
      _mutation = diaryId();
    }
    setState(() => _saving = true);
    try {
      final day = await widget.repository.save(
        _base,
        _events,
        _note,
        _mutation,
      );
      if (!mounted) return;
      if (widget.embedded) {
        setState(() {
          _base = day;
          _dirty = false;
          _saving = false;
          _error = null;
        });
        widget.onPendingChanged?.call(false);
        widget.onSaved?.call(day);
      } else {
        Navigator.pop(context, day);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = e;
      });
      final conflict = e is ApiException && e.code == 'http_409';
      AppNotice.show(
        context,
        kind: AppNoticeKind.error,
        message: conflict
            ? context
                  .l10n
                  .diaryUiThisDayChangedElsewhereCloseAndRefreshBeforeSaving
            : context.l10n.diaryUiCouldNotSaveYourDraftIsStillHere,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final habits =
        _catalog
            ?.where(
              (t) =>
                  t.enabled &&
                  t.kind != 'scale' &&
                  (widget.embedded ? t.diaryHabit : t.key != 'gripe'),
            )
            .toList() ??
        [];
    final scores = _events.where((e) => e.kind == 'scale').toList();
    final editable = widget.day.editable;
    final content = <Widget>[
      Text(
        diaryDate(widget.day.date) == diaryDate(DateTime.now())
            ? context.l10n.diaryUiWhatHappenedToday
            : context.l10n.diaryWhatHappenedOnThisDay,
        style: AppDiaryStyle.title,
      ),
      if (editable) ...[
        const SizedBox(height: 20),
        DiaryCapturePanel(
          onWrite: () => _capture(),
          onSpeak: () => _capture(voice: true),
        ),
      ],
      DiarySection(
        context.l10n.diaryUiYourHabits,
        icon: 'estrela',
        trailing: Text(
          '${habits.where((t) => _events.any((e) => diaryCanonicalKey(e.key) == t.key)).length} ${context.l10n.diaryUiOf} ${habits.length}',
          style: AppDiaryStyle.caption,
        ),
      ),
      Column(
        children: [
          for (final t in habits)
            Padding(padding: const EdgeInsets.only(right: 4), child: _row(t)),
          if (editable)
            Padding(
              padding: EdgeInsets.zero,
              child: DiaryRecordRow(
                title: context.l10n.diaryUiAddHabit,
                icon: 'mais',
                subtitle: context.l10n.diaryChooseCount(
                  _catalog?.where((t) => t.diaryHabit).length ?? 0,
                ),
                onTap: _catalogSheet,
              ),
            ),
        ],
      ),
      DiarySection(context.l10n.diaryUiHowWasYourDay, icon: 'nota'),
      DiaryRecordRow(
        title: _note.isEmpty ? context.l10n.diaryUiHowWasYourDay2 : _note,
        subtitle: scores.isEmpty
            ? context.l10n.diaryUiMoodEnergyStressAndASentence
            : scores
                  .map(
                    (e) =>
                        '${diaryMomentLabel(context, e)} ${diaryMomentValue(context, e)}',
                  )
                  .join(' · '),
        icon: 'nota',
        onTap: _reviewDay,
      ),
      if (!editable)
        Padding(
          padding: const EdgeInsets.only(top: 24),
          child: Text(
            context.l10n.diaryUiThisDayIsClosedYouCanEditUpTo7DaysLater,
            style: AppDiaryStyle.caption,
          ),
        ),
    ];
    final body = _catalog == null
        ? Center(
            child: _error == null
                ? const AppLoadingIndicator()
                : AppGlassPill(
                    label: context.l10n.diaryUiRetry,
                    onPressed: _load,
                  ),
          )
        : SingleChildScrollView(
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    6,
                    widget.embedded ? 40 : 6,
                    6,
                    widget.embedded ? 150 : 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: content
                        .map(
                          (w) => w is DiarySurface || w is DiaryCapturePanel
                              ? w
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                  ),
                                  child: w,
                                ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          );
    return PopScope(
      canPop: !_saving,
      child: Column(
        children: [
          if (!widget.embedded)
            AppSheetHeader(
              title: context.l10n.diaryUiRecord,
              canClose: !_saving,
            ),
          if (widget.embedded && _dirty && _error != null)
            Material(
              color: AppColors.surface,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Text(
                      context
                          .l10n
                          .diaryUiCouldNotSaveYourChangesAreKeptHereRetryOrDiscardToLeave,
                      style: AppDiaryStyle.caption,
                    ),
                    Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        TextButton(
                          onPressed: _save,
                          child: Text(context.l10n.diaryUiRetry),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _events
                                ..clear()
                                ..addAll(_base.events);
                              _note = _base.note;
                              _dirty = false;
                              _error = null;
                            });
                            widget.onPendingChanged?.call(false);
                          },
                          child: Text(context.l10n.diaryUiDiscard),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          if (_saving)
            const LinearProgressIndicator(
              minHeight: 1,
              color: AppColors.textPrimary,
              backgroundColor: Colors.transparent,
            ),
          Expanded(
            child: AbsorbPointer(absorbing: _saving, child: body),
          ),
          if (!widget.embedded)
            AppSheetSaveButton(
              label: context.l10n.diaryUiSave,
              loading: _saving,
              onPressed: _dirty ? _save : null,
            ),
        ],
      ),
    );
  }

  Widget _row(DiaryTracker t) {
    final e = _events
        .where((e) => diaryCanonicalKey(e.key) == t.key)
        .firstOrNull;
    final mealSubtitle = t.kind == 'meal' && e != null
        ? '${e.timeLabel} · ${diaryPortionLabel(context, (e.details['portion'] ?? 'Normal').toString()).toLowerCase()}${e.note.isEmpty ? '' : ', ${e.note.split('\n').first}'}'
        : null;
    return DiaryRecordRow(
      key: ValueKey('diary-tracker-${t.key}'),
      title: diaryTrackerLabel(context, t),
      icon: t.icon,
      subtitle:
          mealSubtitle ??
          (e == null
              ? diaryTrackerPrompt(context, t)
              : !e.happened
              ? context.l10n.diaryUiNo
              : t.kind == 'boolean'
              ? context.l10n.diaryUiYes
              : diaryMomentValue(context, e)),
      selected: e != null && e.happened,
      negative: e != null && !e.happened,
      onNegative: widget.day.editable ? () => _answer(t, false) : null,
      onToggle: widget.day.editable ? () => _toggle(t) : null,
      onTap: !widget.day.editable
          ? null
          : () => t.kind == 'boolean'
                ? _toggle(t)
                : _edit(e ?? DiaryMoment.forTracker(t, widget.day.date)),
    );
  }
}

typedef DiaryReviewResult = ({List<DiaryMoment> scores, String note});

class DiaryDayReviewSheet extends StatefulWidget {
  const DiaryDayReviewSheet({
    required this.repository,
    required this.date,
    required this.catalog,
    required this.events,
    required this.note,
    this.readOnly = false,
    super.key,
  });
  final DiaryRepository repository;
  final DateTime date;
  final List<DiaryTracker> catalog;
  final List<DiaryMoment> events;
  final String note;
  final bool readOnly;
  @override
  State<DiaryDayReviewSheet> createState() => _DiaryDayReviewSheetState();
}

class _DiaryDayReviewSheetState extends State<DiaryDayReviewSheet> {
  final _token = AuthSession.instance.accessToken;
  late final _text = TextEditingController(text: widget.note);
  late final _scores = widget.events.where((e) => e.kind == 'scale').toList();
  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  String _scoreLabel(DiaryTracker t) {
    final moment = _scores
        .where((e) => diaryCanonicalKey(e.key) == t.key)
        .firstOrNull;
    return moment == null
        ? context.l10n.diaryUiAnswer
        : diaryMomentValue(context, moment);
  }

  Future<void> _rate(DiaryTracker t) async {
    final old = _scores
        .where((e) => diaryCanonicalKey(e.key) == t.key)
        .firstOrNull;
    final result = await showAppContentSheet<DiaryMoment>(
      context,
      (_) => DiarySessionGuard(
        token: _token,
        child: DiaryMomentEditor(
          moment: old ?? DiaryMoment.forTracker(t, widget.date),
          tracker: t,
          repository: widget.repository,
          date: widget.date,
        ),
      ),
      glass: true,
      heightFactor: .62,
    );
    if (!mounted || result == null) return;
    setState(() {
      _scores.removeWhere((e) => diaryCanonicalKey(e.key) == t.key);
      if (result.json['deleted'] != true) _scores.add(result);
    });
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      AppSheetHeader(title: context.l10n.diaryUiHowWasYourDay),
      Expanded(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            20,
            20,
            20,
            MediaQuery.viewInsetsOf(context).bottom + 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final t in widget.catalog)
                DiaryRecordRow(
                  key: ValueKey('diary-tracker-${t.key}'),
                  title: diaryTrackerLabel(context, t),
                  icon: t.icon,
                  subtitle: diaryTrackerPrompt(context, t),
                  value: _scoreLabel(t),
                  onTap: widget.readOnly ? null : () => _rate(t),
                ),
              DiarySection(
                context.l10n.diaryUiASentenceAboutYourDay,
                icon: 'nota',
              ),
              TextField(
                key: const Key('diary-note'),
                controller: _text,
                readOnly: widget.readOnly,
                maxLength: 5000,
                minLines: 4,
                maxLines: 8,
                style: AppDiaryStyle.label,
                decoration: InputDecoration(
                  hintText: context.l10n.diaryUiOnlyYouCanSeeThisHowWasYourDay,
                  border: InputBorder.none,
                ),
              ),
            ],
          ),
        ),
      ),
      if (!widget.readOnly)
        AppSheetSaveButton(
          label: context.l10n.diaryUiSave,
          onPressed: () =>
              Navigator.pop(context, (scores: _scores, note: _text.text)),
        ),
    ],
  );
}

class DiaryNoteEditor extends StatefulWidget {
  const DiaryNoteEditor({required this.value, super.key});
  final String value;
  @override
  State<DiaryNoteEditor> createState() => _DiaryNoteEditorState();
}

class _DiaryNoteEditorState extends State<DiaryNoteEditor> {
  late final _text = TextEditingController(text: widget.value);
  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
    child: Column(
      children: [
        AppSheetHeader(title: context.l10n.diaryUiNotes),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              key: const Key('diary-note'),
              controller: _text,
              maxLength: 5000,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              style: AppDiaryStyle.label,
              decoration: InputDecoration(
                hintText: context.l10n.diaryUiOnlyYouCanSeeThisHowWasYourDay,
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        AppSheetSaveButton(
          label: context.l10n.diaryUiDone,
          onPressed: () => Navigator.pop(context, _text.text),
        ),
      ],
    ),
  );
}
