import '../../../core/auth/auth_session.dart';
import 'diary_page.dart';
import 'package:flutter/material.dart';
import '../../../design_system/design_system.dart';
import '../../../design_system/tokens/app_diary_style.dart';
import '../../../shared/widgets/app_sheet_controls.dart';
import '../domain/diary_models.dart';
import 'diary_widgets.dart';

class DiaryCatalogSheet extends StatefulWidget {
  const DiaryCatalogSheet({required this.repository, super.key});
  final DiaryRepository repository;
  @override
  State<DiaryCatalogSheet> createState() => _DiaryCatalogSheetState();
}

class _DiaryCatalogSheetState extends State<DiaryCatalogSheet> {
  final _token = AuthSession.instance.accessToken;
  List<DiaryTracker>? _items;
  String _search = '', _group = '';
  bool _dirty = false, _saving = false;
  Object? _error;
  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final items = await widget.repository.catalog();
      if (mounted) setState(() => _items = diaryDisplayCatalog(items));
    } catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await widget.repository.saveCatalog(_items!);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        AppNotice.show(
          context,
          kind: AppNoticeKind.error,
          message: diaryText(
            context,
            'Não foi possível salvar. Tente novamente.',
            'Could not save. Try again.',
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final candidates = _items?.where((e) => e.diaryHabit).toList() ?? [];
    final visible = candidates
        .where(
          (e) =>
              (_group.isEmpty || e.group == _group) &&
              ('${e.label} ${e.prompt}'.toLowerCase().contains(
                _search.toLowerCase(),
              )),
        )
        .toList();
    return Column(
      children: [
        AppSheetHeader(
          title: diaryText(context, 'O que acompanhar', 'What to track'),
        ),
        if (_items == null)
          Expanded(
            child: Center(
              child: _error == null
                  ? const AppLoadingIndicator()
                  : AppGlassPill(
                      label: diaryText(context, 'Tentar novamente', 'Retry'),
                      onPressed: _load,
                    ),
            ),
          )
        else ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
            child: TextField(
              key: const Key('diary-catalog-search'),
              onChanged: (v) => setState(() => _search = v),
              style: AppDiaryStyle.label,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: diaryText(
                  context,
                  'Buscar entre ${candidates.length}',
                  'Search ${candidates.length} behaviors',
                ),
                filled: true,
                fillColor: AppDiaryStyle.surface,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                for (final group in [
                  '',
                  ...candidates.map((e) => e.group).toSet(),
                ])
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      selectedColor: AppColors.glass,
                      backgroundColor: Colors.transparent,
                      showCheckmark: false,
                      side: const BorderSide(color: AppDiaryStyle.line),
                      label: Text(
                        group.isEmpty
                            ? diaryText(context, 'Todos', 'All')
                            : group,
                        style: AppDiaryStyle.caption.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      selected: _group == group,
                      onSelected: (_) => setState(() => _group = group),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: AbsorbPointer(
              absorbing: _saving,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: visible.length + 1,
                itemBuilder: (c, i) {
                  if (i == visible.length) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: AppGlassPill(
                        label: diaryText(
                          c,
                          'Criar o seu hábito',
                          'Create your habit',
                        ),
                        onPressed: () async {
                          final created =
                              await showAppContentSheet<DiaryTracker>(
                                context,
                                glass: true,
                                (_) => DiarySessionGuard(
                                  token: _token,
                                  child: DiaryCustomTrackerSheet(
                                    repository: widget.repository,
                                  ),
                                ),
                              );
                          if (mounted && created != null) {
                            setState(() {
                              _items = [..._items!, created];
                            });
                          }
                        },
                      ),
                    );
                  }
                  final t = visible[i];
                  return DiaryRecordRow(
                    title: t.label,
                    icon: t.icon,
                    subtitle: t.prompt,
                    selected: t.enabled,
                    onTap: () => _toggle(t),
                    onToggle: () => _toggle(t),
                  );
                },
              ),
            ),
          ),
          AppSheetSaveButton(
            label: diaryText(context, 'Salvar', 'Save'),
            loading: _saving,
            onPressed: _dirty ? _save : null,
          ),
        ],
      ],
    );
  }

  void _toggle(DiaryTracker t) {
    if (_saving) return;
    setState(() {
      _items = _items!
          .map((e) => e.key == t.key ? e.enable(!e.enabled) : e)
          .toList();
      _dirty = true;
    });
  }
}

class DiaryCustomTrackerSheet extends StatefulWidget {
  const DiaryCustomTrackerSheet({required this.repository, super.key});
  final DiaryRepository repository;
  @override
  State<DiaryCustomTrackerSheet> createState() =>
      _DiaryCustomTrackerSheetState();
}

class _DiaryCustomTrackerSheetState extends State<DiaryCustomTrackerSheet> {
  final _name = TextEditingController(),
      _unit = TextEditingController(text: 'vezes');
  String _kind = 'boolean';
  bool _saving = false;
  @override
  void dispose() {
    _name.dispose();
    _unit.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving || _name.text.trim().isEmpty) return;
    setState(() => _saving = true);
    try {
      final result = await widget.repository.createTracker(
        _name.text.trim(),
        _kind,
        _kind == 'quantity' ? _unit.text.trim() : '',
      );
      if (mounted) Navigator.pop(context, result);
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        AppNotice.show(
          context,
          kind: AppNoticeKind.error,
          message: diaryText(
            context,
            'Não foi possível criar o hábito. Tente novamente.',
            'Could not create this habit. Try again.',
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
    child: Column(
      children: [
        AppSheetHeader(
          title: diaryText(context, 'Criar o seu hábito', 'Create your habit'),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                diaryText(
                  context,
                  'O que você quer acompanhar?',
                  'What would you like to track?',
                ),
                style: AppDiaryStyle.title,
              ),
              const SizedBox(height: 24),
              TextField(
                key: const Key('diary-custom-name'),
                controller: _name,
                maxLength: 40,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  labelText: diaryText(context, 'Nome do hábito', 'Habit name'),
                  filled: true,
                  fillColor: AppDiaryStyle.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(color: AppDiaryStyle.line),
                  ),
                ),
              ),
              DiarySection(
                diaryText(context, 'Como responder', 'Response type'),
              ),
              for (final kind in ['boolean', 'quantity'])
                DiaryRecordRow(
                  title: kind == 'boolean'
                      ? diaryText(context, 'Sim ou n\u00e3o', 'Yes or no')
                      : diaryText(context, 'Quantidade', 'Quantity'),
                  icon: 'ok',
                  showIcon: false,
                  selected: _kind == kind,
                  onTap: () => setState(() => _kind = kind),
                  onToggle: () => setState(() => _kind = kind),
                ),
              if (_kind == 'quantity')
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: TextField(
                    controller: _unit,
                    maxLength: 24,
                    decoration: InputDecoration(
                      labelText: diaryText(
                        context,
                        'Unidade (ml, min, vezes…)',
                        'Unit (ml, min, times…)',
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        AppSheetSaveButton(
          label: diaryText(context, 'Criar hábito', 'Create habit'),
          loading: _saving,
          onPressed: _name.text.trim().isEmpty ? null : _save,
        ),
      ],
    ),
  );
}
