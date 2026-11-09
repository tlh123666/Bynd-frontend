import 'package:flutter/material.dart';
import '../../../../design_system/design_system.dart';
import '../../domain/device_models.dart';

class DeviceMenuTile extends StatelessWidget {
  const DeviceMenuTile({
    required this.device,
    required this.onTap,
    this.loading = false,
    super.key,
  });
  final DeviceSnapshot? device;
  final VoidCallback onTap;
  final bool loading;
  @override
  Widget build(BuildContext context) => Semantics(
    label: device == null
        ? 'Conectar pulseira BYND'
        : '${device!.modelName}, ${device!.connected ? 'conectada' : 'desconectada'}, bateria ${device!.batteryPercent ?? 'desconhecida'}',
    button: true,
    child: AppGradientCard(
      onTap: onTap,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Image.asset(
            'assets/images/device-band.png',
            width: 40,
            height: 44,
            fit: BoxFit.contain,
            excludeFromSemantics: true,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        device?.modelName ?? 'Conectar pulseira',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (device?.batteryPercent != null)
                      Text(
                        '${device!.batteryPercent}%',
                        style: const TextStyle(
                          fontSize: 13.5,
                          color: AppColors.textSecondary,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: device?.connected == true
                            ? AppColors.success
                            : AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        loading
                            ? 'Carregando…'
                            : device == null
                            ? 'Adicionar uma BYND'
                            : device!.connected
                            ? 'Conectada · ${_elapsed(device!.lastSyncedAt)}'
                            : 'Desconectada',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textKicker,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          const Text(
            '›',
            style: TextStyle(fontSize: 20, color: AppColors.menuChevron),
          ),
        ],
      ),
    ),
  );
  String _elapsed(DateTime? date) {
    if (date == null) return 'sem sincronização';
    final minutes = DateTime.now().difference(date).inMinutes;
    return minutes < 1
        ? 'agora'
        : minutes < 60
        ? 'há $minutes min'
        : 'há ${minutes ~/ 60} h';
  }
}
