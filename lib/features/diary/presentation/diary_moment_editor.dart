import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/auth/auth_session.dart';
import '../../../design_system/design_system.dart';
import '../../../design_system/tokens/app_diary_style.dart';
import '../../../shared/widgets/app_sheet_controls.dart';
import '../domain/diary_models.dart';
import '../domain/diary_media.dart';
import 'diary_widgets.dart';
import 'diary_page.dart';

class DiaryMomentEditor extends StatefulWidget {
  const DiaryMomentEditor({
    required this.moment,
    required this.repository,
    required this.date,
    this.tracker,
    this.canDelete = false,
    super.key,
  });
  final DiaryMoment moment;
  final DiaryTracker? tracker;
  final DiaryRepository repository;
  final DateTime date;
  final bool canDelete;
  @override
  State<DiaryMomentEditor> createState() => _DiaryMomentEditorState();
}

class _DiaryMomentEditorState extends State<DiaryMomentEditor> {
  late double _value = widget.moment.value ?? 5;
  late final _label = TextEditingController(text: widget.moment.label),
      _note = TextEditingController(text: widget.moment.note);
  late final _foods = TextEditingController(
    text: widget.moment.details['foods'] as String? ?? widget.moment.note,
  );
  late final Map<String, TextEditingController> _nutrients = {
    for (final k in ['calories', 'protein', 'carbs', 'fat'])
      k: TextEditingController(text: '${widget.moment.details[k] ?? ''}'),
  };
  late Map<String, dynamic> _details = {...widget.moment.details};
  late TimeOfDay _time = TimeOfDay.fromDateTime(
    widget.moment.time ??
        DateTime(widget.date.year, widget.date.month, widget.date.day, 12),
  );
  bool _uploading = false;
  String? _validation;
  bool get _meal => widget.moment.kind == 'meal';
  @override
  void dispose() {
    _label.dispose();
    _note.dispose();
    _foods.dispose();
    for (final c in _nutrients.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _photo(ImageSource source) async {
    try {
      final picked = await ImagePicker().pickImage(
        source: source,
        maxWidth: 1600,
        maxHeight: 1600,
        imageQuality: 80,
      );
      if (picked == null) return;
      final bytes = await picked.readAsBytes();
      if (bytes.length > 2 * 1024 * 1024) {
        throw StateError('photo exceeds 2MB');
      }
      if (!mounted) return;
      setState(() => _uploading = true);
      final result = await widget.repository.photo(widget.date, bytes);
      if (mounted) setState(() => _details = {..._details, ...result});
    } catch (e) {
      if (mounted) {
        AppNotice.show(
          context,
          kind: AppNoticeKind.error,
          message: diaryText(
            context,
            'Não foi possível adicionar a foto. Use uma imagem JPG/PNG de até 2 MB.',
            'Could not attach the photo. Use a JPG/PNG up to 2 MB.',
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  Future<void> _timePicker() async {
    final result = await showTimePicker(context: context, initialTime: _time);
    if (mounted && result != null) setState(() => _time = result);
  }

  Future<void> _mealTemplate() async {
    final token = AuthSession.instance.accessToken;
    final result = await showAppContentSheet<Map<String, dynamic>>(
      context,
      glass: true,
      (_) =>
          DiarySessionGuard(token: token, child: const DiaryMealSearchSheet()),
    );
    if (!mounted || result == null) return;
    setState(() {
      _foods.text = (result['it'] as List)
          .map((e) => (e as List).join(' · '))
          .join('\n');
      _details['illustration'] = result['key'];
      for (final k in {'protein': 'p', 'carbs': 'c', 'fat': 'g'}.entries) {
        _nutrients[k.key]!.text = '${result[k.value]}';
      }
      _nutrients['calories']!.text =
          '${((result['p'] as num) * 4 + (result['c'] as num) * 4 + (result['g'] as num) * 9).round()}';
    });
  }

  void _save() {
    if (_label.text.trim().isEmpty) {
      setState(
        () => _validation = diaryText(
          context,
          'Informe o nome.',
          'Enter a name.',
        ),
      );
      return;
    }
    final details = {..._details};
    if (_meal) {
      details['foods'] = _foods.text;
      for (final entry in _nutrients.entries) {
        if (entry.value.text.trim().isEmpty) {
          details.remove(entry.key);
          continue;
        }
        final v = double.tryParse(entry.value.text.replaceAll(',', '.'));
        if (v == null || !v.isFinite || v < 0 || v > 100000) {
          setState(
            () => _validation = diaryText(
              context,
              'Confira os valores nutricionais.',
              'Check the nutrition values.',
            ),
          );
          return;
        }
        details[entry.key] = v;
      }
    }
    final at = DateTime(
      widget.date.year,
      widget.date.month,
      widget.date.day,
      _time.hour,
      _time.minute,
    );
    Navigator.pop(
      context,
      widget.moment.copy({
        'label': _label.text.trim(),
        'note': _meal
            ? _foods.text.characters.take(500).toString()
            : _note.text,
        'occurredAt': at.toIso8601String(),
        'details': details,
        if (widget.moment.kind == 'scale' ||
            (widget.moment.kind == 'quantity' &&
                (widget.tracker?.timeValues.isEmpty ?? true)))
          'numericValue': _value,
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final kind = widget.moment.kind;
    final labels = widget.tracker?.scaleLabels ?? [];
    final scoreLabel = labels.isEmpty
        ? ''
        : labels[((_value - 1) / 2).floor().clamp(0, labels.length - 1)];
    final times = widget.tracker?.timeValues ?? <String>[];
    final numeric = widget.tracker?.values ?? <double>[];
    final values = numeric.isEmpty
        ? List.generate(100, (i) => (i + 1).toDouble())
        : numeric;
    final photo = '${_details['photoUrl'] ?? ''}';
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Column(
        children: [
          AppSheetHeader(
            title: widget.moment.label,
            trailing: widget.canDelete
                ? IconButton(
                    tooltip: diaryText(
                      context,
                      'Excluir registro',
                      'Delete entry',
                    ),
                    onPressed: _uploading
                        ? null
                        : () => Navigator.pop(
                            context,
                            widget.moment.copy({'deleted': true}),
                          ),
                    icon: const Icon(Icons.delete_outline, size: 21),
                  )
                : null,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 16),
              children: [
                if (kind == 'scale') ...[
                  Text(
                    widget.tracker?.prompt ?? widget.moment.label,
                    style: AppDiaryStyle.title,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    DiaryMoment.number(_value),
                    textAlign: TextAlign.center,
                    style: AppTypography.hero.copyWith(fontSize: 64),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    scoreLabel.toUpperCase(),
                    style: AppDiaryStyle.caption,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Slider(
                    min: 1,
                    max: 10,
                    divisions: 9,
                    value: _value.clamp(1, 10),
                    activeColor: AppColors.textPrimary,
                    inactiveColor: AppDiaryStyle.line,
                    label: DiaryMoment.number(_value),
                    onChanged: (v) => setState(() => _value = v),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        labels.firstOrNull ?? '1',
                        style: AppDiaryStyle.caption,
                      ),
                      Text(
                        labels.lastOrNull ?? '10',
                        style: AppDiaryStyle.caption,
                      ),
                    ],
                  ),
                ] else if (kind == 'quantity' && times.isNotEmpty) ...[
                  Text(
                    widget.tracker?.prompt ?? widget.moment.label,
                    style: AppDiaryStyle.title,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 240,
                    child: CupertinoPicker(
                      itemExtent: 48,
                      onSelectedItemChanged: (i) {
                        final h = times[i].split(':');
                        setState(
                          () => _time = TimeOfDay(
                            hour: int.parse(h[0]),
                            minute: int.parse(h[1]),
                          ),
                        );
                      },
                      children: times
                          .map(
                            (v) => Center(
                              child: Text(
                                v,
                                style: AppDiaryStyle.section.copyWith(
                                  fontSize: 27,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ] else if (kind == 'quantity') ...[
                  Text(
                    widget.tracker?.prompt ?? widget.moment.label,
                    style: AppDiaryStyle.title,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 240,
                    child: CupertinoPicker(
                      scrollController: FixedExtentScrollController(
                        initialItem: values
                            .indexOf(_value)
                            .clamp(0, values.length - 1),
                      ),
                      itemExtent: 48,
                      onSelectedItemChanged: (i) =>
                          setState(() => _value = values[i]),
                      children: [
                        for (final v in values)
                          Center(
                            child: Text(
                              '${DiaryMoment.number(v)} ${widget.moment.unit}',
                              style: AppDiaryStyle.section.copyWith(
                                fontSize: 27,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ] else if (_meal) ...[
                  if (DiaryMedia.meals.contains(_details['illustration']))
                    Center(
                      child: ClipRRect(
                        borderRadius: AppDiaryStyle.radius,
                        child: Image.asset(
                          'assets/images/diary/${_details['illustration']}.png',
                          width: 150,
                          height: 150,
                        ),
                      ),
                    ),
                  Text(
                    diaryText(
                      context,
                      'O que você comeu?',
                      'What did you eat?',
                    ),
                    style: AppDiaryStyle.title,
                  ),
                  const SizedBox(height: 16),
                  AppGlassPill(
                    label: diaryText(context, 'Buscar refeição', 'Find a meal'),
                    onPressed: _mealTemplate,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _foods,
                    maxLines: 4,
                    maxLength: 1000,
                    style: AppDiaryStyle.label,
                    decoration: InputDecoration(
                      labelText: diaryText(
                        context,
                        'Alimentos e quantidades',
                        'Foods and amounts',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      for (final portion in ['Leve', 'Normal', 'Pesado'])
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: ChoiceChip(
                              selectedColor: AppColors.glass,
                              backgroundColor: Colors.transparent,
                              showCheckmark: false,
                              side: const BorderSide(color: AppDiaryStyle.line),
                              label: Text(portion),
                              selected:
                                  (_details['portion'] ?? 'Normal') == portion,
                              onSelected: (_) =>
                                  setState(() => _details['portion'] = portion),
                            ),
                          ),
                        ),
                    ],
                  ),
                  DiarySection(
                    diaryText(context, 'Informações nutricionais', 'Nutrition'),
                  ),
                  Text(
                    diaryText(
                      context,
                      'Valores informados por você ou pela refeição escolhida. Ajuste conforme a porção.',
                      'Values entered by you or from the selected meal. Adjust for your portion.',
                    ),
                    style: AppDiaryStyle.caption,
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 16,
                    children: [
                      for (final entry in _nutrients.entries)
                        SizedBox(
                          width: (MediaQuery.sizeOf(context).width - 52) / 2,
                          child: TextField(
                            controller: entry.value,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: InputDecoration(
                              labelText: switch (entry.key) {
                                'calories' => 'kcal',
                                'protein' => diaryText(
                                  context,
                                  'Proteína (g)',
                                  'Protein (g)',
                                ),
                                'carbs' => diaryText(
                                  context,
                                  'Carboidratos (g)',
                                  'Carbs (g)',
                                ),
                                _ => diaryText(
                                  context,
                                  'Gordura (g)',
                                  'Fat (g)',
                                ),
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (photo.isNotEmpty) ...[
                    ClipRRect(
                      borderRadius: AppDiaryStyle.radius,
                      child: photo.startsWith('data:')
                          ? Image.memory(
                              base64Decode(photo.split(',').last),
                              height: 180,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              photo,
                              height: 180,
                              fit: BoxFit.cover,
                              errorBuilder: (_, e, s) => const SizedBox(
                                height: 40,
                                child: Icon(Icons.broken_image_outlined),
                              ),
                            ),
                    ),
                    TextButton(
                      onPressed: () => setState(() {
                        _details.remove('photoUrl');
                        _details.remove('photoKey');
                      }),
                      child: Text(
                        diaryText(context, 'Remover foto', 'Remove photo'),
                      ),
                    ),
                  ],
                  if (_uploading)
                    const Center(child: AppLoadingIndicator())
                  else
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        AppGlassPill(
                          label: diaryText(
                            context,
                            'Tirar foto',
                            'Take a photo',
                          ),
                          onPressed: () => _photo(ImageSource.camera),
                        ),
                        AppGlassPill(
                          label: diaryText(context, 'Galeria', 'Gallery'),
                          onPressed: () => _photo(ImageSource.gallery),
                        ),
                      ],
                    ),
                ] else ...[
                  TextField(
                    controller: _label,
                    maxLength: 80,
                    decoration: InputDecoration(
                      labelText: diaryText(context, 'Registro', 'Entry'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _note,
                    maxLength: 500,
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: diaryText(context, 'Detalhes', 'Details'),
                    ),
                  ),
                ],
                if (kind != 'scale') ...[
                  const SizedBox(height: 20),
                  DiaryRecordRow(
                    title: diaryText(context, 'Horário', 'Time'),
                    icon: 'relo',
                    value: _time.format(context),
                    onTap: _timePicker,
                  ),
                ],
                if (_validation != null)
                  Text(
                    _validation!,
                    style: AppDiaryStyle.caption.copyWith(
                      color: AppColors.error,
                    ),
                  ),
              ],
            ),
          ),
          AppSheetSaveButton(
            label: diaryText(context, 'Concluir', 'Done'),
            loading: _uploading,
            onPressed: _uploading ? null : _save,
          ),
        ],
      ),
    );
  }
}

class DiaryMealSearchSheet extends StatefulWidget {
  const DiaryMealSearchSheet({super.key});
  @override
  State<DiaryMealSearchSheet> createState() => _DiaryMealSearchSheetState();
}

class _DiaryMealSearchSheetState extends State<DiaryMealSearchSheet> {
  late final Future<List<dynamic>> _data = rootBundle
      .loadString('assets/data/diary-meals.json')
      .then((v) => jsonDecode(v) as List);
  String _search = '';
  @override
  Widget build(BuildContext context) => Column(
    children: [
      AppSheetHeader(
        title: diaryText(context, 'Buscar refeição', 'Find a meal'),
      ),
      Padding(
        padding: const EdgeInsets.all(20),
        child: TextField(
          onChanged: (v) => setState(() => _search = v.toLowerCase()),
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            hintText: diaryText(context, 'Buscar alimentos', 'Search foods'),
          ),
        ),
      ),
      Expanded(
        child: FutureBuilder<List<dynamic>>(
          future: _data,
          builder: (c, s) {
            if (!s.hasData) return const Center(child: AppLoadingIndicator());
            final items = s.data!
                .cast<Map>()
                .where((m) => '${m['it']}'.toLowerCase().contains(_search))
                .toList();
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (c, i) {
                final m = items[i];
                final title = (m['it'] as List)
                    .map((v) => (v as List).first)
                    .join(', ');
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/images/diary/${m['key']}.png',
                      width: 62,
                      height: 62,
                    ),
                  ),
                  title: Text(title, style: AppDiaryStyle.label),
                  subtitle: Text(
                    'P ${m['p']} g · C ${m['c']} g · G ${m['g']} g',
                    style: AppDiaryStyle.caption,
                  ),
                  onTap: () =>
                      Navigator.pop(context, Map<String, dynamic>.from(m)),
                );
              },
            );
          },
        ),
      ),
    ],
  );
}
