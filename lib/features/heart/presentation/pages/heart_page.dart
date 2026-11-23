import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../core/auth/auth_session.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/network/api_client.dart';
import '../../../../design_system/design_system.dart';
import '../../../../shared/widgets/day_strip.dart';
import '../../../../shared/widgets/app_sheet_controls.dart';
import '../../../atlas/presentation/pages/atlas_chat_page.dart';
import '../../../device/application/device_scope.dart';
import '../../../device/presentation/pages/device_management_page.dart';
import '../../../diary/data/demo_diary_repository.dart';
import '../../../diary/data/remote_diary_repository.dart';
import '../../../diary/domain/diary_models.dart';
import '../../../diary/presentation/diary_page.dart';
import '../../../diary/presentation/diary_quick_questions.dart';
import '../../application/heart_controller.dart';
import '../../application/heart_history_sync.dart';
import '../../data/demo_heart_repository.dart';
import '../../data/heart_band_gateway.dart';
import '../../data/remote_heart_repository.dart';
import '../../domain/heart_models.dart';
import '../heart_copy.dart';
import '../sheets/heart_detail_sheet.dart';
import '../sheets/heart_recordings_sheet.dart';
import '../sheets/heart_settings_sheet.dart';
import '../widgets/heart_account_guard.dart';
import '../widgets/heart_charts.dart';
import '../widgets/heart_widgets.dart';
import 'heart_recording_page.dart';

class HeartPage extends StatefulWidget {
  const HeartPage({
    this.date,
    this.repository,
    this.diaryRepository,
    this.demo,
    this.config,
    this.initialMetric,
    this.openRecording = false,
    this.onDestinationSelected,
    super.key,
  });
  final DateTime? date;
  final HeartRepository? repository;
  final DiaryRepository? diaryRepository;
  final bool? demo;
  final AppConfig? config;
  final HeartMetric? initialMetric;
  final bool openRecording;
  final ValueChanged<int>? onDestinationSelected;
  @override
  State<HeartPage> createState() => _HeartPageState();
}

class _HeartPageState extends State<HeartPage> {
  late final bool _demo;
  late final HeartController _controller;
  late final DiaryRepository _diary;
  String? _locale;
  bool _habitsSaving = false,
      _syncing = false,
      _more = false,
      _initialOpened = false;
  int _diaryVersion = 0;
  final _moreKey = GlobalKey();
  Rect? _origin;
  ApiClient? _syncClient;
  HeartBandGateway? _syncGateway;
  bool get _busy => _habitsSaving || _syncing || _controller.saving;
  @override
  void initState() {
    super.initState();
    final config = widget.config ?? AppConfig.current;
    _demo = widget.demo ?? config.demoData;
    _controller = HeartController(
      repository:
          widget.repository ??
          (_demo
              ? DemoHeartRepository()
              : RemoteHeartRepository(
                  ApiClient.configured(config: config),
                  session: AuthSession.instance,
                )),
      date: widget.date ?? DateUtils.dateOnly(DateTime.now()),
      session: AuthSession.instance,
    );
    _diary =
        widget.diaryRepository ??
        (_demo
            ? DemoDiaryRepository()
            : RemoteDiaryRepository(
                ApiClient.configured(config: config),
                session: AuthSession.instance,
              ));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = Localizations.localeOf(context).toLanguageTag();
    if (_locale != locale) {
      _locale = locale;
      scheduleMicrotask(() async {
        final load = _controller.load(locale: locale);
        if (mounted && !_initialOpened && widget.openRecording) {
          _initialOpened = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) unawaited(_record());
          });
        }
        await load;
        if (mounted && !_initialOpened) {
          _initialOpened = true;
          if (widget.initialMetric != null && _controller.snapshot != null) {
            await _metric(widget.initialMetric!);
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _syncClient?.close();
    _syncGateway?.dispose();
    _controller.dispose();
    if (widget.diaryRepository == null) _diary.dispose();
    super.dispose();
  }

  Future<void> _metric(HeartMetric metric) async {
    final data = _controller.snapshot;
    if (data == null || _busy) return;
    final date = await showAppContentSheet<DateTime>(
      context,
      (_) => HeartAccountGuard(
        controller: _controller,
        child: HeartDetailSheet(
          repository: _controller.repository,
          snapshot: data,
          metric: metric,
        ),
      ),
      glass: true,
    );
    if (mounted && date != null) {
      await _controller.load(date: date, locale: _locale!);
    }
  }

  Future<void> _settings() async {
    if (_busy || _controller.snapshot == null) return;
    final date = await showAppContentSheet<DateTime>(
      context,
      (_) => HeartAccountGuard(
        controller: _controller,
        child: HeartSettingsSheet(controller: _controller),
      ),
      glass: true,
      dismissible: false,
      enableDrag: false,
    );
    if (mounted && date != null) {
      await _controller.load(date: date, locale: _locale!);
    }
  }

  Future<void> _record() async {
    if (_busy || _controller.accountChanged) return;
    await showAppContentSheet<void>(
      context,
      (_) => HeartAccountGuard(
        controller: _controller,
        child: HeartRecordingPage(
          repository: _controller.repository,
          demo: _demo,
        ),
      ),
      glass: true,
      heightFactor: .99,
      dismissible: false,
      enableDrag: false,
    );
    if (mounted && !_controller.accountChanged) {
      await _controller.load(locale: _locale!);
    }
  }

  Future<void> _history([String? id]) async {
    if (_busy) return;
    await showAppContentSheet<void>(
      context,
      (_) => HeartAccountGuard(
        controller: _controller,
        child: HeartRecordingsSheet(controller: _controller, initialId: id),
      ),
      glass: true,
    );
    if (mounted && !_controller.accountChanged) {
      await _controller.load(locale: _locale!);
    }
  }

  Future<void> _journal({bool meal = false}) async {
    if (_busy) return;
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => DiaryPage(
          repository: _diary,
          date: _controller.date,
          openRecord: meal,
          initialTracker: meal ? 'almoco' : null,
        ),
      ),
    );
    if (mounted) setState(() => _diaryVersion++);
  }

  Future<void> _sync() async {
    if (_busy) return;
    final device = DeviceScope.maybeOf(context)?.device;
    if (device?.connected != true) {
      await Navigator.push(
        context,
        MaterialPageRoute<void>(builder: (_) => const DeviceManagementPage()),
      );
      return;
    }
    if (DeviceScope.maybeOf(context)?.busy == true) return;
    setState(() => _syncing = true);
    try {
      _syncClient ??= ApiClient.configured(config: widget.config);
      _syncGateway ??= NativeHeartBandGateway();
      await HeartHistorySync(_syncClient!, _syncGateway!).sync(device!);
      if (mounted) {
        await _controller.load(locale: _locale!);
        if (mounted) {
          AppNotice.show(
            context,
            kind: AppNoticeKind.success,
            message: heartText(
              context,
              'Leituras sincronizadas.',
              'Readings synchronized.',
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        AppNotice.show(
          context,
          kind: AppNoticeKind.error,
          message: heartText(
            context,
            'Não foi possível sincronizar. Verifique a pulseira e tente novamente.',
            'Could not sync. Check your band and retry.',
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _syncing = false);
    }
  }

  void _destination(int i) {
    if (_busy) return;
    if (widget.onDestinationSelected != null) {
      widget.onDestinationSelected!(i);
      return;
    }
    if (i == 1) {
      AtlasOverlayScope.show(context);
    } else {
      Navigator.of(context).popUntil((r) => r.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _controller,
    builder: (context, _) {
      final c = _controller,
          data = c.snapshot,
          now = DateTime.now(),
          day = DateTime.utc(now.year, now.month, now.day)
              .difference(DateTime.utc(c.date.year, c.date.month, c.date.day))
              .inDays
              .clamp(0, 364);
      return PopScope(
        canPop: !_more && !_busy,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop && _more) setState(() => _more = false);
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            Scaffold(
              extendBody: true,
              backgroundColor: AppColors.homeCanvas,
              body: AppAtmosphereBackground(
                gradient: AppHeartStyle.background,
                light: AppHeartStyle.family,
                palette: AppHeartStyle.sky,
                child: SafeArea(
                  bottom: false,
                  minimum: const EdgeInsets.only(top: 40),
                  child: Column(
                    children: [
                      AppPageHeader(
                        height: 64,
                        padding: EdgeInsets.zero,
                        leading: IconButton(
                          tooltip: MaterialLocalizations.of(
                            context,
                          ).backButtonTooltip,
                          onPressed: _busy
                              ? null
                              : () => Navigator.maybePop(context),
                          icon: const AppSvgIcon(
                            AppSvgAssets.heartBack,
                            size: 24,
                          ),
                        ),
                        title: Text(
                          heartText(context, 'Coração', 'Heart'),
                          style: AppHeartStyle.body.copyWith(
                            fontSize: 19,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        trailing: IconButton(
                          tooltip: heartText(
                            context,
                            'Ajustes do coração',
                            'Heart settings',
                          ),
                          onPressed: _busy || data == null ? null : _settings,
                          icon: const AppSvgIcon(
                            AppSvgAssets.heartSettings,
                            size: 19,
                          ),
                        ),
                      ),
                      IgnorePointer(
                        ignoring: _busy,
                        child: DayStrip(
                          day: day,
                          daysCount: math.max(30, day + 1),
                          onDayChanged: (d) => c.load(
                            date: DateTime(now.year, now.month, now.day - d),
                            locale: _locale!,
                          ),
                        ),
                      ),
                      Expanded(
                        child: HeartAccountGuard(
                          controller: c,
                          child: c.loading
                              ? const Center(child: AppLoadingIndicator())
                              : data == null
                              ? _empty()
                              : RefreshIndicator(
                                  onRefresh: () async {
                                    if (!_busy) await c.load(locale: _locale!);
                                  },
                                  child: SingleChildScrollView(
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    padding: const EdgeInsets.only(
                                      top: 24,
                                      bottom: 150,
                                    ),
                                    child: _content(data),
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: AppBottomNav(
                selectedIndex: 3,
                moreButtonKey: _moreKey,
                moreOpen: _more,
                onDestinationSelected: _destination,
                onMorePressed: () {
                  if (_busy) return;
                  final box = _moreKey.currentContext?.findRenderObject();
                  if (box is RenderBox) {
                    setState(() {
                      _origin = box.localToGlobal(Offset.zero) & box.size;
                      _more = true;
                    });
                  }
                },
              ),
            ),
            if (_more && _origin != null)
              Positioned.fill(
                child: AppQuickActionsOverlay(
                  origin: _origin!,
                  onClose: () => setState(() => _more = false),
                  onActionSelected: (action) {
                    setState(() => _more = false);
                    if (action == AppQuickAction.ecg) {
                      _record();
                    } else if (action == AppQuickAction.dayReview ||
                        action == AppQuickAction.meal) {
                      _journal(meal: action == AppQuickAction.meal);
                    } else {
                      AppNotice.show(
                        context,
                        kind: AppNoticeKind.info,
                        message: heartText(
                          context,
                          'Esta ação estará disponível em breve.',
                          'This action will be available soon.',
                        ),
                      );
                    }
                  },
                ),
              ),
          ],
        ),
      );
    },
  );
  Widget _empty() => SingleChildScrollView(
    padding: const EdgeInsets.all(24),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          heartText(
            context,
            'Não foi possível carregar o Coração.',
            'Could not load Heart.',
          ),
          style: AppHeartStyle.title,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        AppGlassPill(
          label: heartText(context, 'Tentar novamente', 'Retry'),
          onPressed: () => _controller.load(locale: _locale!),
        ),
        const SizedBox(height: 16),
        AppButton(
          label: heartText(context, 'Fazer uma leitura', 'Start a recording'),
          onPressed: _record,
          variant: AppButtonVariant.secondary,
        ),
      ],
    ),
  );
  Widget _content(HeartSnapshot data) {
    final summary = data.summary,
        last = data.records.firstOrNull,
        rest = data.value(HeartMetric.resting),
        upper = data.baseline['upper'] as num?,
        elevated = rest != null && upper != null && rest > upper;
    final children = <Widget>[
      if (_demo) ...[
        Text(
          heartText(context, 'DEMONSTRAÇÃO', 'DEMONSTRATION'),
          style: AppHeartStyle.kicker,
        ),
        const SizedBox(height: 14),
      ],
      Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(data.format(HeartMetric.pulse), style: AppHeartStyle.number),
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Text('bpm', style: AppHeartStyle.body),
          ),
          const SizedBox(width: 16),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                heartText(
                  context,
                  data.fresh(DateTime.now()) ? 'AGORA' : 'ÚLTIMA LEITURA',
                  data.fresh(DateTime.now()) ? 'NOW' : 'LATEST READING',
                ),
                style: AppHeartStyle.kicker,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 22),
      Text(
        !data.hasData
            ? heartText(
                context,
                'Seu coração, em perspectiva.',
                'Your heart, in perspective.',
              )
            : elevated
            ? heartText(
                context,
                'O repouso do seu coração subiu um pouco.',
                'Your resting heart rate is a little higher.',
              )
            : heartText(
                context,
                'O coração acompanhou o seu dia.',
                'Your heart through the day.',
              ),
        style: AppHeartStyle.title,
      ),
      const SizedBox(height: 14),
      HeartExpandable(
        !data.hasData
            ? heartText(
                context,
                'Sincronize sua pulseira para ver os sinais registrados. Leituras ausentes permanecem vazias.',
                'Sync your band to view recorded signals. Missing measurements stay empty.',
              )
            : heartText(
                context,
                'A última leitura registrada foi ${data.format(HeartMetric.pulse)} bpm${data.latestAt == null ? '' : ' às ${heartClock(data.latestAt)}'}. A média do dia foi ${heartNumber(summary['avgHeartRate'] as num?)} bpm e a máxima chegou a ${heartNumber(summary['maxHeartRate'] as num?)} bpm. ${elevated ? 'O repouso ficou acima do seu intervalo pessoal. Compare com as próximas noites.' : ''}',
                'The latest stored reading was ${data.format(HeartMetric.pulse)} bpm${data.latestAt == null ? '' : ' at ${heartClock(data.latestAt)}'}. The daily average was ${heartNumber(summary['avgHeartRate'] as num?)} bpm and the maximum was ${heartNumber(summary['maxHeartRate'] as num?)} bpm.',
              ),
      ),
      if (!_demo &&
          !kIsWeb &&
          defaultTargetPlatform == TargetPlatform.android) ...[
        const SizedBox(height: 20),
        AppGlassPill(
          label: heartText(context, 'Sincronizar pulseira', 'Sync band'),
          onPressed: _sync,
        ),
      ],
      const SizedBox(height: 26),
      AppMetricCard(
        onTap: () => _metric(HeartMetric.pulse),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HeartLabel(
              heartText(
                context,
                'Frequência cardíaca hoje',
                'Heart rate today',
              ),
              chevron: true,
            ),
            const SizedBox(height: 14),
            Text(
              '${data.format(HeartMetric.pulse)} bpm',
              style: AppHeartStyle.value,
            ),
            const SizedBox(height: 8),
            Text(
              heartText(
                context,
                'Repouso ${data.format(HeartMetric.resting)} · média ${heartNumber(summary['avgHeartRate'] as num?)} · máxima ${heartNumber(summary['maxHeartRate'] as num?)}',
                'Resting ${data.format(HeartMetric.resting)} · average ${heartNumber(summary['avgHeartRate'] as num?)} · maximum ${heartNumber(summary['maxHeartRate'] as num?)}',
              ),
              style: AppHeartStyle.caption,
            ),
            const SizedBox(height: 22),
            HeartLineChart(points: data.points, date: data.date),
          ],
        ),
      ),
      const SizedBox(height: 10),
      AppMetricCard(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(22),
              child: Text(
                'ECG',
                style: AppHeartStyle.body.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 17,
                ),
              ),
            ),
            TextButton.icon(
              key: const ValueKey('heart-new-recording'),
              onPressed: _record,
              style: TextButton.styleFrom(
                backgroundColor: AppHeartStyle.ecgButton,
                shape: const RoundedRectangleBorder(),
                minimumSize: const Size(double.infinity, 50),
              ),
              icon: const Icon(Icons.add, size: 18),
              label: Text(
                heartText(context, 'FAZER NOVO ECG', 'NEW ECG RECORDING'),
                style: AppHeartStyle.kicker.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppMetricCard(
                    onTap: () => _history(last?.id),
                    padding: const EdgeInsets.all(14),
                    radius: BorderRadius.circular(16),
                    child: Row(
                      children: [
                        if (last != null)
                          HeartRecordPreview(
                            repository: _controller.repository,
                            record: last,
                          )
                        else
                          const Icon(
                            Icons.monitor_heart_outlined,
                            color: AppHeartStyle.family,
                            size: 28,
                          ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                heartText(
                                  context,
                                  'Seu último registro',
                                  'Your latest recording',
                                ),
                                style: AppHeartStyle.body.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                last == null
                                    ? heartText(
                                        context,
                                        'Nenhuma leitura nesta data',
                                        'No recording on this date',
                                      )
                                    : '${last.kind.toUpperCase()} · ${heartClock(last.measuredAt)}',
                                style: AppHeartStyle.caption,
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          color: AppHeartStyle.muted,
                        ),
                      ],
                    ),
                  ),
                  if (last != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      heartText(
                        context,
                        'Ritmo não classificado',
                        'Rhythm unclassified',
                      ),
                      style: AppHeartStyle.body,
                    ),
                    Text(
                      heartText(
                        context,
                        'O sensor não forneceu uma análise de arritmias.',
                        'No arrhythmia analysis was supplied by the sensor.',
                      ),
                      style: AppHeartStyle.caption,
                    ),
                  ],
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () => _history(),
                    child: Text(
                      heartText(
                        context,
                        'Ver todos os registros',
                        'View all recordings',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      if (data.preferences.pressure) ...[
        const SizedBox(height: 10),
        AppMetricCard(
          onTap: () => _metric(HeartMetric.pressure),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              HeartLabel(
                heartMetricTitle(context, HeartMetric.pressure),
                chevron: true,
              ),
              const SizedBox(height: 18),
              Text(
                '${data.format(HeartMetric.pressure)} mmHg',
                style: AppHeartStyle.value,
              ),
              const SizedBox(height: 8),
              Text(
                heartText(
                  context,
                  'estimativa fornecida pelo dispositivo',
                  'estimate supplied by your device',
                ),
                style: AppHeartStyle.caption,
              ),
            ],
          ),
        ),
      ],
      const SizedBox(height: 22),
      DiaryQuickQuestions(
        key: ValueKey('heart-habits-${heartDate(data.date)}-$_diaryVersion'),
        repository: _diary,
        date: data.date,
        onBusyChanged: (busy) {
          if (mounted) setState(() => _habitsSaving = busy);
        },
        keyPrefix: 'heart-habit',
        bodyStyle: AppHeartStyle.body,
        captionStyle: AppHeartStyle.caption,
        kickerStyle: AppHeartStyle.kicker,
        iconAnswers: true,
        questions: const [
          (
            'c_palpit',
            'Sentiu o coração acelerar parado?',
            'Did your heart race while resting?',
          ),
          (
            'c_sal',
            'Comeu comida muito salgada?',
            'Did you eat very salty food?',
          ),
          ('alc', 'Bebeu álcool?', 'Did you drink alcohol?'),
        ],
      ),
      TextButton(
        onPressed: _journal,
        child: Text(heartText(context, 'Abrir meu Diário', 'Open my diary')),
      ),
      const SizedBox(height: 28),
      Text(
        heartText(context, 'Principais métricas', 'Main metrics'),
        style: AppHeartStyle.title,
      ),
      const SizedBox(height: 12),
      Text(
        heartText(
          context,
          'O que o seu coração mostrou na noite e no dia.',
          'What your heart recorded through the night and day.',
        ),
        style: AppHeartStyle.body,
      ),
      const SizedBox(height: 22),
      LayoutBuilder(
        builder: (c, box) => Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            SizedBox(
              width: (box.maxWidth - 10) / 2,
              child: AppMetricCard(
                onTap: () => _notices(data),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeartLabel(
                      heartText(context, 'Avisos do coração', 'Heart notices'),
                      chevron: true,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      !data.preferences.high
                          ? '—'
                          : data.alerts['aboveBaselineNights'] == null
                          ? '—'
                          : data.alerts['aboveBaselineNights'] == 0
                          ? heartText(context, 'Nenhum', 'None')
                          : '${data.alerts['aboveBaselineNights']}',
                      style: AppHeartStyle.value.copyWith(fontSize: 22),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      heartText(
                        context,
                        'noites acima do normal · últimas 30 datas',
                        'nights above baseline · last 30 dates',
                      ),
                      style: AppHeartStyle.caption,
                    ),
                  ],
                ),
              ),
            ),
            for (final metric in [
              HeartMetric.hrv,
              HeartMetric.oxygen,
              HeartMetric.recovery,
            ])
              SizedBox(
                width: (box.maxWidth - 10) / 2,
                child: AppMetricCard(
                  padding: const EdgeInsets.all(16),
                  onTap: () => _metric(metric),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeartLabel(
                        heartMetricTitle(context, metric),
                        chevron: true,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        '${data.format(metric)} ${metric.unit}',
                        style: AppHeartStyle.value.copyWith(fontSize: 22),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        heartText(
                          context,
                          metric == HeartMetric.recovery
                              ? 'no 1º minuto após treino'
                              : 'leitura registrada',
                          metric == HeartMetric.recovery
                              ? '1st minute after exercise'
                              : 'stored reading',
                        ),
                        style: AppHeartStyle.caption,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      const SizedBox(height: 34),
      Text(
        heartText(
          context,
          'O repouso do seu coração, ao longo dos dias.',
          'Your resting heart rate over time.',
        ),
        style: AppHeartStyle.title,
      ),
      const SizedBox(height: 22),
      AppMetricCard(
        onTap: () => _metric(HeartMetric.resting),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HeartLabel(
              heartText(
                context,
                'FC em repouso · 7 dias',
                'Resting heart rate · 7 days',
              ),
              chevron: true,
            ),
            const SizedBox(height: 16),
            Text(
              '${heartNumber(data.trend.average(HeartMetric.resting))} bpm',
              style: AppHeartStyle.value,
            ),
            const SizedBox(height: 8),
            Text(
              data.baseline['lower'] == null
                  ? heartText(
                      context,
                      'seu intervalo pessoal ainda está em formação',
                      'your personal baseline is still building',
                    )
                  : '${heartText(context, 'seu normal', 'your baseline')}: ${data.baseline['lower']}–${data.baseline['upper']} bpm',
              style: AppHeartStyle.caption,
            ),
            const SizedBox(height: 24),
            HeartTrendChart(trend: data.trend, metric: HeartMetric.resting),
          ],
        ),
      ),
      const SizedBox(height: 32),
      Text(
        heartText(context, 'Sinais desta leitura', 'Signals in this reading'),
        style: AppHeartStyle.title,
      ),
      const SizedBox(height: 12),
      for (final metric in [
        HeartMetric.resting,
        HeartMetric.hrv,
        HeartMetric.oxygen,
        HeartMetric.respiration,
      ])
        HeartReadingRow(
          heartMetricTitle(context, metric),
          '${data.format(metric)} ${metric.unit}',
          onTap: () => _metric(metric),
        ),
      if (data.unavailable.isNotEmpty) ...[
        const SizedBox(height: 20),
        Text(
          heartText(
            context,
            'Alguns dados não puderam ser carregados. Puxe para atualizar.',
            'Some data could not be loaded. Pull to refresh.',
          ),
          style: AppHeartStyle.caption,
        ),
      ],
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final child in children)
          if (child is AppMetricCard || child is DiaryQuickQuestions)
            child
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: child,
            ),
      ],
    );
  }

  Future<void> _notices(HeartSnapshot data) async {
    if (_busy) return;
    await showAppContentSheet<void>(
      context,
      (_) => HeartAccountGuard(
        controller: _controller,
        child: Column(
          children: [
            AppSheetHeader(
              title: heartText(context, 'Avisos do coração', 'Heart notices'),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(22),
                children: [
                  Text(
                    heartText(
                      context,
                      'Seu repouso nas últimas 30 datas',
                      'Your resting rate over the last 30 dates',
                    ),
                    style: AppHeartStyle.title,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    !data.preferences.high
                        ? heartText(
                            context,
                            'Os avisos de repouso estão desativados nos ajustes.',
                            'Resting rate notices are disabled in settings.',
                          )
                        : data.alerts['aboveBaselineNights'] == null
                        ? heartText(
                            context,
                            'Ainda não há noites medidas suficientes para comparar com seu intervalo pessoal.',
                            'There are not enough measured nights to compare with your personal baseline.',
                          )
                        : '${data.alerts['aboveBaselineNights']} ${heartText(context, 'noites acima do seu normal', 'nights above your baseline')} · ${data.alerts['observedNights']} ${heartText(context, 'noites observadas', 'observed nights')}',
                    style: AppHeartStyle.body,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    heartText(context, 'Ritmo irregular', 'Irregular rhythm'),
                    style: AppHeartStyle.title,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    heartText(
                      context,
                      'Nenhuma classificação validada de ritmo foi fornecida pelo dispositivo. Isso não representa um resultado normal nem uma exclusão de arritmia.',
                      'No validated rhythm classification was supplied by the device. This does not represent a normal result or rule out an arrhythmia.',
                    ),
                    style: AppHeartStyle.body,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      glass: true,
    );
  }
}
