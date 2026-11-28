import 'dart:async';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:new_jcvital/core/auth/auth_session.dart';
import 'package:new_jcvital/core/network/api_client.dart';
import 'package:new_jcvital/features/heart/application/heart_controller.dart';
import 'package:new_jcvital/features/heart/data/remote_heart_repository.dart';
import 'package:new_jcvital/features/heart/domain/heart_models.dart';
import '../../support/auth_fakes.dart' show MemoryAccessStorage;
import 'heart_test_support.dart';

void main() {
  final date = DateTime(2026, 11, 14);
  test(
    'an account switch during asynchronous header resolution prevents the write',
    () async {
      var sends = 0;
      final token = Completer<String?>();
      final client = ApiClient(
        baseUrl: Uri.parse('https://example.test/api/v1'),
        tokenProvider: () => token.future,
        client: MockClient((r) async {
          sends++;
          return http.Response('{}', 200);
        }),
      );
      final request = client.request(
        'POST',
        '/me/heart-rate/ecg/records',
        expectedAccessToken: 'original-account',
        body: {
          'samples': [1, 2, 3],
        },
      );
      final assertion = expectLater(
        request,
        throwsA(
          isA<ApiException>().having((e) => e.code, 'code', 'account_changed'),
        ),
      );
      token.complete('another-account');
      await assertion;
      expect(sends, 0);
      client.close();
    },
  );
  test(
    'selected local date, optional failures and Premium use actual API contracts',
    () async {
      final requests = <http.Request>[];
      final repo = RemoteHeartRepository(
        ApiClient(
          baseUrl: Uri.parse('https://example.test/api/v1'),
          tokenProvider: () async => 't',
          client: MockClient((r) async {
            requests.add(r);
            expect(r.headers['authorization'], 'Bearer t');
            if (r.url.path.endsWith('/trend')) {
              if (r.url.queryParameters['days'] == '30') {
                return http.Response(jsonEncode({'code': 100011}), 200);
              }
              return http.Response(
                jsonEncode({
                  'code': 200,
                  'data': {
                    'days': [
                      {'statDate': '2026-11-14', 'hasData': false},
                    ],
                  },
                }),
                200,
              );
            }
            if (r.url.path.endsWith('/samples')) {
              return http.Response('{}', 503);
            }
            if (r.url.path.endsWith('/experience') ||
                r.url.path.endsWith('/records')) {
              expect(r.url.queryParameters['date'], '2026-11-14');
              expect(r.url.queryParameters['timezone'], 'America/Sao_Paulo');
            }
            return http.Response(jsonEncode({'code': 200, 'data': {}}), 200);
          }),
        ),
        timezone: () => 'America/Sao_Paulo',
      );
      final data = await repo.load(date, 'pt-BR');
      expect(requests.length, 6);
      expect(
        requests
            .where((r) => r.url.path.endsWith('/trend'))
            .map((r) => r.url.queryParameters['days']),
        ['30', '7'],
      );
      expect(data.hasData, false);
      expect(data.demo, false);
      expect(data.points, isEmpty);
      expect(data.format(HeartMetric.pulse), '—');
      expect(data.value(HeartMetric.oxygen), isNull);
      expect(data.unavailable, {'samples'});
      expect(data.trend.locked, false);
      expect(data.trend.days.single['hasData'], false);
      repo.dispose();
    },
  );
  test(
    'preferences preserve false and record CRUD preserves kind, notes and cursor',
    () async {
      final requests = <http.Request>[];
      final repo = RemoteHeartRepository(
        ApiClient(
          baseUrl: Uri.parse('https://example.test/api/v1'),
          tokenProvider: () async => 't',
          client: MockClient((r) async {
            requests.add(r);
            final body = r.body.isEmpty
                ? <String, dynamic>{}
                : jsonDecode(r.body);
            return http.Response(
              jsonEncode({
                'code': 200,
                'data': r.method == 'GET' && r.url.path.endsWith('/records')
                    ? {
                        'items': [heartRecordingFixture().json],
                        'nextCursor': 'next',
                      }
                    : body,
              }),
              200,
            );
          }),
        ),
        timezone: () => 'UTC',
      );
      final prefs = await repo.savePreferences(
        const HeartPreferences({
          'showEstimatedPressure': false,
          'notifyHighResting': false,
          'notifyIrregularRhythm': true,
        }),
      );
      expect(prefs.pressure, false);
      expect(prefs.high, false);
      expect(
        jsonDecode(requests.last.body).keys,
        unorderedEquals([
          'showEstimatedPressure',
          'notifyHighResting',
          'notifyIrregularRhythm',
        ]),
      );
      final page = await repo.recordings(date: date, cursor: 'prev');
      expect(page.next, 'next');
      expect(page.items.single.kind, 'ppg');
      expect(requests.last.url.queryParameters['cursor'], 'prev');
      await repo.recording('record-1');
      expect(requests.last.method, 'GET');
      await repo.annotate('record-1', 'after_coffee', ['palpitations']);
      expect(requests.last.method, 'PATCH');
      expect(jsonDecode(requests.last.body)['symptoms'], ['palpitations']);
      await repo.deleteRecording('record-1');
      expect(requests.last.method, 'DELETE');
      repo.dispose();
    },
  );
  test('late date responses cannot replace the selected day', () async {
    final first = Completer<HeartSnapshot>(),
        second = Completer<HeartSnapshot>();
    final repo = MemoryHeartRepository()
      ..onLoad = (d) => d.day == 14 ? first.future : second.future;
    final c = HeartController(repository: repo, date: date);
    final a = c.load(), b = c.load(date: DateTime(2026, 11, 13));
    second.complete(heartSnapshotFixture(DateTime(2026, 11, 13)));
    await b;
    first.complete(heartSnapshotFixture(date));
    await a;
    expect(c.snapshot!.date.day, 13);
    c.dispose();
  });
  test(
    'account change clears private data and rejects in-flight loads',
    () async {
      final session = AuthSession(storage: MemoryAccessStorage());
      await session.setAccessToken('a');
      final pending = Completer<HeartSnapshot>();
      final repo = MemoryHeartRepository()..onLoad = (_) => pending.future;
      final c = HeartController(repository: repo, date: date, session: session);
      final task = c.load();
      await session.setAccessToken('b');
      pending.complete(heartSnapshotFixture(date));
      await task;
      expect(c.accountChanged, true);
      expect(c.snapshot, isNull);
      c.dispose();
      await session.signOut();
      session.dispose();
    },
  );
  test(
    'missing days are excluded from averages and old readings are never current',
    () {
      final s = heartSnapshotFixture(date);
      expect(s.trend.average(HeartMetric.resting), 58);
      expect(s.fresh(DateTime(2026, 11, 16)), false);
      expect(s.format(HeartMetric.recovery), '−28');
      expect(
        const HeartTrend(
          days: [
            {'hasData': false, 'avgHeartRate': 99},
          ],
        ).average(HeartMetric.pulse),
        isNull,
      );
    },
  );
}
