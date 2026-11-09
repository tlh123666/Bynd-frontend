import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_jcvital/features/device/application/device_controller.dart';
import 'package:new_jcvital/features/device/data/demo_device_repository.dart';
import 'package:new_jcvital/features/device/data/device_gateways.dart';
import 'package:new_jcvital/features/device/domain/device_models.dart';
import 'device_test_support.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('换绑失败保留旧设备，并关闭刚连上的新设备', () async {
    final repository = TestDeviceRepository(testDeviceStore())..failBind = true;
    final gateway = TestDeviceGateway();
    final controller = DeviceController(
      repository: repository,
      gateway: gateway,
      isDemo: true,
    );
    addTearDown(controller.dispose);
    await controller.initialize();
    final previous = controller.device;
    await expectLater(
      controller.pair((await gateway.scan()).first),
      throwsA(isA<DeviceFailure>()),
    );
    expect(controller.device, previous);
    expect((await repository.restore())!.serialNumber, previous!.serialNumber);
    expect(gateway.disconnects, 1);
  });
  test('解绑后的空状态和重新配对可以恢复', () async {
    final store = testDeviceStore();
    final controller = DeviceController(
      repository: TestDeviceRepository(store),
      gateway: TestDeviceGateway(),
      isDemo: true,
    );
    addTearDown(controller.dispose);
    await controller.initialize();
    await controller.unpair();
    expect(await DemoDeviceRepository(store).restore(), isNull);
    await controller.pair((await controller.gateway.scan()).first);
    expect(
      (await DemoDeviceRepository(store).restore())!.serialNumber,
      '7B0082 1901',
    );
  });
  test('硬件失败写入失败回执，不会记录成功', () async {
    final repository = TestDeviceRepository(testDeviceStore());
    final gateway = TestDeviceGateway()..failCommand = true;
    final controller = DeviceController(
      repository: repository,
      gateway: gateway,
      isDemo: true,
    );
    addTearDown(controller.dispose);
    await controller.initialize();
    await expectLater(
      controller.perform(DeviceOperationType.restart),
      throwsA(isA<DeviceFailure>()),
    );
    expect(repository.operations.values.single.status, 'failed');
    expect(controller.busy, isFalse);
    expect(controller.error, 'A pulseira não respondeu.');
  });
  test('固件升级电量不足时不会启动操作或传输', () async {
    final repository = TestDeviceRepository(testDeviceStore());
    final gateway = TestDeviceGateway();
    final controller = DeviceController(
      repository: repository,
      gateway: gateway,
      isDemo: true,
    );
    addTearDown(controller.dispose);
    await controller.initialize();
    controller.device = controller.device!.copyWith(batteryPercent: 29);
    final release = FirmwareRelease(
      id: 'release',
      version: '2.4.2',
      downloadUrl: Uri.parse('https://example.org/firmware.bin'),
      sha256: 'a' * 64,
      sizeBytes: 1024,
    );
    await expectLater(
      controller.perform(DeviceOperationType.firmwareUpdate, release: release),
      throwsA(
        isA<DeviceFailure>().having((e) => e.code, 'code', 'battery_low'),
      ),
    );
    expect(repository.begun, 0);
    expect(gateway.installations, 0);
  });
  test('执行中连点不会重复发送物理命令', () async {
    final gateway = TestDeviceGateway()..holdCommand = Completer<void>();
    final repository = TestDeviceRepository(testDeviceStore());
    final controller = DeviceController(
      repository: repository,
      gateway: gateway,
      isDemo: true,
    );
    addTearDown(controller.dispose);
    await controller.initialize();
    final first = controller.perform(DeviceOperationType.restart);
    await Future<void>.delayed(Duration.zero);
    await expectLater(
      controller.perform(DeviceOperationType.restart),
      throwsA(isA<DeviceFailure>().having((e) => e.code, 'code', 'busy')),
    );
    gateway.holdCommand!.complete();
    await first;
    expect(gateway.commands, 1);
    expect(repository.begun, 1);
  });
  test('缺失原生驱动不会回退为模拟扫描成功', () async {
    const gateway = MethodChannelDeviceGateway(
      channel: MethodChannel('test/missing_device_driver'),
    );
    await expectLater(
      gateway.scan(),
      throwsA(
        isA<DeviceFailure>().having(
          (e) => e.code,
          'code',
          'unsupported_platform',
        ),
      ),
    );
  });
}
