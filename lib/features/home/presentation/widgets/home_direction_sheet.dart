import 'package:flutter/material.dart';
import '../../../../design_system/design_system.dart';
import '../../../../l10n/app_localizations_context.dart';
import '../../domain/home_models.dart';

/// The daily direction already computed by the backend. Chat is a separate
/// feature: opening this sheet never fabricates an assistant conversation.
class HomeDirectionSheet extends StatelessWidget {
  const HomeDirectionSheet({required this.snapshot, super.key});
  final HomeSnapshot snapshot;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      AppDetailHeader(
        title: context.l10n.homeDirection,
        onClose: () => Navigator.pop(context),
      ),
      Expanded(
        child: ListView(
          padding: const EdgeInsets.all(22),
          children: [
            Text(
              homeDateKey(snapshot.date),
              style: AppTypography.kicker.copyWith(color: AppColors.textMuted),
            ),
            const SizedBox(height: 20),
            Text(snapshot.title, style: AppTypography.homeTitle),
            const SizedBox(height: 16),
            for (final paragraph in snapshot.paragraphs)
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Text(paragraph, style: AppTypography.homeBody),
              ),
            if (snapshot.recommendation.isNotEmpty) ...[
              const SizedBox(height: 24),
              AppGradientCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.homeRecommendation,
                      style: AppTypography.title,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      snapshot.recommendation,
                      style: AppTypography.body.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    ],
  );
}
