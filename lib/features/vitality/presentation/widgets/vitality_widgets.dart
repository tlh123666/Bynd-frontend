import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import '../../../../design_system/design_system.dart';
import '../../../../l10n/app_localizations_context.dart';
import '../../../../shared/widgets/app_sheet_controls.dart';
import '../../application/vitality_controller.dart';
import '../../domain/vitality_models.dart';
import '../vitality_copy.dart';

class VitalityAccountGuard extends StatelessWidget {
  const VitalityAccountGuard({
    required this.controller,
    required this.child,
    super.key,
  });
  final VitalityController controller;
  final Widget child;
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: controller,
    builder: (c, _) => controller.accountChanged
        ? Column(
            children: [
              AppSheetHeader(title: c.l10n.vitalitySettings),
              Expanded(
                child: Center(
                  child: Text(
                    c.l10n.vitalityAccountChanged,
                    style: AppVitalityStyle.body,
                  ),
                ),
              ),
            ],
          )
        : child,
  );
}

class VitalityLabel extends StatelessWidget {
  const VitalityLabel(this.text, {this.chevron = false, super.key});
  final String text;
  final bool chevron;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(child: Text(text.toUpperCase(), style: AppVitalityStyle.kicker)),
      if (chevron)
        const Icon(
          Icons.chevron_right,
          size: 19,
          color: AppVitalityStyle.muted,
        ),
    ],
  );
}

class VitalityExpandable extends StatefulWidget {
  const VitalityExpandable(this.text, {super.key});
  final String text;
  @override
  State<VitalityExpandable> createState() => _VitalityExpandableState();
}

class _VitalityExpandableState extends State<VitalityExpandable> {
  bool _open = false;
  @override
  Widget build(BuildContext c) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      AnimatedSize(
        duration: AppMotion.enabled(c) ? AppMotion.page : Duration.zero,
        alignment: Alignment.topCenter,
        child: Text(
          widget.text,
          style: AppVitalityStyle.body,
          maxLines: _open ? null : 3,
          overflow: _open ? null : TextOverflow.fade,
        ),
      ),
      TextButton.icon(
        onPressed: () => setState(() => _open = !_open),
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: const Size(0, 24),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          textStyle: AppVitalityStyle.body,
        ),
        iconAlignment: IconAlignment.end,
        icon: Icon(_open ? Icons.expand_less : Icons.expand_more, size: 16),
        label: Text(_open ? c.l10n.vitalityLess : c.l10n.vitalityMore),
      ),
    ],
  );
}

class VitalityForecast extends StatelessWidget {
  const VitalityForecast({
    required this.snapshot,
    required this.color,
    this.onTap,
    super.key,
  });
  final VitalitySnapshot snapshot;
  final Color color;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext c) {
    final s = snapshot;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VitalityLabel(
              s.kind == VitalityKind.recovery
                  ? c.l10n.vitalityForecastRecovery
                  : c.l10n.vitalityForecastEnergy,
            ),
            const SizedBox(height: 14),
            Text(
              vitalityNumber(c, s.forecast.lastOrNull?.score),
              style: AppVitalityStyle.value,
            ),
            const SizedBox(height: 8),
            Text(
              s.forecast.isEmpty
                  ? c.l10n.vitalityNoForecast
                  : c.l10n.vitalityForecastExplanation,
              style: AppVitalityStyle.caption,
            ),
            if (s.forecast.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Column(
                  children: [
                    Row(
                      children: [
                        for (final point in s.forecast)
                          Expanded(
                            child: Text(
                              vitalityNumber(c, point.score),
                              style: AppVitalityStyle.body.copyWith(
                                color: AppColors.textPrimary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 12,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Divider(color: color.withValues(alpha: .35)),
                          Row(
                            children: [
                              for (final _ in s.forecast)
                                Expanded(
                                  child: Center(
                                    child: Container(
                                      width: 5,
                                      height: 5,
                                      decoration: const BoxDecoration(
                                        color: AppColors.textPrimary,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final (index, point) in s.forecast.indexed)
                          Expanded(
                            child: Text(
                              s.kind == VitalityKind.energy
                                  ? TimeOfDay.fromDateTime(
                                      point.at.toLocal(),
                                    ).format(c)
                                  : index == 0
                                  ? c.l10n.vitalityToday
                                  : index == 1
                                  ? c.l10n.vitalityTomorrow
                                  : DateFormat.E(
                                      Localizations.localeOf(c).toLanguageTag(),
                                    ).format(point.at),
                              textAlign: TextAlign.center,
                              style: AppVitalityStyle.caption,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
