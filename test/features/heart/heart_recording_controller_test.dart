import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_jcvital/core/auth/auth_session.dart';
import 'package:new_jcvital/core/auth/auth_token_store.dart';
import 'package:new_jcvital/features/device/domain/device_models.dart';
import 'package:new_jcvital/features/heart/application/heart_recording_controller.dart';
import '../../support/auth_fakes.dart' show MemoryAccessStorage;
import 'heart_test_support.dart';

const device = DeviceSnapshot(
  id: 'cloud-id',
  serialNumber: 'B1',
  transportId: 'BLE-ID',
  connected: true,
);

class LateStartGateway extends FakeHeartGateway {
  final firstStart = Completer<void>();
  @override
  Future<void> start(DeviceSnapshot device) async {
    startedDevices.add(device);
    if (startedDevices.length == 1) {
      await firstStart.future;
    } else {
      emit({'event': 'ecg_started'});
    }
  }
}

void main() {
  test(
    'a cancelled start returning late cannot stop its replacement',
    () async {
      final gateway = LateStartGateway();
      final c = HeartRecordingController(
        repository: MemoryHeartRepository(),
        gateway: gateway,
        device: device,
      );
      addTearDown(c.dispose);
      final oldStart = c.start();
      await Future<void>.delayed(Duration.zero);
      await c.cancel();
      await c.start();
      final stops = gateway.stops;
      gateway.firstStart.complete();
      await oldStart;
      expect(gateway.stops, stops);
      expect(c.status, HeartRecordingStatus.measuring);
    },
  );
  test(
    'retry waits for old cancellation and uses the current device snapshot',
    () async {
      final repo = MemoryHeartRepository(), gateway = FakeHeartGateway();
      final c = HeartRecordingController(
        repository: repo,
        gateway: gateway,
        device: device,
      );
      addTearDown(c.dispose);
      await c.start();
      gateway.stopWait = Completer<void>();
      final cancel = c.cancel();
      const replacement = DeviceSnapshot(
        id: 'cloud-b',
        serialNumber: 'B2',
        transportId: 'NEW-BLE',
        connected: true,
      );
      final retry = c.start(device: replacement);
      await Future<void>.delayed(Duration.zero);
      expect(gateway.startedDevices.length, 1);
      gateway.stopWait!.complete();
      await cancel;
      await retry;
      expect(gateway.startedDevices.last.transportId, 'NEW-BLE');
      gateway.emit({
        'event': 'ecg_waveform',
        'samples': [1, 2, 3],
        'waveformKind': 'ppg',
      });
      gateway.emit({'event': 'ecg_completed', 'durationMillis': 30000});
      await Future<void>.delayed(Duration.zero);
      expect(repo.payloads.single['deviceSerial'], 'B2');
      expect(c.status, HeartRecordingStatus.complete);
    },
  );
  test(
    'immediate cancellation never starts native collection after an await',
    () async {
      final gateway = FakeHeartGateway();
      final c = HeartRecordingController(
        repository: MemoryHeartRepository(),
        gateway: gateway,
        device: device,
      );
      addTearDown(c.dispose);
      final start = c.start();
      await c.cancel();
      await start;
      expect(gateway.startedDevices, isEmpty);
      expect(c.status, HeartRecordingStatus.cancelled);
    },
  );
  test(
    'real waveform kind and fresh metrics are preserved; retry uses the same idempotency key',
    () async {
      final repo = MemoryHeartRepository()..failCreate = true,
          gateway = FakeHeartGateway();
      final c = HeartRecordingController(
        repository: repo,
        gateway: gateway,
        device: device,
      );
      addTearDown(c.dispose);
      await c.start();
      gateway.emit({
        'event': 'ecg_waveform',
        'samples': [1, 2, 3, 4],
        'waveformKind': 'ppg',
      });
      gateway.emit({'event': 'ecg_metrics', 'heartRate': 70, 'hrv': 42});
      gateway.emit({
        'event': 'ecg_completed',
        'durationMillis': 30000,
        'heartRate': 200,
      });
      await Future<void>.delayed(Duration.zero);
      expect(c.status, HeartRecordingStatus.saveFailed);
      expect(c.samples, [1, 2, 3, 4]);
      expect(repo.payloads.single['heartRate'], 70);
      expect(repo.payloads.single['deviceSerial'], 'B1');
      expect(repo.payloads.single['waveformKind'], 'ppg');
      expect(repo.payloads.single['hrvMs'], 42);
      repo.failCreate = false;
      await c.save();
      expect(c.status, HeartRecordingStatus.complete);
      expect(
        repo.payloads[0]['clientRequestId'],
        repo.payloads[1]['clientRequestId'],
      );
      expect(repo.payloads[1].containsKey('classification'), isFalse);
    },
  );
  test(
    'no waveform, cancellation and late completion never create successful reports',
    () async {
      final repo = MemoryHeartRepository(), gateway = FakeHeartGateway();
      final c = HeartRecordingController(
        repository: repo,
        gateway: gateway,
        device: device,
      );
      addTearDown(c.dispose);
      await c.start();
      gateway.emit({'event': 'ecg_completed', 'durationMillis': 30000});
      expect(c.status, HeartRecordingStatus.failed);
      expect(repo.creates, 0);
      await c.start();
      gateway.emit({
        'event': 'ecg_waveform',
        'samples': [1, 2],
      });
      await c.cancel();
      gateway.emit({'event': 'ecg_completed', 'durationMillis': 30000});
      await Future<void>.delayed(Duration.zero);
      expect(repo.creates, 0);
      expect(c.samples, isEmpty);
    },
  );
  test(
    'account change clears private capture and stops native collection',
    () async {
      final session = AuthSession(storage: MemoryAccessStorage());
      await session.setAccessToken('account-a');
      final repo = MemoryHeartRepository(), gateway = FakeHeartGateway();
      final c = HeartRecordingController(
        repository: repo,
        gateway: gateway,
        device: device,
        session: session,
      );
      addTearDown(() {
        c.dispose();
        session.dispose();
        AuthTokenStore.instance.clear();
      });
      await c.start();
      gateway.emit({
        'event': 'ecg_waveform',
        'samples': [1, 2],
      });
      await session.setAccessToken('account-b');
      gateway.emit({'event': 'ecg_completed', 'durationMillis': 30000});
      await Future<void>.delayed(Duration.zero);
      expect(repo.creates, 0);
      expect(c.samples, isEmpty);
      expect(c.errorCode, 'account_changed');
      expect(gateway.stops, greaterThan(0));
    },
  );
  testWidgets(
    'stall timeout and delayed device start use actual capture time',
    (tester) async {
      var now = DateTime(2026, 11, 14, 12);
      final gateway = FakeHeartGateway()..startWait = Completer<void>();
      final c = HeartRecordingController(
        repository: MemoryHeartRepository(),
        gateway: gateway,
        device: device,
        clock: () => now,
      );
      addTearDown(c.dispose);
      final start = c.start();
      await tester.pump();
      now = now.add(const Duration(seconds: 15));
      gateway.startWait!.complete();
      await start;
      now = now.add(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));
      expect(c.status, HeartRecordingStatus.measuring);
      now = now.add(const Duration(seconds: 11));
      await tester.pump(const Duration(seconds: 1));
      expect(c.status, HeartRecordingStatus.failed);
      expect(c.errorCode, 'no_waveform');
    },
  );
}
