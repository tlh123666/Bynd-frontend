import 'package:flutter/widgets.dart';
import '../../../core/network/api_client.dart';
import '../data/demo_device_repository.dart';
import '../data/device_gateways.dart';
import '../data/device_store.dart';
import '../data/remote_device_repository.dart';
import 'device_controller.dart';

class DeviceScope extends InheritedNotifier<DeviceController> {
  const DeviceScope({
    required DeviceController controller,
    required super.child,
    super.key,
  }) : super(notifier: controller);
  static DeviceController of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<DeviceScope>()!.notifier!;
  static DeviceController? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<DeviceScope>()?.notifier;
}

abstract final class DeviceRuntime {
  static DeviceController create({Future<String?> Function()? tokenProvider}) {
    const demo = bool.fromEnvironment('DEVICE_DEMO', defaultValue: true);
    final store = PreferenceDeviceStore();
    return DeviceController(
      isDemo: demo,
      repository: demo
          ? DemoDeviceRepository(store)
          : RemoteDeviceRepository(
              ApiClient(
                baseUrl: Uri.parse(
                  const String.fromEnvironment(
                    'API_BASE_URL',
                    defaultValue: 'http://localhost:8080/api/v1',
                  ),
                ),
                tokenProvider: tokenProvider ?? () async => null,
              ),
              store,
            ),
      gateway: demo ? DemoDeviceGateway() : const MethodChannelDeviceGateway(),
    );
  }
}
