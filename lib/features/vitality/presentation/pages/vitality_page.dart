import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/auth/auth_session.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/network/api_client.dart';
import '../../../../design_system/design_system.dart';
import '../../../../l10n/app_localizations_context.dart';
import '../../../../shared/widgets/day_strip.dart';
import '../../../../shared/navigation/app_quick_action_navigation.dart';
import '../../../atlas/presentation/pages/atlas_chat_page.dart';
import '../../../diary/data/demo_diary_repository.dart';
import '../../../diary/data/remote_diary_repository.dart';
import '../../../diary/domain/diary_models.dart';
import '../../../diary/presentation/diary_page.dart';
import '../../../diary/presentation/diary_health_sheet.dart';
import '../../../diary/presentation/diary_widgets.dart' show diaryText;
import '../../../heart/domain/heart_models.dart';
import '../../../heart/presentation/pages/heart_page.dart';
import '../../../sleep/presentation/pages/sleep_page.dart';
import '../../application/vitality_controller.dart';
import '../../data/demo_vitality_repository.dart';
import '../../data/remote_vitality_repository.dart';
import '../../domain/vitality_models.dart';
import '../vitality_copy.dart';
import '../widgets/vitality_widgets.dart';
import '../sheets/vitality_detail_sheet.dart';

/// Recovery and Energy share layout, account isolation, and data contracts.
class VitalityPage extends StatefulWidget {
  const VitalityPage({
    required this.kind,
    this.date,
    this.demo,
    this.repository,
    this.diaryRepository,
    this.onDestinationSelected,
    super.key,
  });
  final VitalityKind kind;
  final DateTime? date;
  final bool? demo;
  final VitalityRepository? repository;
  final DiaryRepository? diaryRepository;
  final ValueChanged<int>? onDestinationSelected;
  @override
  State<VitalityPage> createState() => _VitalityPageState();
}

class _VitalityPageState extends State<VitalityPage> {
  late final bool _demo = widget.demo ?? AppConfig.current.demoData;
  late final _controller = VitalityController(
    repository:
        widget.repository ??
        (_demo
            ? DemoVitalityRepository()
            : RemoteVitalityRepository(
                ApiClient.configured(),
                session: AuthSession.instance,
              )),
    kind: widget.kind,
    historyDays: 30,
    date: DateUtils.dateOnly(widget.date ?? DateTime.now()),
    session: AuthSession.instance,
  );
  late final DiaryRepository _diary =
      widget.diaryRepository ??
      (_demo
          ? DemoDiaryRepository()
          : RemoteDiaryRepository(
              ApiClient.configured(),
              session: AuthSession.instance,
            ));
  bool _started = false, _more = false;
  final _moreKey = GlobalKey();
  final _historyWindow = AppHealthHistory();
  Rect? _origin;
  bool get _recovery => widget.kind == VitalityKind.recovery;
  bool get _busy => _controller.saving;
  int get _day =>
      vitalityDayDistance(DateTime.now(), _controller.date).clamp(0, 364);
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_started) {
      _started = true;
      scheduleMicrotask(_controller.load);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _diary.dispose();
    super.dispose();
  }

  Future<void> _changeDate(int day) async {
    if (_busy) return;
    await _controller.load(date: vitalityShiftDay(DateTime.now(), -day));
  }

  Future<void> _journal({String? tracker}) async {
    if (_busy) return;
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => DiaryPage(
          repository: _diary,
          date: _controller.date,
          openRecord: tracker != null,
          initialTracker: tracker,
        ),
      ),
    );
  }

  Future<void> _detail({String? metric}) async {
    final snapshot = _controller.snapshot;
    if (snapshot == null || _busy) return;
    await showAppContentSheet<void>(
      context,
      (_) => VitalityAccountGuard(
        controller: _controller,
        child: VitalityDetailSheet(
          controller: _controller,
          snapshot: snapshot,
          color: _recovery
              ? AppVitalityStyle.recovery
              : AppVitalityStyle.energy,
          metric: metric,
        ),
      ),
      glass: true,
    );
  }

  Future<void> _metric(String key) async {
    if (_busy) return;
    final metric = switch (key) {
      'hrvMs' => HeartMetric.hrv,
      'restingHeartRate' => HeartMetric.resting,
      'respiratoryRate' => HeartMetric.respiration,
      _ => null,
    };
    if (key == 'sleepMinutes') {
      await Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (_) => SleepPage(date: _controller.date, demo: _demo),
        ),
      );
    } else if (metric != null) {
      await Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (_) => HeartPage(
            date: _controller.date,
            demo: _demo,
            initialMetric: metric,
          ),
        ),
      );
    } else {
      await _detail(metric: key);
    }
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _controller,
    builder: (c, _) {
      final l = c.l10n;
      return PopScope(
        canPop: !_busy && !_more,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop && _more) setState(() => _more = false);
        },
        child: Stack(
          children: [
            Scaffold(
              backgroundColor: const Color(0xFF030504),
              extendBody: true,
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
                        title: Text(
                          vitalityTitle(c, widget.kind),
                          style: AppVitalityStyle.body.copyWith(
                            color: AppColors.textPrimary,
                            fontSize: 17,
                          ),
                        ),
                        leading: IconButton(
                          tooltip: MaterialLocalizations.of(
                            c,
                          ).backButtonTooltip,
                          onPressed: _busy ? null : () => Navigator.maybePop(c),
                          icon: const AppSvgIcon(
                            'assets/icons/site/vitality-back.svg',
                            size: 22,
                          ),
                        ),
                      ),
                      IgnorePointer(
                        ignoring: _busy,
                        child: DayStrip(
                          day: _day,
                          daysCount: 365,
                          onDayChanged: _changeDate,
                        ),
                      ),
                      Expanded(
                        child: _controller.accountChanged
                            ? Center(
                                child: Text(
                                  l.vitalityAccountChanged,
                                  style: AppVitalityStyle.body,
                                ),
                              )
                            : _controller.loading
                            ? const Center(child: AppLoadingIndicator())
                            : _controller.error != null &&
                                  _controller.snapshot == null
                            ? Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      l.vitalityLoadingFailed,
                                      style: AppVitalityStyle.body,
                                    ),
                                    const SizedBox(height: 16),
                                    AppGlassPill(
                                      label: l.vitalityRetry,
                                      onPressed: _controller.load,
                                    ),
                                  ],
                                ),
                              )
                            : RefreshIndicator(
                                onRefresh: _controller.load,
                                child: ListView(
                                  key: const Key('vitality-content'),
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  padding: const EdgeInsets.fromLTRB(
                                    AppHealthStyle.edge,
                                    14,
                                    AppHealthStyle.edge,
                                    140,
                                  ),
                                  children: _controller.snapshot == null
                                      ? []
                                      : _content(_controller.snapshot!),
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
                onDestinationSelected: (i) {
                  if (_busy) return;
                  if (widget.onDestinationSelected != null) {
                    widget.onDestinationSelected!(i);
                  } else if (i == 1) {
                    AtlasOverlayScope.show(c);
                  } else {
                    Navigator.maybePop(c);
                  }
                },
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
                    if (AppQuickActionNavigation.open(
                      c,
                      action,
                      demo: _demo,
                      date: _controller.date,
                    )) {
                      return;
                    }
                    if (action == AppQuickAction.dayReview ||
                        action == AppQuickAction.meal) {
                      unawaited(
                        _journal(
                          tracker: action == AppQuickAction.meal
                              ? 'almoco'
                              : null,
                        ),
                      );
                    } else {
                      AppNotice.show(
                        c,
                        kind: AppNoticeKind.info,
                        message: c.l10n.comingSoon(
                          action.localizedLabel(c.l10n).replaceAll('\n', ' '),
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

  List<Widget> _content(VitalitySnapshot data) {
    final l = context.l10n;
    final score = data.score;
    final low = data.baselineLow;
    final high = data.baselineHigh;
    final below = score != null && low != null && score < low;
    final above = score != null && high != null && score > high;
    final needsAttention =
        below || (score != null && low == null && score < 67);
    final status = score == null
        ? l.vitalityMissing
        : below
        ? l.vitalityLow
        : above
        ? l.vitalityGood
        : low != null
        ? l.vitalityNormal
        : vitalityStatus(context, score);
    final title = score == null
        ? l.vitalityNoData
        : _recovery
        ? (needsAttention ? l.vitalityRecoveryLow : l.vitalityRecoveryReady)
        : (needsAttention ? l.vitalityEnergyLow : l.vitalityEnergyReady);
    final main = _recovery
        ? [
            'trainingLoad',
            'sleepDebtMinutes',
            'yesterdayStress',
            'todayTrainingLoad',
          ]
        : ['stressScore', 'restingHeartRate', 'vo2Max', 'todayTrainingLoad'];
    final signals = _recovery
        ? [
            'hrvMs',
            'restingHeartRate',
            'respiratoryRate',
            'sleepMinutes',
            'temperatureDeviation',
          ]
        : ['steps', 'activeMinutes', 'calories', 'sleepMinutes'];
    Object? value(String key) =>
        key == 'trainingLoad' ? data.trainingLoad : data.metrics[key];
    String formatted(String key) =>
        vitalityMetricValue(context, key, value(key));
    final directions = _recovery
        ? <(IconData, String)>[
            (
              Icons.bedtime_outlined,
              diaryText(
                context,
                'Priorize o horário de dormir',
                'Keep your planned bedtime',
              ),
            ),
            (
              Icons.directions_walk_outlined,
              diaryText(
                context,
                'Prefira movimento leve',
                'Choose light movement',
              ),
            ),
            (
              Icons.coffee_outlined,
              diaryText(
                context,
                'Evite cafeína no fim da tarde',
                'Avoid caffeine late in the day',
              ),
            ),
          ]
        : <(IconData, String)>[
            (
              Icons.schedule_outlined,
              diaryText(
                context,
                'Reserve tempo para o mais importante',
                'Make time for what matters most',
              ),
            ),
            (
              Icons.coffee_outlined,
              diaryText(
                context,
                'Prefira café mais cedo',
                'Have coffee earlier in the day',
              ),
            ),
            (
              Icons.light_mode_outlined,
              diaryText(
                context,
                'Faça uma pausa ao ar livre',
                'Take a break outdoors',
              ),
            ),
          ];
    return [
      AppHealthHero(
        value: vitalityNumber(context, score),
        valueKey: const Key('vitality-score'),
        label: _recovery
            ? diaryText(context, 'Nota de recuperação', 'Recovery score')
            : diaryText(context, 'Nota de energia', 'Energy score'),
        status: status,
        color: score == null
            ? AppColors.textMuted
            : below || score < 67 && low == null
            ? AppHealthStyle.attention
            : AppHealthStyle.positive,
      ),
      const SizedBox(height: 24),
      Text(title, style: AppHealthStyle.title),
      const SizedBox(height: 8),
      Text(
        score == null
            ? diaryText(
                context,
                'Sincronize a pulseira para acompanhar suas leituras.',
                'Sync your band to see your readings.',
              )
            : _recovery
            ? l.vitalityRecoveryAnalysis
            : l.vitalityEnergyAnalysis,
        style: AppHealthStyle.body,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
      const SizedBox(height: 7),
      Text(
        data.demo ? l.vitalityDemo : l.vitalityEstimated,
        style: AppHealthStyle.small,
      ),
      const SizedBox(height: 30),
      AppHealthTrend(
        key: const Key('vitality-trend'),
        points: _historyWindow.resolve([
          for (final point in data.trend) (date: point.at, value: point.score),
        ], data.date),
        selected: data.date,
        minimum: 0,
        maximum: 100,
        low: low,
        high: high,
        rangeLabel: l.vitalityNormal,
        emptyLabel: l.vitalityNoData,
        onSelected: (date) => _changeDate(
          vitalityDayDistance(DateTime.now(), date).clamp(0, 364),
        ),
      ),
      const SizedBox(height: 18),
      DiaryHealthEntry(
        topic: _recovery ? DiaryHealthTopic.recovery : DiaryHealthTopic.energy,
        repository: _diary,
        date: data.date,
        title: vitalityTitle(context, data.kind),
        subtitle: _recovery
            ? diaryText(
                context,
                'Recuperação, bebida, sono, sintomas e estresse',
                'Recovery, drinks, sleep, symptoms and stress',
              )
            : diaryText(
                context,
                'Café, água, comida, sol, pausas e disposição',
                'Coffee, water, meals, sunlight, breaks and energy',
              ),
      ),
      if (_day == 0 && score != null) ...[
        const SizedBox(height: AppHealthStyle.sectionGap),
        AppHealthSection(
          diaryText(context, 'Direção do dia', 'Direction for today'),
          Icons.explore_outlined,
        ),
        const SizedBox(height: 8),
        for (final (icon, label) in directions)
          AppHealthRow(label: label, icon: icon),
      ],
      const SizedBox(height: AppHealthStyle.sectionGap),
      AppHealthSection(l.vitalityMetrics, Icons.grid_view_outlined),
      const SizedBox(height: AppHealthStyle.gap),
      AppHealthMetricGrid(
        children: [
          for (final key in main)
            AppHealthMetric(
              label: vitalityMetricName(context, key),
              value: formatted(key),
              unit: vitalityMetricUnit(key),
              icon: _signalIcon(key),
            ),
        ],
      ),
      const SizedBox(height: AppHealthStyle.sectionGap),
      AppHealthSection(l.vitalitySignals, Icons.monitor_heart_outlined),
      const SizedBox(height: AppHealthStyle.gap),
      AppHealthPanel(
        child: Column(
          children: [
            for (final (index, key) in signals.indexed)
              AppHealthRow(
                label: vitalityMetricName(context, key),
                icon: _signalIcon(key),
                value: formatted(key) == '—'
                    ? '—'
                    : '${formatted(key)} ${vitalityMetricUnit(key)}'.trim(),
                onTap: () => _metric(key),
                divider: index != signals.length - 1,
              ),
          ],
        ),
      ),
    ];
  }

  IconData _signalIcon(String key) => switch (key) {
    'sleepMinutes' || 'sleepDebtMinutes' => Icons.bedtime_outlined,
    'restingHeartRate' || 'hrvMs' => Icons.monitor_heart_outlined,
    'temperatureDeviation' => Icons.thermostat_outlined,
    'steps' || 'activeMinutes' => Icons.directions_walk_outlined,
    'calories' => Icons.local_fire_department_outlined,
    'trainingLoad' || 'todayTrainingLoad' => Icons.bolt_outlined,
    'respiratoryRate' || 'vo2Max' => Icons.air_outlined,
    _ => Icons.speed_outlined,
  };
}
