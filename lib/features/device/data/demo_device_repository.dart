import 'dart:convert';
import '../domain/device_models.dart';
import '../domain/device_repository.dart';
import 'device_store.dart';

class DemoDeviceRepository implements DeviceRepository {
  DemoDeviceRepository(this.store);
  static const storageKey = 'bynd.device.demo.v1';
  final DeviceStore store;
  DeviceSnapshot? _device;
  final Map<String, DeviceOperation> operations = {};

  @override
  Future<DeviceSnapshot?> restore() async {
    final stored = await store.read(storageKey);
    if (stored == null) {
      _device = DeviceSnapshot.reference();
      await _save();
    } else {
      final json = jsonDecode(stored) as Map<String, dynamic>;
      _device = json['device'] == null
          ? null
          : DeviceSnapshot.fromJson(
              (json['device'] as Map).cast<String, dynamic>(),
            );
    }
    return _device;
  }

  Future<void> _save() =>
      store.write(storageKey, jsonEncode({'device': _device?.toJson()}));
  @override
  Future<DeviceSnapshot> bind(
    DeviceSnapshot connected, {
    required String requestId,
    String? replacingDeviceId,
  }) async {
    final previous = _device;
    _device = connected.copyWith(id: 'demo-${connected.shortSerial}');
    try {
      await _save();
    } catch (_) {
      _device = previous;
      rethrow;
    }
    return _device!;
  }

  @override
  Future<void> unbind(String deviceId) async {
    final previous = _device;
    _device = null;
    try {
      await _save();
    } catch (_) {
      _device = previous;
      rethrow;
    }
  }

  @override
  Future<void> saveTelemetry(DeviceSnapshot snapshot) async {
    _device = snapshot;
    await _save();
  }

  @override
  Future<FirmwareRelease?> checkFirmware(DeviceSnapshot snapshot) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return null;
  }

  @override
  Future<DeviceOperation> beginOperation(
    DeviceSnapshot device,
    DeviceOperationType type,
    String requestId, {
    FirmwareRelease? release,
  }) async {
    return operations.putIfAbsent(
      requestId,
      () => DeviceOperation(id: requestId, type: type, status: 'pending'),
    );
  }

  @override
  Future<void> finishOperation(
    DeviceSnapshot device,
    DeviceOperation operation, {
    required bool succeeded,
    String? errorCode,
    String? firmwareVersion,
  }) async {
    operations[operation.id] = DeviceOperation(
      id: operation.id,
      type: operation.type,
      status: succeeded ? 'succeeded' : 'failed',
    );
  }

  @override
  void close() {}
}
