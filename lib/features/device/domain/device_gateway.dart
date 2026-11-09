import 'device_models.dart';

/// Hardware acknowledgements come through this boundary, never from HTTP.
abstract interface class DeviceGateway {
  Future<List<DiscoveredBand>> scan();
  Future<DeviceSnapshot> connect(DiscoveredBand band);
  Future<void> disconnect(DeviceSnapshot device);
  Future<DeviceSnapshot> read(DeviceSnapshot device);
  Future<void> execute(DeviceSnapshot device, DeviceOperationType type);
  Future<void> installFirmware(
    DeviceSnapshot device,
    FirmwareRelease release,
    void Function(double) onProgress,
  );
}

/// Optional lifecycle for native drivers. Demo and existing test gateways do
/// not need to implement an Android platform lifecycle.
abstract interface class ManagedDeviceGateway {
  Future<void> stopScan();
  Future<void> close();
}

abstract interface class DeviceOperationCapabilities {
  Future<bool> supportsOperation(DeviceOperationType type);
}
