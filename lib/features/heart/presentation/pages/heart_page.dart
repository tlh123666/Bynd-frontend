import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../core/auth/auth_session.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/network/api_client.dart';
import '../../../../design_system/design_system.dart';
import '../../../../shared/widgets/day_strip.dart';
import '../../../atlas/presentation/pages/atlas_chat_page.dart';
import '../../../device/application/device_scope.dart';
import '../../../device/presentation/pages/device_management_page.dart';
import '../../../diary/data/demo_diary_repository.dart';
import '../../../diary/data/remote_diary_repository.dart';
import '../../../diary/domain/diary_models.dart';
import '../../../diary/presentation/diary_page.dart';
import '../../../diary/presentation/diary_health_sheet.dart';
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
import '../widgets/heart_recording_trace.dart';
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
  bool _syncing = false, _more = false, _initialOpened = false;
  final _moreKey = GlobalKey();
  final _historyWindow = AppHealthHistory();
  Rect? _origin;
  ApiClient? _syncClient;
  HeartBandGateway? _syncGateway;
  bool get _busy => _syncing || _controller.saving;
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
    await _openRecordingRoute(
      HeartRecordingPage(repository: _controller.repository, demo: _demo),
    );
    if (mounted && !_controller.accountChanged) {
      await _controller.load(locale: _locale!);
    }
  }

  Future<void> _history([String? id]) async {
    if (_busy) return;
    await _openRecordingRoute(
      HeartRecordingsSheet(
        controller: _controller,
        initialId: id,
        onNewRecording: _record,
      ),
    );
    if (mounted && !_controller.accountChanged) {
      await _controller.load(locale: _locale!);
    }
  }

  Future<void> _openRecordingRoute(Widget child) =>
      Navigator.of(context).push<void>(
        MaterialPageRoute(
          builder: (_) => Scaffold(
            backgroundColor: AppHealthStyle.canvas,
            body: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: AppHealthStyle.background,
              ),
              child: SafeArea(
                child: HeartAccountGuard(controller: _controller, child: child),
              ),
            ),
          ),
        ),
      );

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
        final partial = e is ApiException && e.code == 'partial_sync';
        AppNotice.show(
          context,
          kind: AppNoticeKind.error,
          message: heartText(
            context,
            partial
                ? 'A sincronização ficou incompleta. Aproxime a pulseira e tente novamente.'
                : 'Não foi possível sincronizar. Verifique a pulseira e tente novamente.',
            partial
                ? 'Sync was incomplete. Bring your band closer and retry.'
                : 'Could not sync. Check your band and retry.',
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
                gradient: AppHealthStyle.background,
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
                            fontSize: 17,
                            color: AppColors.textPrimary,
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
    String copy(String pt, String en) => heartText(context, pt, en);
    final rest = data.value(HeartMetric.resting);
    final upper = data.baseline['upper'] as num?;
    final lower = data.baseline['lower'] as num?;
    final above = rest != null && upper != null && rest > upper;
    final below = rest != null && lower != null && rest < lower;
    final last = data.records.firstOrNull;
    final today = DateUtils.isSameDay(data.date, DateTime.now());
    final signals = [
      HeartMetric.pulse,
      HeartMetric.hrv,
      HeartMetric.oxygen,
      HeartMetric.respiration,
      if (data.preferences.pressure) HeartMetric.pressure,
    ];
    final points = <AppHealthPoint>[
      for (final row in data.trend.days)
        if (DateTime.tryParse('${row['statDate'] ?? row['date']}')
            case final DateTime date)
          (
            date: date,
            value: row['hasData'] == true
                ? row['restingHeartRate'] as num?
                : null,
          ),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppHealthStyle.edge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppHealthHero(
            value: data.format(HeartMetric.resting),
            label: copy('bpm em repouso', 'resting bpm'),
            status: rest == null
                ? copy('Sem leitura', 'No reading')
                : above
                ? copy('Acima do habitual', 'Above baseline')
                : below
                ? copy('Abaixo do habitual', 'Below baseline')
                : lower != null && upper != null
                ? copy('No seu intervalo', 'In your range')
                : copy('Leitura registrada', 'Recorded'),
            color: rest == null
                ? AppColors.textMuted
                : above || below
                ? AppHealthStyle.attention
                : AppHealthStyle.positive,
          ),
          const SizedBox(height: 24),
          Text(
            !data.hasData
                ? copy(
                    'Seu coração, em perspectiva.',
                    'Your heart, in perspective.',
                  )
                : above
                ? copy(
                    'Repouso acima do habitual.',
                    'Resting rate above baseline.',
                  )
                : copy(
                    'Seu coração ao longo do dia.',
                    'Your heart through the day.',
                  ),
            style: AppHealthStyle.title,
          ),
          const SizedBox(height: 8),
          HeartExpandable(
            !data.hasData
                ? copy(
                    'Sincronize sua pulseira para ver os sinais registrados.',
                    'Sync your band to see recorded signals.',
                  )
                : copy(
                    'Média de ${heartNumber(data.summary['avgHeartRate'] as num?)} bpm e máxima de ${heartNumber(data.summary['maxHeartRate'] as num?)} bpm no dia selecionado.',
                    'Average of ${heartNumber(data.summary['avgHeartRate'] as num?)} bpm and maximum of ${heartNumber(data.summary['maxHeartRate'] as num?)} bpm on the selected day.',
                  ),
          ),
          if (_demo)
            Text(
              copy('Demonstração', 'Demonstration'),
              style: AppHealthStyle.small,
            ),
          if (!_demo &&
              !kIsWeb &&
              defaultTargetPlatform == TargetPlatform.android) ...[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: AppGlassPill(
                label: copy('Sincronizar pulseira', 'Sync band'),
                onPressed: _sync,
              ),
            ),
          ],
          const SizedBox(height: 26),
          AppHealthTrend(
            key: const Key('heart-resting-trend'),
            points: _historyWindow.resolve(points, data.date),
            selected: data.date,
            minimum: 40,
            maximum: 90,
            low: lower,
            high: upper,
            rangeLabel: copy('Seu intervalo', 'Your range'),
            emptyLabel: copy(
              'Sem histórico de repouso.',
              'No resting rate history.',
            ),
            marker: AppHealthStyle.pulse,
            unit: 'bpm',
            onSelected: (date) {
              if (!_busy) _controller.load(date: date, locale: _locale!);
            },
          ),
          const SizedBox(height: 18),
          DiaryHealthEntry(
            topic: DiaryHealthTopic.heart,
            repository: _diary,
            date: data.date,
            title: copy('Coração', 'Heart'),
            subtitle: copy(
              'Álcool, café, estresse e como você está',
              'Alcohol, coffee, stress and how you feel',
            ),
          ),
          if (today && data.hasData) ...[
            const SizedBox(height: AppHealthStyle.sectionGap),
            AppHealthSection(
              copy('Direção do dia', 'Direction for today'),
              Icons.explore_outlined,
            ),
            const SizedBox(height: 8),
            AppHealthRow(
              label: copy('Faça movimento leve', 'Choose light movement'),
              icon: Icons.directions_walk_outlined,
            ),
            AppHealthRow(
              label: copy('Evite álcool à noite', 'Avoid alcohol tonight'),
              icon: Icons.local_bar_outlined,
            ),
            AppHealthRow(
              label: copy(
                'Mantenha seu horário de dormir',
                'Keep your planned bedtime',
              ),
              icon: Icons.bedtime_outlined,
            ),
          ],
          const SizedBox(height: AppHealthStyle.sectionGap),
          AppHealthSection('ECG', Icons.monitor_heart_outlined),
          const SizedBox(height: 14),
          if (last != null) ...[
            HeartLatestTrace(repository: _controller.repository, record: last),
            AppHealthRow(
              label: copy('Tipo de sinal', 'Signal type'),
              value: last.label,
              onTap: () => _history(last.id),
            ),
            AppHealthRow(
              label: copy('Batimento', 'Heart rate'),
              value: last.number('heartRate') == null
                  ? '—'
                  : '${last.number('heartRate')} bpm',
            ),
            AppHealthRow(
              label: copy('Ritmo', 'Rhythm'),
              value: copy('Não classificado', 'Unclassified'),
            ),
            AppHealthRow(
              label: copy('Horário', 'Time'),
              value: heartClock(last.measuredAt),
            ),
          ] else
            AppHealthRow(
              label: copy(
                'Nenhuma leitura nesta data',
                'No recording on this date',
              ),
            ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  key: const ValueKey('heart-new-recording'),
                  label: copy('Fazer ECG', 'Record ECG'),
                  onPressed: _record,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AppButton(
                  label: copy('Histórico', 'History'),
                  variant: AppButtonVariant.secondary,
                  onPressed: () => _history(),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppHealthStyle.sectionGap),
          AppHealthSection(
            copy('Principais métricas', 'Main metrics'),
            Icons.grid_view_outlined,
          ),
          const SizedBox(height: AppHealthStyle.gap),
          AppHealthMetricGrid(
            children: [
              AppHealthMetric(
                label: copy('FC média', 'Average heart rate'),
                value: heartNumber(data.summary['avgHeartRate'] as num?),
                unit: 'bpm',
                icon: Icons.favorite_border,
              ),
              AppHealthMetric(
                label: copy('FC máxima', 'Maximum heart rate'),
                value: heartNumber(data.summary['maxHeartRate'] as num?),
                unit: 'bpm',
                icon: Icons.show_chart,
              ),
              AppHealthMetric(
                label: copy('Queda após o esforço', 'Post-exercise drop'),
                value: data.format(HeartMetric.recovery),
                unit: 'bpm',
                icon: Icons.trending_down,
              ),
              AppHealthMetric(
                label: copy('Avisos do coração', 'Heart notices'),
                value: heartNumber(
                  data.preferences.high
                      ? data.alerts['aboveBaselineNights'] as num?
                      : null,
                ),
                caption: copy('Últimos 30 dias', 'Last 30 days'),
                icon: Icons.notifications_none,
              ),
            ],
          ),
          const SizedBox(height: AppHealthStyle.sectionGap),
          AppHealthSection(
            copy('Sinais desta leitura', 'Signals in this reading'),
            Icons.analytics_outlined,
          ),
          const SizedBox(height: AppHealthStyle.gap),
          AppHealthPanel(
            child: Column(
              children: [
                for (final (index, metric) in signals.indexed)
                  AppHealthRow(
                    key: ValueKey('heart-signal-${metric.name}'),
                    label: heartMetricTitle(context, metric),
                    icon:
                        metric == HeartMetric.oxygen ||
                            metric == HeartMetric.respiration
                        ? Icons.air_outlined
                        : Icons.monitor_heart_outlined,
                    value: data.format(metric) == '—'
                        ? '—'
                        : '${data.format(metric)} ${metric.unit}',
                    onTap: () => _metric(metric),
                    divider: index != signals.length - 1,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppHealthRow(
            key: const Key('heart-settings-entry'),
            label: copy('Ajustes do coração', 'Heart settings'),
            icon: Icons.settings_outlined,
            onTap: _settings,
            divider: false,
          ),
          if (data.unavailable.isNotEmpty)
            Text(
              copy(
                'Alguns dados não puderam ser carregados. Puxe para atualizar.',
                'Some data could not load. Pull to refresh.',
              ),
              style: AppHealthStyle.small,
            ),
        ],
      ),
    );
  }
}
