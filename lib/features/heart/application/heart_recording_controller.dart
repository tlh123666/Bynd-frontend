import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../../../core/auth/auth_session.dart';
import '../../../core/utils/local_timezone.dart';
import '../../device/domain/device_models.dart';
import '../../diary/domain/diary_models.dart' show diaryId;
import '../data/heart_band_gateway.dart';
import '../domain/heart_models.dart';

enum HeartRecordingStatus {
  ready,
  starting,
  measuring,
  saving,
  saveFailed,
  complete,
  failed,
  cancelled,
}

/// Capture never manufactures a rhythm classification. Only fresh vendor
/// metric events belong to this recording; completion's cached metrics do not.
class HeartRecordingController extends ChangeNotifier {
  HeartRecordingController({
    required this.repository,
    required this.gateway,
    required this._device,
    AuthSession? session,
    DateTime Function()? clock,
    // 15s：测量结果包（ECGResult）可能在软结束、波形停止之后到达，
    // 停止窗口最长约 10s，10s 的旧阈值会在结果到达前误判停摆。
    this.stallTimeout = const Duration(seconds: 15),
  }) : _session = session,
       _token = session?.accessToken,
       _clock = clock ?? DateTime.now {
    session?.addListener(_account);
  }
  final HeartRepository repository;
  final HeartBandGateway gateway;
  DeviceSnapshot _device;
  DeviceSnapshot get device => _device;
  final AuthSession? _session;
  final String? _token;
  final DateTime Function() _clock;
  final Duration stallTimeout;
  HeartRecordingStatus status = HeartRecordingStatus.ready;
  HeartRecording? record;
  String? errorCode;
  List<int> samples = [];
  Map<String, dynamic> metrics = {};
  Map<String, dynamic>? _payload;
  DateTime? startedAt, _lastPacket;
  String waveformKind = 'unknown';
  int? sampleRate;
  int elapsedSeconds = 0;
  StreamSubscription<Map<String, dynamic>>? _subscription;
  Timer? _watchdog;
  Future<void> _cleanup = Future.value();
  bool _disposed = false, _saving = false;
  int _generation = 0;
  bool get busy => [
    HeartRecordingStatus.starting,
    HeartRecordingStatus.measuring,
    HeartRecordingStatus.saving,
  ].contains(status);
  bool get _sameAccount => _session == null || _session.accessToken == _token;
  void _emit() {
    if (!_disposed) notifyListeners();
  }

  void _account() {
    if (!_sameAccount) {
      _generation++;
      samples = [];
      metrics = {};
      _payload = null;
      record = null;
      status = HeartRecordingStatus.cancelled;
      errorCode = 'account_changed';
      unawaited(_endCapture());
      _emit();
    }
  }

  Future<void> start({DeviceSnapshot? device}) async {
    if (busy || !_sameAccount || _disposed) return;
    final captureDevice = device ?? _device;
    if (!gateway.supported) {
      errorCode = 'unsupported_platform';
      status = HeartRecordingStatus.failed;
      _emit();
      return;
    }
    if (!captureDevice.connected || captureDevice.transportId == null) {
      errorCode = 'device_not_connected';
      status = HeartRecordingStatus.failed;
      _emit();
      return;
    }
    _device = captureDevice;
    final generation = ++_generation;
    samples = [];
    metrics = {};
    _payload = null;
    record = null;
    sampleRate = null;
    waveformKind = 'unknown';
    startedAt = _clock();
    _lastPacket = null;
    elapsedSeconds = 0;
    errorCode = null;
    status = HeartRecordingStatus.starting;
    _emit();
    try {
      // A retry must not race the previous native stop/EventChannel cancel.
      await _cleanup;
      if (_disposed || generation != _generation || !_sameAccount) return;
      final previous = _subscription;
      _subscription = null;
      await previous?.cancel();
      if (_disposed || generation != _generation || !_sameAccount) return;
      _subscription = gateway.events.listen(
        (event) {
          if (generation == _generation) _event(event);
        },
        onError: (Object e) {
          if (generation == _generation) _fail('capture_failed');
        },
      );
      await gateway.start(captureDevice).timeout(const Duration(seconds: 20));
      if (_disposed || generation != _generation || !_sameAccount) {
        // Cancellation already stopped this generation. A late response must
        // never stop a newer recording that has since started.
        return;
      }
      if (status == HeartRecordingStatus.starting) {
        startedAt = _clock();
        _lastPacket = startedAt;
        status = HeartRecordingStatus.measuring;
      }
      if (status != HeartRecordingStatus.measuring) return;
      _watchdog = Timer.periodic(const Duration(milliseconds: 500), (_) {
        if (_disposed || !busy || status == HeartRecordingStatus.saving) return;
        final now = _clock();
        elapsedSeconds = now.difference(startedAt!).inSeconds.clamp(0, 30);
        if (now.difference(_lastPacket ?? startedAt!) > stallTimeout) {
          _fail('no_waveform');
          return;
        }
        // 75s：原生启动重试最多 ~36s + 手环测量 30s + 结果包，全程覆盖。
        if (now.difference(startedAt!) > const Duration(seconds: 75)) {
          _fail('capture_timeout');
          return;
        }
        _emit();
      });
      _emit();
    } catch (e) {
      if (!_disposed && generation == _generation) {
        _fail(e is PlatformException ? e.code : 'capture_failed');
      }
    }
  }

  void _event(Map<String, dynamic> event) {
    if (_disposed ||
        !_sameAccount ||
        ![
          HeartRecordingStatus.starting,
          HeartRecordingStatus.measuring,
        ].contains(status)) {
      return;
    }
    // 任何事件（含原生启动重试的 ecg_retry 心跳）都刷新停摆看门狗：
    // 波形开始前原生会重试启动手环，此期间无波形但会话是活的。
    _lastPacket = _clock();
    switch (event['event']) {
      case 'ecg_started':
        startedAt = event['startedAtMillis'] is num
            ? DateTime.fromMillisecondsSinceEpoch(
                (event['startedAtMillis'] as num).round(),
              )
            : _clock();
        status = HeartRecordingStatus.measuring;
      case 'ecg_waveform':
        final chunk = (event['samples'] as List? ?? [])
            .whereType<num>()
            .map((n) => n.round())
            .toList();
        if (samples.length + chunk.length > 90000) {
          _fail('too_many_samples');
          return;
        }
        samples.addAll(chunk);
        if (chunk.isNotEmpty) _lastPacket = _clock();
        if (['ecg', 'ppg'].contains(event['waveformKind'])) {
          waveformKind = '${event['waveformKind']}';
        }
        if (event['sampleRateHz'] is num) {
          sampleRate = (event['sampleRateHz'] as num).round();
        }
      case 'ecg_metrics':
        const bounds = {
          'heartRate': (20, 250),
          'hrv': (1, 1000),
          'stress': (0, 100),
          'systolicBloodPressure': (40, 260),
          'diastolicBloodPressure': (20, 180),
          'respiratoryRate': (1, 100),
        };
        for (final key in bounds.keys) {
          final n = event[key];
          if (n is num && n >= bounds[key]!.$1 && n <= bounds[key]!.$2) {
            metrics[key] = n.round();
          }
        }
      case 'ecg_completed':
        final duration = (event['durationMillis'] as num?)?.round() ?? 0;
        if (samples.isEmpty || duration < 29000) {
          _fail('incomplete_recording');
          return;
        }
        _payload = {
          'clientRequestId': 'heart-${diaryId()}',
          'deviceSerial': device.serialNumber,
          'measuredAt': startedAt!.toUtc().toIso8601String(),
          'timezone': localIanaTimezone(),
          'durationMillis': duration.clamp(1000, 302000),
          'waveformKind': waveformKind,
          'samples': List<int>.of(samples),
          if (sampleRate != null) 'sampleRateHz': sampleRate,
          ...metrics,
          if (metrics['hrv'] != null) 'hrvMs': metrics['hrv'],
        }..remove('hrv');
        _watchdog?.cancel();
        unawaited(save());
      case 'ecg_cancelled':
        status = HeartRecordingStatus.cancelled;
        _watchdog?.cancel();
      case 'ecg_failed':
        _fail('disconnected');
    }
    _emit();
  }

  void _fail(String code) {
    if (_disposed) return;
    errorCode = code;
    status = HeartRecordingStatus.failed;
    _watchdog?.cancel();
    unawaited(_endCapture());
    _emit();
  }

  Future<void> save() async {
    if (_saving || _payload == null || !_sameAccount || _disposed) return;
    final generation = _generation;
    _saving = true;
    status = HeartRecordingStatus.saving;
    errorCode = null;
    _emit();
    try {
      final saved = await repository.createRecording(_payload!);
      if (!_disposed && generation == _generation && _sameAccount) {
        record = saved;
        status = HeartRecordingStatus.complete;
      }
    } catch (e) {
      if (!_disposed && generation == _generation) {
        errorCode = 'save_failed';
        status = HeartRecordingStatus.saveFailed;
      }
    } finally {
      _saving = false;
      _emit();
    }
  }

  Future<void> _endCapture() {
    _watchdog?.cancel();
    _watchdog = null;
    final subscription = _subscription;
    _subscription = null;
    return _cleanup = _cleanup.then((_) async {
      try {
        await gateway.stop();
      } catch (_) {}
      try {
        await subscription?.cancel();
      } catch (_) {}
    });
  }

  Future<void> cancel() async {
    _generation++;
    _payload = null;
    samples = [];
    metrics = {};
    record = null;
    status = HeartRecordingStatus.cancelled;
    await _endCapture();
    _emit();
  }

  @override
  void dispose() {
    _disposed = true;
    _generation++;
    _session?.removeListener(_account);
    unawaited(_endCapture().whenComplete(gateway.dispose));
    super.dispose();
  }
}
