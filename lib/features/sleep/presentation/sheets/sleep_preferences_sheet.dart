import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import '../../../../design_system/design_system.dart';
import '../../../../shared/widgets/app_sheet_controls.dart';
import '../../application/sleep_controller.dart';
import '../../application/sleep_reminders.dart';
import '../../application/sleep_report.dart';
import '../../data/demo_sleep_repository.dart';
import '../../domain/sleep_models.dart';
import '../sleep_copy.dart';
import '../widgets/sleep_widgets.dart';

class SleepPreferencesSheet extends StatefulWidget {
  const SleepPreferencesSheet({required this.controller, super.key});
  final SleepController controller;
  @override
  State<SleepPreferencesSheet> createState() => _SleepPreferencesSheetState();
}

class _SleepPreferencesSheetState extends State<SleepPreferencesSheet> {
  late SleepPreferences _preferences = widget.controller.snapshot!.preferences;
  bool _saving = false, _reporting = false;
  String? _error;
  List<Map<String, dynamic>>? _plans;
  Object? _planError;
  @override
  void initState() {
    super.initState();
    _loadPlans();
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

  String _copy(String pt, String en) => sleepText(context, pt, en);

  Future<T?> _page<T>(String title, WidgetBuilder body) => Navigator.push<T>(
    context,
    MaterialPageRoute(
      builder: (context) => Scaffold(
        backgroundColor: AppHealthStyle.canvas,
        body: DecoratedBox(
          decoration: const BoxDecoration(gradient: AppHealthStyle.background),
          child: SafeArea(
            child: AppGlassScrollHeader(
              header: _header(context, title),
              height: 49,
              body: (inset) => Padding(
                padding: EdgeInsets.only(top: inset),
                child: body(context),
              ),
            ),
          ),
        ),
      ),
    ),
  );

  Widget _header(BuildContext context, String title) => AppPageHeader(
    height: 49,
    title: Text(title, style: AppTypography.detailBody.copyWith(fontSize: 17)),
    leading: BackButton(
      onPressed: _saving ? null : () => Navigator.pop(context),
    ),
  );

  Future<void> _chooseDuration(bool target) async {
    final title = target
        ? _copy('Necessidade de sono', 'Sleep need')
        : _copy('Desacelerar', 'Wind down');
    final current = target ? _preferences.target : _preferences.windDown;
    final values = {
      if (target)
        ...List.generate(17, (index) => 360 + index * 15)
      else ...[
        0,
        15,
        30,
        45,
        60,
        90,
        120,
        180,
      ],
      current,
    }.toList()..sort();
    final result = await _page<int>(
      title,
      (routeContext) => ListView(
        padding: const EdgeInsets.all(AppHealthStyle.edge),
        children: [
          Text(
            target
                ? _copy(
                    'Usamos essa duração para comparar suas noites com seu objetivo.',
                    'We use this duration to compare measured nights with your goal.',
                  )
                : _copy(
                    'Escolha quanto tempo reservar antes de dormir.',
                    'Choose how much time to set aside before bedtime.',
                  ),
            style: AppHealthStyle.body,
          ),
          const SizedBox(height: 16),
          AppHealthPanel(
            child: Column(
              children: [
                for (final (index, value) in values.indexed)
                  AppHealthRow(
                    label: value == 0
                        ? _copy('Sem intervalo', 'No wind-down period')
                        : sleepDuration(value),
                    icon: current == value ? Icons.check : null,
                    divider: index != values.length - 1,
                    onTap: () => Navigator.pop(routeContext, value),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
    if (mounted && result != null) {
      setState(
        () => _preferences = _preferences.copy({
          if (target)
            'targetSleepMinutes': result
          else
            'windDownMinutes': result,
        }),
      );
    }
  }

  Future<void> _clockSettings() async {
    var bedtime = _preferences.bedtime, wake = _preferences.wake;
    var weekend = _preferences.weekendWake;
    final result = await _page<(int, int, int?)>(
      _copy('Acordar e deitar', 'Wake time and bedtime'),
      (routeContext) => StatefulBuilder(
        builder: (routeContext, update) {
          Future<void> choose({
            bool night = false,
            bool weekendDay = false,
          }) async {
            final title = night
                ? _copy('Deitar', 'Bedtime')
                : _copy('Acordar', 'Wake time');
            final selected = await showAppContentSheet<int>(
              routeContext,
              (_) => _SleepTimePicker(
                initial: night
                    ? bedtime
                    : weekendDay
                    ? (weekend ?? wake)
                    : wake,
                title: title,
              ),
              glass: true,
              heightFactor: .55,
            );
            if (!routeContext.mounted || selected == null) return;
            update(() {
              if (night) {
                bedtime = selected;
              } else if (weekendDay) {
                weekend = selected;
              } else {
                wake = selected;
              }
            });
          }

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(AppHealthStyle.edge),
                  children: [
                    if (_preferences.show('showBiologicalClock'))
                      Center(
                        child: CustomPaint(
                          size: const Size(280, 150),
                          painter: SleepClockPainter(bedtime, wake),
                        ),
                      ),
                    AppHealthPanel(
                      child: Column(
                        children: [
                          AppHealthRow(
                            label: _copy('Deitar', 'Bedtime'),
                            value: sleepClock(bedtime),
                            icon: Icons.bedtime_outlined,
                            onTap: () => choose(night: true),
                          ),
                          AppHealthRow(
                            label: _copy('Dias úteis', 'Weekdays'),
                            value: sleepClock(wake),
                            icon: Icons.alarm_outlined,
                            onTap: choose,
                          ),
                          AppHealthRow(
                            label: _copy(
                              'Sábado e domingo',
                              'Saturday and Sunday',
                            ),
                            value: sleepClock(weekend ?? wake),
                            icon: Icons.calendar_today_outlined,
                            onTap: () => choose(weekendDay: true),
                            divider: false,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _copy(
                        'Estes horários são as metas do planejador.',
                        'These times are planner targets.',
                      ),
                      style: AppHealthStyle.small,
                    ),
                  ],
                ),
              ),
              AppSheetSaveButton(
                label: _copy('Confirmar', 'Confirm'),
                onPressed: () =>
                    Navigator.pop(routeContext, (bedtime, wake, weekend)),
              ),
            ],
          );
        },
      ),
    );
    if (mounted && result != null) {
      setState(
        () => _preferences = _preferences.copy({
          'targetBedtimeHour': result.$1 ~/ 60,
          'targetBedtimeMinute': result.$1 % 60,
          'targetWakeHour': result.$2 ~/ 60,
          'targetWakeMinute': result.$2 % 60,
          if (result.$3 != null) 'targetWeekendWakeMinute': result.$3,
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

  Future<void> _shareReport() async {
    if (_reporting) return;
    final data = widget.controller.snapshot;
    if (data == null) return;
    final portuguese = Localizations.localeOf(context).languageCode == 'pt';
    final render = context.findRenderObject();
    final bounds = render is RenderBox
        ? render.localToGlobal(Offset.zero) & render.size
        : null;
    setState(() => _reporting = true);
    try {
      var trend = await widget.controller.repository.trend(data.date, 30);
      if (trend.locked) {
        trend = await widget.controller.repository.trend(data.date, 7);
      }
      if (!mounted || widget.controller.accountChanged) return;
      if (!trend.days.any((day) => day['hasData'] == true)) {
        AppNotice.show(
          context,
          kind: AppNoticeKind.error,
          message: _copy(
            'Nenhuma noite disponível para exportar.',
            'No recorded nights to export.',
          ),
        );
        return;
      }
      final bytes = await buildSleepReport(
        trend,
        portuguese: portuguese,
        demo: widget.controller.repository is DemoSleepRepository,
      );
      if (!mounted || widget.controller.accountChanged) return;
      await Printing.sharePdf(
        bytes: bytes,
        filename: 'BYND-sleep-${sleepDate(data.date)}.pdf',
        bounds: bounds,
      );
    } catch (_) {
      if (mounted && !widget.controller.accountChanged) {
        AppNotice.show(
          context,
          kind: AppNoticeKind.error,
          message: _copy(
            'Não foi possível exportar o relatório.',
            'Could not export the report.',
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _reporting = false);
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
    final title = _copy('Ajustes do sono', 'Sleep settings');
    if (widget.controller.snapshot?.unavailable.contains('preferences') !=
        false) {
      return Column(
        children: [
          _header(context, title),
          Expanded(
            child: Center(
              child: Text(
                _copy(
                  'Os ajustes não puderam ser carregados. Atualize a página e tente novamente.',
                  'Settings could not be loaded. Refresh the page and try again.',
                ),
                style: AppHealthStyle.body,
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
          Expanded(
            child: AbsorbPointer(
              absorbing: _saving,
              child: AppGlassScrollHeader(
                header: _header(context, title),
                height: 49,
                body: (inset) => ListView(
                  padding: EdgeInsets.fromLTRB(
                    AppHealthStyle.edge,
                    inset + 18,
                    AppHealthStyle.edge,
                    20,
                  ),
                  children: [
                    AppHealthSection(
                      _copy('Planejador de sono', 'Sleep planner'),
                      Icons.bedtime_outlined,
                    ),
                    const SizedBox(height: 14),
                    AppHealthPanel(
                      child: Column(
                        children: [
                          AppHealthRow(
                            label: _copy(
                              'Acordar e deitar',
                              'Wake time and bedtime',
                            ),
                            subtitle:
                                '${sleepClock(_preferences.bedtime)} → ${sleepClock(_preferences.wake)}',
                            icon: Icons.alarm_outlined,
                            onTap: _clockSettings,
                          ),
                          AppHealthRow(
                            label: _copy('Necessidade de sono', 'Sleep need'),
                            value: sleepDuration(_preferences.target),
                            icon: Icons.schedule_outlined,
                            onTap: () => _chooseDuration(true),
                          ),
                          AppHealthRow(
                            label: _copy('Desacelerar', 'Wind down'),
                            value: '${_preferences.windDown} min',
                            icon: Icons.nights_stay_outlined,
                            onTap: () => _chooseDuration(false),
                            divider: false,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    AppHealthSection(
                      _copy('Mostrar na página', 'Show on the page'),
                      Icons.visibility_outlined,
                    ),
                    const SizedBox(height: 14),
                    AppHealthPanel(
                      child: Column(
                        children: [
                          for (final (key, pt, en, icon) in const [
                            (
                              'showStages',
                              'Fases do sono',
                              'Sleep stages',
                              Icons.stacked_line_chart,
                            ),
                            (
                              'showBiologicalClock',
                              'Relógio do planejador',
                              'Planner clock',
                              Icons.schedule_outlined,
                            ),
                            (
                              'showRespiration',
                              'Respiração e oxigênio',
                              'Breathing and oxygen',
                              Icons.air_outlined,
                            ),
                            (
                              'showNaps',
                              'Cochilos',
                              'Naps',
                              Icons.hotel_outlined,
                            ),
                            (
                              'showSleepDebt',
                              'Dívida de sono',
                              'Sleep debt',
                              Icons.timelapse,
                            ),
                            (
                              'showSleepTrend',
                              'Suas noites',
                              'Your nights',
                              Icons.show_chart,
                            ),
                            (
                              'showSleepSignals',
                              'Sinais desta leitura',
                              'Signals in this reading',
                              Icons.monitor_heart_outlined,
                            ),
                          ])
                            SwitchListTile.adaptive(
                              key: ValueKey(key),
                              contentPadding: EdgeInsets.zero,
                              secondary: Icon(
                                icon,
                                size: 19,
                                color: AppColors.textSecondary,
                              ),
                              title: Text(
                                _copy(pt, en),
                                style: AppHealthStyle.body,
                              ),
                              value: _preferences.show(key),
                              activeTrackColor: AppColors.textPrimary,
                              activeThumbColor: AppColors.homeCanvas,
                              onChanged: (value) => setState(
                                () => _preferences = _preferences.copy({
                                  key: value,
                                }),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    AppHealthSection(
                      _copy('Lembretes para deitar', 'Bedtime reminders'),
                      Icons.notifications_none,
                    ),
                    const SizedBox(height: 12),
                    if (_planError != null)
                      AppGlassPill(
                        label: _copy('Tentar novamente', 'Retry'),
                        onPressed: _loadPlans,
                      )
                    else if (_plans == null)
                      const Center(child: AppLoadingIndicator())
                    else
                      AppHealthPanel(
                        child: Column(
                          children: [
                            for (final plan in _plans!)
                              AppHealthRow(
                                icon: plan['enabled'] == true
                                    ? Icons.notifications_active_outlined
                                    : Icons.notifications_off_outlined,
                                label: sleepClock(
                                  ((plan['bedtimeHour'] as num?)?.toInt() ??
                                              0) *
                                          60 +
                                      ((plan['bedtimeMinute'] as num?)
                                              ?.toInt() ??
                                          0),
                                ),
                                subtitle: plan['enabled'] == true
                                    ? _copy('Ativado', 'Enabled')
                                    : _copy('Desativado', 'Disabled'),
                                onTap: () => _plan(plan),
                              ),
                            if (_plans!.length < 5)
                              AppHealthRow(
                                label: _copy(
                                  'Adicionar lembrete',
                                  'Add reminder',
                                ),
                                icon: Icons.add,
                                onTap: _plan,
                                divider: false,
                              ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 24),
                    AppHealthSection(
                      _copy(
                        'Relatório para o médico',
                        'Report for your doctor',
                      ),
                      Icons.description_outlined,
                    ),
                    const SizedBox(height: 12),
                    AppHealthPanel(
                      child: AppHealthRow(
                        label: _reporting
                            ? _copy(
                                'Preparando relatório…',
                                'Preparing report…',
                              )
                            : _copy(
                                'Exportar noites e fases em PDF',
                                'Export nights and stages as PDF',
                              ),
                        icon: Icons.picture_as_pdf_outlined,
                        onTap: _reporting ? null : _shareReport,
                        divider: false,
                      ),
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        _error!,
                        style: AppHealthStyle.body.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          AppSheetSaveButton(
            label: _copy('Salvar', 'Save'),
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
