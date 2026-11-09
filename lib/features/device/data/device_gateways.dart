import 'dart:async';
import 'package:flutter/services.dart';
import '../domain/device_gateway.dart';
import '../domain/device_models.dart';

class DemoDeviceGateway implements DeviceGateway {
  @override
  Future<List<DiscoveredBand>> scan() async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    return const [
      DiscoveredBand(
        transportId: 'demo-7B0082',
        name: 'BYND ONE · 7B0082',
        rssi: -52,
      ),
      DiscoveredBand(
        transportId: 'demo-5A0047',
        name: 'BYND ONE · 5A0047',
        rssi: -62,
      ),
    ];
  }

  @override
  Future<DeviceSnapshot> connect(DiscoveredBand band) async {
    await Future<void>.delayed(const Duration(milliseconds: 650));
    return DeviceSnapshot(
      id: band.transportId,
      serialNumber: '${band.transportId.replaceFirst('demo-', '')} 1901',
      firmwareVersion: '2.4.1',
      hardwareRevision: '1.0',
      batteryPercent: 82,
      rssi: band.rssi,
      connected: true,
      observedAt: DateTime.now(),
      lastSyncedAt: DateTime.now(),
      transportId: band.transportId,
    );
  }

  @override
  Future<void> disconnect(DeviceSnapshot device) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
  }

  @override
  Future<DeviceSnapshot> read(DeviceSnapshot device) async =>
      device.copyWith(connected: true, observedAt: DateTime.now());
  @override
  Future<void> execute(DeviceSnapshot device, DeviceOperationType type) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
  }

  @override
  Future<void> installFirmware(
    DeviceSnapshot device,
    FirmwareRelease release,
    void Function(double) onProgress,
  ) async {
    for (var i = 1; i <= 10; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 160));
      onProgress(i / 10);
    }
  }
}

class MethodChannelDeviceGateway implements DeviceGateway {
  const MethodChannelDeviceGateway({
    this.channel = const MethodChannel('com.bynd/device_management'),
    this.events = const EventChannel('com.bynd/device_management_events'),
  });
  final MethodChannel channel;
  final EventChannel events;

  Future<T?> _call<T>(String method, [Map<String, dynamic>? arguments]) async {
    try {
      return await channel
          .invokeMethod<T>(method, arguments)
          .timeout(const Duration(seconds: 30));
    } on MissingPluginException {
      throw const DeviceFailure(
        'O Bluetooth da pulseira ainda não está disponível nesta versão do app.',
        code: 'unsupported_platform',
      );
    } on TimeoutException {
      throw const DeviceFailure(
        'A pulseira não respondeu. Aproxime-a do celular e tente novamente.',
        code: 'device_timeout',
      );
    } on PlatformException catch (error) {
      throw DeviceFailure(switch (error.code) {
        'permission_denied' =>
          'Permita o acesso ao Bluetooth nas configurações do celular.',
        'bluetooth_off' => 'Ative o Bluetooth para conectar sua pulseira.',
        'device_disconnected' =>
          'A pulseira desconectou. Aproxime-a do celular.',
        _ => 'Não foi possível comunicar com a pulseira. Tente novamente.',
      }, code: error.code);
    }
  }

  Map<String, dynamic> _args(DeviceSnapshot device) {
    if (device.transportId == null) {
      throw const DeviceFailure(
        'Encontre sua pulseira novamente para conectar este celular.',
        code: 'transport_missing',
      );
    }
    return {
      'deviceId': device.transportId,
      'serialNumber': device.serialNumber,
    };
  }

  @override
  Future<List<DiscoveredBand>> scan() async {
    final values = await _call<List>('scanDevices') ?? [];
    return values.map((value) {
      final item = (value as Map).cast<String, dynamic>();
      return DiscoveredBand(
        transportId: item['deviceId'] as String,
        name: item['name'] as String? ?? 'BYND ONE',
        rssi: (item['rssi'] as num).toInt(),
      );
    }).toList();
  }

  @override
  Future<DeviceSnapshot> connect(DiscoveredBand band) async {
    final data = (await _call<Map>('connect', {
      'deviceId': band.transportId,
    }))?.cast<String, dynamic>();
    if (data == null ||
        (data['serialNumber'] as String? ?? '').trim().isEmpty) {
      throw const DeviceFailure(
        'Não foi possível confirmar o número de série da pulseira.',
        code: 'identity_missing',
      );
    }
    return DeviceSnapshot.fromJson({
      ...data,
      'deviceId': band.transportId,
      'transportId': band.transportId,
      'connected': true,
      'observedAt': DateTime.now().toUtc().toIso8601String(),
    });
  }

  @override
  Future<void> disconnect(DeviceSnapshot device) async {
    await _call<void>('disconnect', _args(device));
  }

  @override
  Future<DeviceSnapshot> read(DeviceSnapshot device) async {
    final data = (await _call<Map>(
      'readStatus',
      _args(device),
    ))?.cast<String, dynamic>();
    if (data == null) {
      throw const DeviceFailure('Não foi possível ler o estado da pulseira.');
    }
    return DeviceSnapshot.fromJson({
      ...device.toJson(),
      ...data,
      'deviceId': device.id,
      'serialNumber': device.serialNumber,
      'observedAt': DateTime.now().toUtc().toIso8601String(),
    });
  }

  @override
  Future<void> execute(DeviceSnapshot device, DeviceOperationType type) async {
    await _call<void>(
      type == DeviceOperationType.restart ? 'restart' : 'eraseUnsyncedData',
      _args(device),
    );
  }

  @override
  Future<void> installFirmware(
    DeviceSnapshot device,
    FirmwareRelease release,
    void Function(double) onProgress,
  ) async {
    if (release.downloadUrl.scheme != 'https' ||
        !RegExp(r'^[a-fA-F0-9]{64}$').hasMatch(release.sha256) ||
        release.sizeBytes <= 0) {
      throw const DeviceFailure(
        'O pacote de atualização não pôde ser verificado.',
        code: 'invalid_firmware',
      );
    }
    StreamSubscription<dynamic>? subscription;
    try {
      subscription = events.receiveBroadcastStream().listen((event) {
        if (event is Map &&
            event['deviceId'] == device.transportId &&
            event['type'] == 'firmwareProgress') {
          onProgress(((event['progress'] as num).toDouble()).clamp(0, 1));
        }
      }, onError: (_) {});
      // The native SDK must verify SHA-256, model compatibility and its signed package.
      await channel
          .invokeMethod<void>('installFirmware', {
            ..._args(device),
            'release': release.toJson(),
          })
          .timeout(const Duration(minutes: 10));
      onProgress(1);
    } on MissingPluginException {
      throw const DeviceFailure(
        'Atualização de firmware indisponível nesta plataforma.',
        code: 'unsupported_platform',
      );
    } on TimeoutException {
      throw const DeviceFailure(
        'A atualização não foi confirmada pela pulseira. Verifique a conexão.',
        code: 'device_timeout',
      );
    } on PlatformException {
      throw const DeviceFailure(
        'A atualização foi interrompida. Mantenha a pulseira por perto e tente novamente.',
        code: 'firmware_failed',
      );
    } finally {
      await subscription?.cancel();
    }
  }
}
