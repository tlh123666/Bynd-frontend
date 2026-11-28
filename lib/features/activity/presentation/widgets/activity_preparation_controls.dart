import 'package:flutter/material.dart';

import '../../../../design_system/design_system.dart';
import '../../../../l10n/app_localizations_context.dart';

/// 准备页的演示面板；数值仅用于展示，不代表设备或实际建议。
class ActivityPreparationControls extends StatefulWidget {
  const ActivityPreparationControls({super.key});

  @override
  State<ActivityPreparationControls> createState() =>
      _ActivityPreparationControlsState();
}

class _ActivityPreparationControlsState
    extends State<ActivityPreparationControls> {
  bool _enabled = true;

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    return AppFrostedSurface.modalSheet(
      key: const ValueKey('activity-preparation-controls'),
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppRadii.sheet),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 38,
              height: 5,
              decoration: const BoxDecoration(
                color: AppColors.textMuted,
                borderRadius: AppRadii.pillBorder,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0x12ffffff),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.cloud_outlined,
                        size: 20,
                        color: Color(0xfff1d98c),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '26°',
                        style: AppTypography.page.copyWith(fontSize: 24),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Brasília',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.textMuted,
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          s.preparationWeatherOk,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.caption.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    s.preparationWeatherExample,
                    style: AppTypography.body.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    s.preparationDemoLabel,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    value: _enabled ? .24 : 0,
                    strokeWidth: 2,
                    color: AppColors.textPrimary,
                    backgroundColor: AppColors.textMuted,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _enabled ? '24' : '–',
                        style: AppTypography.page.copyWith(
                          fontSize: 24,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (_enabled)
                        Text.rich(
                          TextSpan(
                            style: AppTypography.caption.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                            children: [
                              TextSpan(text: '${s.preparationLoadBase} · '),
                              TextSpan(
                                text: s.preparationLoadLevel,
                                style: const TextStyle(
                                  color: Color(0xff86d4a3),
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        Text(
                          s.preparationLoadOff,
                          style: AppTypography.caption.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                    ],
                  ),
                ),
                Switch.adaptive(
                  value: _enabled,
                  onChanged: (value) => setState(() => _enabled = value),
                  activeTrackColor: const Color(0xff505257),
                  thumbColor: const WidgetStatePropertyAll(Colors.white),
                  trackOutlineColor: const WidgetStatePropertyAll(
                    Color(0xff898c90),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: 272,
              height: 48,
              child: AppButton(
                label: s.startActivityButton,
                onPressed: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(s.waitingForSensors)));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
