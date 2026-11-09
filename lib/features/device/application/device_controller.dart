import 'dart:math';
import 'package:flutter/foundation.dart';
import '../../../core/network/api_client.dart';
import '../domain/device_gateway.dart';
import '../domain/device_models.dart';
import '../domain/device_repository.dart';

class DeviceController extends ChangeNotifier {
  DeviceController({
    required this.repository,
    required this.gateway,
    required this.isDemo,
  }) : device = isDemo ? DeviceSnapshot.reference() : null;
  final DeviceRepository repository;
  final DeviceGateway gateway;
  final bool isDemo;
  DeviceSnapshot? device;
  bool loading = false;
  bool busy = false;
  bool initialized = false;
  bool _disposed = false;
  String? error;
  String? operationLabel;
  double? progress;
  Future<void>? _initialization;
  static final _random = Random.secure();
  String _requestId() =>
      '${DateTime.now().microsecondsSinceEpoch}-${List.generate(12, (_) => _random.nextInt(256).toRadixString(16).padLeft(2, '0')).join()}';
  void _emit() {
    if (!_disposed) notifyListeners();
  }

  DeviceFailure _failure(Object error) => error is DeviceFailure
      ? error
      : error is ApiException
      ? DeviceFailure(error.message, code: error.code)
      : const DeviceFailure(
          'Não foi possível salvar a alteração. Tente novamente.',
          code: 'storage_error',
        );

  Future<void> initialize() => _initialization ??= refresh();

  Future<void> refresh() async {
    if (loading || busy) return;
    loading = true;
    error = null;
    _emit();
    try {
      device = await repository.restore();
      if (!isDemo && device?.transportId != null) {
        try {
          device = await gateway.read(device!);
          await repository.saveTelemetry(device!);
        } on DeviceFailure {
          device = device!.copyWith(connected: false);
        }
      }
    } catch (cause) {
      error = _failure(cause).message;
    } finally {
      loading = false;
      initialized = true;
      _emit();
    }
  }

  Future<T> _run<T>(String label, Future<T> Function() action) async {
    if (busy || loading) {
      throw const DeviceFailure(
        'Aguarde a operação atual terminar.',
        code: 'busy',
      );
    }
    busy = true;
    operationLabel = label;
    error = null;
    progress = null;
    _emit();
    try {
      return await action();
    } catch (cause) {
      final failure = _failure(cause);
      error = failure.message;
      throw failure;
    } finally {
      busy = false;
      operationLabel = null;
      progress = null;
      _emit();
    }
  }

  Future<List<DiscoveredBand>> scan() =>
      _run('Procurando pulseiras…', () async {
        final found = await gateway.scan();
        return found
            .where(
              (band) =>
                  band.transportId != device?.transportId ||
                  device?.connected != true,
            )
            .toList();
      });

  Future<void> pair(
    DiscoveredBand band,
  ) => _run('Conectando pulseira…', () async {
    final previous = device;
    final connected = await gateway.connect(band);
    try {
      device = await repository.bind(
        connected,
        requestId: _requestId(),
        replacingDeviceId: previous?.serialNumber == connected.serialNumber
            ? null
            : previous?.id,
      );
    } catch (_) {
      try {
        await gateway.disconnect(connected);
      } catch (_) {}
      device = previous;
      rethrow;
    }
    // A previous physical link can be closed after the account swap commits.
    if (previous != null && previous.transportId != connected.transportId) {
      try {
        await gateway.disconnect(previous);
      } catch (_) {}
    }
    try {
      await repository.saveTelemetry(device!);
    } catch (_) {
      throw const DeviceFailure(
        'Pulseira pareada. Não foi possível enviar o estado ao servidor; atualize para tentar novamente.',
        code: 'telemetry_pending',
      );
    }
  });

  Future<void> unpair() => _run('Despareando pulseira…', () async {
    final current = device;
    if (current == null) return;
    await repository.unbind(current.id);
    device = null;
    try {
      if (current.transportId != null) await gateway.disconnect(current);
    } catch (_) {
      throw const DeviceFailure(
        'Pulseira removida da conta. Desative o Bluetooth para encerrar a conexão deste celular.',
        code: 'disconnect_pending',
      );
    }
  });

  Future<FirmwareRelease?> checkFirmware() =>
      _run('Verificando atualização…', () async {
        final current = device;
        if (current == null) {
          throw const DeviceFailure(
            'Pareie uma pulseira para verificar atualizações.',
          );
        }
        return repository.checkFirmware(current);
      });

  Future<void> perform(
    DeviceOperationType type, {
    FirmwareRelease? release,
  }) => _run(
    type == DeviceOperationType.restart
        ? 'Reiniciando pulseira…'
        : type == DeviceOperationType.eraseData
        ? 'Apagando dados da pulseira…'
        : 'Atualizando firmware…',
    () async {
      final before = device;
      if (before == null || !before.connected) {
        throw const DeviceFailure(
          'Conecte a pulseira antes de continuar.',
          code: 'device_disconnected',
        );
      }
      final current = await gateway.read(before);
      device = current;
      if (!current.connected) {
        throw const DeviceFailure(
          'A pulseira desconectou. Conecte novamente antes de continuar.',
          code: 'device_disconnected',
        );
      }
      await repository.saveTelemetry(current);
      if (type == DeviceOperationType.firmwareUpdate &&
          (release == null ||
              current.batteryPercent == null ||
              current.batteryPercent! < 30)) {
        throw const DeviceFailure(
          'A pulseira precisa de pelo menos 30% de bateria para atualizar.',
          code: 'battery_low',
        );
      }
      final operation = await repository.beginOperation(
        current,
        type,
        _requestId(),
        release: release,
      );
      if (operation.status == 'succeeded') return;
      if (operation.status != 'pending') {
        throw const DeviceFailure(
          'Esta operação já foi encerrada. Atualize a página.',
        );
      }
      try {
        if (type == DeviceOperationType.firmwareUpdate) {
          await gateway.installFirmware(current, release!, (value) {
            progress = value;
            _emit();
          });
        } else {
          await gateway.execute(current, type);
        }
      } catch (cause) {
        try {
          await repository.finishOperation(
            current,
            operation,
            succeeded: false,
            errorCode: _failure(cause).code,
          );
        } catch (_) {}
        rethrow;
      }
      if (release != null) {
        device = current.copyWith(firmwareVersion: release.version);
      }
      if (type == DeviceOperationType.restart && !isDemo) {
        device = device?.copyWith(connected: false);
      }
      try {
        await repository.finishOperation(
          current,
          operation,
          succeeded: true,
          firmwareVersion: release?.version,
        );
        if (device != null) await repository.saveTelemetry(device!);
      } catch (_) {
        throw const DeviceFailure(
          'A pulseira concluiu a operação. O registro no servidor será reenviado ao atualizar.',
          code: 'result_pending',
        );
      }
    },
  );

  @override
  void dispose() {
    _disposed = true;
    repository.close();
    super.dispose();
  }
}
