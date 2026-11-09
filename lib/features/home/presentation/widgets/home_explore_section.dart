import 'package:flutter/material.dart';
import '../../../../design_system/design_system.dart';
import '../../../../l10n/app_localizations_context.dart';

class HomeExploreSection extends StatelessWidget {
  const HomeExploreSection({
    required this.patterns,
    required this.onMapa,
    required this.onDiary,
    super.key,
  });
  final int? patterns;
  final VoidCallback onMapa, onDiary;
  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        children: [
          _Entry(
            kicker: 'MAPA',
            tag: patterns == null || patterns == 0
                ? s.homeWaitingPatterns
                : '$patterns ${s.homePatterns}',
            title: s.homeMapaTitle,
            body: patterns != null && patterns! > 0
                ? s.homeMapaBody
                : s.homeMapaWaiting,
            action: s.homeExploreMapa,
            onTap: onMapa,
            icon: AppSvgAssets.homeBrain,
          ),
          _Entry(
            kicker: s.homeDiaryKicker,
            title: s.homeDiaryTitle,
            body: s.homeDiaryBody,
            action: s.homeAddEntry,
            onTap: onDiary,
          ),
        ],
      ),
    );
  }
}

class _Entry extends StatelessWidget {
  const _Entry({
    required this.kicker,
    required this.title,
    required this.body,
    required this.action,
    required this.onTap,
    this.tag,
    this.icon,
  });
  final String kicker, title, body, action;
  final String? tag, icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: const BoxDecoration(
      border: Border(top: BorderSide(color: AppColors.glassBorder)),
    ),
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    kicker,
                    style: AppTypography.kicker.copyWith(
                      color: AppColors.textInactive,
                    ),
                  ),
                ),
                if (tag != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.homePatternTag,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      tag!,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.homePatternText,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: AppTypography.section.copyWith(fontSize: 23, height: 1.25),
            ),
            const SizedBox(height: 8),
            Text(
              body,
              style: AppTypography.body.copyWith(
                fontSize: 14.5,
                color: AppColors.menuIcon,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Text(
                    action,
                    style: AppTypography.label.copyWith(fontSize: 15),
                  ),
                ),
                if (icon != null)
                  AppSvgIcon(icon!, size: 22, color: AppColors.deviceIcon),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
