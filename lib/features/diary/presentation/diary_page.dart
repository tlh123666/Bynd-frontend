import '../../../l10n/app_localizations_context.dart';
import '../../activity/presentation/pages/activity_overview_page.dart';
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
    this.initialTracker,
    super.key,
  });
  final DiaryRepository? repository;
  final DateTime? date;
  final bool openRecord;
  final String? initialTracker;
  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  late final DiaryRepository _repo =
      widget.repository ??
      (AppConfig.current.demoData
          ? DemoDiaryRepository()
          : RemoteDiaryRepository(
              ApiClient.configured(),
              session: AuthSession.instance,
            ));
  late int _day = widget.date == null
      ? 0
      : DateTime.now().difference(widget.date!).inDays.clamp(0, 364);
  final _moreKey = GlobalKey();
  Rect? _origin;
  bool _quickOpen = false;
  DiaryDay? _data;
  Object? _error;
  int _request = 0;
  bool _loading = true, _opened = false;
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
        _error = diaryText(
          context,
          'Sua conta mudou. Abra o Diário novamente.',
          'Your account changed. Reopen the diary.',
        );
      });
    }
  }

  Future<void> _load() async {
    final request = ++_request;
    setState(() {
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
    setState(() => _data = result);
    AppNotice.show(
      context,
      kind: AppNoticeKind.success,
      message: diaryText(context, 'Dia salvo', 'Day saved'),
    );
  }

  @override
  void dispose() {
    _request++;
    _session.removeListener(_changedAccount);
    if (widget.repository == null) _repo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.expand,
    children: [
      Scaffold(
        extendBody: true,
        backgroundColor: AppColors.homeCanvas,
        body: AppDetailBackground(
          gradient: AppDiaryStyle.background,
          headerWash: AppDiaryStyle.headerWash,
          child: SafeArea(
            bottom: false,
            minimum: const EdgeInsets.only(top: 31),
            child: Column(
              children: [
                AppPageHeader(
                  height: 49,
                  actionWidth: 96,
                  padding: EdgeInsets.zero,
                  leading: IconButton(
                    tooltip: MaterialLocalizations.of(
                      context,
                    ).backButtonTooltip,
                    onPressed: () => Navigator.pop(context),
                    icon: const DiaryIcon('volta', size: 22),
                  ),
                  title: Text(
                    diaryText(context, 'Di\u00e1rio', 'Diary'),
                    style: AppTypography.detailBody.copyWith(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: diaryText(
                          context,
                          'Seus cap\u00edtulos',
                          'Your chapters',
                        ),
                        onPressed: () => Navigator.push(
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
                      IconButton(
                        tooltip: diaryText(context, 'Registrar', 'Record'),
                        onPressed: _data?.editable == true
                            ? () => _record()
                            : null,
                        icon: const DiaryIcon('mais', size: 22),
                      ),
                    ],
                  ),
                ),
                DayStrip(
                  day: _day,
                  daysCount: 365,
                  onDayChanged: (d) {
                    setState(() => _day = d);
                    unawaited(_load());
                  },
                ),
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
                                  '$_error',
                                  textAlign: TextAlign.center,
                                  style: AppDiaryStyle.caption,
                                ),
                                const SizedBox(height: 16),
                                AppGlassPill(
                                  label: diaryText(
                                    context,
                                    'Tentar novamente',
                                    'Retry',
                                  ),
                                  onPressed: _load,
                                ),
                              ],
                            ),
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _load,
                          child: ListView(
                            padding: const EdgeInsets.fromLTRB(20, 40, 6, 160),
                            children: [
                              Text(
                                _day == 0
                                    ? diaryText(
                                        context,
                                        'O que aconteceu hoje?',
                                        'What happened today?',
                                      )
                                    : _day == 1
                                    ? diaryText(
                                        context,
                                        'O que aconteceu ontem?',
                                        'What happened yesterday?',
                                      )
                                    : diaryText(
                                        context,
                                        'Como foi o dia ${_date.day}?',
                                        'How was ${diaryDate(_date)}?',
                                      ),
                                style: AppDiaryStyle.title,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                diaryText(
                                  context,
                                  '${_data!.automatic.length} da pulseira · ${_data!.events.length} registros seus',
                                  '${_data!.automatic.length} from your band · ${_data!.events.length} your entries',
                                ),
                                style: AppDiaryStyle.caption.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              DiarySection(
                                _day == 0
                                    ? diaryText(context, 'Hoje', 'Today')
                                    : _day == 1
                                    ? diaryText(context, 'Ontem', 'Yesterday')
                                    : diaryDate(_date),
                                icon: 'relo',
                                trailing: Text(
                                  '${_data!.timeline.length} ${diaryText(context, 'momentos', 'moments')}',
                                  style: AppDiaryStyle.caption,
                                ),
                              ),
                              const SizedBox(height: 14),
                              if (_data!.timeline.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 36,
                                  ),
                                  child: Text(
                                    diaryText(
                                      context,
                                      'Seu dia começa com um registro.',
                                      'Your day begins with an entry.',
                                    ),
                                    style: AppDiaryStyle.caption,
                                  ),
                                ),
                              for (final m in _data!.timeline)
                                DiaryTimelineTile(
                                  moment: m,
                                  onTap: m.automatic || !_data!.editable
                                      ? null
                                      : () => _record(selected: m),
                                ),
                              if (_data!.note.isNotEmpty) ...[
                                DiarySection(
                                  diaryText(context, 'Notas', 'Notes'),
                                  icon: 'nota',
                                ),
                                DiarySurface(
                                  child: Padding(
                                    padding: const EdgeInsets.all(18),
                                    child: Text(
                                      _data!.note,
                                      style: AppDiaryStyle.label,
                                    ),
                                  ),
                                ),
                              ],
                              if (!_data!.editable)
                                Text(
                                  diaryText(
                                    context,
                                    'Você pode editar os últimos 7 dias.',
                                    'You can edit the past 7 days.',
                                  ),
                                  style: AppDiaryStyle.caption,
                                ),
                              if (_data!.editable)
                                Padding(
                                  padding: const EdgeInsets.only(top: 28),
                                  child: Center(
                                    child: AppGlassPill(
                                      label: diaryText(
                                        context,
                                        'Registrar o dia',
                                        'Record your day',
                                      ),
                                      onPressed: () => _record(),
                                    ),
                                  ),
                                ),
                            ],
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
          moreOpen: _quickOpen,
          onDestinationSelected: (index) {
            if (index == 0) {
              Navigator.popUntil(context, (r) => r.isFirst);
            } else {
              AppNotice.show(
                context,
                kind: AppNoticeKind.info,
                message: context.l10n.sectionComingSoon,
              );
            }
          },
          onMorePressed: () {
            final box = _moreKey.currentContext?.findRenderObject();
            if (box is! RenderBox) return;
            setState(() {
              _origin = box.localToGlobal(Offset.zero) & box.size;
              _quickOpen = true;
            });
          },
        ),
      ),
      if (_quickOpen)
        Positioned.fill(
          child: AppQuickActionsOverlay(
            origin: _origin!,
            onClose: () => setState(() => _quickOpen = false),
            onActionSelected: (action) {
              setState(() => _quickOpen = false);
              if (action == AppQuickAction.dayReview ||
                  action == AppQuickAction.meal) {
                _record(
                  initialTracker: action == AppQuickAction.meal
                      ? 'almoco'
                      : null,
                );
              } else if (action == AppQuickAction.startActivity) {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) =>
                        const ActivityOverviewPage(openSelectorOnEnter: true),
                  ),
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
                    title: diaryText(context, 'Diário', 'Diary'),
                    onClose: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        diaryText(
                          context,
                          'Sua conta mudou. Abra o Diário novamente.',
                          'Your account changed. Reopen the diary.',
                        ),
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
