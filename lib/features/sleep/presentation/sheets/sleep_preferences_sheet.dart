import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../design_system/design_system.dart';
import '../../../../shared/widgets/app_sheet_controls.dart';
import '../../application/sleep_controller.dart';
import '../../application/sleep_reminders.dart';
import '../../data/demo_sleep_repository.dart';
import '../../domain/sleep_models.dart';
import '../sleep_copy.dart';
import '../widgets/sleep_widgets.dart';

class SleepPreferencesSheet extends StatefulWidget {
  const SleepPreferencesSheet({
    required this.controller,
    this.planner = false,
    super.key,
  });
  final SleepController controller;
  final bool planner;
  @override
  State<SleepPreferencesSheet> createState() => _SleepPreferencesSheetState();
}

class _SleepPreferencesSheetState extends State<SleepPreferencesSheet> {
  late SleepPreferences _preferences = widget.controller.snapshot!.preferences;
  bool _saving = false;
  String? _error;
  List<Map<String, dynamic>>? _plans;
  Object? _planError;
  @override
  void initState() {
    super.initState();
    if (widget.planner) _loadPlans();
  }

  Future<void> _loadPlans() async {
    setState(() => _planError = null);
    try {
      final rows = await widget.controller.repository.plans();
      if (mounted) setState(() => _plans = rows);
    } catch (e) {
      if (mounted) setState(() => _planError = e);
    }
  }

  Future<void> _time(bool bedtime) async {
    final minute = await showAppContentSheet<int>(
      context,
      (_) => _SleepTimePicker(
        initial: bedtime ? _preferences.bedtime : _preferences.wake,
        title: sleepText(
          context,
          bedtime ? 'Deitar' : 'Acordar',
          bedtime ? 'Bedtime' : 'Wake time',
        ),
      ),
      glass: true,
      heightFactor: .55,
    );
    if (mounted && minute != null) {
      setState(
        () => _preferences = _preferences.copy({
          if (bedtime) ...{
            'targetBedtimeHour': minute ~/ 60,
            'targetBedtimeMinute': minute % 60,
          } else ...{
            'targetWakeHour': minute ~/ 60,
            'targetWakeMinute': minute % 60,
          },
        }),
      );
    }
  }

  Future<void> _save() async {
    if (_saving) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    final saved = await widget.controller.savePreferences(_preferences);
    if (!mounted) return;
    if (saved) {
      Navigator.pop(context);
    } else {
      setState(() {
        _saving = false;
        _error = sleepText(
          context,
          'Não foi possível salvar. Suas escolhas continuam aqui.',
          'Could not save. Your changes are kept here.',
        );
      });
    }
  }

  Future<void> _plan([Map<String, dynamic>? plan]) async {
    await showAppContentSheet<void>(
      context,
      (_) => SleepReminderEditor(
        repository: widget.controller.repository,
        preference: _preferences,
        plan: plan,
      ),
      glass: true,
    );
    if (mounted) await _loadPlans();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.controller.snapshot!.unavailable.contains('preferences')) {
      return Column(
        children: [
          AppSheetHeader(
            title: sleepText(context, 'Ajustes do sono', 'Sleep settings'),
          ),
          Expanded(
            child: Center(
              child: Text(
                sleepText(
                  context,
                  'Os ajustes não puderam ser carregados. Atualize a página e tente novamente.',
                  'Settings could not be loaded. Refresh the page and try again.',
                ),
                style: AppSleepStyle.body,
              ),
            ),
          ),
        ],
      );
    }
    return PopScope(
      canPop: !_saving,
      child: Column(
        children: [
          AppSheetHeader(
            title: sleepText(
              context,
              widget.planner ? 'Planejador de sono' : 'Ajustes do sono',
              widget.planner ? 'Sleep planner' : 'Sleep settings',
            ),
            canClose: !_saving,
          ),
          Expanded(
            child: AbsorbPointer(
              absorbing: _saving,
              child: ListView(
                padding: const EdgeInsets.all(22),
                children: [
                  Text(
                    sleepText(
                      context,
                      'Seu ritmo para a noite',
                      'Your night-time rhythm',
                    ),
                    style: AppSleepStyle.title,
                  ),
                  const SizedBox(height: 22),
                  if (widget.planner)
                    CustomPaint(
                      size: const Size(280, 150),
                      painter: SleepClockPainter(
                        _preferences.bedtime,
                        _preferences.wake,
                      ),
                    ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      sleepText(context, 'Deitar', 'Bedtime'),
                      style: AppSleepStyle.body,
                    ),
                    trailing: Text(
                      sleepClock(_preferences.bedtime),
                      style: AppSleepStyle.value,
                    ),
                    onTap: () => _time(true),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      sleepText(context, 'Acordar', 'Wake time'),
                      style: AppSleepStyle.body,
                    ),
                    trailing: Text(
                      sleepClock(_preferences.wake),
                      style: AppSleepStyle.value,
                    ),
                    onTap: () => _time(false),
                  ),
                  const SizedBox(height: 22),
                  SleepLabel(sleepText(context, 'Meta de sono', 'Sleep goal')),
                  const SizedBox(height: 12),
                  Text(
                    sleepDuration(_preferences.target),
                    style: AppSleepStyle.value,
                  ),
                  Slider(
                    key: const Key('sleep-target'),
                    value: _preferences.target.toDouble().clamp(360, 600),
                    min: 360,
                    max: 600,
                    divisions: 8,
                    activeColor: AppColors.textPrimary,
                    inactiveColor: AppColors.glassBorder,
                    label: sleepDuration(_preferences.target),
                    onChanged: (v) => setState(
                      () => _preferences = _preferences.copy({
                        'targetSleepMinutes': v.round(),
                      }),
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      sleepText(
                        context,
                        'Desacelerar antes de dormir',
                        'Wind down before bed',
                      ),
                      style: AppSleepStyle.body,
                    ),
                    trailing: DropdownButton<int>(
                      value: _preferences.windDown,
                      dropdownColor: AppColors.surface,
                      items:
                          {
                                0,
                                15,
                                30,
                                45,
                                60,
                                90,
                                120,
                                180,
                                _preferences.windDown,
                              }
                              .map(
                                (n) => DropdownMenuItem(
                                  value: n,
                                  child: Text(
                                    '$n min',
                                    style: AppSleepStyle.caption,
                                  ),
                                ),
                              )
                              .toList(),
                      onChanged: (v) {
                        if (v != null) {
                          setState(
                            () => _preferences = _preferences.copy({
                              'windDownMinutes': v,
                            }),
                          );
                        }
                      },
                    ),
                  ),
                  if (!widget.planner) ...[
                    const SizedBox(height: 24),
                    Text(
                      sleepText(context, 'O que mostrar', 'What to show'),
                      style: AppSleepStyle.title,
                    ),
                    for (final row in [
                      ('showStages', 'Fases do sono', 'Sleep stages'),
                      (
                        'showBiologicalClock',
                        'Relógio biológico',
                        'Sleep schedule',
                      ),
                      (
                        'showRespiration',
                        'Respiração e oxigênio',
                        'Breathing and oxygen',
                      ),
                    ])
                      SwitchListTile.adaptive(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          sleepText(context, row.$2, row.$3),
                          style: AppSleepStyle.body,
                        ),
                        value: _preferences.show(row.$1),
                        activeTrackColor: AppColors.textPrimary,
                        activeThumbColor: AppColors.homeCanvas,
                        onChanged: (v) => setState(
                          () => _preferences = _preferences.copy({row.$1: v}),
                        ),
                      ),
                  ],
                  if (widget.planner) ...[
                    const SizedBox(height: 30),
                    Text(
                      sleepText(
                        context,
                        'Lembretes para deitar',
                        'Bedtime reminders',
                      ),
                      style: AppSleepStyle.title,
                    ),
                    const SizedBox(height: 14),
                    if (_planError != null)
                      AppGlassPill(
                        label: sleepText(context, 'Tentar novamente', 'Retry'),
                        onPressed: _loadPlans,
                      )
                    else if (_plans == null)
                      const Center(child: AppLoadingIndicator())
                    else ...[
                      for (final plan in _plans!)
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(
                            plan['enabled'] == true
                                ? Icons.notifications_active_outlined
                                : Icons.notifications_off_outlined,
                            color: AppColors.textMuted,
                          ),
                          title: Text(
                            sleepClock(
                              ((plan['bedtimeHour'] as num?)?.toInt() ?? 0) *
                                      60 +
                                  ((plan['bedtimeMinute'] as num?)?.toInt() ??
                                      0),
                            ),
                            style: AppSleepStyle.value,
                          ),
                          subtitle: Text(
                            sleepText(
                              context,
                              plan['enabled'] == true
                                  ? 'Ativado'
                                  : 'Desativado',
                              plan['enabled'] == true ? 'Enabled' : 'Disabled',
                            ),
                            style: AppSleepStyle.caption,
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => _plan(plan),
                        ),
                      if (_plans!.length < 5)
                        TextButton.icon(
                          onPressed: () => _plan(),
                          icon: const Icon(Icons.add),
                          label: Text(
                            sleepText(
                              context,
                              'Adicionar lembrete',
                              'Add reminder',
                            ),
                          ),
                        ),
                    ],
                  ],
                  if (_error != null)
                    Text(
                      _error!,
                      style: AppSleepStyle.body.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                ],
              ),
            ),
          ),
          AppSheetSaveButton(
            label: sleepText(context, 'Salvar', 'Save'),
            loading: _saving,
            onPressed: _save,
          ),
        ],
      ),
    );
  }
}

class _SleepTimePicker extends StatefulWidget {
  const _SleepTimePicker({required this.initial, required this.title});
  final int initial;
  final String title;
  @override
  State<_SleepTimePicker> createState() => _SleepTimePickerState();
}

class _SleepTimePickerState extends State<_SleepTimePicker> {
  late int _hour = widget.initial ~/ 60, _minute = widget.initial % 60;
  late final _hours = FixedExtentScrollController(initialItem: _hour);
  late final _minutes = FixedExtentScrollController(initialItem: _minute);
  @override
  void dispose() {
    _hours.dispose();
    _minutes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      AppSheetHeader(title: widget.title),
      Expanded(
        child: Row(
          children: [
            Expanded(
              child: CupertinoPicker(
                scrollController: _hours,
                itemExtent: 44,
                onSelectedItemChanged: (v) => _hour = v,
                children: [
                  for (var i = 0; i < 24; i++)
                    Center(
                      child: Text(
                        i.toString().padLeft(2, '0'),
                        style: AppSleepStyle.value,
                      ),
                    ),
                ],
              ),
            ),
            Text(':', style: AppSleepStyle.value),
            Expanded(
              child: CupertinoPicker(
                scrollController: _minutes,
                itemExtent: 44,
                onSelectedItemChanged: (v) => _minute = v,
                children: [
                  for (var i = 0; i < 60; i++)
                    Center(
                      child: Text(
                        i.toString().padLeft(2, '0'),
                        style: AppSleepStyle.value,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      AppSheetSaveButton(
        label: sleepText(context, 'Salvar', 'Save'),
        onPressed: () => Navigator.pop(context, _hour * 60 + _minute),
      ),
    ],
  );
}

class SleepReminderEditor extends StatefulWidget {
  const SleepReminderEditor({
    required this.repository,
    required this.preference,
    this.plan,
    super.key,
  });
  final SleepRepository repository;
  final SleepPreferences preference;
  final Map<String, dynamic>? plan;
  @override
  State<SleepReminderEditor> createState() => _SleepReminderEditorState();
}

class _SleepReminderEditorState extends State<SleepReminderEditor> {
  late int _bedtime = widget.plan == null
      ? widget.preference.bedtime
      : (widget.plan!['bedtimeHour'] as num).toInt() * 60 +
            (widget.plan!['bedtimeMinute'] as num).toInt();
  late int _week = (widget.plan?['week'] as num?)?.toInt() ?? 127;
  late int _lead =
      (widget.plan?['remindBeforeMinutes'] as num?)?.toInt() ??
      widget.preference.windDown;
  late bool _enabled = widget.plan?['enabled'] != false;
  bool _saving = false;
  String? _error;
  Future<void> _save() async {
    if (_saving || _week == 0) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final portuguese = Localizations.localeOf(context).languageCode == 'pt';
      final native =
          widget.repository is! DemoSleepRepository &&
          SleepReminders.instance.supported;
      final allowed = !_enabled || !native
          ? false
          : await SleepReminders.instance.requestPermission();
      await widget.repository.savePlan({
        ...?widget.plan,
        'enabled': _enabled,
        'bedtimeHour': _bedtime ~/ 60,
        'bedtimeMinute': _bedtime % 60,
        'remindBeforeMinutes': _lead,
        'week': _week,
        'timezone': widget.preference.timezone,
      });
      if (!mounted) return;
      if (native) {
        try {
          await SleepReminders.instance.apply(
            await widget.repository.plans(),
            portuguese: portuguese,
          );
        } catch (_) {
          if (mounted) {
            AppNotice.show(
              context,
              kind: AppNoticeKind.warning,
              message: sleepText(
                context,
                'Lembrete salvo. Não foi possível programar a notificação neste aparelho.',
                'Reminder saved. This device could not schedule the notification.',
              ),
            );
          }
        }
      }
      if (!mounted) return;
      if (_enabled && !allowed && widget.repository is! DemoSleepRepository) {
        AppNotice.show(
          context,
          kind: AppNoticeKind.info,
          message: sleepText(
            context,
            'Lembrete salvo. Ative as notificações no aplicativo do celular para recebê-lo.',
            'Reminder saved. Enable notifications in the mobile app to receive it.',
          ),
        );
      }
      Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = sleepText(
            context,
            'Não foi possível salvar o lembrete.',
            'Could not save the reminder.',
          );
        });
      }
    }
  }

  Future<void> _delete() async {
    final confirmed = await AppConfirmationSheet.show(
      context,
      title: sleepText(context, 'Excluir lembrete?', 'Delete reminder?'),
      message: sleepText(
        context,
        'Este lembrete será removido.',
        'This reminder will be removed.',
      ),
      confirmLabel: sleepText(context, 'Excluir', 'Delete'),
    );
    if (!confirmed || !mounted) return;
    setState(() => _saving = true);
    try {
      await widget.repository.deletePlan('${widget.plan!['id']}');
      if (widget.repository is! DemoSleepRepository &&
          SleepReminders.instance.supported) {
        try {
          await SleepReminders.instance.apply(
            await widget.repository.plans(),
            portuguese:
                mounted && Localizations.localeOf(context).languageCode == 'pt',
          );
        } catch (_) {
          await SleepReminders.instance.clear();
        }
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = sleepText(
            context,
            'Não foi possível excluir.',
            'Could not delete.',
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !_saving,
    child: Column(
      children: [
        AppSheetHeader(
          title: sleepText(context, 'Lembrete para deitar', 'Bedtime reminder'),
          canClose: !_saving,
        ),
        Expanded(
          child: AbsorbPointer(
            absorbing: _saving,
            child: ListView(
              padding: const EdgeInsets.all(22),
              children: [
                SwitchListTile.adaptive(
                  title: Text(
                    sleepText(context, 'Ativado', 'Enabled'),
                    style: AppSleepStyle.body,
                  ),
                  value: _enabled,
                  activeTrackColor: AppColors.textPrimary,
                  activeThumbColor: AppColors.homeCanvas,
                  onChanged: (v) => setState(() => _enabled = v),
                ),
                ListTile(
                  title: Text(
                    sleepText(context, 'Deitar', 'Bedtime'),
                    style: AppSleepStyle.body,
                  ),
                  trailing: Text(
                    sleepClock(_bedtime),
                    style: AppSleepStyle.value,
                  ),
                  onTap: () async {
                    final n = await showAppContentSheet<int>(
                      context,
                      (_) => _SleepTimePicker(
                        initial: _bedtime,
                        title: sleepText(context, 'Deitar', 'Bedtime'),
                      ),
                      glass: true,
                      heightFactor: .55,
                    );
                    if (mounted && n != null) setState(() => _bedtime = n);
                  },
                ),
                const SizedBox(height: 24),
                SleepLabel(sleepText(context, 'Dias da semana', 'Weekdays')),
                Wrap(
                  spacing: 5,
                  children: [
                    for (var d = 0; d < 7; d++)
                      FilterChip(
                        label: Text(
                          sleepText(
                            context,
                            ['D', 'S', 'T', 'Q', 'Q', 'S', 'S'][d],
                            ['S', 'M', 'T', 'W', 'T', 'F', 'S'][d],
                          ),
                        ),
                        selected: _week & (1 << d) != 0,
                        selectedColor: AppColors.glassBorderStrong,
                        onSelected: (_) => setState(() => _week ^= 1 << d),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  sleepText(context, 'Avisar antes', 'Remind before'),
                  style: AppSleepStyle.body,
                ),
                DropdownButton<int>(
                  value: _lead,
                  dropdownColor: AppColors.surface,
                  items: {0, 15, 30, 45, 60, 90, 120, _lead}
                      .map(
                        (n) =>
                            DropdownMenuItem(value: n, child: Text('$n min')),
                      )
                      .toList(),
                  onChanged: (n) {
                    if (n != null) setState(() => _lead = n);
                  },
                ),
                if (_error != null)
                  Text(
                    _error!,
                    style: AppSleepStyle.body.copyWith(color: AppColors.error),
                  ),
                if (widget.plan != null)
                  TextButton.icon(
                    onPressed: _delete,
                    icon: const Icon(Icons.delete_outline),
                    label: Text(
                      sleepText(context, 'Excluir lembrete', 'Delete reminder'),
                    ),
                  ),
              ],
            ),
          ),
        ),
        AppSheetSaveButton(
          label: sleepText(context, 'Salvar', 'Save'),
          loading: _saving,
          onPressed: _week == 0 ? null : _save,
        ),
      ],
    ),
  );
}
