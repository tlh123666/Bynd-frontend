import 'package:flutter/material.dart';
import '../../../../design_system/design_system.dart';
import '../../application/device_scope.dart';

class DeviceInformationPage extends StatelessWidget {
  const DeviceInformationPage({this.safety = false, super.key});
  final bool safety;
  @override
  Widget build(BuildContext context) {
    final controller = DeviceScope.of(context);
    final device = controller.device;
    return Scaffold(
      body: AppDetailBackground(
        child: SafeArea(
          child: Column(
            children: [
              AppDetailHeader(
                title: safety ? 'Segurança e normas' : 'Sobre a pulseira',
                onClose: () => Navigator.pop(context),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(22),
                  children: [
                    if (!safety) ...[
                      Center(
                        child: Image.asset(
                          'assets/images/device-band.png',
                          height: 200,
                          excludeFromSemantics: true,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        device?.modelName ?? 'BYND ONE',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 16),
                      AppGradientCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ID da pulseira · ${device?.serialNumber ?? '—'}',
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Firmware · ${device?.firmwareVersion ?? '—'}',
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Hardware · ${device?.hardwareRevision.isNotEmpty == true ? device!.hardwareRevision : '—'}',
                            ),
                          ],
                        ),
                      ),
                      if (controller.isDemo)
                        const Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: AppNotice(
                            kind: AppNoticeKind.info,
                            message:
                                'Modo demonstração. Os dados e comandos deste ambiente são simulados e ficam neste dispositivo.',
                          ),
                        ),
                    ] else ...[
                      const _InfoBlock(
                        'Cuide da sua pulseira',
                        'Mantenha os sensores e a pele limpos e secos. Use a pulseira com conforto e remova-a se sentir irritação. Siga as instruções fornecidas com o seu modelo.',
                      ),
                      const _InfoBlock(
                        'Carregamento',
                        'Use o carregador indicado pelo fabricante. Não carregue a pulseira molhada e mantenha-a longe de calor excessivo.',
                      ),
                      const _InfoBlock(
                        'Seus dados',
                        'Desparear a pulseira mantém os dados já sincronizados com a sua conta. Apagar dados da pulseira remove apenas registros locais que ainda não foram enviados.',
                      ),
                      const _InfoBlock(
                        'Atualizações',
                        'Mantenha o celular e a pulseira próximos e carregados durante uma atualização. Use apenas pacotes publicados para o seu modelo.',
                      ),
                      const _InfoBlock(
                        'Informações regulatórias',
                        'Consulte a embalagem e o manual do fabricante para certificações e limites de uso específicos do seu modelo.',
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoBlock extends StatelessWidget {
  const _InfoBlock(this.title, this.body);
  final String title, body;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: AppGradientCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10),
          Text(
            body,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    ),
  );
}
