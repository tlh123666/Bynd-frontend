import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_jcvital/features/device/data/device_gateways.dart';
import 'package:new_jcvital/features/device/domain/device_models.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('com.bynd/device_management');
  const gateway = MethodChannelDeviceGateway(channel: channel);
  final calls = <MethodCall>[];
  const address = 'AA:BB:CC:DD:EE:FF';
  setUp(() {
    calls.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          calls.add(call);
          return switch (call.method) {
            'scanDevices' => [
              {'deviceId': address, 'name': 'V5', 'rssi': -51},
            ],
            'connect' || 'readStatus' => {
              'deviceId': address,
              'serialNumber': address,
              'modelCode': 'V5',
              'firmwareVersion': '1.2.3',
              'batteryPercent': 0,
              'rssi': -51,
              'connected': true,
            },
            'capabilities' => {
              'restart': false,
              'eraseUnsyncedData': false,
              'installFirmware': false,
            },
            _ => null,
          };
        });
  });
  tearDown(
    () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null),
  );

  test(
    'scan and connection use the registered native contract and retain hardware identity',
    () async {
      final band = (await gateway.scan()).single;
      expect(band.transportId, address);
      expect(band.rssi, -51);
      final connected = await gateway.connect(band);
      expect(connected.serialNumber, address);
      expect(connected.transportId, address);
      expect(connected.modelCode, 'V5');
      expect(connected.batteryPercent, 0);
      expect(connected.lastSyncedAt, isNull);
      expect(calls.map((call) => call.method), ['scanDevices', 'connect']);
    },
  );
  test(
    'status refresh keeps cloud UUID separate from the local transport address',
    () async {
      final snapshot = DeviceSnapshot(
        id: 'cloud-uuid',
        serialNumber: address,
        transportId: address,
      );
      final updated = await gateway.read(snapshot);
      expect(updated.id, 'cloud-uuid');
      expect(updated.transportId, address);
      expect(updated.batteryPercent, 0);
      expect(updated.firmwareVersion, '1.2.3');
      expect(calls.single.arguments, {
        'deviceId': address,
        'serialNumber': address,
      });
    },
  );
  test('another bands identity cannot overwrite the bound device', () async {
    final snapshot = DeviceSnapshot(
      id: 'cloud-uuid',
      serialNumber: '11:22:33:44:55:66',
      transportId: address,
    );
    await expectLater(
      gateway.read(snapshot),
      throwsA(
        isA<DeviceFailure>().having((e) => e.code, 'code', 'identity_mismatch'),
      ),
    );
  });
  test(
    'permission and adapter failures remain actionable instead of claiming a missing SDK',
    () async {
      for (final code in [
        'permission_denied',
        'bluetooth_off',
        'location_disabled',
      ]) {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
              channel,
              (_) async => throw PlatformException(code: code),
            );
        await expectLater(
          gateway.scan(),
          throwsA(isA<DeviceFailure>().having((e) => e.code, 'code', code)),
        );
      }
    },
  );
  test(
    'unsupported vendor writes are reported as unsupported capabilities',
    () async {
      for (final operation in DeviceOperationType.values) {
        expect(await gateway.supportsOperation(operation), false);
      }
    },
  );
  test(
    'native scanning can be stopped and driver lifecycle can close cleanly',
    () async {
      await gateway.stopScan();
      await gateway.close();
      expect(calls.map((call) => call.method), ['stopScan', 'close']);
    },
  );
}
