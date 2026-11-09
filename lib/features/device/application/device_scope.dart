import 'package:flutter/widgets.dart';
import '../../../core/network/api_client.dart';
import '../../../core/config/app_config.dart';
import '../../../core/localization/app_locale_controller.dart';
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
  static DeviceController create({
    AppConfig? config,
    AppLocaleController? locale,
    Future<String?> Function()? tokenProvider,
  }) {
    final settings = config ?? AppConfig.current;
    final demo = settings.deviceDemo;
    final store = PreferenceDeviceStore();
    return DeviceController(
      isDemo: demo,
      repository: demo
          ? DemoDeviceRepository(store)
          : RemoteDeviceRepository(
              ApiClient.configured(
                config: settings,
                locale: locale,
                tokenProvider: tokenProvider,
              ),
              store,
            ),
      gateway: demo ? DemoDeviceGateway() : const MethodChannelDeviceGateway(),
    );
  }
}
