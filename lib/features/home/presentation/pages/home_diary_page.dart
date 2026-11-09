import 'package:flutter/material.dart';
import '../../../../design_system/design_system.dart';
import '../../../../l10n/app_localizations_context.dart';
import '../../../../shared/widgets/day_strip.dart';
import '../../application/home_controller.dart';
import '../../domain/home_models.dart';
import '../widgets/home_account_guard.dart';

class HomeDiaryPage extends StatefulWidget {
  const HomeDiaryPage({required this.controller, super.key});
  final HomeController controller;
  @override
  State<HomeDiaryPage> createState() => _HomeDiaryPageState();
}

class _HomeDiaryPageState extends State<HomeDiaryPage> {
  late int _day = widget.controller.day;
  late DateTime _date = widget.controller.date;
  Future<List<HomeDiaryEvent>>? _future;
  String? _locale;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_locale != context.l10n.localeName) {
      _locale = context.l10n.localeName;
      _reload();
    }
  }

  void _reload() {
    _future = widget.controller.repository.diary(_date, _locale!);
  }

  Future<void> _add() async {
    final saved = await showAppContentSheet<bool>(
      context,
      (_) => HomeAccountGuard(
        controller: widget.controller,
        child: _DiaryEntryForm(controller: widget.controller, date: _date),
      ),
    );
    if (!mounted || saved != true) return;
    setState(_reload);
    AppNotice.show(
      context,
      kind: AppNoticeKind.success,
      message: context.l10n.homeEntrySaved,
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    return Scaffold(
      backgroundColor: AppColors.homeCanvas,
      body: AppDetailBackground(
        child: SafeArea(
          child: Column(
            children: [
              AppDetailHeader(
                title: s.homeDiary,
                onClose: () => Navigator.pop(context),
              ),
              DayStrip(
                day: _day,
                onDayChanged: (day) => setState(() {
                  _day = day;
                  _date = homeDay(widget.controller.now, day);
                  _reload();
                }),
              ),
              Expanded(
                child: FutureBuilder<List<HomeDiaryEvent>>(
                  future: _future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(child: AppLoadingIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: AppButton(
                          label: s.homeRetry,
                          onPressed: () => setState(_reload),
                        ),
                      );
                    }
                    final events = snapshot.data ?? [];
                    return ListView(
                      padding: const EdgeInsets.all(22),
                      children: [
                        Text(s.homeDiaryTitle, style: AppTypography.homeTitle),
                        const SizedBox(height: 12),
                        Text(
                          s.homeDiaryBody,
                          style: AppTypography.body.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 28),
                        if (events.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: Text(
                              s.homeDiaryEmpty,
                              style: AppTypography.body.copyWith(
                                color: AppColors.textMuted,
                              ),
                            ),
                          ),
                        for (final event in events)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: AppGradientCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(event.label, style: AppTypography.title),
                                  if (event.note.isNotEmpty) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      event.note,
                                      style: AppTypography.body.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                  if (event.occurredAt != null) ...[
                                    const SizedBox(height: 12),
                                    Text(
                                      '${event.occurredAt!.toLocal().hour.toString().padLeft(2, '0')}:${event.occurredAt!.toLocal().minute.toString().padLeft(2, '0')}',
                                      style: AppTypography.caption.copyWith(
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(22),
                child: AppButton(
                  label: s.homeAddEntry,
                  expanded: true,
                  onPressed: _add,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DiaryEntryForm extends StatefulWidget {
  const _DiaryEntryForm({required this.controller, required this.date});
  final HomeController controller;
  final DateTime date;
  @override
  State<_DiaryEntryForm> createState() => _DiaryEntryFormState();
}

class _DiaryEntryFormState extends State<_DiaryEntryForm> {
  final _form = GlobalKey<FormState>();
  final _label = TextEditingController(), _note = TextEditingController();
  String _category = 'meal';
  bool _saving = false;
  String? _error;
  @override
  void dispose() {
    _label.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate() || _saving) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await widget.controller.repository.saveDiary(
        widget.date,
        context.l10n.localeName,
        category: _category,
        label: _label.text.trim(),
        note: _note.text.trim(),
      );
      if (mounted) Navigator.pop(context, true);
    } catch (_) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = context.l10n.homeEntryFailed;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final categories = {
      'meal': s.homeMeal,
      'training': s.homeTraining,
      'mood': s.homeMood,
      'caffeine': s.homeCaffeine,
      'custom': s.homeOther,
    };
    return PopScope(
      canPop: !_saving,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          children: [
            AppDetailHeader(
              title: s.homeNewEntry,
              onClose: _saving ? null : () => Navigator.pop(context),
            ),
            Expanded(
              child: Form(
                key: _form,
                child: ListView(
                  padding: const EdgeInsets.all(22),
                  children: [
                    Text(
                      homeDateKey(widget.date),
                      style: AppTypography.kicker.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final entry in categories.entries)
                          ChoiceChip(
                            label: Text(entry.value),
                            selected: _category == entry.key,
                            onSelected: _saving
                                ? null
                                : (_) => setState(() => _category = entry.key),
                          ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      key: const Key('home-diary-label'),
                      controller: _label,
                      enabled: !_saving,
                      maxLength: 80,
                      decoration: InputDecoration(labelText: s.homeEntryLabel),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? s.homeEntryRequired
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      key: const Key('home-diary-note'),
                      controller: _note,
                      enabled: !_saving,
                      maxLength: 500,
                      maxLines: 4,
                      decoration: InputDecoration(labelText: s.homeEntryNote),
                    ),
                    if (_error != null)
                      Text(
                        _error!,
                        style: AppTypography.caption.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: AppButton(
                  label: s.homeSave,
                  expanded: true,
                  loading: _saving,
                  onPressed: _save,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
