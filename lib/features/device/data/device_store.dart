import 'package:shared_preferences/shared_preferences.dart';

abstract interface class DeviceStore {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
}

class PreferenceDeviceStore implements DeviceStore {
  @override
  Future<String?> read(String key) async =>
      (await SharedPreferences.getInstance()).getString(key);
  @override
  Future<void> write(String key, String value) async {
    final saved = await (await SharedPreferences.getInstance()).setString(
      key,
      value,
    );
    if (!saved) throw StateError('Device preferences could not be saved');
  }
}

class MemoryDeviceStore implements DeviceStore {
  final Map<String, String> values = {};
  @override
  Future<String?> read(String key) async => values[key];
  @override
  Future<void> write(String key, String value) async {
    values[key] = value;
  }
}
