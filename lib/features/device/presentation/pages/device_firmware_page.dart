import 'package:flutter/material.dart';
import '../../../../design_system/design_system.dart';
import '../../application/device_scope.dart';
import '../../domain/device_models.dart';

class DeviceFirmwarePage extends StatefulWidget {
  const DeviceFirmwarePage({super.key});
  @override
  State<DeviceFirmwarePage> createState() => _DeviceFirmwarePageState();
}

class _DeviceFirmwarePageState extends State<DeviceFirmwarePage> {
  bool _started = false;
  bool _checking = true;
  bool _installing = false;
  bool _installed = false;
  FirmwareRelease? _release;
  String? _error;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_started) {
      _started = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _check();
      });
    }
  }

  Future<void> _check() async {
    final controller = DeviceScope.of(context);
    setState(() {
      _checking = true;
      _error = null;
    });
    try {
      final release = await controller.checkFirmware();
      if (mounted) setState(() => _release = release);
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  Future<void> _install() async {
    final controller = DeviceScope.of(context);
    if (!await AppConfirmationSheet.show(
      context,
      title: 'Atualizar a pulseira?',
      message:
          'Mantenha a pulseira perto do celular e não feche o app durante a atualização. A bateria precisa estar acima de 30%.',
      confirmLabel: 'Instalar atualização',
      note: controller.isDemo
          ? 'Demonstração: nenhuma pulseira física será alterada.'
          : null,
    )) {
      return;
    }
    if (!mounted) return;
    setState(() {
      _installing = true;
      _error = null;
    });
    try {
      await controller.perform(
        DeviceOperationType.firmwareUpdate,
        release: _release,
      );
      if (mounted) {
        setState(() {
          _release = null;
          _installed = true;
        });
      }
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
    } finally {
      if (mounted) setState(() => _installing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = DeviceScope.of(context);
    return PopScope(
      canPop: !_installing,
      child: Scaffold(
        body: AppDetailBackground(
          child: SafeArea(
            child: Column(
              children: [
                AppDetailHeader(
                  title: 'Firmware',
                  onClose: _installing ? null : () => Navigator.pop(context),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 44),
                        const Center(
                          child: AppSvgIcon(
                            AppSvgAssets.deviceFirmware,
                            size: 56,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 28),
                        Text(
                          _installing
                              ? 'Atualizando…'
                              : _checking
                              ? 'Verificando atualização…'
                              : _error != null
                              ? 'Vamos tentar de novo.'
                              : _release != null
                              ? 'Uma nova versão chegou.'
                              : _installed
                              ? 'Pulseira atualizada.'
                              : controller.isDemo
                              ? 'Tudo em dia.'
                              : 'Nenhuma atualização disponível.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'Versão atual · ${controller.device?.firmwareVersion.isNotEmpty == true ? controller.device!.firmwareVersion : '—'}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 28),
                        if (_checking || _installing)
                          Center(
                            child: AppLoadingIndicator(
                              label: _installing && controller.progress != null
                                  ? '${(controller.progress! * 100).round()}%'
                                  : 'Aguarde…',
                            ),
                          ),
                        if (_error != null)
                          AppNotice(
                            kind: AppNoticeKind.error,
                            message: _error!,
                          ),
                        if (!_checking && !_installing && _release != null) ...[
                          AppGradientCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Versão ${_release!.version}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  _release!.notes,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    height: 1.5,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          AppButton(
                            label: 'Instalar atualização',
                            expanded: true,
                            onPressed: _install,
                          ),
                        ],
                        if (!_checking && !_installing) ...[
                          const SizedBox(height: 16),
                          AppButton(
                            label: 'Verificar novamente',
                            variant: AppButtonVariant.secondary,
                            expanded: true,
                            onPressed: _check,
                          ),
                        ],
                        if (controller.isDemo)
                          const Padding(
                            padding: EdgeInsets.only(top: 24),
                            child: Text(
                              'Modo demonstração · firmware de referência 2.4.1.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ),
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
