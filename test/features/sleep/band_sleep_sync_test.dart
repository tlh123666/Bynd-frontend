import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:new_jcvital/core/auth/auth_session.dart';
import 'package:new_jcvital/core/auth/auth_token_store.dart';
import 'package:new_jcvital/core/network/api_client.dart';
import 'package:new_jcvital/features/device/domain/device_models.dart';
import 'package:new_jcvital/features/sleep/application/band_sleep_sync.dart';
import '../../support/auth_fakes.dart' show MemoryAccessStorage;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('sleep-sync-test');
  const device = DeviceSnapshot(
    id: 'linked-device',
    serialNumber: 'B1',
    transportId: 'BLE-ID',
    connected: true,
  );
  late AuthSession session;
  setUp(() async {
    session = AuthSession(storage: MemoryAccessStorage());
    await session.setAccessToken('account-a');
  });
  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
    session.dispose();
    AuthTokenStore.instance.clear();
  });
  test(
    'uploads 24-session batches with stable IDs and stage facts only',
    () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            expect(call.method, 'readSleepHistory');
            expect(call.arguments['serialNumber'], 'B1');
            return {
              'history': {
                'sleep': [
                  for (var day = 1; day <= 25; day++)
                    {
                      'date':
                          '2026-10-${day.toString().padLeft(2, '0')} 01:00:00',
                      'sleepUnitLength': 5,
                      'arraySleep': List.filled(24, '01').join(' '),
                    },
                ],
              },
            };
          });
      final requests = <Map<String, dynamic>>[];
      final client = ApiClient(
        baseUrl: Uri.parse('https://example.test/api/v1'),
        tokenProvider: () async => session.accessToken,
        client: MockClient((request) async {
          expect(request.url.path, '/api/v1/me/sleep/sessions');
          final body = jsonDecode(request.body) as Map<String, dynamic>;
          requests.add(body);
          return http.Response(
            jsonEncode({
              'code': 200,
              'data': {
                'accepted': (body['sessions'] as List).length,
                'updated': 0,
                'filtered': 0,
              },
            }),
            200,
          );
        }),
      );
      addTearDown(client.close);
      final sync = BandSleepSync(
        client,
        channel: channel,
        session: session,
        clock: () => DateTime(2026, 11, 14),
        timezone: () => 'Asia/Shanghai',
      );
      expect(await sync.sync(device), 25);
      expect(requests.map((r) => (r['sessions'] as List).length), [24, 1]);
      final first = (requests.first['sessions'] as List).first as Map;
      expect(
        first.keys,
        unorderedEquals([
          'clientRequestId',
          'startAt',
          'endAt',
          'stageIntervalMinutes',
          'segments',
        ]),
      );
      expect(requests.first['deviceSerial'], 'B1');
      expect(requests.first['timezone'], 'Asia/Shanghai');
      await sync.sync(device);
      expect(
        (requests[2]['sessions'] as List).first['clientRequestId'],
        first['clientRequestId'],
      );
    },
  );
  test('account change during BLE read prevents any upload', () async {
    final read = Completer<dynamic>();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (_) => read.future);
    var uploads = 0;
    final client = ApiClient(
      baseUrl: Uri.parse('https://example.test/api/v1'),
      tokenProvider: () async => session.accessToken,
      client: MockClient((_) async {
        uploads++;
        return http.Response('{}', 200);
      }),
    );
    addTearDown(client.close);
    final future = BandSleepSync(
      client,
      channel: channel,
      session: session,
    ).sync(device);
    final assertion = expectLater(
      future,
      throwsA(
        isA<ApiException>().having((e) => e.code, 'code', 'account_changed'),
      ),
    );
    await session.setAccessToken('account-b');
    read.complete({
      'history': {'sleep': []},
    });
    await assertion;
    expect(uploads, 0);
  });
}
