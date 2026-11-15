import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/auth/auth_session.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/network/api_client.dart';
import '../../../../design_system/design_system.dart';
import '../../../../l10n/app_localizations_context.dart';
import '../../../../shared/widgets/day_strip.dart';
import '../../../../shared/widgets/day_calendar.dart';
import '../../../../shared/navigation/app_quick_action_navigation.dart';
import '../../../atlas/presentation/pages/atlas_chat_page.dart';
import '../../../activity/presentation/pages/activity_overview_page.dart';
import '../../../diary/data/demo_diary_repository.dart';
import '../../../diary/data/remote_diary_repository.dart';
import '../../../diary/domain/diary_models.dart';
import '../../../diary/presentation/diary_page.dart';
import '../../../diary/presentation/diary_quick_questions.dart';
import '../../../heart/domain/heart_models.dart';
import '../../../heart/presentation/pages/heart_page.dart';
import '../../../sleep/presentation/pages/sleep_page.dart';
import '../../application/vitality_controller.dart';
import '../../data/demo_vitality_repository.dart';
import '../../data/remote_vitality_repository.dart';
import '../../domain/vitality_models.dart';
import '../vitality_copy.dart';
import '../widgets/vitality_charts.dart';
import '../widgets/vitality_widgets.dart';
import '../sheets/vitality_detail_sheet.dart';
import '../sheets/vitality_settings_sheet.dart';

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
  bool _started = false, _habitsBusy = false, _more = false;
  int _diaryVersion = 0;
  final _moreKey = GlobalKey();
  Rect? _origin;
  bool get _recovery => widget.kind == VitalityKind.recovery;
  bool get _busy => _controller.saving || _habitsBusy;
  Color get _color =>
      _recovery ? AppVitalityStyle.recovery : AppVitalityStyle.energy;
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
    setState(() => _diaryVersion++);
    await _controller.load(date: vitalityShiftDay(DateTime.now(), -day));
  }

  Future<void> _calendar() async {
    final day = await showDayCalendar(
      context: context,
      selectedDay: _day,
      daysCount: 365,
      tone: DayStripTone.neutral,
    );
    if (mounted && day != null) await _changeDate(day);
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
    if (mounted) setState(() => _diaryVersion++);
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
          color: _color,
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

  Future<void> _settings() async {
    final snapshot = _controller.snapshot;
    if (snapshot == null || _busy) return;
    final calendar = await showAppContentSheet<bool>(
      context,
      (_) => VitalityAccountGuard(
        controller: _controller,
        child: VitalitySettingsSheet(
          controller: _controller,
          snapshot: snapshot,
        ),
      ),
      glass: true,
    );
    if (mounted && calendar == true) await _calendar();
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
              body: AppAtmosphereBackground(
                gradient: _recovery
                    ? AppVitalityStyle.recoverySky
                    : AppVitalityStyle.energySky,
                light: _color.withValues(alpha: .04),
                palette: _recovery
                    ? AppVitalityStyle.recoveryPalette
                    : AppVitalityStyle.energyPalette,
                child: SafeArea(
                  bottom: false,
                  minimum: const EdgeInsets.only(top: 51),
                  child: Column(
                    children: [
                      AppPageHeader(
                        height: 49,
                        title: Text(
                          vitalityTitle(c, widget.kind),
                          style: AppVitalityStyle.body.copyWith(
                            color: AppColors.textPrimary,
                            fontSize: 19,
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
                        trailing: IconButton(
                          key: const Key('vitality-settings'),
                          tooltip: l.vitalitySettings,
                          onPressed: _controller.snapshot == null || _busy
                              ? null
                              : _settings,
                          icon: const AppSvgIcon(
                            'assets/icons/site/vitality-settings.svg',
                            size: 19,
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
                                  padding: const EdgeInsets.only(bottom: 140),
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
                    Navigator.push(c, AtlasSheetRoute());
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
                    if (action == AppQuickAction.startActivity) {
                      Navigator.push(
                        c,
                        MaterialPageRoute<void>(
                          builder: (_) => const ActivityOverviewPage(
                            openSelectorOnEnter: true,
                          ),
                        ),
                      );
                    } else if (action == AppQuickAction.dayReview ||
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

  List<Widget> _content(VitalitySnapshot s) {
    final l = context.l10n, score = s.score;
    final title = score == null
        ? l.vitalityNoData
        : _recovery
        ? (score >= 67
              ? l.vitalityRecoveryReady
              : score >= 34
              ? l.vitalityRecoveryLow
              : l.vitalityRecoveryRest)
        : (score >= 67
              ? l.vitalityEnergyReady
              : score >= 34
              ? l.vitalityEnergyLow
              : l.vitalityEnergyRest);
    final mainKeys = _recovery
        ? ['trainingLoad', 'hrvMs', 'restingHeartRate']
        : ['stressScore', 'restingHeartRate', 'vo2Max'];
    final signalKeys = _recovery
        ? [
            'hrvMs',
            'restingHeartRate',
            'temperatureDeviation',
            'respiratoryRate',
            'sleepMinutes',
          ]
        : ['steps', 'activeMinutes', 'calories', 'restingHeartRate'];
    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(22, 29, 22, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.end,
              spacing: 12,
              children: [
                Text(
                  vitalityNumber(context, score),
                  key: const Key('vitality-score'),
                  style: AppVitalityStyle.number,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    vitalityStatus(context, score).toUpperCase(),
                    style: AppVitalityStyle.kicker.copyWith(
                      color: score == null
                          ? AppVitalityStyle.muted
                          : score >= 67
                          ? AppVitalityStyle.good
                          : score >= 34
                          ? AppVitalityStyle.attention
                          : AppVitalityStyle.low,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              '${_day == 0
                  ? '${l.vitalityToday} · '
                  : _day == 1
                  ? '${l.vitalityYesterday.toLowerCase()} · '
                  : ''}${vitalityDateLabel(context, s.date)}',
              style: AppVitalityStyle.caption,
            ),
            const SizedBox(height: 18),
            Text(title, style: AppVitalityStyle.title),
            const SizedBox(height: 12),
            VitalityExpandable(
              _recovery ? l.vitalityRecoveryAnalysis : l.vitalityEnergyAnalysis,
            ),
            if (!s.demo)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  l.vitalityEstimated,
                  style: AppVitalityStyle.caption,
                ),
              ),
          ],
        ),
      ),
      if (s.preferences.flag('lowRecoveryNotice') &&
          _recovery &&
          score != null &&
          score < 34)
        _notice(l.vitalityRecoveryRest),
      if (s.preferences.flag('morningNotice') && _recovery && score != null)
        _notice(
          l.vitalityScoreSummary(
            vitalityNumber(context, score),
            vitalityStatus(context, score),
          ),
        ),
      if (s.preferences.flag('goalNotice') &&
          !_recovery &&
          (vitalityValue(s.metrics['steps']) ?? -1) >= s.preferences.stepGoal)
        _notice(l.vitalityGoalReached),
      if (s.preferences.flag('movementNotice') &&
          !_recovery &&
          s.metrics['activeMinutes'] is num &&
          (s.metrics['activeMinutes'] as num) < s.preferences.activeGoal)
        _notice(l.vitalityMovementHint),
      if (_recovery) _recoveryCard(s) else _energyCard(s),
      if (s.preferences.forecastFor(s.kind))
        Padding(
          padding: const EdgeInsets.only(top: 28),
          child: VitalityForecast(
            snapshot: s,
            color: _color,
            onTap: () => _detail(),
          ),
        ),
      Padding(
        padding: const EdgeInsets.only(top: 30),
        child: DiaryQuickQuestions(
          key: ValueKey(
            'vitality-diary-${vitalityDate(s.date)}-$_diaryVersion',
          ),
          repository: _diary,
          date: s.date,
          onBusyChanged: (v) {
            if (mounted) setState(() => _habitsBusy = v);
          },
          ratingKey: _recovery ? 'acordou' : 'energia',
          ratingQuestion: _recovery
              ? l.vitalityWakeQuestion
              : l.vitalityEnergyQuestion,
          ratingLowLabel: _recovery ? l.vitalityScaleBad : l.vitalityScaleLow,
          ratingHighLabel: _recovery
              ? l.vitalityScaleGood
              : l.vitalityScaleHigh,
          onOpenDiary: _journal,
          questions: _recovery
              ? [
                  ('dor', l.vitalitySoreness, l.vitalitySoreness),
                  ('gripe', l.vitalityFlu, l.vitalityFlu),
                ]
              : [
                  ('c_cafemanha', l.vitalityBreakfast, l.vitalityBreakfast),
                  ('c_cochilo', l.vitalityNap, l.vitalityNap),
                ],
          iconAnswers: true,
          bodyStyle: AppVitalityStyle.body,
          captionStyle: AppVitalityStyle.caption,
          kickerStyle: AppVitalityStyle.kicker,
        ),
      ),
      if (!_recovery || s.preferences.flag('showFactors')) ...[
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 38, 22, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l.vitalityMetrics, style: AppVitalityStyle.title),
              const SizedBox(height: 8),
              Text(
                _recovery ? l.vitalityRecoveryMetrics : l.vitalityEnergyMetrics,
                style: AppVitalityStyle.body,
              ),
            ],
          ),
        ),
        AppMetricCard(
          onTap: () => _metric(mainKeys.first),
          child: _metricTile(s, mainKeys.first),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final key in mainKeys.skip(1))
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: key == mainKeys[1] ? 4 : 0,
                    left: key == mainKeys[2] ? 4 : 0,
                  ),
                  child: AppMetricCard(
                    onTap: () => _metric(key),
                    child: _metricTile(s, key),
                  ),
                ),
              ),
          ],
        ),
      ],
      Padding(
        padding: const EdgeInsets.fromLTRB(22, 35, 22, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (s.average != null && s.previousAverage != null) ...[
              Text(
                _recovery
                    ? (s.average! >= s.previousAverage!
                          ? l.vitalityRecoveryWeekUp
                          : l.vitalityRecoveryWeekDown)
                    : (s.average! >= s.previousAverage!
                          ? l.vitalityEnergyWeekUp
                          : l.vitalityEnergyWeekDown),
                style: AppVitalityStyle.title,
              ),
              const SizedBox(height: 10),
            ],
            VitalityExpandable(
              s.average != null && s.previousAverage != null
                  ? '${l.vitalityWeekSummary(vitalityNumber(context, s.average), vitalityDelta(context, s.average! - s.previousAverage!))}\n\n${l.vitalityWeekExplanation}'
                  : l.vitalityWeekExplanation,
            ),
          ],
        ),
      ),
      AppMetricCard(
        key: const Key('vitality-week'),
        onTap: () => _detail(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VitalityLabel(
              _recovery ? l.vitalityRecoveryWeek : l.vitalityEnergyWeek,
              chevron: true,
            ),
            const SizedBox(height: 12),
            Text.rich(
              TextSpan(
                text: vitalityNumber(context, s.average),
                style: AppVitalityStyle.value,
                children: [
                  TextSpan(
                    text: ' ${l.vitalityAverage}',
                    style: AppVitalityStyle.caption,
                  ),
                ],
              ),
            ),
            if (s.average != null && s.previousAverage != null)
              Text(
                l.vitalityComparedWeek(
                  '${s.average! - s.previousAverage! >= 0 ? '+' : ''}${vitalityNumber(context, s.average! - s.previousAverage!)}',
                ),
                style: AppVitalityStyle.caption,
              ),
            const SizedBox(height: 14),
            if (s.baselineLow != null)
              Text(
                l.vitalityNormal.toUpperCase(),
                style: AppVitalityStyle.kicker,
              ),
            VitalityChart(
              points: s.trend,
              color: _color,
              low: s.baselineLow,
              high: s.baselineHigh,
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(22, 30, 22, 16),
        child: Text(l.vitalitySignals, style: AppVitalityStyle.title),
      ),
      AppMetricCard(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            for (final key in signalKeys)
              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 4,
                ),
                leading: AppSvgIcon(
                  _signalIcon(key),
                  size: 22,
                  color: AppVitalityStyle.secondary,
                ),
                title: Text(
                  vitalityMetricName(context, key),
                  style: AppVitalityStyle.body,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${vitalityMetricValue(context, key, s.metrics[key])}${vitalityMetricUnit(key)}',
                      style: AppVitalityStyle.body,
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.chevron_right,
                      size: 17,
                      color: AppVitalityStyle.muted,
                    ),
                  ],
                ),
                onTap: () => _metric(key),
              ),
          ],
        ),
      ),
      if (s.demo)
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 20, 22, 0),
          child: Text(l.vitalityDemo, style: AppVitalityStyle.caption),
        ),
      if (s.lastSyncAt != null)
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 20, 22, 0),
          child: Text(
            '${l.vitalitySyncTime} · ${TimeOfDay.fromDateTime(s.lastSyncAt!.toLocal()).format(context)}',
            style: AppVitalityStyle.caption,
          ),
        ),
    ];
  }

  String _signalIcon(String key) =>
      'assets/icons/site/home-${switch (key) {
        'hrvMs' => 'hrv',
        'restingHeartRate' => 'rhr',
        'temperatureDeviation' => 'temperature',
        'respiratoryRate' => 'respiration',
        'sleepMinutes' => 'sleep',
        'activeMinutes' => 'activeMinutes',
        _ => key,
      }}.svg';

  Widget _notice(String text) => Padding(
    padding: const EdgeInsets.fromLTRB(22, 0, 22, 12),
    child: Text(text, style: AppVitalityStyle.body),
  );
  Widget _metricTile(VitalitySnapshot s, String key) {
    final value = key == 'trainingLoad' ? s.trainingLoad : s.metrics[key];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VitalityLabel(vitalityMetricName(context, key)),
        const SizedBox(height: 12),
        Text(
          vitalityMetricValue(context, key, value),
          style: AppVitalityStyle.value,
        ),
        if (vitalityMetricUnit(key).isNotEmpty)
          Text(vitalityMetricUnit(key), style: AppVitalityStyle.caption),
      ],
    );
  }

  Widget _recoveryCard(VitalitySnapshot s) => InkWell(
    onTap: () => _detail(),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: VitalityLabel(
            context.l10n.vitalityTodayRecovery,
            chevron: true,
          ),
        ),
        const SizedBox(height: 12),
        Text(vitalityNumber(context, s.score), style: AppVitalityStyle.value),
        const SizedBox(height: 5),
        Text(
          vitalityStatus(context, s.score).toLowerCase(),
          style: AppVitalityStyle.caption,
        ),
        const SizedBox(height: 10),
        RecoveryArc(score: s.score),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Row(
            children: [
              for (final row in [
                (
                  context.l10n.vitalityYesterday,
                  vitalityNumber(context, s.yesterday),
                ),
                (
                  context.l10n.vitalityNormal,
                  s.baselineLow == null
                      ? '—'
                      : '${vitalityNumber(context, s.baselineLow)}–${vitalityNumber(context, s.baselineHigh)}',
                ),
                (
                  context.l10n.vitalityAverage7,
                  vitalityNumber(context, s.average),
                ),
              ])
                Expanded(
                  child: Column(
                    children: [
                      Text(row.$1, style: AppVitalityStyle.caption),
                      const SizedBox(height: 6),
                      Text(
                        row.$2,
                        style: AppVitalityStyle.value.copyWith(fontSize: 24),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        if (s.baselineLow == null)
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 12, 22, 0),
            child: Text(
              context.l10n.vitalityNoBaseline,
              style: AppVitalityStyle.caption,
            ),
          ),
      ],
    ),
  );
  Widget _energyCard(VitalitySnapshot s) {
    final latest = s.observations.lastOrNull;
    final age = latest == null ? null : DateTime.now().difference(latest.at);
    final fresh =
        s.demo ||
        (age != null &&
            !age.isNegative &&
            age.inMinutes < 5 &&
            DateUtils.isSameDay(s.date, DateTime.now()));
    final time = latest == null
        ? ''
        : fresh
        ? context.l10n.vitalityNow
        : TimeOfDay.fromDateTime(latest.at.toLocal()).format(context);
    final peak = s.observations.isEmpty
        ? null
        : s.observations.reduce(
            (a, b) => (a.score ?? 0) >= (b.score ?? 0) ? a : b,
          );
    final future = s.preferences.forecastFor(s.kind)
        ? s.forecast.lastOrNull
        : null;
    return AppMetricCard(
      onTap: () => _detail(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VitalityLabel(context.l10n.vitalityEnergyDay, chevron: true),
          const SizedBox(height: 12),
          Text.rich(
            TextSpan(
              text: vitalityNumber(context, latest?.score),
              style: AppVitalityStyle.value,
              children: [
                TextSpan(text: ' $time', style: AppVitalityStyle.caption),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            peak != null && future != null && s.preferences.flag('showWindows')
                ? context.l10n.vitalityEnergyPeakForecast(
                    vitalityNumber(context, peak.score),
                    TimeOfDay.fromDateTime(peak.at.toLocal()).format(context),
                    vitalityNumber(context, future.score),
                    TimeOfDay.fromDateTime(future.at.toLocal()).format(context),
                  )
                : context.l10n.vitalityCurveExplanation,
            style: AppVitalityStyle.caption,
          ),
          const SizedBox(height: 10),
          VitalityChart(
            points: s.observations,
            forecast: s.preferences.forecastFor(s.kind) ? s.forecast : const [],
            color: _color,
            intraday: true,
            low: s.baselineLow,
            high: s.baselineHigh,
          ),
          if (s.preferences.flag('showWindows') && s.observations.isNotEmpty)
            Builder(
              builder: (c) {
                final peak = s.observations.reduce(
                  (a, b) => (a.score ?? 0) >= (b.score ?? 0) ? a : b,
                );
                return Text(
                  c.l10n.vitalityPeakAt(
                    vitalityNumber(c, peak.score),
                    TimeOfDay.fromDateTime(peak.at.toLocal()).format(c),
                  ),
                  style: AppVitalityStyle.caption,
                );
              },
            ),
        ],
      ),
    );
  }
}
