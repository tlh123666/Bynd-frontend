import 'dart:async';
import 'package:new_jcvital/features/device/data/demo_device_repository.dart';
import 'package:new_jcvital/features/device/data/device_gateways.dart';
import 'package:new_jcvital/features/device/data/device_store.dart';
import 'package:new_jcvital/features/device/domain/device_models.dart';

class TestDeviceRepository extends DemoDeviceRepository {
  TestDeviceRepository(super.store);
  bool failBind = false;
  int begun = 0;
  @override
  Future<DeviceSnapshot> bind(
    DeviceSnapshot connected, {
    required String requestId,
    String? replacingDeviceId,
  }) {
    if (failBind) {
      throw const DeviceFailure('Falha de vínculo', code: 'bind_failed');
    }
    return super.bind(
      connected,
      requestId: requestId,
      replacingDeviceId: replacingDeviceId,
    );
  }

  @override
  Future<DeviceOperation> beginOperation(
    DeviceSnapshot device,
    DeviceOperationType type,
    String requestId, {
    FirmwareRelease? release,
  }) {
    begun++;
    return super.beginOperation(device, type, requestId, release: release);
  }
}

class TestDeviceGateway extends DemoDeviceGateway {
  int commands = 0;
  int installations = 0;
  int disconnects = 0;
  bool failCommand = false;
  Completer<void>? holdCommand;
  @override
  Future<List<DiscoveredBand>> scan() async => const [
    DiscoveredBand(
      transportId: 'demo-7B0082',
      name: 'BYND ONE · 7B0082',
      rssi: -52,
    ),
  ];
  @override
  Future<DeviceSnapshot> connect(DiscoveredBand band) async => DeviceSnapshot(
    id: band.transportId,
    serialNumber: '7B0082 1901',
    firmwareVersion: '2.4.1',
    batteryPercent: 82,
    rssi: -52,
    connected: true,
    transportId: band.transportId,
    observedAt: DateTime.now(),
    lastSyncedAt: DateTime.now(),
  );
  @override
  Future<void> disconnect(DeviceSnapshot device) async {
    disconnects++;
  }

  @override
  Future<void> execute(DeviceSnapshot device, DeviceOperationType type) async {
    commands++;
    if (failCommand) {
      throw const DeviceFailure(
        'A pulseira não respondeu.',
        code: 'device_timeout',
      );
    }
    await holdCommand?.future;
  }

  @override
  Future<void> installFirmware(
    DeviceSnapshot device,
    FirmwareRelease release,
    void Function(double) onProgress,
  ) async {
    installations++;
    onProgress(1);
  }
}

MemoryDeviceStore testDeviceStore() => MemoryDeviceStore();
