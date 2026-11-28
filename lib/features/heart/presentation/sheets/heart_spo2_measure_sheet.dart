import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../design_system/design_system.dart';
import '../../../device/domain/device_models.dart';
import '../../data/heart_band_gateway.dart';
import '../heart_copy.dart';

/// 「Measure now」血氧弹层：一次性读数，单独展示，
/// 永不混入夜间平均值（客户 11-27 确认的口径）。
class HeartSpo2MeasureSheet extends StatefulWidget {
  const HeartSpo2MeasureSheet({
    required this.gateway,
    required this.device,
    super.key,
  });

  final HeartBandGateway gateway;
  final DeviceSnapshot device;

  @override
  State<HeartSpo2MeasureSheet> createState() => _HeartSpo2MeasureSheetState();
}

class _HeartSpo2MeasureSheetState extends State<HeartSpo2MeasureSheet> {
  bool _running = true;
  int? _spo2;
  int? _heartRate;
  String? _error;
  int _request = 0;
  int _elapsedSeconds = 0;
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && _running) {
        setState(() => _elapsedSeconds++);
      }
    });
    _measure();
  }

  String get _elapsedLabel {
    final m = _elapsedSeconds ~/ 60;
    final s = _elapsedSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  Future<void> _measure() async {
    final request = ++_request;
    setState(() {
      _running = true;
      _elapsedSeconds = 0;
      _error = null;
    });
    try {
      final result = await widget.gateway.measureSpo2Now(widget.device);
      if (!mounted || request != _request) return;
      setState(() {
        _spo2 = (result['spo2'] as num?)?.toInt();
        _heartRate = (result['heartRate'] as num?)?.toInt();
        _running = false;
        if (_spo2 == null) {
          _error = heartText(
            context,
            'A pulseira não informou o valor. Tente novamente.',
            'The band did not report a value. Please try again.',
          );
        }
      });
    } catch (error) {
      if (!mounted || request != _request) return;
      setState(() {
        _running = false;
        _error = heartText(
          context,
          'Não foi possível concluir a leitura. Fique parado e tente novamente.',
          'The reading did not finish. Stay still and try again.',
        );
      });
    }
  }

  @override
  void dispose() {
    _request++;
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String copy(String pt, String en) => heartText(context, pt, en);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              copy('Medir SpO2 agora', 'Measure SpO2 now'),
              style: AppHealthStyle.title,
            ),
            const SizedBox(height: 8),
            Text(
              copy(
                'Esta leitura é pontual e não entra na média noturna.',
                'This is a one-off reading, never mixed into the night average.',
              ),
              style: AppHealthStyle.small,
            ),
            const SizedBox(height: 28),
            if (_running) ...[
              Text(
                copy(
                  'Fique parado e relaxado até o fim da leitura.',
                  'Stay still and relaxed until the reading finishes.',
                ),
                textAlign: TextAlign.center,
                style: AppHealthStyle.body,
              ),
              const SizedBox(height: 24),
              const Center(child: AppLoadingIndicator()),
              const SizedBox(height: 12),
              Text(
                '${copy('Tempo', 'Elapsed')} $_elapsedLabel · ${copy('cerca de 1 min', 'about 1 min')}',
                textAlign: TextAlign.center,
                style: AppHealthStyle.small,
              ),
            ] else if (_spo2 != null) ...[
              Text(
                '$_spo2%',
                textAlign: TextAlign.center,
                style: AppHealthStyle.hero,
              ),
              const SizedBox(height: 6),
              Text(
                copy('Leitura agora', 'Reading now'),
                textAlign: TextAlign.center,
                style: AppHealthStyle.body,
              ),
              if (_heartRate != null) ...[
                const SizedBox(height: 4),
                Text(
                  '$_heartRate bpm',
                  textAlign: TextAlign.center,
                  style: AppHealthStyle.small,
                ),
              ],
            ] else ...[
              Text(
                _error ??
                    copy('Leitura não concluída.', 'Reading not completed.'),
                textAlign: TextAlign.center,
                style: AppHealthStyle.body,
              ),
              const SizedBox(height: 20),
              AppButton(
                label: copy('Tentar de novo', 'Try again'),
                onPressed: _measure,
                variant: AppButtonVariant.secondary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
