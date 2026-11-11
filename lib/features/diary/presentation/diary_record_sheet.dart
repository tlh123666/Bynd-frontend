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
    this.selected,
    this.initialTracker,
    super.key,
  });
  final DiaryRepository repository;
  final DiaryDay day;
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
        _catalog = items;
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
            jsonEncode(widget.day.events.map((e) => e.json).toList()) ||
        _note != widget.day.note;
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
      _put(result);
    }
  }

  void _toggle(DiaryTracker t) {
    final found = _events.where((e) => e.key == t.key).firstOrNull;
    if (found != null) {
      setState(() {
        _events.removeWhere((e) => e.key == t.key);
        _mark();
      });
    } else if (t.kind == 'boolean') {
      _put(DiaryMoment.forTracker(t, widget.day.date));
    } else {
      unawaited(_edit(DiaryMoment.forTracker(t, widget.day.date)));
    }
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

  Future<void> _editNote() async {
    final note = await _sheet<String>(DiaryNoteEditor(value: _note));
    if (mounted && note != null) {
      setState(() {
        _note = note;
        _mark();
      });
    }
  }

  Future<void> _save() async {
    if (_saving || !_dirty) return;
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
        widget.day,
        _events,
        _note,
        _mutation,
      );
      if (mounted) Navigator.pop(context, day);
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      final conflict = e is ApiException && e.code == 'http_409';
      AppNotice.show(
        context,
        kind: AppNoticeKind.error,
        message: conflict
            ? diaryText(
                context,
                'Este dia foi alterado em outro lugar. Feche e atualize antes de salvar.',
                'This day changed elsewhere. Close and refresh before saving.',
              )
            : diaryText(
                context,
                'Não foi possível salvar. Seu rascunho continua aqui.',
                'Could not save. Your draft is still here.',
              ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final habits =
        _catalog
            ?.where((e) => e.enabled && e.kind != 'scale' && e.key != 'gripe')
            .toList() ??
        [];
    // Meals lead the source's record screen, then the user's selected behaviors.
    habits.sort((a, b) => (a.meal ? 0 : 1).compareTo(b.meal ? 0 : 1));
    return PopScope(
      canPop: !_saving,
      child: Column(
        children: [
          AppSheetHeader(
            title: diaryText(context, 'Registrar', 'Record'),
            canClose: !_saving,
            trailing: PopupMenuButton<String>(
              tooltip: diaryText(context, 'Mais opções', 'More options'),
              icon: const Icon(Icons.more_horiz, size: 24),
              onSelected: (v) {
                if (v == 'catalog') {
                  _catalogSheet();
                } else if (v == 'custom') {
                  _sheet<DiaryTracker>(
                    DiaryCustomTrackerSheet(repository: widget.repository),
                  ).then((v) {
                    if (mounted && v != null) unawaited(_load());
                  });
                } else {
                  _capture();
                }
              },
              itemBuilder: (c) => [
                PopupMenuItem(
                  value: 'catalog',
                  child: Text(
                    diaryText(c, 'O que acompanhar', 'What to track'),
                  ),
                ),
                PopupMenuItem(
                  value: 'custom',
                  child: Text(
                    diaryText(c, 'Criar o seu hábito', 'Create your habit'),
                  ),
                ),
                PopupMenuItem(
                  value: 'ai',
                  child: Text(
                    diaryText(c, 'Registrar com a IA', 'Record with AI'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: AbsorbPointer(
              absorbing: _saving,
              child: _catalog == null
                  ? Center(
                      child: _error == null
                          ? const AppLoadingIndicator()
                          : AppGlassPill(
                              label: diaryText(
                                context,
                                'Tentar novamente',
                                'Retry',
                              ),
                              onPressed: _load,
                            ),
                    )
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(6, 6, 6, 24),
                      children:
                          [
                                Text(
                                  diaryText(
                                    context,
                                    'O que aconteceu ${diaryDate(widget.day.date) == diaryDate(DateTime.now()) ? 'hoje' : 'neste dia'}?',
                                    'What happened on this day?',
                                  ),
                                  style: AppDiaryStyle.title,
                                ),
                                const SizedBox(height: 20),
                                DiaryCapturePanel(
                                  onWrite: () => _capture(),
                                  onSpeak: () => _capture(voice: true),
                                ),
                                DiarySection(
                                  diaryText(
                                    context,
                                    'Comportamentos',
                                    'Behaviors',
                                  ),
                                  icon: 'ok',
                                  trailing: Text(
                                    '${habits.where((t) => _events.any((e) => e.key == t.key)).length} ${diaryText(context, 'de', 'of')} ${habits.length}',
                                    style: AppDiaryStyle.caption,
                                  ),
                                ),
                                Column(
                                  children: [for (final t in habits) _row(t)],
                                ),
                                const SizedBox(height: 12),
                                DiarySurface(
                                  child: DiaryRecordRow(
                                    title: diaryText(
                                      context,
                                      'Adicionar comportamentos',
                                      'Add behaviors',
                                    ),
                                    icon: 'mais',
                                    subtitle: diaryText(
                                      context,
                                      'Escolha entre ${_catalog!.where((e) => !e.meal && e.key != 'gripe').length}',
                                      'Choose from ${_catalog!.length}',
                                    ),
                                    onTap: _catalogSheet,
                                  ),
                                ),
                                DiarySection(
                                  diaryText(
                                    context,
                                    'Como você está',
                                    'How you feel',
                                  ),
                                ),
                                Column(
                                  children: [
                                    for (final t in _catalog!.where(
                                      (e) => e.enabled && e.kind == 'scale',
                                    ))
                                      _row(t),
                                  ],
                                ),
                                DiarySection(
                                  diaryText(context, 'Notas', 'Notes'),
                                ),
                                DiarySurface(
                                  child: DiaryRecordRow(
                                    title: _note.isEmpty
                                        ? diaryText(
                                            context,
                                            'Escreva sobre o seu dia',
                                            'Write about your day',
                                          )
                                        : _note,
                                    icon: 'nota',
                                    subtitle: diaryText(
                                      context,
                                      'Só você vê',
                                      'Only you can see this',
                                    ),
                                    onTap: _editNote,
                                  ),
                                ),
                                if (_events.any(
                                  (e) => !_catalog!.any((t) => t.key == e.key),
                                )) ...[
                                  DiarySection(
                                    diaryText(
                                      context,
                                      'Outros registros',
                                      'Other entries',
                                    ),
                                  ),
                                  for (final e in _events.where(
                                    (e) =>
                                        !_catalog!.any((t) => t.key == e.key),
                                  ))
                                    DiaryRecordRow(
                                      title: e.label,
                                      icon: e.icon,
                                      subtitle: e.valueLabel,
                                      onTap: () => _edit(e),
                                    ),
                                ],
                              ]
                              .map(
                                (child) => child is DiaryCapturePanel
                                    ? child
                                    : Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                        ),
                                        child: child,
                                      ),
                              )
                              .toList(),
                    ),
            ),
          ),
          AppSheetSaveButton(
            label: diaryText(context, 'Salvar', 'Save'),
            loading: _saving,
            onPressed: _dirty ? _save : null,
          ),
        ],
      ),
    );
  }

  Widget _row(DiaryTracker t) {
    final e = _events.where((e) => e.key == t.key).firstOrNull;
    final mealSubtitle = t.kind == 'meal' && e != null
        ? '${e.timeLabel} · ${(e.details['portion'] ?? 'Normal').toString().toLowerCase()}${e.note.isEmpty ? '' : ', ${e.note.split('\n').first}'}'
        : null;
    return DiaryRecordRow(
      key: ValueKey('diary-tracker-${t.key}'),
      title: t.label,
      icon: t.icon,
      subtitle: mealSubtitle ?? e?.valueLabel ?? t.prompt,
      selected: e != null,
      onToggle: () => _toggle(t),
      onTap: () => t.kind == 'boolean'
          ? _toggle(t)
          : _edit(e ?? DiaryMoment.forTracker(t, widget.day.date)),
    );
  }
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
        AppSheetHeader(title: diaryText(context, 'Notas', 'Notes')),
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
                hintText: diaryText(
                  context,
                  'Só você vê. Como foi seu dia?',
                  'Only you can see this. How was your day?',
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        AppSheetSaveButton(
          label: diaryText(context, 'Concluir', 'Done'),
          onPressed: () => Navigator.pop(context, _text.text),
        ),
      ],
    ),
  );
}
