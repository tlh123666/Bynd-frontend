import 'package:flutter/material.dart';
import '../../../../design_system/design_system.dart';
import '../../../../l10n/app_localizations_context.dart';
import '../../domain/home_models.dart';

class HomeSignalsSection extends StatelessWidget {
  const HomeSignalsSection({
    required this.snapshot,
    required this.signals,
    required this.onSignal,
    required this.onCustomize,
    required this.onAll,
    super.key,
  });
  final HomeSnapshot snapshot;
  final List<HomeSignal> signals;
  final ValueChanged<HomeSignal> onSignal;
  final VoidCallback onCustomize, onAll;
  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 32, 8, 7),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: onAll,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      strings.homeSignals,
                      style: AppTypography.section,
                    ),
                  ),
                ),
              ),
              IconButton(
                constraints: const BoxConstraints.tightFor(
                  width: 44,
                  height: 44,
                ),
                onPressed: onCustomize,
                tooltip: strings.homeCustomize,
                icon: const AppSvgIcon(
                  AppSvgAssets.homeCustomize,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            final textScale =
                MediaQuery.textScalerOf(context).scale(14.5) / 14.5;
            final height =
                AppSizes.signalHeight + (textScale - 1).clamp(0, 3) * 56;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: signals.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: constraints.maxWidth < 300 ? 1 : 2,
                mainAxisExtent: height,
                mainAxisSpacing: AppSizes.signalGap,
                crossAxisSpacing: AppSizes.signalGap,
              ),
              itemBuilder: (context, i) {
                final measurement = snapshot.measurement(signals[i]);
                return AppSignalCard(
                  key: ValueKey('home-signal-${signals[i].name}'),
                  label: signals[i].label(strings.localeName),
                  iconAsset: signals[i].iconAsset,
                  value: signals[i].format(
                    measurement.value,
                    strings.localeName,
                  ),
                  unit: measurement.value == null ? '' : signals[i].unit,
                  caption: measurement.value == null
                      ? strings.homeNoMeasurement
                      : measurement.caption,
                  captionColor: measurement.value == null
                      ? AppColors.textMuted
                      : switch (measurement.status) {
                          HomeSignalStatus.good => AppColors.sage,
                          HomeSignalStatus.attention =>
                            AppColors.signalAttention,
                          HomeSignalStatus.neutral => AppColors.textMuted,
                        },
                  onPressed: () => onSignal(signals[i]),
                );
              },
            );
          },
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 20, top: 10),
            child: TextButton(
              onPressed: onAll,
              child: Text(
                strings.homeAllSignals,
                style: AppTypography.label.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
