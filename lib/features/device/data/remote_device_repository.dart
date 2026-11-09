import 'dart:convert';
import '../../../core/network/api_client.dart';
import '../domain/device_models.dart';
import '../domain/device_repository.dart';
import 'device_store.dart';

class RemoteDeviceRepository implements DeviceRepository {
  RemoteDeviceRepository(this.api, this.store);
  final ApiClient api;
  final DeviceStore store;
  static const _transportKey = 'bynd.device.transport.v1';
  static const _outboxKey = 'bynd.device.receipts.v1';
  final Map<String, Map<String, dynamic>> _receipts = {};

  @override
  Future<DeviceSnapshot?> restore() async {
    final storedReceipts = await store.read(_outboxKey);
    if (storedReceipts != null) {
      for (final entry in (jsonDecode(storedReceipts) as Map).entries) {
        _receipts[entry.key as String] = (entry.value as Map)
            .cast<String, dynamic>();
      }
    }
    // An acknowledgement is retried, never the physical command itself.
    for (final entry in _receipts.entries.toList()) {
      try {
        await api.request('PATCH', entry.key, body: entry.value);
        _receipts.remove(entry.key);
      } on ApiException catch (error) {
        if (error.code == 'http_404' || error.code == 'http_409') {
          _receipts.remove(entry.key);
        }
      }
    }
    await _saveReceipts();
    final list = await api.request('GET', '/me/devices');
    final devices = (list['items'] as List).cast<Map<String, dynamic>>();
    if (devices.isEmpty) return null;
    final primary = devices.firstWhere(
      (d) => d['isPrimary'] == true,
      orElse: () => devices.first,
    );
    final data = await api.request(
      'GET',
      '/me/devices/${primary['deviceId']}/management',
    );
    final device = (data['device'] as Map).cast<String, dynamic>();
    final telemetry =
        (data['telemetry'] as Map?)?.cast<String, dynamic>() ?? {};
    final transports =
        jsonDecode(await store.read(_transportKey) ?? '{}') as Map;
    return DeviceSnapshot.fromJson({
      ...device,
      ...telemetry,
      'connected': false,
      'transportId': transports[device['deviceId']],
    });
  }

  @override
  Future<DeviceSnapshot> bind(
    DeviceSnapshot connected, {
    required String requestId,
    String? replacingDeviceId,
  }) async {
    final data = await api.request(
      'POST',
      '/me/devices/bind',
      body: {
        'serialNumber': connected.serialNumber,
        'manufacturer': connected.manufacturer,
        'modelCode': connected.modelCode,
        'modelName': connected.modelName,
        'firmwareVersion': connected.firmwareVersion,
        'hardwareRevision': connected.hardwareRevision,
        'clientRequestId': requestId,
        'setAsPrimary': true,
        'replaceDeviceId': ?replacingDeviceId,
      },
    );
    final result = connected.copyWith(id: data['deviceId'] as String);
    // Cloud ownership has committed. A cache failure must not undo that fact.
    try {
      final transports =
          jsonDecode(await store.read(_transportKey) ?? '{}') as Map;
      if (replacingDeviceId != null) transports.remove(replacingDeviceId);
      transports[result.id] = connected.transportId;
      await store.write(_transportKey, jsonEncode(transports));
    } catch (_) {
      /* Re-pairing can recover the local transport address. */
    }
    return result;
  }

  @override
  Future<void> unbind(String deviceId) async {
    await api.request('DELETE', '/me/devices/$deviceId');
    try {
      final transports =
          jsonDecode(await store.read(_transportKey) ?? '{}') as Map;
      transports.remove(deviceId);
      await store.write(_transportKey, jsonEncode(transports));
    } catch (_) {
      /* The server remains the ownership authority. */
    }
  }

  @override
  Future<void> saveTelemetry(DeviceSnapshot snapshot) async {
    await api.request(
      'PUT',
      '/me/devices/${snapshot.id}/telemetry',
      body: {
        'observedAt': (snapshot.observedAt ?? DateTime.now())
            .toUtc()
            .toIso8601String(),
        'connected': snapshot.connected,
        'batteryPercent': snapshot.batteryPercent,
        'rssi': snapshot.rssi,
        'firmwareVersion': snapshot.firmwareVersion,
        'lastSyncedAt': snapshot.lastSyncedAt?.toUtc().toIso8601String(),
      },
    );
  }

  @override
  Future<FirmwareRelease?> checkFirmware(DeviceSnapshot snapshot) async {
    final data = await api.request(
      'GET',
      '/me/devices/${snapshot.id}/firmware',
    );
    return data['updateAvailable'] == true
        ? FirmwareRelease.fromJson(
            (data['release'] as Map).cast<String, dynamic>(),
          )
        : null;
  }

  @override
  Future<DeviceOperation> beginOperation(
    DeviceSnapshot device,
    DeviceOperationType type,
    String requestId, {
    FirmwareRelease? release,
  }) async {
    final data = await api.request(
      'POST',
      '/me/devices/${device.id}/operations',
      body: {
        'type': type.apiValue,
        'clientRequestId': requestId,
        if (release != null) 'firmwareReleaseId': release.id,
      },
    );
    return DeviceOperation(
      id: data['id'] as String,
      type: type,
      status: data['status'] as String,
    );
  }

  Future<void> _saveReceipts() async {
    try {
      await store.write(_outboxKey, jsonEncode(_receipts));
    } catch (_) {
      /* HTTP is still attempted. */
    }
  }

  @override
  Future<void> finishOperation(
    DeviceSnapshot device,
    DeviceOperation operation, {
    required bool succeeded,
    String? errorCode,
    String? firmwareVersion,
  }) async {
    final path = '/me/devices/${device.id}/operations/${operation.id}';
    final body = <String, dynamic>{
      'status': succeeded ? 'succeeded' : 'failed',
      'errorCode': ?errorCode,
      'firmwareVersion': ?firmwareVersion,
    };
    _receipts[path] = body;
    await _saveReceipts();
    await api.request('PATCH', path, body: body);
    _receipts.remove(path);
    await _saveReceipts();
  }

  @override
  void close() => api.close();
}
