import 'device_models.dart';

abstract interface class DeviceRepository {
  Future<DeviceSnapshot?> restore();
  Future<DeviceSnapshot> bind(
    DeviceSnapshot connected, {
    required String requestId,
    String? replacingDeviceId,
  });
  Future<void> unbind(String deviceId);
  Future<void> saveTelemetry(DeviceSnapshot snapshot);
  Future<FirmwareRelease?> checkFirmware(DeviceSnapshot snapshot);
  Future<DeviceOperation> beginOperation(
    DeviceSnapshot device,
    DeviceOperationType type,
    String requestId, {
    FirmwareRelease? release,
  });
  Future<void> finishOperation(
    DeviceSnapshot device,
    DeviceOperation operation, {
    required bool succeeded,
    String? errorCode,
    String? firmwareVersion,
  });
  void close();
}
