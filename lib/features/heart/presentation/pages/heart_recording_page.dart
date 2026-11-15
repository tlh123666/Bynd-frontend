import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/auth/auth_session.dart';
import '../../../../design_system/design_system.dart';
import '../../../../shared/widgets/app_sheet_controls.dart';
import '../../../device/application/device_scope.dart';
import '../../../device/domain/device_models.dart';
import '../../../device/presentation/pages/device_management_page.dart';
import '../../application/heart_recording_controller.dart';
import '../../data/heart_band_gateway.dart';
import '../../domain/heart_models.dart';
import '../heart_copy.dart';
import '../sheets/heart_recording_report.dart';
import '../widgets/heart_charts.dart';
import '../widgets/heart_widgets.dart';

class HeartRecordingPage extends StatefulWidget {
  const HeartRecordingPage({
    required this.repository,
    required this.demo,
    this.gateway,
    super.key,
  });
  final HeartRepository repository;
  final bool demo;
  final HeartBandGateway? gateway;
  @override
  State<HeartRecordingPage> createState() => _HeartRecordingPageState();
}

class _HeartRecordingPageState extends State<HeartRecordingPage>
    with WidgetsBindingObserver {
  late final HeartBandGateway _gateway =
      widget.gateway ??
      (widget.demo ? DemoHeartBandGateway() : NativeHeartBandGateway());
  HeartRecordingController? _controller;
  bool _closing = false;
  bool _foreground = true;
  @override
  void initState() {
    super.initState();
    _foreground = ![
      AppLifecycleState.paused,
      AppLifecycleState.hidden,
      AppLifecycleState.detached,
    ].contains(WidgetsBinding.instance.lifecycleState);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_controller != null) {
      _controller!.removeListener(_changed);
      _controller!.dispose();
    } else {
      _gateway.dispose();
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _foreground = true;
    }
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.detached) {
      _foreground = false;
      if (_controller?.status == HeartRecordingStatus.starting ||
          _controller?.status == HeartRecordingStatus.measuring) {
        unawaited(_controller!.cancel());
      }
    }
  }

  void _changed() {
    if (mounted) setState(() {});
  }

  Future<void> _start() async {
    if (!_foreground || _closing || _controller?.busy == true) return;
    final device = widget.demo
        ? const DeviceSnapshot(
            id: 'demo',
            serialNumber: 'DEMONSTRATION',
            connected: true,
            transportId: 'demo',
          )
        : DeviceScope.maybeOf(context)?.device;
    if (!widget.demo && DeviceScope.maybeOf(context)?.busy == true) {
      AppNotice.show(
        context,
        kind: AppNoticeKind.info,
        message: heartText(
          context,
          'Aguarde a operação da pulseira terminar.',
          'Wait for the current band operation to finish.',
        ),
      );
      return;
    }
    if (device?.connected != true || device?.transportId == null) {
      await Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const DeviceManagementPage()),
      );
      if (mounted) setState(() {});
      return;
    }
    _controller ??= HeartRecordingController(
      repository: widget.repository,
      gateway: _gateway,
      device: device!,
      session: AuthSession.instance,
    )..addListener(_changed);
    await _controller!.start(device: device);
  }

  Future<void> _close() async {
    if (_closing || _controller?.status == HeartRecordingStatus.saving) return;
    _closing = true;
    if (_controller?.busy == true ||
        _controller?.status == HeartRecordingStatus.saveFailed) {
      final confirmed = await AppConfirmationSheet.show(
        context,
        title: heartText(
          context,
          'Interromper a leitura?',
          'Stop this recording?',
        ),
        message: heartText(
          context,
          'A leitura que ainda não foi salva será descartada.',
          'The recording that has not been saved will be discarded.',
        ),
        confirmLabel: heartText(context, 'Descartar', 'Discard'),
        cancelLabel: heartText(context, 'Continuar', 'Continue'),
      );
      if (!confirmed || !mounted) {
        _closing = false;
        return;
      }
    }
    await _controller?.cancel();
    if (mounted) Navigator.pop(context);
    _closing = false;
  }

  @override
  Widget build(BuildContext context) {
    final c = _controller,
        status = c?.status ?? HeartRecordingStatus.ready,
        measuring =
            status == HeartRecordingStatus.starting ||
            status == HeartRecordingStatus.measuring;
    if (status == HeartRecordingStatus.complete && c?.record != null) {
      return HeartRecordingReport(
        repository: widget.repository,
        record: c!.record!,
      );
    }
    return PopScope(
      canPop: c?.busy != true && status != HeartRecordingStatus.saveFailed,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _close();
      },
      child: Column(
        children: [
          SizedBox(
            height: 48,
            child: Row(
              children: [
                IconButton(
                  tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                  onPressed: status == HeartRecordingStatus.saving
                      ? null
                      : _close,
                  icon: const Icon(Icons.close, size: 22),
                ),
                Expanded(
                  child: Text(
                    'ECG',
                    textAlign: TextAlign.center,
                    style: AppHeartStyle.body.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: 17,
                    ),
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(22, 20, 22, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (widget.demo) ...[
                    Text(
                      heartText(
                        context,
                        'DEMONSTRAÇÃO · DADOS SIMULADOS',
                        'DEMONSTRATION · SIMULATED DATA',
                      ),
                      style: AppHeartStyle.kicker,
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (measuring) ...[
                    Text(
                      '${30 - (c?.elapsedSeconds ?? 0)}',
                      style: AppHeartStyle.number,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      heartText(
                        context,
                        'segundos · faltam para terminar',
                        'seconds · remaining',
                      ),
                      style: AppHeartStyle.caption,
                    ),
                    const SizedBox(height: 22),
                    Text(
                      heartText(
                        context,
                        'Lendo o seu pulso.',
                        'Reading your pulse.',
                      ),
                      style: AppHeartStyle.title,
                    ),
                    const SizedBox(height: 14),
                    Text(
                      heartText(
                        context,
                        'Continue com o sensor em contato. Fique parado e sem falar.',
                        'Keep contact with the sensor. Stay still and quiet.',
                      ),
                      style: AppHeartStyle.body,
                    ),
                    const SizedBox(height: 24),
                    HeartWaveform(
                      samples: c?.samples ?? [],
                      height: 180,
                      live: true,
                    ),
                    const SizedBox(height: 20),
                    LinearProgressIndicator(
                      value: (c?.elapsedSeconds ?? 0) / 30,
                      color: AppHeartStyle.family,
                      backgroundColor: AppColors.glassBorder,
                      minHeight: 2,
                    ),
                    const SizedBox(height: 20),
                    HeartStats([
                      (
                        heartText(context, 'Batimento', 'Heart rate'),
                        heartNumber(c?.metrics['heartRate'] as num?),
                      ),
                      (
                        heartText(context, 'Amostras', 'Samples'),
                        '${c?.samples.length ?? 0}',
                      ),
                      (heartText(context, 'Duração', 'Duration'), '30 s'),
                    ]),
                  ] else if (status == HeartRecordingStatus.saving ||
                      status == HeartRecordingStatus.saveFailed) ...[
                    Text(
                      heartText(
                        context,
                        'Sua leitura foi capturada.',
                        'Your recording was captured.',
                      ),
                      style: AppHeartStyle.title,
                    ),
                    const SizedBox(height: 24),
                    HeartWaveform(samples: c!.samples, height: 170),
                    const SizedBox(height: 24),
                    if (status == HeartRecordingStatus.saving)
                      const Center(child: AppLoadingIndicator())
                    else
                      Text(
                        heartText(
                          context,
                          'Não foi possível salvar no servidor. O traçado continua aqui. Tente salvar novamente.',
                          'The server could not save this recording. Your waveform is kept here. Try saving again.',
                        ),
                        style: AppHeartStyle.body,
                      ),
                  ] else ...[
                    SizedBox(
                      height: 230,
                      child: Image.asset(
                        'assets/images/heart-ecg-band.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 18),
                    HeartLabel(
                      heartText(context, 'Como medir', 'How to measure'),
                    ),
                    const SizedBox(height: 18),
                    for (final row in [
                      (
                        heartText(
                          context,
                          'Sente-se e apoie o braço',
                          'Sit down and support your arm',
                        ),
                        heartText(
                          context,
                          'Na mesa ou no colo, com o braço relaxado.',
                          'On a table or your lap, with your arm relaxed.',
                        ),
                      ),
                      (
                        heartText(
                          context,
                          'Mantenha contato com o sensor',
                          'Keep contact with the sensor',
                        ),
                        heartText(
                          context,
                          'Use a pulseira firme, sem apertar, por 30 segundos.',
                          'Wear the band securely, without overtightening, for 30 seconds.',
                        ),
                      ),
                      (
                        heartText(
                          context,
                          'Fique parado e sem falar',
                          'Stay still and quiet',
                        ),
                        heartText(
                          context,
                          'Assim a leitura sai mais limpa.',
                          'This helps produce a cleaner recording.',
                        ),
                      ),
                    ])
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              row.$1,
                              style: AppHeartStyle.body.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(row.$2, style: AppHeartStyle.caption),
                          ],
                        ),
                      ),
                    if (!widget.demo)
                      Text(
                        heartText(
                          context,
                          'O sensor disponível nesta versão registra pulso óptico (PPG). Este sinal não é um ECG elétrico e não classifica arritmias.',
                          'The available sensor records an optical pulse wave (PPG). This signal is not an electrical ECG and does not classify arrhythmias.',
                        ),
                        style: AppHeartStyle.body,
                      ),
                    if (c?.errorCode != null) ...[
                      const SizedBox(height: 18),
                      Text(
                        heartText(
                          context,
                          'Não recebemos uma leitura completa. Verifique a conexão e o contato com o sensor e tente novamente.',
                          'A complete recording was not received. Check the connection and sensor contact, then retry.',
                        ),
                        style: AppHeartStyle.body.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    ],
                    if (!_gateway.supported) ...[
                      const SizedBox(height: 18),
                      Text(
                        heartText(
                          context,
                          'A medição da pulseira está disponível no aplicativo Android. Neste dispositivo você pode consultar seus registros.',
                          'Band measurement is available in the Android app. You can view stored recordings on this device.',
                        ),
                        style: AppHeartStyle.caption,
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ),
          AppSheetSaveButton(
            label: heartText(
              context,
              status == HeartRecordingStatus.saveFailed
                  ? 'Salvar novamente'
                  : measuring
                  ? 'Cancelar'
                  : 'Começar',
              status == HeartRecordingStatus.saveFailed
                  ? 'Retry saving'
                  : measuring
                  ? 'Cancel'
                  : 'Start',
            ),
            loading: status == HeartRecordingStatus.saving,
            onPressed: status == HeartRecordingStatus.saving
                ? null
                : status == HeartRecordingStatus.saveFailed
                ? () => c!.save()
                : measuring
                ? _close
                : _gateway.supported
                ? _start
                : null,
          ),
        ],
      ),
    );
  }
}
