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
  late Future<List<Map<String, dynamic>>> _future = _load();
  int _selected = 0;
  Future<List<Map<String, dynamic>>> _load() async {
    final data = await widget.repository.chapters();
    _selected = (data.length - 1).clamp(0, 1000);
    return data;
  }

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
                diaryText(context, 'Seus capítulos', 'Your chapters'),
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
                        label: diaryText(c, 'Tentar novamente', 'Retry'),
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
                          diaryText(
                            c,
                            'Seus capítulos vão aparecer conforme você registra seus dias.',
                            'Your chapters will appear as you record your days.',
                          ),
                          style: AppDiaryStyle.section,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                  final chapter = data[_selected];
                  final highlights = (chapter['highlights'] as List? ?? [])
                      .map(
                        (e) => DiaryMoment(Map<String, dynamic>.from(e as Map)),
                      )
                      .toList();
                  return Column(
                    children: [
                      CenteredTabStrip(
                        itemCount: data.length,
                        selectedIndex: _selected,
                        onSelectedIndexChanged: (i) =>
                            setState(() => _selected = i),
                        onItemTap: (i) => setState(() => _selected = i),
                        itemBuilder: (c, i, w) => SizedBox(
                          width: w,
                          child: Center(
                            child: Text(
                              '${diaryText(c, 'Capítulo', 'Chapter')} ${i + 1}',
                              style: AppDiaryStyle.caption.copyWith(
                                color: i == _selected
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
                                  '${_selected + 1}',
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
                                        diaryText(
                                          c,
                                          'de ${data.length} capítulos',
                                          'of ${data.length} chapters',
                                        ),
                                        style: AppDiaryStyle.caption,
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        '${chapter['period'] ?? '${chapter['startDate']} a ${chapter['endDate']}'}'
                                            .toUpperCase(),
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
                              diaryText(c, 'Em números', 'By the numbers'),
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
                                      diaryText(
                                        c,
                                        'Dias registrados',
                                        'Recorded days',
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: _stat(
                                      '${chapter['moments']}',
                                      diaryText(c, 'Momentos', 'Moments'),
                                    ),
                                  ),
                                ],
                              ),
                            if (chapter['sections'] == null)
                              DiarySection(
                                diaryText(c, 'Momentos', 'Moments'),
                                trailing: Text(
                                  '${highlights.length}',
                                  style: AppDiaryStyle.caption,
                                ),
                              ),
                            if (chapter['sections'] == null)
                              for (final m in highlights)
                                DiaryRecordRow(
                                  title: m.label,
                                  icon: m.icon,
                                  subtitle:
                                      '${m.time == null ? '' : diaryDate(m.time!)} · ${m.valueLabel}',
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
                ? diaryText(context, 'Conquistas', 'Achievements')
                : diaryText(context, 'Momentos', 'Moments'),
            icon: i == 1 ? 'estrela' : 'alvo',
            trailing: Text(
              '${(sections[i] as List).length}',
              style: AppDiaryStyle.caption,
            ),
          ),
        for (final raw in sections[i] as List)
          DiaryRecordRow(
            showIcon: i != 0,
            title: '${raw['label']}',
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
