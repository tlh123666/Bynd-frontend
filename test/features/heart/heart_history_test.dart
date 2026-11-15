import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:new_jcvital/core/auth/auth_session.dart';
import 'package:new_jcvital/core/network/api_client.dart';
import 'package:new_jcvital/features/device/domain/device_models.dart';
import 'package:new_jcvital/features/heart/application/heart_history_sync.dart';
import 'package:new_jcvital/features/heart/domain/heart_rate_sample_upload.dart';
import 'package:new_jcvital/features/heart/domain/heart_vital_history.dart';
import '../../support/auth_fakes.dart' show MemoryAccessStorage;
import 'heart_test_support.dart';

void main() {
  test(
    'invalid sensor slots leave timestamp gaps; duplicate histories remain idempotent',
    () {
      final row = {
        'date': '2026.11.14 10:00:00',
        'arrayDynamicHR': '[60, bad, 0, 64, 255]',
      };
      final points = heartRateSamplesFromHistory({
        'dynamicHeartRate': [row, row],
        'staticHeartRate': [
          {'date': '2026.11.14 10:00:00', 'staticHR': '72'},
        ],
      });
      expect(points.length, 3);
      expect(points.where((p) => p.context == 'continuous').map((p) => p.bpm), [
        60,
        64,
      ]);
      expect(
        points.last.measuredAt.difference(points.first.measuredAt).inSeconds,
        30,
      );
      expect(points.where((p) => p.context == 'manual').single.bpm, 72);
    },
  );
  test(
    'HRV, blood pressure and oxygen require their own timestamps and valid values',
    () {
      final grouped = heartVitalsFromHistory({
        'metrics': {'hrv': 70, 'bloodOxygen': 98},
        'hrv': [
          {
            'date': '2026.11.13 22:00:00',
            'hrv': '50',
            'highBP': '120',
            'lowBP': '78',
          },
          {
            'date': '2026.11.13 22:00:00',
            'hrv': '50',
            'highBP': '120',
            'lowBP': '78',
          },
          {'date': 'invalid', 'hrv': 66},
          {'date': '2026.11.14 10:00:00', 'hrv': -1, 'highBP': 70, 'lowBP': 90},
        ],
        'bloodOxygen': [
          {'date': '2026.11.13 22:00:00', 'Blood_oxygen': '98'},
          {'date': '2026.11.14 10:00:00', 'Blood_oxygen': 101},
        ],
      });
      expect(grouped.keys, ['2026-11-13']);
      expect(grouped.values.single.length, 3);
      expect(grouped.values.single.map((r) => r['metricType']), [
        'blood_pressure',
        'hrv',
        'spo2',
      ]);
    },
  );
  test(
    'sync chunks heart samples and submits deterministic complete-day vital batches',
    () async {
      final session = AuthSession(storage: MemoryAccessStorage());
      await session.setAccessToken('a');
      final gateway = FakeHeartGateway()
        ..history = {
          'history': {
            'dynamicHeartRate': [
              {
                'date': '2026.11.14 00:00:00',
                'arrayDynamicHR': List.filled(501, 60),
              },
            ],
            'hrv': [
              {
                'date': '2026.11.14 00:00:00',
                'hrv': 55,
                'highBP': 120,
                'lowBP': 80,
              },
            ],
            'bloodOxygen': [
              {'date': '2026.11.14 00:00:00', 'Blood_oxygen': 98},
            ],
          },
        };
      final requests = <http.Request>[];
      final client = ApiClient(
        baseUrl: Uri.parse('https://example.test/api/v1'),
        tokenProvider: () async => 'a',
        client: MockClient((r) async {
          requests.add(r);
          final body = jsonDecode(r.body);
          return http.Response(
            jsonEncode({
              'code': 200,
              'data': r.url.path.endsWith('/samples')
                  ? {'accepted': (body['samples'] as List).length}
                  : {'rejectedCount': 0},
            }),
            200,
          );
        }),
      );
      final sync = HeartHistorySync(client, gateway, session: session);
      const device = DeviceSnapshot(
        id: 'cloud-id',
        serialNumber: 'B1',
        connected: true,
        transportId: 'ble',
      );
      expect(await sync.sync(device), 501);
      expect((jsonDecode(requests[0].body)['samples'] as List).length, 500);
      expect((jsonDecode(requests[1].body)['samples'] as List).length, 1);
      final vital = jsonDecode(requests[2].body);
      expect((vital['records'] as List).length, 3);
      expect(vital['deviceId'], 'cloud-id');
      await sync.sync(device);
      expect(
        jsonDecode(requests[5].body)['clientBatchId'],
        vital['clientBatchId'],
      );
      client.close();
      gateway.dispose();
      await session.signOut();
      session.dispose();
    },
  );
}
