import 'package:flutter/material.dart';
import '../../../../design_system/design_system.dart';
import '../../application/device_controller.dart';
import '../../application/device_scope.dart';
import '../../domain/device_models.dart';

class DevicePairingPage extends StatefulWidget {
  const DevicePairingPage({super.key});
  @override
  State<DevicePairingPage> createState() => _DevicePairingPageState();
}

class _DevicePairingPageState extends State<DevicePairingPage> {
  List<DiscoveredBand> _bands = [];
  bool _scanning = true;
  bool _pairing = false;
  String? _error;
  bool _started = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _scan();
    });
  }

  Future<void> _scan() async {
    final controller = DeviceScope.of(context);
    setState(() {
      _scanning = true;
      _error = null;
      _bands = [];
    });
    try {
      final bands = await controller.scan();
      if (mounted) setState(() => _bands = bands);
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
    } finally {
      if (mounted) setState(() => _scanning = false);
    }
  }

  Future<void> _pair(DiscoveredBand band, DeviceController controller) async {
    if (_pairing) return;
    final replacing = controller.device;
    if (replacing != null &&
        !await AppConfirmationSheet.show(
          context,
          title: 'Substituir a pulseira?',
          message:
              '${band.name} será a pulseira deste app. Os dados já enviados pela sua pulseira atual ficam guardados.',
          confirmLabel: 'Parear pulseira',
          note: controller.isDemo
              ? 'Demonstração: nenhuma pulseira física será alterada.'
              : null,
        )) {
      return;
    }
    if (!mounted) return;
    setState(() {
      _pairing = true;
      _error = null;
    });
    try {
      await controller.pair(band);
      if (mounted) {
        AppNotice.success(
          context,
          controller.isDemo
              ? 'Demonstração: pulseira pareada.'
              : 'Pulseira pareada.',
        );
        Navigator.pop(context, true);
      }
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
    } finally {
      if (mounted) setState(() => _pairing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = DeviceScope.of(context);
    return PopScope(
      canPop: !_pairing,
      child: Scaffold(
        body: AppDetailBackground(
          child: SafeArea(
            child: Column(
              children: [
                AppDetailHeader(
                  title: 'Parear pulseira',
                  onClose: _pairing ? null : () => Navigator.pop(context),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(22, 24, 22, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Image.asset(
                            'assets/images/device-band.png',
                            height: 180,
                            excludeFromSemantics: true,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Sua BYND, por perto.',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Ative o Bluetooth, deixe a pulseira carregada e aproxime-a do celular. Selecione a sua pulseira quando ela aparecer.',
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        if (controller.isDemo) ...[
                          const SizedBox(height: 16),
                          const AppNotice(
                            kind: AppNoticeKind.info,
                            message:
                                'Modo demonstração. As pulseiras abaixo são simuladas.',
                          ),
                        ],
                        const SizedBox(height: 24),
                        if (_scanning || _pairing)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: AppLoadingIndicator(
                                label: _pairing
                                    ? 'Conectando pulseira…'
                                    : 'Procurando pulseiras…',
                              ),
                            ),
                          ),
                        if (_error != null) ...[
                          AppNotice(
                            kind: AppNoticeKind.error,
                            message: _error!,
                          ),
                          const SizedBox(height: 16),
                        ],
                        if (!_scanning && !_pairing) ...[
                          if (_bands.isEmpty && _error == null)
                            const Text(
                              'Nenhuma pulseira encontrada. Confira o Bluetooth e tente novamente.',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                height: 1.5,
                              ),
                            ),
                          for (final band in _bands)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: AppActionCard(
                                title: band.name,
                                description:
                                    'Sinal ${band.rssi >= -65 ? 'forte' : 'próximo'} · toque para conectar',
                                iconAsset: AppSvgAssets.devicePair,
                                onTap: () => _pair(band, controller),
                              ),
                            ),
                          const SizedBox(height: 18),
                          AppButton(
                            label: 'Procurar novamente',
                            expanded: true,
                            variant: AppButtonVariant.secondary,
                            onPressed: _scan,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
