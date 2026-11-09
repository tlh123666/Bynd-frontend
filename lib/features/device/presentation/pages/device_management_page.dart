import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../design_system/design_system.dart';
import '../../application/device_controller.dart';
import '../../application/device_scope.dart';
import '../../domain/device_models.dart';
import '../widgets/device_connection_scene.dart';
import 'device_firmware_page.dart';
import 'device_information_page.dart';
import 'device_pairing_page.dart';

class DeviceManagementPage extends StatefulWidget {
  const DeviceManagementPage({super.key});
  @override
  State<DeviceManagementPage> createState() => _DeviceManagementPageState();
}

class _DeviceManagementPageState extends State<DeviceManagementPage> {
  int _tab = 0;
  bool _confirming = false;
  void _open(Widget page) =>
      Navigator.of(context).push<void>(MaterialPageRoute(builder: (_) => page));
  Future<void> _confirm(
    DeviceController controller, {
    required String title,
    required String message,
    required String confirm,
    required Future<void> Function() action,
    required String success,
    bool danger = false,
  }) async {
    if (_confirming || controller.busy) return;
    _confirming = true;
    final accepted = await AppConfirmationSheet.show(
      context,
      title: title,
      message: message,
      confirmLabel: confirm,
      danger: danger,
      note: controller.isDemo
          ? 'Demonstração: nenhuma pulseira física será alterada.'
          : null,
    );
    _confirming = false;
    if (!accepted || !mounted) return;
    try {
      await action();
      if (mounted) {
        AppNotice.success(
          context,
          '${controller.isDemo ? 'Demonstração: ' : ''}$success',
        );
      }
    } catch (error) {
      if (mounted) AppNotice.error(context, error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = DeviceScope.of(context);
    final device = controller.device;
    return PopScope(
      canPop: !controller.busy,
      child: Scaffold(
        body: AppDetailBackground(
          child: Padding(
            padding: EdgeInsets.only(
              top: math.max(20, MediaQuery.paddingOf(context).top),
            ),
            child: AppLoadingOverlay(
              loading: controller.busy,
              label: controller.operationLabel ?? 'Aguarde…',
              child: RefreshIndicator(
                onRefresh: controller.refresh,
                color: AppColors.textPrimary,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _DeviceHeader(
                        onClose: () => Navigator.pop(context),
                        onInfo: () => _open(const DeviceInformationPage()),
                      ),
                    ),
                    if (controller.loading && !controller.initialized)
                      const SliverFillRemaining(
                        child: Center(
                          child: AppLoadingIndicator(
                            label: 'Carregando pulseira…',
                          ),
                        ),
                      )
                    else ...[
                      if (controller.error != null)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(22),
                            child: Column(
                              children: [
                                AppNotice(
                                  kind: AppNoticeKind.error,
                                  message: controller.error!,
                                ),
                                const SizedBox(height: 12),
                                AppButton(
                                  label: 'Tentar novamente',
                                  variant: AppButtonVariant.secondary,
                                  onPressed: controller.refresh,
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (device == null)
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: _EmptyDevice(
                            onPair: () => _open(const DevicePairingPage()),
                          ),
                        )
                      else ...[
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(22, 18, 22, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: _Identity(
                                    label: device.connected
                                        ? 'CONECTADA A'
                                        : 'PULSEIRA PAREADA',
                                    value: device.displayName,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _Identity(
                                    label: 'ÚLTIMA SINCRONIZAÇÃO',
                                    value: _syncLabel(device.lastSyncedAt),
                                    right: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 22),
                            child: AppUnderlineTabs(
                              labels: const ['Estado', 'Avançada'],
                              selectedIndex: _tab,
                              onChanged: (index) =>
                                  setState(() => _tab = index),
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: AnimatedSwitcher(
                            duration: AppMotion.enabled(context)
                                ? AppMotion.feedback
                                : Duration.zero,
                            child: _tab == 0
                                ? _DeviceStatus(
                                    key: const ValueKey('status'),
                                    device: device,
                                    isDemo: controller.isDemo,
                                    onPair: () =>
                                        _open(const DevicePairingPage()),
                                  )
                                : _advanced(controller, device),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: SizedBox(
                            height: 40 + MediaQuery.paddingOf(context).bottom,
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _advanced(
    DeviceController controller,
    DeviceSnapshot device,
  ) => Padding(
    key: const ValueKey('advanced'),
    padding: const EdgeInsets.fromLTRB(21, 20, 21, 0),
    child: Column(
      children: [
        AppGradientCard(
          child: IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: _SmallInfo(
                    label: 'ID da pulseira',
                    value: device.serialNumber,
                  ),
                ),
                const VerticalDivider(
                  width: 32,
                  color: AppColors.deviceDivider,
                ),
                Expanded(
                  child: _SmallInfo(
                    label: 'Firmware',
                    value:
                        '${device.firmwareVersion.isEmpty ? '—' : device.firmwareVersion}${controller.isDemo ? ' · atualizado' : ''}',
                  ),
                ),
              ],
            ),
          ),
        ),
        _action(
          'Parear outra pulseira',
          'Conecte uma pulseira BYND nova. Ela substitui a que está pareada agora.',
          AppSvgAssets.devicePair,
          () => _open(const DevicePairingPage()),
        ),
        _action(
          'Desparear a pulseira',
          'Remove a ligação Bluetooth entre esta pulseira e o app.',
          AppSvgAssets.deviceUnpair,
          () => _confirm(
            controller,
            title: 'Desparear a pulseira?',
            message:
                'A ligação entre esta pulseira e a sua conta será removida. Seus dados já sincronizados continuam guardados.',
            confirm: 'Desparear',
            action: controller.unpair,
            success: 'Pulseira despareada.',
          ),
        ),
        _action(
          'Atualizar o firmware',
          'Procura e instala a versão mais recente do sistema da pulseira.',
          AppSvgAssets.deviceFirmware,
          () => _open(const DeviceFirmwarePage()),
        ),
        _action(
          'Reiniciar a pulseira',
          'Desliga e liga de novo. Seus dados ficam guardados.',
          AppSvgAssets.deviceRestart,
          () => _confirm(
            controller,
            title: 'Reiniciar a pulseira?',
            message:
                'A conexão será interrompida por alguns instantes. Seus dados ficam guardados.',
            confirm: 'Reiniciar',
            action: () => controller.perform(DeviceOperationType.restart),
            success: 'Reinício confirmado pela pulseira.',
          ),
        ),
        _action(
          'Segurança e normas',
          'Informações de segurança, certificações e cuidados com a pulseira.',
          AppSvgAssets.deviceSafety,
          () => _open(const DeviceInformationPage(safety: true)),
        ),
        _action(
          'Apagar dados da pulseira',
          'Apaga os batimentos e o sono guardados na pulseira que ainda não foram enviados. Não dá para recuperar.',
          AppSvgAssets.deviceErase,
          () => _confirm(
            controller,
            title: 'Apagar dados da pulseira?',
            message:
                'Os batimentos e o sono que ainda não foram enviados serão apagados. Não dá para recuperar. Os dados já sincronizados com sua conta ficam guardados.',
            confirm: 'Apagar dados',
            danger: true,
            action: () => controller.perform(DeviceOperationType.eraseData),
            success: 'Dados locais da pulseira apagados.',
          ),
          danger: true,
        ),
      ],
    ),
  );
  Widget _action(
    String title,
    String description,
    String icon,
    VoidCallback onTap, {
    bool danger = false,
  }) => Padding(
    padding: const EdgeInsets.only(top: 10),
    child: AppActionCard(
      title: title,
      description: description,
      iconAsset: icon,
      onTap: onTap,
      danger: danger,
    ),
  );
  String _syncLabel(DateTime? date) {
    if (date == null) return '—';
    final local = date.toLocal(), now = DateTime.now();
    final day =
        local.year == now.year &&
            local.month == now.month &&
            local.day == now.day
        ? 'hoje'
        : '${local.day}/${local.month}';
    return '$day, ${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
  }
}

class _DeviceHeader extends SliverPersistentHeaderDelegate {
  _DeviceHeader({required this.onClose, required this.onInfo});
  final VoidCallback onClose, onInfo;
  @override
  double get minExtent => 52;
  @override
  double get maxExtent => 52;
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) => ColoredBox(
    color: overlapsContent
        ? AppColors.profileMiddle.withValues(alpha: .96)
        : Colors.transparent,
    child: AppDetailHeader(title: 'Pulseira', onClose: onClose, onInfo: onInfo),
  );
  @override
  bool shouldRebuild(covariant _DeviceHeader oldDelegate) => true;
}

class _Identity extends StatelessWidget {
  const _Identity({
    required this.label,
    required this.value,
    this.right = false,
  });
  final String label, value;
  final bool right;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: right
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start,
    children: [
      Text(
        label,
        textAlign: right ? TextAlign.right : TextAlign.left,
        style: const TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.47,
          height: 14 / 10.5,
          color: AppColors.textInactive,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        value,
        textAlign: right ? TextAlign.right : TextAlign.left,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          height: 19 / 15,
        ),
      ),
    ],
  );
}

class _SmallInfo extends StatelessWidget {
  const _SmallInfo({required this.label, required this.value});
  final String label, value;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontSize: 11.5,
          color: AppColors.textHalf,
          height: 1.3,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        value,
        style: const TextStyle(
          fontSize: 14.5,
          fontWeight: FontWeight.w500,
          height: 1.3,
        ),
      ),
    ],
  );
}

class _DeviceStatus extends StatelessWidget {
  const _DeviceStatus({
    required this.device,
    required this.isDemo,
    required this.onPair,
    super.key,
  });
  final DeviceSnapshot device;
  final bool isDemo;
  final VoidCallback onPair;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 30),
    child: Column(
      children: [
        DeviceConnectionScene(connected: device.connected),
        const SizedBox(height: 18),
        Text(
          device.connected ? 'PULSEIRA CONECTADA' : 'PULSEIRA DESCONECTADA',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.82,
          ),
        ),
        const SizedBox(height: 8),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Text(
            device.connected
                ? isDemo
                      ? 'Bateria em ${device.batteryPercent}%, dura mais uns 3 dias. Os dados chegam ao app a cada 5 minutos.'
                      : 'Bateria em ${device.batteryPercent ?? '—'}%. Os dados aparecem aqui após a sincronização com a pulseira.'
                : 'Aproxime a pulseira do celular e confira se o Bluetooth está ativado.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
              color: AppColors.menuIcon,
            ),
          ),
        ),
        if (!device.connected)
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: AppButton(
              label: 'Conectar pulseira',
              variant: AppButtonVariant.secondary,
              onPressed: onPair,
            ),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 28, 22, 0),
          child: AppGradientCard(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: _Metric(
                      'Bateria',
                      device.batteryPercent == null
                          ? '—'
                          : '${device.batteryPercent}%',
                    ),
                  ),
                  const VerticalDivider(
                    width: 1,
                    color: AppColors.deviceDivider,
                  ),
                  Expanded(
                    child: _Metric(
                      'Sinal',
                      device.connected ? device.signalLabel : '—',
                    ),
                  ),
                  const VerticalDivider(
                    width: 1,
                    color: AppColors.deviceDivider,
                  ),
                  Expanded(
                    child: _Metric(
                      'Firmware',
                      device.firmwareVersion.isEmpty
                          ? '—'
                          : device.firmwareVersion,
                    ),
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

class _Metric extends StatelessWidget {
  const _Metric(this.label, this.value);
  final String label, value;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(
        label,
        style: const TextStyle(fontSize: 11.5, color: AppColors.textHalf),
      ),
      const SizedBox(height: 4),
      Text(
        value,
        style: const TextStyle(
          fontFamily: AppFontFamilies.urbanist,
          fontSize: 24,
          fontWeight: FontWeight.w300,
          height: 1.2,
        ),
      ),
    ],
  );
}

class _EmptyDevice extends StatelessWidget {
  const _EmptyDevice({required this.onPair});
  final VoidCallback onPair;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(22),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/device-band.png',
          height: 200,
          excludeFromSemantics: true,
        ),
        const SizedBox(height: 28),
        const Text(
          'Sua próxima conexão.',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w300),
        ),
        const SizedBox(height: 12),
        const Text(
          'Conecte sua pulseira BYND para acompanhar o corpo, todos os dias.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            height: 1.5,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 28),
        AppButton(label: 'Parear pulseira', expanded: true, onPressed: onPair),
      ],
    ),
  );
}
