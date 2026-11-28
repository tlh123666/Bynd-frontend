import '../../../../shared/navigation/app_quick_action_navigation.dart';
import 'package:flutter/foundation.dart';
import '../../../device/application/device_scope.dart';
import '../../../device/presentation/pages/device_management_page.dart';
import '../../application/band_sleep_sync.dart';
import 'dart:math' as math;
import '../../../diary/data/demo_diary_repository.dart';
import '../../../diary/data/remote_diary_repository.dart';
import '../../../diary/domain/diary_models.dart';
import '../widgets/sleep_night_tracks.dart';
import '../../../diary/presentation/diary_health_sheet.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/auth/auth_session.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/network/api_client.dart';
import '../../../../design_system/design_system.dart';
import '../../../../shared/widgets/day_strip.dart';
import '../../../atlas/presentation/pages/atlas_chat_page.dart';
import '../../../diary/presentation/diary_page.dart';
import '../../application/sleep_controller.dart';
import '../../data/demo_sleep_repository.dart';
import '../../data/remote_sleep_repository.dart';
import '../../domain/sleep_models.dart';
import '../sleep_copy.dart';
import '../sheets/sleep_metric_sheet.dart';
import '../sheets/sleep_preferences_sheet.dart';

class SleepPage extends StatefulWidget {
  const SleepPage({
    this.date,
    this.repository,
    this.config,
    this.demo,
    this.diaryRepository,
    super.key,
  });
  final DateTime? date;
  final SleepRepository? repository;
  final AppConfig? config;
  final bool? demo;
  final DiaryRepository? diaryRepository;
  @override
  State<SleepPage> createState() => _SleepPageState();
}

class _SleepPageState extends State<SleepPage> {
  late final SleepController _controller;
  late final DiaryRepository _diary;
  bool _syncing = false;
  ApiClient? _syncClient;
  BandSleepSync? _sync;
  String? _locale;
  final _moreKey = GlobalKey();
  final _historyWindow = AppHealthHistory();
  Rect? _origin;
  bool _more = false;
  @override
  void initState() {
    super.initState();
    final config = widget.config ?? AppConfig.current;
    _diary =
        widget.diaryRepository ??
        ((widget.demo ?? config.demoData)
            ? DemoDiaryRepository()
            : RemoteDiaryRepository(
                ApiClient.configured(config: config),
                session: AuthSession.instance,
              ));
    _controller = SleepController(
      date: widget.date ?? DateUtils.dateOnly(DateTime.now()),
      session: AuthSession.instance,
      repository:
          widget.repository ??
          ((widget.demo ?? config.demoData)
              ? DemoSleepRepository()
              : RemoteSleepRepository(
                  ApiClient.configured(config: config),
                  session: AuthSession.instance,
                )),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = Localizations.localeOf(context).toLanguageTag();
    if (_locale != locale) {
      _locale = locale;
      scheduleMicrotask(() => _controller.load(locale: locale));
    }
  }

  @override
  void dispose() {
    _syncClient?.close();
    _controller.dispose();
    if (widget.diaryRepository == null) _diary.dispose();
    super.dispose();
  }

  Future<void> _syncBand() async {
    if (_syncing) return;
    final devices = DeviceScope.maybeOf(context);
    if (devices?.device?.connected != true) {
      await Navigator.push(
        context,
        MaterialPageRoute<void>(builder: (_) => const DeviceManagementPage()),
      );
      return;
    }
    if (devices!.busy || devices.loading) return;
    setState(() => _syncing = true);
    try {
      _syncClient ??= ApiClient.configured(config: widget.config);
      _sync ??= BandSleepSync(_syncClient!);
      final n = await _sync!.sync(devices.device!);
      if (!mounted) return;
      await _controller.load(locale: _locale!);
      if (mounted) {
        AppNotice.show(
          context,
          kind: AppNoticeKind.success,
          message: sleepText(
            context,
            n > 0 ? 'Sono sincronizado.' : 'Nenhum novo registro de sono.',
            n > 0 ? 'Sleep synced.' : 'No new sleep records.',
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        final partial = e is ApiException && e.code == 'partial_sleep_sync';
        AppNotice.show(
          context,
          kind: AppNoticeKind.error,
          message: sleepText(
            context,
            partial
                ? 'A sincronização do sono ficou incompleta. Aproxime a pulseira e tente novamente.'
                : 'Não foi possível sincronizar. Aproxime a pulseira e tente novamente.',
            partial
                ? 'Sleep sync was incomplete. Bring your band closer and retry.'
                : 'Could not sync. Bring your band closer and retry.',
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _syncing = false);
    }
  }

  Future<void> _metric(SleepMetric metric) async {
    if (_syncing || _controller.saving) return;
    final data = _controller.snapshot;
    if (data == null) return;
    final date = await showAppContentSheet<DateTime>(
      context,
      (_) => SleepAccountGuard(
        controller: _controller,
        child: SleepMetricSheet(
          controller: _controller,
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

  Future<void> _preferences() async {
    if (_syncing || _controller.saving) return;
    if (_controller.snapshot == null) return;
    final previousTarget = _controller.snapshot!.preferences.target;
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: AppHealthStyle.canvas,
          body: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: AppHealthStyle.background,
            ),
            child: SafeArea(
              child: SleepAccountGuard(
                controller: _controller,
                child: SleepPreferencesSheet(controller: _controller),
              ),
            ),
          ),
        ),
      ),
    );
    if (mounted &&
        !_controller.accountChanged &&
        previousTarget != _controller.snapshot?.preferences.target) {
      await _controller.load(locale: _locale!);
    }
  }

  Future<void> _journal({bool meal = false}) async {
    if (_controller.saving || _syncing) return;
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

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _controller,
    builder: (context, _) {
      final c = _controller, data = c.snapshot;
      final now = DateTime.now();
      final selected = DateTime.utc(c.date.year, c.date.month, c.date.day);
      final day = DateTime.utc(
        now.year,
        now.month,
        now.day,
      ).difference(selected).inDays.clamp(0, 364);
      return PopScope(
        canPop: !_more && !c.saving && !_syncing,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop && _more) setState(() => _more = false);
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            Scaffold(
              extendBody: true,
              backgroundColor: AppColors.homeCanvas,
              body: DecoratedBox(
                decoration: const BoxDecoration(
                  gradient: AppHealthStyle.background,
                ),
                child: SafeArea(
                  bottom: false,
                  minimum: const EdgeInsets.only(top: 31),
                  child: Column(
                    children: [
                      AppPageHeader(
                        height: 49,
                        padding: EdgeInsets.zero,
                        leading: IconButton(
                          tooltip: MaterialLocalizations.of(
                            context,
                          ).backButtonTooltip,
                          onPressed: c.saving || _syncing
                              ? null
                              : () => Navigator.maybePop(context),
                          icon: const AppSvgIcon(
                            AppSvgAssets.sleepBack,
                            size: 24,
                          ),
                        ),
                        title: Text(
                          sleepText(context, 'Sono', 'Sleep'),
                          style: AppSleepStyle.body.copyWith(
                            color: AppColors.textPrimary,
                            fontSize: 17,
                          ),
                        ),
                        trailing: IconButton(
                          tooltip: sleepText(
                            context,
                            'Ajustes do sono',
                            'Sleep settings',
                          ),
                          onPressed: data == null || c.saving || _syncing
                              ? null
                              : () => _preferences(),
                          icon: const AppSvgIcon(
                            AppSvgAssets.sleepSettings,
                            size: 19,
                          ),
                        ),
                      ),
                      IgnorePointer(
                        ignoring: c.saving || _syncing,
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
                        child: SleepAccountGuard(
                          controller: c,
                          child: c.loading
                              ? const Center(child: AppLoadingIndicator())
                              : data == null
                              ? Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(24),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          sleepText(
                                            context,
                                            'Não foi possível carregar o sono.',
                                            'Could not load sleep data.',
                                          ),
                                          style: AppSleepStyle.body,
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 16),
                                        AppGlassPill(
                                          label: sleepText(
                                            context,
                                            'Tentar novamente',
                                            'Retry',
                                          ),
                                          onPressed: () =>
                                              c.load(locale: _locale!),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : RefreshIndicator(
                                  onRefresh: () async {
                                    if (_syncing || c.saving) {
                                      return;
                                    }
                                    await c.load(locale: _locale!);
                                  },
                                  child: SingleChildScrollView(
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    padding: const EdgeInsets.fromLTRB(
                                      0,
                                      34,
                                      0,
                                      150,
                                    ),
                                    child: _content(context, data),
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: AppBottomNav(
                selectedIndex: null,
                moreButtonKey: _moreKey,
                moreOpen: _more,
                onDestinationSelected: (i) {
                  if (c.saving || _syncing) return;
                  if (i == 0) {
                    Navigator.popUntil(context, (r) => r.isFirst);
                  } else if (i == 1) {
                    AtlasOverlayScope.show(context);
                  }
                },
                onMorePressed: () {
                  if (c.saving || _syncing) return;
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
                    if (AppQuickActionNavigation.open(
                      context,
                      action,
                      demo: widget.demo,
                      date: _controller.date,
                    )) {
                      return;
                    }
                    if (action == AppQuickAction.dayReview ||
                        action == AppQuickAction.meal) {
                      _journal(meal: action == AppQuickAction.meal);
                    }
                  },
                ),
              ),
          ],
        ),
      );
    },
  );
  Widget _content(BuildContext context, SleepSnapshot data) {
    String copy(String pt, String en) => sleepText(context, pt, en);
    final session = data.session;
    final score = data.value(SleepMetric.score);
    final notes = data.insight['body'];
    final title = data.insight['title'];
    final showStages = data.preferences.show('showStages');
    final metrics = [
      if (data.preferences.show('showSleepDebt')) SleepMetric.debt,
      SleepMetric.restlessness,
      if (data.preferences.show('showRespiration')) SleepMetric.oxygen,
      if (data.preferences.show('showNaps')) SleepMetric.nap,
    ];
    final signals = [
      SleepMetric.restingHeartRate,
      SleepMetric.hrv,
      if (data.preferences.show('showRespiration')) SleepMetric.oxygen,
    ];
    final points = <AppHealthPoint>[
      for (final row in data.trend.days)
        if (DateTime.tryParse('${row['statDate'] ?? row['date']}')
            case final DateTime date)
          (
            date: date,
            value: row['hasData'] == true ? row['sleepScore'] as num? : null,
          ),
    ];
    final scoreStatus = score == null
        ? copy('Sem nota', 'No score')
        : score >= 85
        ? copy('Ótima', 'Great')
        : score >= 70
        ? copy('Boa', 'Good')
        : score >= 60
        ? copy('Regular', 'Fair')
        : copy('Ruim', 'Low');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppHealthStyle.edge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppHealthHero(
            value: data.format(SleepMetric.score),
            label: copy('Nota do sono', 'Sleep score'),
            status: scoreStatus,
            color: score == null
                ? AppColors.textMuted
                : score >= 70
                ? AppHealthStyle.positive
                : score >= 60
                ? AppHealthStyle.attention
                : AppHealthStyle.low,
          ),
          const SizedBox(height: 24),
          Text(
            !data.hasNight
                ? copy('Nenhuma noite registrada.', 'No night recorded.')
                : title is String && title.isNotEmpty
                ? title
                : copy(
                    'Sua noite, em perspectiva.',
                    'Your night in perspective.',
                  ),
            style: AppHealthStyle.title,
          ),
          const SizedBox(height: 8),
          if (notes is String && notes.isNotEmpty)
            Text(
              notes,
              style: AppHealthStyle.body,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            )
          else if (session == null)
            Text(
              copy(
                'Sincronize sua pulseira para ver o sono registrado.',
                'Sync your band to see recorded sleep.',
              ),
              style: AppHealthStyle.body,
            ),
          if (!kIsWeb &&
              defaultTargetPlatform == TargetPlatform.android &&
              !(widget.demo ??
                  (widget.config ?? AppConfig.current).demoData)) ...[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: AppButton(
                label: copy('Sincronizar pulseira', 'Sync band'),
                onPressed: _syncing ? null : _syncBand,
                loading: _syncing,
                variant: AppButtonVariant.secondary,
              ),
            ),
          ],
          if (session != null) ...[
            const SizedBox(height: AppHealthStyle.sectionGap),
            AppHealthSection(
              copy('Sua noite', 'Your night'),
              Icons.bedtime_outlined,
            ),
            const SizedBox(height: AppHealthStyle.gap),
            InkWell(
              onTap: () => _metric(SleepMetric.duration),
              child: AppHealthHero(
                value: data.format(SleepMetric.duration),
                label: copy(
                  'dormidas · ${sleepDuration(session.duration)} na cama',
                  'asleep · ${sleepDuration(session.duration)} in bed',
                ),
                status: copy('Tempo de sono', 'Sleep duration'),
              ),
            ),
            if (showStages) ...[
              const SizedBox(height: 14),
              SleepNightTracks(
                key: ValueKey(
                  'sleep-night-${sleepDate(data.date)}-${session.id}',
                ),
                session: session,
              ),
              const SizedBox(height: 12),
              for (final (metric, color) in const [
                (SleepMetric.awake, AppHealthStyle.awake),
                (SleepMetric.light, AppHealthStyle.light),
                (SleepMetric.deep, AppHealthStyle.deep),
                (SleepMetric.rem, AppHealthStyle.rem),
              ])
                _stageRow(data, metric, color),
            ],
            AppHealthRow(
              label: sleepMetricTitle(context, SleepMetric.efficiency),
              value: data.format(SleepMetric.efficiency),
            ),
            AppHealthRow(
              label: sleepMetricTitle(context, SleepMetric.latency),
              value: data.format(SleepMetric.latency),
            ),
            if (session.quality == 'partial')
              Text(
                copy(
                  'Registro parcial: há intervalos sem leitura.',
                  'Partial record: some intervals were not measured.',
                ),
                style: AppHealthStyle.small,
              ),
          ],
          const SizedBox(height: 18),
          DiaryHealthEntry(
            topic: DiaryHealthTopic.sleep,
            repository: _diary,
            date: data.date,
            title: copy('Sono', 'Sleep'),
            subtitle: copy(
              'Café, álcool, telas, quarto e rotina da noite',
              'Coffee, alcohol, screens, bedroom and evening routine',
            ),
          ),
          const SizedBox(height: AppHealthStyle.sectionGap),
          AppHealthSection(
            copy('Principais métricas', 'Key metrics'),
            Icons.grid_view_outlined,
          ),
          const SizedBox(height: AppHealthStyle.gap),
          AppHealthMetricGrid(
            children: [
              for (final metric in metrics)
                AppHealthMetric(
                  label: sleepMetricTitle(context, metric),
                  value: data.format(metric),
                  icon: _icon(metric),
                  caption: metric == SleepMetric.nap && data.value(metric) == 0
                      ? copy('Sem cochilo neste dia', 'No naps on this date')
                      : null,
                ),
            ],
          ),
          if (data.preferences.show('showSleepTrend')) ...[
            const SizedBox(height: AppHealthStyle.sectionGap),
            AppHealthSection(
              copy('Suas noites', 'Your nights'),
              Icons.show_chart,
            ),
            const SizedBox(height: AppHealthStyle.gap),
            AppHealthTrend(
              key: const Key('sleep-score-trend'),
              points: _historyWindow.resolve(points, data.date),
              selected: data.date,
              minimum: 0,
              maximum: 100,
              emptyLabel: data.trend.locked
                  ? copy(
                      'Histórico detalhado disponível no Premium.',
                      'Detailed history is available with Premium.',
                    )
                  : copy(
                      'Sem histórico de notas de sono.',
                      'No sleep score history.',
                    ),
              onSelected: (date) =>
                  _controller.load(date: date, locale: _locale!),
            ),
          ],
          if (data.preferences.show('showSleepSignals')) ...[
            const SizedBox(height: AppHealthStyle.sectionGap),
            AppHealthSection(
              copy('Sinais desta leitura', 'Signals in this reading'),
              Icons.monitor_heart_outlined,
            ),
            const SizedBox(height: AppHealthStyle.gap),
            AppHealthPanel(
              child: Column(
                children: [
                  for (final (index, metric) in signals.indexed)
                    AppHealthRow(
                      label: sleepMetricTitle(context, metric),
                      icon: _icon(metric),
                      value: data.format(metric),
                      onTap: () => _metric(metric),
                      divider: index != signals.length - 1,
                    ),
                ],
              ),
            ),
          ],
          if (data.unavailable.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              copy(
                'Alguns dados não puderam ser carregados. Puxe para atualizar.',
                'Some data could not load. Pull to refresh.',
              ),
              style: AppHealthStyle.small,
            ),
          ],
        ],
      ),
    );
  }

  Widget _stageRow(SleepSnapshot data, SleepMetric metric, Color color) {
    final minutes = data.value(metric);
    final duration = data.session?.duration;
    final ratio = minutes == null || duration == null || duration <= 0
        ? null
        : (minutes / duration).clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppHealthRow(
            label: sleepMetricTitle(context, metric),
            value:
                '${data.format(metric)}${ratio == null ? '' : ' · ${(ratio * 100).round()}%'}',
            divider: false,
          ),
          if (ratio != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: ratio,
                minHeight: 4,
                color: color,
                backgroundColor: AppHealthStyle.divider,
              ),
            ),
        ],
      ),
    );
  }

  IconData _icon(SleepMetric metric) => switch (metric) {
    SleepMetric.heartRate ||
    SleepMetric.restingHeartRate ||
    SleepMetric.hrv => Icons.monitor_heart_outlined,
    SleepMetric.oxygen || SleepMetric.respiration => Icons.air_outlined,
    SleepMetric.temperature => Icons.thermostat_outlined,
    SleepMetric.debt => Icons.schedule_outlined,
    _ => Icons.bedtime_outlined,
  };
}

class SleepAccountGuard extends StatelessWidget {
  const SleepAccountGuard({
    required this.controller,
    required this.child,
    super.key,
  });
  final SleepController controller;
  final Widget child;
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: controller,
    builder: (context, _) => controller.accountChanged
        ? Center(
            child: Text(
              sleepText(
                context,
                'Sua conta mudou. Abra o Sono novamente.',
                'Your account changed. Reopen Sleep.',
              ),
              style: AppSleepStyle.body,
            ),
          )
        : child,
  );
}
