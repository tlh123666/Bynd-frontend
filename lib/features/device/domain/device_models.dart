enum DeviceOperationType {
  restart('restart'),
  eraseData('erase_data'),
  firmwareUpdate('firmware_update');

  const DeviceOperationType(this.apiValue);
  final String apiValue;
}

class DeviceFailure implements Exception {
  const DeviceFailure(this.message, {this.code = 'device_error'});
  final String message;
  final String code;
  @override
  String toString() => message;
}

class DeviceSnapshot {
  const DeviceSnapshot({
    required this.id,
    required this.serialNumber,
    this.modelName = 'BYND ONE',
    this.modelCode = 'BYND_ONE',
    this.manufacturer = 'BYND',
    this.firmwareVersion = '',
    this.hardwareRevision = '',
    this.batteryPercent,
    this.rssi,
    this.connected = false,
    this.lastSyncedAt,
    this.observedAt,
    this.transportId,
  });

  final String id;
  final String serialNumber;
  final String modelName;
  final String modelCode;
  final String manufacturer;
  final String firmwareVersion;
  final String hardwareRevision;
  final int? batteryPercent;
  final int? rssi;
  final bool connected;
  final DateTime? lastSyncedAt;
  final DateTime? observedAt;
  // A BLE address belongs to this installation, never to the cloud identity.
  final String? transportId;

  String get shortSerial => serialNumber.split(RegExp(r'[ -]')).first;
  String get displayName => '$modelName · $shortSerial';
  String get signalLabel => rssi == null
      ? '—'
      : rssi! >= -65
      ? 'Forte'
      : rssi! >= -85
      ? 'Médio'
      : 'Fraco';

  DeviceSnapshot copyWith({
    String? id,
    String? firmwareVersion,
    int? batteryPercent,
    int? rssi,
    bool? connected,
    DateTime? lastSyncedAt,
    DateTime? observedAt,
    String? transportId,
  }) => DeviceSnapshot(
    id: id ?? this.id,
    serialNumber: serialNumber,
    modelName: modelName,
    modelCode: modelCode,
    manufacturer: manufacturer,
    firmwareVersion: firmwareVersion ?? this.firmwareVersion,
    hardwareRevision: hardwareRevision,
    batteryPercent: batteryPercent ?? this.batteryPercent,
    rssi: rssi ?? this.rssi,
    connected: connected ?? this.connected,
    lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
    observedAt: observedAt ?? this.observedAt,
    transportId: transportId ?? this.transportId,
  );

  factory DeviceSnapshot.fromJson(Map<String, dynamic> json) => DeviceSnapshot(
    id: (json['deviceId'] ?? json['id']) as String,
    serialNumber: json['serialNumber'] as String,
    modelName: json['modelName'] as String? ?? 'BYND ONE',
    modelCode: json['modelCode'] as String? ?? 'BYND_ONE',
    manufacturer: json['manufacturer'] as String? ?? 'BYND',
    firmwareVersion: json['firmwareVersion'] as String? ?? '',
    hardwareRevision: json['hardwareRevision'] as String? ?? '',
    batteryPercent: (json['batteryPercent'] as num?)?.toInt(),
    rssi: (json['rssi'] as num?)?.toInt(),
    connected: json['connected'] == true,
    lastSyncedAt: DateTime.tryParse(json['lastSyncedAt'] as String? ?? ''),
    observedAt: DateTime.tryParse(json['observedAt'] as String? ?? ''),
    transportId: json['transportId'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'deviceId': id,
    'serialNumber': serialNumber,
    'modelName': modelName,
    'modelCode': modelCode,
    'manufacturer': manufacturer,
    'firmwareVersion': firmwareVersion,
    'hardwareRevision': hardwareRevision,
    'batteryPercent': batteryPercent,
    'rssi': rssi,
    'connected': connected,
    'lastSyncedAt': lastSyncedAt?.toUtc().toIso8601String(),
    'observedAt': observedAt?.toUtc().toIso8601String(),
    'transportId': transportId,
  };

  static DeviceSnapshot reference() => DeviceSnapshot(
    id: 'demo-bynd-one',
    serialNumber: '5A0047 1901',
    firmwareVersion: '2.4.1',
    hardwareRevision: '1.0',
    batteryPercent: 82,
    rssi: -48,
    connected: true,
    lastSyncedAt: DateTime.now().subtract(const Duration(minutes: 5)),
    observedAt: DateTime.now(),
    transportId: 'demo-5A0047',
  );
}

class DiscoveredBand {
  const DiscoveredBand({
    required this.transportId,
    required this.name,
    required this.rssi,
  });
  final String transportId;
  final String name;
  final int rssi;
}

class FirmwareRelease {
  const FirmwareRelease({
    required this.id,
    required this.version,
    required this.downloadUrl,
    required this.sha256,
    required this.sizeBytes,
    this.notes = '',
  });
  final String id;
  final String version;
  final Uri downloadUrl;
  final String sha256;
  final int sizeBytes;
  final String notes;
  factory FirmwareRelease.fromJson(Map<String, dynamic> json) =>
      FirmwareRelease(
        id: json['id'] as String,
        version: json['version'] as String,
        downloadUrl: Uri.parse(json['downloadUrl'] as String),
        sha256: json['sha256'] as String,
        sizeBytes: (json['sizeBytes'] as num).toInt(),
        notes: json['releaseNotes'] as String? ?? '',
      );
  Map<String, dynamic> toJson() => {
    'id': id,
    'version': version,
    'downloadUrl': downloadUrl.toString(),
    'sha256': sha256,
    'sizeBytes': sizeBytes,
    'releaseNotes': notes,
  };
}

class DeviceOperation {
  const DeviceOperation({
    required this.id,
    required this.type,
    required this.status,
  });
  final String id;
  final DeviceOperationType type;
  final String status;
}
