import '../../../shared/navigation/app_quick_action_navigation.dart';
import '../../../l10n/app_localizations_context.dart';
import '../../atlas/application/atlas_greeting_store.dart';
import '../../atlas/application/atlas_scope.dart';
import '../../atlas/presentation/pages/atlas_chat_page.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/auth/auth_session.dart';
import '../../../core/config/app_config.dart';
import '../../../core/network/api_client.dart';
import '../../../design_system/design_system.dart';
import '../../../design_system/tokens/app_diary_style.dart';
import '../../../shared/widgets/day_strip.dart';
import '../data/demo_diary_repository.dart';
import '../data/remote_diary_repository.dart';
import '../domain/diary_models.dart';
import 'diary_widgets.dart';
import 'diary_record_sheet.dart';
import 'diary_chapters_page.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({
    this.repository,
    this.date,
    this.openRecord = false,
    this.timeline = false,
    this.initialTracker,
    super.key,
  });
  final DiaryRepository? repository;
  final DateTime? date;
  final bool openRecord;
  final bool timeline;
  final String? initialTracker;
  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 日记页的开场白在本页加载时预取：点开 Atlas 弹窗之前就绪。
    unawaited(
      AtlasGreetingStore.instance.prepare('diary', AtlasScope.of(context)),
    );
  }

  late final DiaryRepository _repo =
      widget.repository ??
      (AppConfig.current.demoData
          ? DemoDiaryRepository()
          : RemoteDiaryRepository(
              ApiClient.configured(),
              session: AuthSession.instance,
            ));
  late int _day = _dayOffset(widget.date);

  static int _dayOffset(DateTime? date) {
    if (date == null) return 0;
    final now = DateTime.now();
    return DateTime.utc(now.year, now.month, now.day)
        .difference(DateTime.utc(date.year, date.month, date.day))
        .inDays
        .clamp(0, 364);
  }

  final _moreKey = GlobalKey();
  Rect? _origin;
  bool _quickOpen = false;
  DiaryDay? _data;
  Object? _error;
  int _request = 0;
  bool _loading = true, _opened = false, _pending = false;
  int _generation = 0;
  final _session = AuthSession.instance;
  final String? _token = AuthSession.instance.accessToken;
  DateTime get _date {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day - _day);
  }

  @override
  void initState() {
    super.initState();
    _session.addListener(_changedAccount);
    unawaited(_load());
  }

  void _changedAccount() {
    if (_session.accessToken != _token && mounted) {
      _request++;
      setState(() {
        _data = null;
        _loading = false;
        _error = 'account_changed';
      });
    }
  }

  Future<void> _load() async {
    final request = ++_request;
    setState(() {
      _generation++;
      _loading = true;
      _error = null;
      _data = null;
    });
    try {
      final data = await _repo.load(_date);
      if (!mounted || request != _request) return;
      setState(() {
        _data = data;
        _loading = false;
      });
      if (widget.openRecord && !_opened) {
        _opened = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            unawaited(_record(initialTracker: widget.initialTracker));
          }
        });
      }
    } catch (e) {
      if (mounted && request == _request) {
        setState(() {
          _error = e;
          _loading = false;
        });
      }
    }
  }

  Future<void> _record({DiaryMoment? selected, String? initialTracker}) async {
    if (_data == null || !_data!.editable) return;
    final result = await showAppContentSheet<DiaryDay>(
      context,
      glass: true,
      (_) => DiarySessionGuard(
        token: _token,
        child: DiaryRecordSheet(
          repository: _repo,
          day: _data!,
          selected: selected,
          initialTracker: initialTracker,
        ),
      ),
    );
    if (!mounted || result == null) return;
    setState(() {
      _data = result;
      _generation++;
    });
    AppNotice.show(
      context,
      kind: AppNoticeKind.success,
      message: context.l10n.diaryUiDaySaved,
    );
  }

  @override
  void dispose() {
    _request++;
    _session.removeListener(_changedAccount);
    if (widget.repository == null) _repo.dispose();
    super.dispose();
  }

  Widget _header(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      AppPageHeader(
        height: 49,
        actionWidth: 96,
        padding: EdgeInsets.zero,
        leading: IconButton(
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          onPressed: _pending ? null : () => Navigator.pop(context),
          icon: const DiaryIcon('volta', size: 22),
        ),
        title: Text(
          widget.timeline
              ? context.l10n.diaryUiTimeline
              : context.l10n.diaryUiDiary,
          style: AppDiaryStyle.label.copyWith(
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: context.l10n.diaryUiYourChapters,
              onPressed: _pending
                  ? null
                  : () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) => DiarySessionGuard(
                          token: _token,
                          child: DiaryChaptersPage(repository: _repo),
                        ),
                      ),
                    ),
              icon: const DiaryIcon('livro', size: 22),
            ),
            if (!widget.timeline)
              IconButton(
                tooltip: context.l10n.diaryUiTimeline,
                onPressed: _pending
                    ? null
                    : () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (_) => DiaryPage(
                              repository: _repo,
                              date: _date,
                              timeline: true,
                            ),
                          ),
                        );
                        if (mounted) unawaited(_load());
                      },
                icon: const AppSvgIcon(
                  'assets/icons/site/diary-history.svg',
                  size: 22,
                ),
              ),
          ],
        ),
      ),
      DayStrip(
        day: _day,
        daysCount: 365,
        onDayChanged: (d) {
          if (_pending) return;
          setState(() => _day = d);
          unawaited(_load());
        },
      ),
    ],
  );

  Widget _timeline(BuildContext context) {
    final data = _data;
    final moments = data?.timeline ?? const <DiaryMoment>[];
    final l = context.l10n;
    return AppGlassScrollHeader(
      key: ValueKey('diary-timeline-$_day'),
      header: _header(context),
      height: 95,
      body: (inset) => RefreshIndicator(
        onRefresh: _load,
        edgeOffset: inset,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            AppHealthStyle.edge,
            inset + 24,
            AppHealthStyle.edge,
            156,
          ),
          children: [
            if (_loading)
              const Center(child: AppLoadingIndicator())
            else if (_error != null) ...[
              Text(
                _error == 'account_changed'
                    ? l.diaryUiYourAccountChangedReopenTheDiary
                    : l.diaryLoadFailed,
                style: AppDiaryStyle.label,
              ),
              const SizedBox(height: 12),
              AppGlassPill(label: l.diaryUiRetry, onPressed: _load),
            ] else if (data != null) ...[
              Text(
                _day == 0
                    ? l.diaryUiWhatHappenedToday
                    : _day == 1
                    ? l.diaryUiWhatHappenedYesterday
                    : l.diaryHowWasDate(diaryDisplayDate(context, _date)),
                style: AppDiaryStyle.title,
              ),
              const SizedBox(height: 8),
              Text(
                l.diaryBandAndEntries(
                  data.automatic.length,
                  data.events.length,
                ),
                style: AppDiaryStyle.caption,
              ),
              const SizedBox(height: 18),
              if (moments.isEmpty)
                Text(
                  l.diaryUiYourDayBeginsWithAnEntry,
                  style: AppDiaryStyle.caption,
                ),
              for (final moment in moments)
                DiaryTimelineTile(
                  key: ValueKey(moment.id),
                  moment: moment,
                  onTap: moment.automatic || !data.editable
                      ? null
                      : () => _record(selected: moment),
                ),
              if (data.note.isNotEmpty) ...[
                DiarySection(l.diaryUiNotes, icon: 'nota'),
                Text(data.note, style: AppDiaryStyle.label),
              ],
              if (!data.editable) ...[
                const SizedBox(height: 14),
                Text(
                  l.diaryUiYouCanEditThePast7Days,
                  style: AppDiaryStyle.caption,
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.expand,
    children: [
      PopScope(
        canPop: !_pending,
        child: Scaffold(
          extendBody: true,
          backgroundColor: AppColors.homeCanvas,
          body: AppDetailBackground(
            gradient: AppDiaryStyle.background,
            headerWash: AppDiaryStyle.headerWash,
            child: DiaryScrollingBackground(
              child: SafeArea(
                bottom: false,
                minimum: const EdgeInsets.only(top: 31),
                child: widget.timeline
                    ? _timeline(context)
                    : Column(
                        children: [
                          _header(context),
                          Expanded(
                            child: _loading
                                ? const Center(child: AppLoadingIndicator())
                                : _error != null
                                ? Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(24),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            _error == 'account_changed'
                                                ? context
                                                      .l10n
                                                      .diaryUiYourAccountChangedReopenTheDiary
                                                : context.l10n.diaryLoadFailed,
                                            textAlign: TextAlign.center,
                                            style: AppDiaryStyle.caption,
                                          ),
                                          const SizedBox(height: 16),
                                          AppGlassPill(
                                            label: context.l10n.diaryUiRetry,
                                            onPressed: _load,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : DiaryRecordSheet(
                                    key: ValueKey(
                                      'diary-inline-$_day-$_generation',
                                    ),
                                    repository: _repo,
                                    day: _data!,
                                    embedded: true,
                                    onPendingChanged: (pending) {
                                      if (mounted) {
                                        setState(() => _pending = pending);
                                      }
                                    },
                                    onSaved: (day) {
                                      if (mounted) setState(() => _data = day);
                                    },
                                  ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
          bottomNavigationBar: AppBottomNav(
            selectedIndex: null,
            moreButtonKey: _moreKey,
            moreOpen: _quickOpen,
            onDestinationSelected: (index) {
              if (_pending) return;
              if (index == 0) {
                Navigator.popUntil(context, (r) => r.isFirst);
              } else if (index == 1) {
                // Atlas：与首页底栏同款，滑出对话浮层；来源=diary，
                // 开场白按日记上下文生成（此前误报 coming soon）
                AtlasOverlayScope.show(context, origin: 'diary');
              } else {
                AppNotice.show(
                  context,
                  kind: AppNoticeKind.info,
                  message: context.l10n.sectionComingSoon,
                );
              }
            },
            onMorePressed: () {
              if (_pending) return;
              final box = _moreKey.currentContext?.findRenderObject();
              if (box is! RenderBox) return;
              setState(() {
                _origin = box.localToGlobal(Offset.zero) & box.size;
                _quickOpen = true;
              });
            },
          ),
        ),
      ),
      if (_quickOpen)
        Positioned.fill(
          child: AppQuickActionsOverlay(
            origin: _origin!,
            onClose: () => setState(() => _quickOpen = false),
            onActionSelected: (action) {
              setState(() => _quickOpen = false);
              if (AppQuickActionNavigation.open(
                context,
                action,
                demo: _repo is DemoDiaryRepository,
              )) {
                return;
              }
              if (action == AppQuickAction.dayReview ||
                  action == AppQuickAction.meal) {
                _record(
                  initialTracker: action == AppQuickAction.meal
                      ? 'almoco'
                      : null,
                );
              } else {
                AppNotice.show(
                  context,
                  kind: AppNoticeKind.info,
                  message: context.l10n.comingSoon(
                    action.localizedLabel(context.l10n).replaceAll('\n', ' '),
                  ),
                );
              }
            },
          ),
        ),
    ],
  );
}

/// Every modal owns a guard too: a route above the page must not expose stale private drafts.
class DiarySessionGuard extends StatelessWidget {
  const DiarySessionGuard({
    required this.token,
    required this.child,
    super.key,
  });
  final String? token;
  final Widget child;
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: AuthSession.instance,
    builder: (context, _) => AuthSession.instance.accessToken == token
        ? child
        : Material(
            color: AppColors.homeCanvas,
            child: SafeArea(
              child: Column(
                children: [
                  AppDetailHeader(
                    title: context.l10n.diaryUiDiary,
                    onClose: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        context.l10n.diaryUiYourAccountChangedReopenTheDiary,
                        style: AppDiaryStyle.caption,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
  );
}
