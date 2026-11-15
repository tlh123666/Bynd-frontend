import '../../../l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';
import '../../../design_system/design_system.dart';
import '../../../design_system/tokens/app_diary_style.dart';
import '../../../shared/widgets/centered_tab_strip.dart';
import '../domain/diary_models.dart';
import 'diary_widgets.dart';

class DiaryChaptersPage extends StatefulWidget {
  const DiaryChaptersPage({required this.repository, super.key});
  final DiaryRepository repository;
  @override
  State<DiaryChaptersPage> createState() => _DiaryChaptersPageState();
}

class _DiaryChaptersPageState extends State<DiaryChaptersPage> {
  late Future<List<Map<String, dynamic>>> _future;
  Locale? _locale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = Localizations.localeOf(context);
    if (_locale != locale) {
      _locale = locale;
      _future = _load();
    }
  }

  int? _selected;
  Future<List<Map<String, dynamic>>> _load() => widget.repository.chapters();

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.homeCanvas,
    body: AppDetailBackground(
      gradient: AppDiaryStyle.background,
      headerWash: AppDiaryStyle.headerWash,
      child: SafeArea(
        minimum: const EdgeInsets.only(top: 31),
        child: Column(
          children: [
            AppPageHeader(
              height: 49,
              title: Text(
                context.l10n.diaryUiYourChapters,
                style: AppTypography.detailBody.copyWith(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
              leading: IconButton(
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                onPressed: () => Navigator.pop(context),
                icon: const DiaryIcon('volta', size: 22),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _future,
                builder: (c, s) {
                  if (s.connectionState != ConnectionState.done) {
                    return const Center(child: AppLoadingIndicator());
                  }
                  if (s.hasError) {
                    return Center(
                      child: AppGlassPill(
                        label: c.l10n.diaryUiRetry,
                        onPressed: () => setState(() => _future = _load()),
                      ),
                    );
                  }
                  final data = s.data ?? [];
                  if (data.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(24),
                      child: Center(
                        child: Text(
                          c
                              .l10n
                              .diaryUiYourChaptersWillAppearAsYouRecordYourDays,
                          style: AppDiaryStyle.section,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                  final selected = (_selected ?? data.length - 1).clamp(
                    0,
                    data.length - 1,
                  );
                  final chapter = diaryReferenceChapter(c, data[selected]);
                  final highlights = (chapter['highlights'] as List? ?? [])
                      .map(
                        (e) => DiaryMoment(Map<String, dynamic>.from(e as Map)),
                      )
                      .toList();
                  return Column(
                    children: [
                      CenteredTabStrip(
                        itemCount: data.length,
                        selectedIndex: selected,
                        onSelectedIndexChanged: (i) =>
                            setState(() => _selected = i),
                        onItemTap: (i) => setState(() => _selected = i),
                        itemBuilder: (c, i, w) => SizedBox(
                          width: w,
                          child: Center(
                            child: Text(
                              '${c.l10n.diaryUiChapter} ${i + 1}',
                              style: AppDiaryStyle.caption.copyWith(
                                color: i == selected
                                    ? AppColors.textPrimary
                                    : AppColors.textMuted,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.fromLTRB(20, 28, 20, 40),
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${selected + 1}',
                                  style: AppTypography.hero.copyWith(
                                    height: .95,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        c.l10n.diaryChapterCount(data.length),
                                        style: AppDiaryStyle.caption,
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        diaryChapterPeriod(
                                          c,
                                          chapter,
                                        ).toUpperCase(),
                                        style: AppTypography.kicker.copyWith(
                                          color: AppColors.textMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '${chapter['title']}',
                              style: AppDiaryStyle.title,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '${chapter['body']}',
                              style: AppDiaryStyle.label.copyWith(
                                height: 1.55,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            DiarySection(
                              c.l10n.diaryUiByTheNumbers,
                              icon: 'relo',
                            ),
                            if (chapter['sections'] != null)
                              ..._sections(chapter)
                            else
                              Row(
                                children: [
                                  Expanded(
                                    child: _stat(
                                      '${chapter['days']}',
                                      c.l10n.diaryUiRecordedDays,
                                    ),
                                  ),
                                  Expanded(
                                    child: _stat(
                                      '${chapter['moments']}',
                                      c.l10n.diaryUiMoments,
                                    ),
                                  ),
                                ],
                              ),
                            if (chapter['sections'] == null)
                              DiarySection(
                                c.l10n.diaryUiMoments,
                                trailing: Text(
                                  '${highlights.length}',
                                  style: AppDiaryStyle.caption,
                                ),
                              ),
                            if (chapter['sections'] == null)
                              for (final m in highlights)
                                DiaryRecordRow(
                                  title: diaryMomentLabel(c, m),
                                  icon: m.icon,
                                  subtitle:
                                      '${m.time == null ? '' : diaryDate(m.time!)} · ${diaryMomentValue(c, m)}',
                                ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );
  Widget _stat(String value, String label) => Container(
    padding: const EdgeInsets.symmetric(vertical: 20),
    decoration: const BoxDecoration(
      border: Border(
        top: BorderSide(color: AppDiaryStyle.line),
        bottom: BorderSide(color: AppDiaryStyle.line),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: AppTypography.signalValue),
        const SizedBox(height: 8),
        Text(label, style: AppDiaryStyle.caption),
      ],
    ),
  );

  List<Widget> _sections(Map<String, dynamic> chapter) {
    final sections = chapter['sections'] as List;
    return [
      for (int i = 0; i < sections.length; i++) ...[
        if (i > 0)
          DiarySection(
            i == 1
                ? context.l10n.diaryUiAchievements
                : context.l10n.diaryUiMoments,
            icon: i == 1 ? 'estrela' : 'alvo',
            trailing: Text(
              '${(sections[i] as List).length}',
              style: AppDiaryStyle.caption,
            ),
          ),
        for (final raw in sections[i] as List)
          DiaryRecordRow(
            showIcon: i != 0,
            title: raw['valueKey'] == null
                ? '${raw['label']}'
                : diaryMomentLabel(
                    context,
                    DiaryMoment({
                      'id': '',
                      'valueKey': raw['valueKey'],
                      'label': raw['label'],
                    }),
                  ),
            icon:
                raw['icon'] as String? ??
                (i == 0
                    ? 'relo'
                    : i == 1
                    ? 'estrela'
                    : 'alvo'),
            subtitle: '${raw['note']}'.isEmpty ? null : '${raw['note']}',
            value: '${raw['value']}'.isEmpty ? null : '${raw['value']}',
          ),
      ],
    ];
  }
}
