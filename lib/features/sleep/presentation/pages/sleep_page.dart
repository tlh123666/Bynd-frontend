import 'package:flutter/foundation.dart';
import '../../../device/application/device_scope.dart';
import '../../../device/presentation/pages/device_management_page.dart';
import '../../application/band_sleep_sync.dart';
import 'dart:math' as math;
import '../../../diary/data/demo_diary_repository.dart';
import '../../../diary/data/remote_diary_repository.dart';
import '../../../diary/domain/diary_models.dart';
import '../widgets/sleep_habits_card.dart';
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
import '../widgets/sleep_widgets.dart';
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
  bool _habitsSaving = false, _syncing = false;
  ApiClient? _syncClient;
  BandSleepSync? _sync;
  int _habitsVersion = 0;
  String? _locale;
  final _moreKey = GlobalKey();
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
    if (_syncing || _habitsSaving) return;
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
            'Sleep sync completed.',
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        AppNotice.show(
          context,
          kind: AppNoticeKind.error,
          message: sleepText(
            context,
            'Não foi possível sincronizar. Aproxime a pulseira e tente novamente.',
            'Could not sync. Bring your band closer and retry.',
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _syncing = false);
    }
  }

  Future<void> _metric(SleepMetric metric) async {
    if (_habitsSaving || _syncing || _controller.saving) return;
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

  Future<void> _preferences({bool planner = false}) async {
    if (_habitsSaving || _syncing || _controller.saving) return;
    if (_controller.snapshot == null) return;
    final previousTarget = _controller.snapshot!.preferences.target;
    await showAppContentSheet<void>(
      context,
      (_) => SleepAccountGuard(
        controller: _controller,
        child: SleepPreferencesSheet(controller: _controller, planner: planner),
      ),
      glass: true,
    );
    if (mounted &&
        !_controller.accountChanged &&
        previousTarget != _controller.snapshot?.preferences.target) {
      await _controller.load(locale: _locale!);
    }
  }

  Future<void> _journal({bool meal = false}) async {
    if (_controller.saving || _habitsSaving || _syncing) return;
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
    if (mounted) setState(() => _habitsVersion++);
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
        canPop: !_more && !c.saving && !_habitsSaving && !_syncing,
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
                  gradient: AppSleepStyle.background,
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
                          onPressed: c.saving || _habitsSaving || _syncing
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
                            fontSize: 19,
                          ),
                        ),
                        trailing: IconButton(
                          tooltip: sleepText(
                            context,
                            'Ajustes do sono',
                            'Sleep settings',
                          ),
                          onPressed:
                              data == null ||
                                  c.saving ||
                                  _habitsSaving ||
                                  _syncing
                              ? null
                              : () => _preferences(),
                          icon: const AppSvgIcon(
                            AppSvgAssets.sleepSettings,
                            size: 19,
                          ),
                        ),
                      ),
                      IgnorePointer(
                        ignoring: c.saving || _habitsSaving || _syncing,
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
                                    if (_habitsSaving || _syncing || c.saving) {
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
                  if (c.saving || _habitsSaving || _syncing) return;
                  if (i == 0) {
                    Navigator.popUntil(context, (r) => r.isFirst);
                  } else if (i == 1) {
                    Navigator.of(context).push(AtlasSheetRoute());
                  }
                },
                onMorePressed: () {
                  if (c.saving || _habitsSaving || _syncing) return;
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
    final session = data.session;
    final children = <Widget>[
      if (!kIsWeb &&
          defaultTargetPlatform == TargetPlatform.android &&
          !(widget.demo ?? (widget.config ?? AppConfig.current).demoData)) ...[
        Padding(
          padding: const EdgeInsets.only(bottom: 22),
          child: AppButton(
            label: sleepText(context, 'Sincronizar pulseira', 'Sync band'),
            onPressed: _syncing ? null : _syncBand,
            loading: _syncing,
            variant: AppButtonVariant.secondary,
          ),
        ),
      ],

      if (!data.hasNight) ...[
        Text(
          sleepText(
            context,
            'Não conseguimos ler o seu sono nessa noite.',
            'No sleep was recorded for this night.',
          ),
          style: AppSleepStyle.title,
        ),
        const SizedBox(height: 14),
        Text(
          sleepText(
            context,
            'Sincronize a pulseira. Só mostramos dados de sono registrados pelo seu dispositivo.',
            'Sync your band. This page only shows sleep recorded by your device.',
          ),
          style: AppSleepStyle.body,
        ),
      ] else ...[
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(data.format(SleepMetric.score), style: AppSleepStyle.score),
            const SizedBox(width: 12),
            Padding(
              padding: const EdgeInsets.only(bottom: 7),
              child: Text(
                data.value(SleepMetric.score) == null
                    ? sleepText(context, 'SEM NOTA', 'NO SCORE')
                    : (data.value(SleepMetric.score)! >= 85
                          ? sleepText(context, 'ÓTIMA', 'GREAT')
                          : data.value(SleepMetric.score)! >= 78
                          ? sleepText(context, 'BOA', 'GOOD')
                          : data.value(SleepMetric.score)! >= 76
                          ? sleepText(context, 'NORMAL', 'NORMAL')
                          : sleepText(context, 'ATENÇÃO', 'LOW')),
                style: AppSleepStyle.kicker.copyWith(
                  color: (data.value(SleepMetric.score) ?? 0) >= 78
                      ? AppSleepStyle.levelGood
                      : (data.value(SleepMetric.score) ?? 0) >= 76
                      ? AppSleepStyle.levelNormal
                      : AppSleepStyle.levelLow,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          '${sleepText(context, 'nesta noite', 'this night')} · ${sleepNightDate(context, data.date)}',
          style: AppSleepStyle.caption,
        ),
        const SizedBox(height: 16),
        Text(
          '${data.insight['title'] ?? sleepText(context, 'Sua noite, em perspectiva.', 'Your night in perspective.')}',
          style: AppSleepStyle.title,
        ),
        if (data.insight['body'] is String) ...[
          const SizedBox(height: 14),
          SleepExpandable(data.insight['body'] as String),
        ],
        const SizedBox(height: 24),
        SleepCard(
          onTap: () => _metric(SleepMetric.duration),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SleepLabel(
                sleepMetricTitle(context, SleepMetric.duration),
                chevron: true,
              ),
              const SizedBox(height: 12),
              Text(
                data.format(SleepMetric.duration),
                style: AppSleepStyle.value,
              ),
              const SizedBox(height: 4),
              Text(
                '${sleepText(context, 'Duração total', 'Total duration')} ${sleepDuration(session!.duration)}',
                style: AppSleepStyle.caption,
              ),
              if (data.preferences.show('showStages'))
                SleepStageChart(
                  session: session,
                  vitals: data.vitals,
                  compact: true,
                ),
              if (session.quality == 'partial')
                Text(
                  sleepText(
                    context,
                    'Registro parcial: há intervalos sem leitura.',
                    'Partial record: some intervals were not measured.',
                  ),
                  style: AppSleepStyle.caption,
                ),
            ],
          ),
        ),
      ],
      const SizedBox(height: 40),
      SleepLabel(
        sleepText(context, 'Direção para esta noite', 'Direction for tonight'),
      ),
      const SizedBox(height: 14),
      Text(
        '${sleepText(context, 'Deite às', 'Bedtime')} ${sleepClock(data.preferences.bedtime)}.',
        style: AppSleepStyle.title,
      ),
      const SizedBox(height: 12),
      Text(
        sleepText(
          context,
          'Seu horário escolhido para desacelerar e preparar a noite.',
          'Your chosen time to wind down and prepare for the night.',
        ),
        style: AppSleepStyle.body,
      ),
      if (data.preferences.show('showBiologicalClock')) ...[
        const SizedBox(height: 20),
        SleepCard(
          onTap: () => _preferences(planner: true),
          child: Column(
            children: [
              SleepLabel(
                sleepText(context, 'Planejador de sono', 'Sleep planner'),
                chevron: true,
              ),
              const SizedBox(height: 12),
              CustomPaint(
                size: const Size(280, 150),
                painter: SleepClockPainter(
                  data.preferences.bedtime,
                  data.preferences.wake,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        sleepClock(data.preferences.bedtime),
                        style: AppSleepStyle.value,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.nights_stay_outlined,
                    color: AppColors.textMuted,
                  ),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        sleepClock(data.preferences.wake),
                        style: AppSleepStyle.value,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
      const SizedBox(height: 40),
      Text(
        sleepText(context, 'Principais métricas', 'Key metrics'),
        style: AppSleepStyle.title,
      ),
      const SizedBox(height: 10),
      Text(
        sleepText(
          context,
          'O que ficou para recuperar e como o seu corpo passou a noite.',
          'Your recorded sleep and the signals measured overnight.',
        ),
        style: AppSleepStyle.body,
      ),
      const SizedBox(height: 20),
      LayoutBuilder(
        builder: (context, box) {
          final metrics = [
            SleepMetric.debt,
            SleepMetric.restlessness,
            if (data.preferences.show('showRespiration'))
              SleepMetric.respiration,
            SleepMetric.nap,
          ];
          return Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final m in metrics)
                SizedBox(
                  width: box.maxWidth < 280
                      ? box.maxWidth
                      : (box.maxWidth - 10) / 2,
                  child: SleepCard(
                    onTap: () => _metric(m),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SleepLabel(sleepMetricTitle(context, m), chevron: true),
                        const SizedBox(height: 20),
                        Text(
                          m == SleepMetric.respiration
                              ? data.format(SleepMetric.oxygen)
                              : data.format(m),
                          style: AppSleepStyle.value.copyWith(fontSize: 22),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          sleepText(
                            context,
                            m == SleepMetric.debt
                                ? data.summary['sleepDebtNights'] == null
                                      ? 'últimos 7 dias'
                                      : '${data.summary['sleepDebtNights']} noites com leitura'
                                : m == SleepMetric.restlessness
                                ? 'despertares registrados'
                                : m == SleepMetric.respiration
                                ? 'oxigênio medido'
                                : 'neste dia',
                            m == SleepMetric.debt
                                ? data.summary['sleepDebtNights'] == null
                                      ? 'last 7 days'
                                      : '${data.summary['sleepDebtNights']} measured nights'
                                : m == SleepMetric.restlessness
                                ? 'recorded awakenings'
                                : m == SleepMetric.respiration
                                ? 'measured oxygen'
                                : 'on this day',
                          ),
                          style: AppSleepStyle.caption,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
      const SizedBox(height: 36),
      Text(
        sleepText(
          context,
          'Seu sono ao longo dos dias',
          'Your sleep over time',
        ),
        style: AppSleepStyle.title,
      ),
      const SizedBox(height: 18),
      SleepCard(
        onTap: () => _metric(SleepMetric.score),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SleepLabel(
              sleepMetricTitle(context, SleepMetric.score),
              chevron: true,
            ),
            const SizedBox(height: 12),
            Text(
              data.trend.average('sleepScore')?.round().toString() ?? '—',
              style: AppSleepStyle.value,
            ),
            Text(
              sleepText(
                context,
                'média dos dias registrados',
                'average of measured days',
              ),
              style: AppSleepStyle.caption,
            ),
            const SizedBox(height: 18),
            SleepHistoryChart(trend: data.trend, field: 'sleepScore'),
          ],
        ),
      ),
      const SizedBox(height: 36),
      Text(sleepText(context, 'Hábitos', 'Habits'), style: AppSleepStyle.title),
      const SizedBox(height: 12),
      SleepHabitsCard(
        key: ValueKey('sleep-habits-${sleepDate(data.date)}-$_habitsVersion'),
        repository: _diary,
        date: data.date,
        onBusyChanged: (busy) {
          if (mounted) setState(() => _habitsSaving = busy);
        },
      ),
      const SizedBox(height: 12),
      SleepCard(
        onTap: () => _journal(),
        child: Row(
          children: [
            const Icon(Icons.menu_book_outlined, color: AppColors.textMuted),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                sleepText(
                  context,
                  'Registrar hábitos no Diário',
                  'Record habits in your diary',
                ),
                style: AppSleepStyle.body,
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
      const SizedBox(height: 32),
      Text(
        sleepText(context, 'Sinais desta leitura', 'Signals in this view'),
        style: AppSleepStyle.title,
      ),
      for (final m in [
        SleepMetric.heartRate,
        SleepMetric.hrv,
        SleepMetric.oxygen,
        SleepMetric.temperature,
      ])
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(sleepMetricTitle(context, m), style: AppSleepStyle.body),
          trailing: Text(data.format(m), style: AppSleepStyle.caption),
          onTap: () => _metric(m),
        ),
      TextButton(
        onPressed: () => Navigator.of(context).push(AtlasSheetRoute()),
        child: Text(
          sleepText(
            context,
            'Perguntar ao Atlas sobre esta noite →',
            'Ask Atlas about this night →',
          ),
        ),
      ),
      if (data.unavailable.isNotEmpty)
        Text(
          sleepText(
            context,
            'Alguns dados não puderam ser carregados. Puxe para atualizar.',
            'Some data could not be loaded. Pull to refresh.',
          ),
          style: AppSleepStyle.caption,
        ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children
          .map(
            (child) => child is SleepCard
                ? child
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: child,
                  ),
          )
          .toList(),
    );
  }
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
