import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_health_style.dart';

class AppHealthHero extends StatelessWidget {
  const AppHealthHero({
    required this.value,
    required this.label,
    this.status,
    this.color,
    this.valueKey,
    super.key,
  });

  final String value, label;
  final String? status;
  final Color? color;
  final Key? valueKey;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Flexible(
        child: Text(value, key: valueKey, style: AppHealthStyle.hero),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppHealthStyle.small),
              if (status != null)
                Text(
                  status!.toUpperCase(),
                  style: AppHealthStyle.small.copyWith(
                    color: color,
                    letterSpacing: 1.4,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        ),
      ),
    ],
  );
}

class AppHealthSection extends StatelessWidget {
  const AppHealthSection(this.label, this.icon, {super.key});
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, size: 18, color: AppColors.textSecondary),
      const SizedBox(width: 8),
      Expanded(child: Text(label, style: AppHealthStyle.section)),
    ],
  );
}

class AppHealthRow extends StatelessWidget {
  const AppHealthRow({
    required this.label,
    this.icon,
    this.value,
    this.subtitle,
    this.onTap,
    this.divider = true,
    super.key,
  });
  final String label;
  final String? value, subtitle;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool divider;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Container(
      constraints: const BoxConstraints(minHeight: 58),
      padding: const EdgeInsets.symmetric(vertical: 11),
      decoration: divider
          ? const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppHealthStyle.divider)),
            )
          : null,
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 19, color: AppColors.textSecondary),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppHealthStyle.body.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                if (subtitle != null)
                  Text(subtitle!, style: AppHealthStyle.small),
              ],
            ),
          ),
          if (value != null) ...[
            const SizedBox(width: 8),
            Flexible(child: Text(value!, style: AppHealthStyle.body)),
          ],
          if (onTap != null) ...[
            const SizedBox(width: 5),
            const Icon(
              Icons.chevron_right,
              size: 17,
              color: AppColors.textMuted,
            ),
          ],
        ],
      ),
    ),
  );
}

class AppHealthPanel extends StatelessWidget {
  const AppHealthPanel({required this.child, super.key});
  final Widget child;
  @override
  Widget build(BuildContext context) => Material(
    color: AppHealthStyle.surface,
    borderRadius: BorderRadius.circular(AppHealthStyle.radius),
    clipBehavior: Clip.antiAlias,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppHealthStyle.edge),
      child: child,
    ),
  );
}

class AppHealthMetric extends StatelessWidget {
  const AppHealthMetric({
    required this.label,
    required this.value,
    required this.icon,
    this.unit = '',
    this.caption,
    super.key,
  });
  final String label, value, unit;
  final String? caption;
  final IconData icon;

  @override
  Widget build(BuildContext context) => AppHealthPanel(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 105),
        child: Align(
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(icon, size: 17, color: AppColors.textSecondary),
                  const SizedBox(width: 6),
                  Expanded(child: Text(label, style: AppHealthStyle.small)),
                ],
              ),
              const SizedBox(height: 18),
              Text.rich(
                TextSpan(
                  text: value,
                  style: AppHealthStyle.value,
                  children: [
                    if (unit.isNotEmpty && value != '—')
                      TextSpan(text: ' $unit', style: AppHealthStyle.legend),
                  ],
                ),
              ),
              if (caption != null) ...[
                const SizedBox(height: 4),
                Text(caption!, style: AppHealthStyle.small),
              ],
            ],
          ),
        ),
      ),
    ),
  );
}

class AppHealthMetricGrid extends StatelessWidget {
  const AppHealthMetricGrid({required this.children, super.key});
  final List<AppHealthMetric> children;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) {
      const gap = 6.0;
      final width =
          box.maxWidth < 270 || MediaQuery.textScalerOf(context).scale(15) > 24
          ? box.maxWidth
          : (box.maxWidth - gap) / 2;
      return Wrap(
        spacing: gap,
        runSpacing: gap,
        children: [
          for (final metric in children) SizedBox(width: width, child: metric),
        ],
      );
    },
  );
}

class AppChartLegend extends StatelessWidget {
  const AppChartLegend(this.items, {this.active, super.key});
  final List<(Color, String)> items;
  final Set<int>? active;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 10),
    child: Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        for (final (index, (color, label)) in items.indexed)
          Opacity(
            opacity: active == null || active!.contains(index) ? 1 : .55,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 4,
                  height: 10,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 6),
                Text(label, style: AppHealthStyle.legend),
              ],
            ),
          ),
      ],
    ),
  );
}
