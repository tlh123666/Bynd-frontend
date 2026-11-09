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
