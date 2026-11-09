import 'package:flutter/material.dart';
import '../../../../design_system/design_system.dart';
import '../../../../l10n/app_localizations_context.dart';
import '../../../../shared/widgets/day_strip.dart';
import '../../application/home_controller.dart';
import '../../domain/home_models.dart';
import 'home_signal_detail_page.dart';
import '../widgets/home_account_guard.dart';

class HomeSignalsPage extends StatelessWidget {
  const HomeSignalsPage({required this.controller, super.key});
  final HomeController controller;
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.homeCanvas,
    body: AppDetailBackground(
      child: SafeArea(
        child: ListenableBuilder(
          listenable: controller,
          builder: (context, _) => Column(
            children: [
              AppDetailHeader(
                title: context.l10n.homeNumbers,
                onClose: () => Navigator.pop(context),
              ),
              DayStrip(day: controller.day, onDayChanged: controller.setDay),
              Expanded(
                child: controller.loading
                    ? const Center(child: AppLoadingIndicator())
                    : controller.error != null
                    ? Center(
                        child: AppButton(
                          label: context.l10n.homeRetry,
                          onPressed: controller.reload,
                        ),
                      )
                    : ListView(
                        padding: const EdgeInsets.all(22),
                        children: [
                          for (final signal in HomeSignal.values)
                            Container(
                              decoration: const BoxDecoration(
                                border: Border(bottom: AppBorders.divider),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                leading: AppSvgIcon(
                                  signal.iconAsset,
                                  size: 22,
                                  color: AppColors.textSecondary,
                                ),
                                title: Text(
                                  signal.label(context.l10n.localeName),
                                  style: AppTypography.listItem,
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      signal.format(
                                        controller.snapshot
                                            ?.measurement(signal)
                                            .value,
                                        context.l10n.localeName,
                                      ),
                                      style: AppTypography.title.copyWith(
                                        fontSize: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      controller.snapshot
                                                  ?.measurement(signal)
                                                  .value ==
                                              null
                                          ? ''
                                          : signal.unit,
                                      style: AppTypography.caption.copyWith(
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    const Icon(
                                      Icons.chevron_right,
                                      color: AppColors.menuChevron,
                                      size: 18,
                                    ),
                                  ],
                                ),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (_) => HomeAccountGuard(
                                      controller: controller,
                                      child: HomeSignalDetailPage(
                                        controller: controller,
                                        signal: signal,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
