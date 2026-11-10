import 'package:new_jcvital/core/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_jcvital/main.dart';
import 'package:new_jcvital/features/device/application/device_controller.dart';
import 'package:new_jcvital/features/device/data/demo_device_repository.dart';
import 'package:new_jcvital/features/device/presentation/pages/device_management_page.dart';
import 'device_test_support.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));
  testWidgets('侧栏进入状态页，高级操作取消不执行，确认解绑后可重新配对', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    final store = testDeviceStore(), gateway = TestDeviceGateway();
    final controller = DeviceController(
      repository: TestDeviceRepository(store),
      gateway: gateway,
      isDemo: true,
    );
    addTearDown(controller.dispose);
    await controller.initialize();
    await tester.pumpWidget(
      ByndApp(
        deviceController: controller,
        config: AppConfig.resolve(
          defines: const {'MAPA_USE_DEMO_DATA': 'true'},
        ),
      ),
    );
    await tester.tap(find.byTooltip('Menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('BYND ONE'));
    await tester.pumpAndSettle();
    expect(find.byType(DeviceManagementPage), findsOneWidget);
    expect(find.text('PULSEIRA CONECTADA'), findsOneWidget);
    expect(find.text('Forte'), findsOneWidget);
    await tester.tap(find.text('Avançada'));
    await tester.pumpAndSettle();
    final erase = find.text('Apagar dados da pulseira');
    await tester.ensureVisible(erase);
    await tester.pumpAndSettle();
    await tester.tap(erase);
    await tester.pumpAndSettle();
    expect(find.text('Apagar dados da pulseira?'), findsOneWidget);
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    expect(gateway.commands, 0);
    final unpair = find.text('Desparear a pulseira');
    await tester.ensureVisible(unpair);
    await tester.pumpAndSettle();
    await tester.tap(unpair);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Desparear'));
    await tester.pumpAndSettle();
    expect(controller.device, isNull);
    expect(await DemoDeviceRepository(store).restore(), isNull);
    await tester.tap(find.text('Parear pulseira'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('BYND ONE · 7B0082'));
    await tester.pumpAndSettle();
    expect(controller.device!.serialNumber, '7B0082 1901');
    expect(find.byType(DeviceManagementPage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('较窄屏幕可滚动到高级页最后一项', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    final controller = DeviceController(
      repository: TestDeviceRepository(testDeviceStore()),
      gateway: TestDeviceGateway(),
      isDemo: true,
    );
    addTearDown(controller.dispose);
    await controller.initialize();
    await tester.pumpWidget(
      ByndApp(
        deviceController: controller,
        config: AppConfig.resolve(
          defines: const {'MAPA_USE_DEMO_DATA': 'true'},
        ),
      ),
    );
    await tester.tap(find.byTooltip('Menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('BYND ONE'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Avançada'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Apagar dados da pulseira'));
    await tester.pumpAndSettle();
    expect(
      tester.getCenter(find.text('Apagar dados da pulseira')).dy,
      lessThan(640),
    );
    expect(tester.takeException(), isNull);
  });
}
