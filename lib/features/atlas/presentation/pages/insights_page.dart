import 'package:flutter/material.dart';

import '../../../../design_system/design_system.dart';
import '../../../../l10n/app_localizations_context.dart';
import '../../application/atlas_scope.dart';
import '../../data/models/insight.dart';

/// 洞察列表页：来自规则引擎的当前洞察（后端已按权益/授权/新鲜度过滤）。
///
/// 卡片默认只露标题与摘要；因素、建议与就医提示收在展开区——洞察卡是
/// 「短表面」（Voice Guidelines §3.2），默认信息密度要克制。
class InsightsPage extends StatefulWidget {
  const InsightsPage({super.key});

  @override
  State<InsightsPage> createState() => _InsightsPageState();
}

class _InsightsPageState extends State<InsightsPage> {
  late Future<InsightList> _future;

  @override
  void initState() {
    super.initState();
    _future = AtlasScope.of(context).fetchInsights(limit: 20);
  }

  Future<void> _reload() async {
    setState(() => _future = AtlasScope.of(context).fetchInsights(limit: 20));
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: Text(strings.insightsTitle, style: AppTypography.homeTitle),
        actions: [
          IconButton(
            tooltip: strings.insightsRefresh,
            icon: const Icon(Icons.refresh),
            onPressed: _reload,
          ),
        ],
      ),
      body: FutureBuilder<InsightList>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return _Message(text: strings.insightsError);
          }
          final insights = snapshot.data ?? InsightList.empty;
          if (insights.isEmpty) {
            return _Message(text: strings.insightsEmpty);
          }
          return RefreshIndicator(
            onRefresh: _reload,
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: insights.items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) =>
                  _InsightCard(insight: insights.items[index]),
            ),
          );
        },
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  const _InsightCard({required this.insight});

  final Insight insight;

  Color get _severityColor =>
      insight.isWarning ? AppColors.warning : AppColors.action;

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          iconColor: AppColors.textDim,
          collapsedIconColor: AppColors.textDim,
          title: Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _severityColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    insight.title,
                    style: AppTypography.listItem.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          subtitle: Text(
            insight.summary,
            style: AppTypography.caption.copyWith(color: AppColors.textDim),
          ),
          children: [
            if (insight.possibleFactors.isNotEmpty) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  strings.insightsFactors,
                  style: AppTypography.kicker.copyWith(
                    color: AppColors.textDim,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              for (final factor in insight.possibleFactors)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '• $factor',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              const SizedBox(height: 10),
            ],
            if (insight.actionableSteps.isNotEmpty) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  strings.insightsActions,
                  style: AppTypography.kicker.copyWith(
                    color: AppColors.textDim,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              for (final step in insight.actionableSteps)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '• $step',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              const SizedBox(height: 10),
            ],
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                insight.seekMedicalHelp.message,
                style: AppTypography.caption.copyWith(color: AppColors.textDim),
              ),
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                insight.disclaimer,
                style: AppTypography.kicker.copyWith(color: AppColors.textDim),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: AppTypography.caption.copyWith(color: AppColors.textDim),
    ),
  );
}
