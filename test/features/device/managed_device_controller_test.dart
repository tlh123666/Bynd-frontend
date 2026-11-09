import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_jcvital/features/device/application/device_controller.dart';
import 'package:new_jcvital/features/device/domain/device_gateway.dart';
import 'package:new_jcvital/features/device/domain/device_models.dart';
import 'device_test_support.dart';

class _ManagedGateway extends TestDeviceGateway
    implements ManagedDeviceGateway, DeviceOperationCapabilities {
  final pendingScan = Completer<List<DiscoveredBand>>();
  bool failReads = false;
  bool failReadAfterConnect = false;
  @override
  Future<List<DiscoveredBand>> scan() => pendingScan.future;
  @override
  Future<void> stopScan() async {
    if (!pendingScan.isCompleted) pendingScan.complete([]);
  }

  @override
  Future<void> close() => stopScan();
  @override
  Future<bool> supportsOperation(DeviceOperationType type) async => false;
  @override
  Future<DeviceSnapshot> connect(DiscoveredBand band) async {
    final result = await super.connect(band);
    if (failReadAfterConnect) failReads = true;
    return result;
  }

  @override
  Future<DeviceSnapshot> read(DeviceSnapshot device) {
    if (failReads) {
      throw const DeviceFailure('Disconnected', code: 'device_disconnected');
    }
    return super.read(device);
  }
}

void main() {
  test('cancelled native scan releases controller busy state', () async {
    final gateway = _ManagedGateway();
    final controller = DeviceController(
      repository: TestDeviceRepository(testDeviceStore()),
      gateway: gateway,
      isDemo: true,
    );
    addTearDown(controller.dispose);
    await controller.initialize();
    final scan = controller.scan();
    expect(controller.busy, true);
    await controller.stopScan();
    expect(await scan, isEmpty);
    expect(controller.busy, false);
  });
  test(
    'unsupported hardware command never creates a cloud operation or sends a write',
    () async {
      final repository = TestDeviceRepository(testDeviceStore()),
          gateway = _ManagedGateway();
      final controller = DeviceController(
        repository: repository,
        gateway: gateway,
        isDemo: true,
      );
      addTearDown(controller.dispose);
      await controller.initialize();
      await expectLater(
        controller.perform(DeviceOperationType.eraseData),
        throwsA(
          isA<DeviceFailure>().having(
            (e) => e.code,
            'code',
            'unsupported_operation',
          ),
        ),
      );
      expect(repository.begun, 0);
      expect(gateway.commands, 0);
      expect(controller.busy, false);
    },
  );
  test(
    'failed single-GATT replacement cannot leave a false connected status on previous band',
    () async {
      final repository = TestDeviceRepository(testDeviceStore())
        ..failBind = true;
      final gateway = _ManagedGateway()..failReadAfterConnect = true;
      final controller = DeviceController(
        repository: repository,
        gateway: gateway,
        isDemo: false,
      );
      addTearDown(controller.dispose);
      await controller.initialize();
      final previous = controller.device!;
      await expectLater(
        controller.pair(
          const DiscoveredBand(transportId: 'another', name: 'V5', rssi: -55),
        ),
        throwsA(isA<DeviceFailure>()),
      );
      expect(controller.device!.serialNumber, previous.serialNumber);
      expect(controller.device!.connected, false);
      expect((await repository.restore())!.serialNumber, previous.serialNumber);
    },
  );
}
