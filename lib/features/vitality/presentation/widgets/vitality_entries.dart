import 'package:flutter/material.dart';
import '../../../../design_system/design_system.dart';
import '../../../../l10n/app_localizations_context.dart';
import '../../domain/vitality_models.dart';
import '../pages/vitality_page.dart';
import '../vitality_copy.dart';

/// Explicit entry points in both Today and Health, sharing the selected date.
class VitalityEntries extends StatelessWidget {
  const VitalityEntries({
    required this.date,
    required this.demo,
    this.onDestinationSelected,
    super.key,
  });
  final DateTime date;
  final bool demo;
  final ValueChanged<int>? onDestinationSelected;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final kind in VitalityKind.values)
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: kind == VitalityKind.energy ? 4 : 0,
                right: kind == VitalityKind.recovery ? 4 : 0,
              ),
              child: AppMetricCard(
                key: ValueKey('vitality-entry-${kind.name}'),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => VitalityPage(
                      kind: kind,
                      date: date,
                      demo: demo,
                      onDestinationSelected: onDestinationSelected,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      kind == VitalityKind.recovery
                          ? Icons.favorite_border
                          : Icons.bolt_outlined,
                      color: kind == VitalityKind.recovery
                          ? AppVitalityStyle.recovery
                          : AppVitalityStyle.energy,
                      size: 22,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      vitalityTitle(context, kind),
                      style: AppVitalityStyle.body.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 19,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context.l10n.vitalityDetails,
                      style: AppVitalityStyle.caption,
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    ),
  );
}
