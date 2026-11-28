import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../../device/domain/device_models.dart';
import 'demo_heart_repository.dart';

abstract interface class HeartBandGateway {
  bool get supported;
  Stream<Map<String, dynamic>> get events;
  Future<void> start(DeviceSnapshot device);
  Future<void> stop();
  Future<Map<String, dynamic>> readHistory(DeviceSnapshot device);

  /// On-demand SpO2 ("Measure now"): a one-off reading that the UI shows
  /// apart and never mixes into the night average.
  Future<Map<String, dynamic>> measureSpo2Now(DeviceSnapshot device);
  void dispose();
}

class NativeHeartBandGateway implements HeartBandGateway {
  NativeHeartBandGateway({
    this.channel = const MethodChannel('com.bynd/device_management'),
    EventChannel? eventChannel,
  }) : _events = (eventChannel ?? const EventChannel('com.bynd/heart_events'))
           .receiveBroadcastStream()
           .map((e) => Map<String, dynamic>.from(e as Map));
  final MethodChannel channel;
  final Stream<Map<String, dynamic>> _events;
  @override
  bool get supported =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
  @override
  Stream<Map<String, dynamic>> get events => _events;
  Map<String, dynamic> _identity(DeviceSnapshot d) => {
    'deviceId': d.transportId,
    'serialNumber': d.serialNumber,
  };
  @override
  Future<void> start(DeviceSnapshot device) async {
    await channel.invokeMethod<void>('startHeartRecording', {
      ..._identity(device),
      'durationSeconds': 30,
    });
  }

  @override
  Future<void> stop() async {
    await channel.invokeMethod<void>('stopHeartRecording');
  }

  @override
  Future<Map<String, dynamic>> readHistory(DeviceSnapshot device) async =>
      Map<String, dynamic>.from(
        await channel
                .invokeMethod<Map>('readHeartHistory', _identity(device))
                .timeout(const Duration(seconds: 120)) ??
            {},
      );
  @override
  Future<Map<String, dynamic>> measureSpo2Now(DeviceSnapshot device) async =>
      Map<String, dynamic>.from(
        await channel
                .invokeMethod<Map>('startOnDemandSpo2', _identity(device))
                .timeout(const Duration(seconds: 120)) ??
            {},
      );
  @override
  void dispose() {}
}

class DemoHeartBandGateway implements HeartBandGateway {
  final _controller = StreamController<Map<String, dynamic>>.broadcast();
  Timer? _timer;
  @override
  bool get supported => true;
  @override
  Stream<Map<String, dynamic>> get events => _controller.stream;
  @override
  Future<void> start(DeviceSnapshot device) async {
    _timer?.cancel();
    final wave = demoHeartWaveform();
    var index = 0;
    _controller.add({'event': 'ecg_started', 'durationSeconds': 30});
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (index >= wave.length) {
        _timer?.cancel();
        _controller.add({'event': 'ecg_completed', 'durationMillis': 30000});
        return;
      }
      _controller.add({
        'event': 'ecg_waveform',
        'waveformKind': 'ecg',
        'sampleRateHz': 100,
        'samples': wave.sublist(index, index + 10),
      });
      _controller.add({'event': 'ecg_metrics', 'heartRate': 64});
      index += 10;
    });
  }

  @override
  Future<void> stop() async {
    _timer?.cancel();
    if (!_controller.isClosed) _controller.add({'event': 'ecg_cancelled'});
  }

  @override
  Future<Map<String, dynamic>> readHistory(DeviceSnapshot device) async => {};
  @override
  Future<Map<String, dynamic>> measureSpo2Now(DeviceSnapshot device) async {
    await Future<void>.delayed(const Duration(seconds: 3));
    return {
      'spo2': 97,
      'heartRate': 64,
      'measuredAt': DateTime.now().toIso8601String(),
    };
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.close();
  }
}
