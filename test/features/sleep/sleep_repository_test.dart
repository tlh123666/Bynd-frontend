import 'dart:async';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:new_jcvital/core/auth/auth_session.dart';
import 'package:new_jcvital/core/network/api_client.dart';
import 'package:new_jcvital/features/sleep/application/sleep_controller.dart';
import 'package:new_jcvital/features/sleep/data/remote_sleep_repository.dart';
import 'package:new_jcvital/features/sleep/domain/sleep_models.dart';
import '../../support/auth_fakes.dart' show MemoryAccessStorage;
import 'sleep_test_support.dart';

void main() {
  final date = DateTime(2026, 11, 14);
  test(
    'selected night, time zone, language and premium restriction use the real API contract',
    () async {
      final requests = <http.Request>[];
      final repo = RemoteSleepRepository(
        ApiClient(
          baseUrl: Uri.parse('https://example.test/api/v1'),
          tokenProvider: () async => 'token',
          client: MockClient((r) async {
            requests.add(r);
            expect(r.headers['authorization'], 'Bearer token');
            dynamic data = {};
            if (r.url.path.endsWith('/experience')) {
              expect(r.url.queryParameters['date'], '2026-11-14');
              data = {
                'session': sleepSessionFixture(),
                'summary': {'sleepDebtMinutes': 90},
              };
            }
            if (r.url.path.endsWith('/insight')) {
              expect(r.url.queryParameters['locale'], 'pt-BR');
              expect(r.url.queryParameters['timezone'], 'America/Sao_Paulo');
            }
            if (r.url.path.endsWith('/sessions')) {
              expect(r.url.queryParameters['sessionType'], 'nap');
              data = {'items': []};
            }
            if (r.url.path.endsWith('/trend')) {
              return http.Response(jsonEncode({'code': 100011}), 200);
            }
            return http.Response(jsonEncode({'code': 200, 'data': data}), 200);
          }),
        ),
        timezone: () => 'America/Sao_Paulo',
      );
      final snapshot = await repo.load(date, 'pt-BR');
      expect(snapshot.session!.asleep, 450);
      expect(snapshot.trend.locked, isTrue);
      expect(snapshot.value(SleepMetric.debt), 90);
      expect(snapshot.value(SleepMetric.respiration), isNull);
      expect(snapshot.value(SleepMetric.temperature), isNull);
      expect(snapshot.unavailable, isEmpty);
      expect(requests.length, 5);
      repo.dispose();
    },
  );
  test(
    'missing real sleep stays empty; it never selects a demo night',
    () async {
      final repo = RemoteSleepRepository(
        ApiClient(
          baseUrl: Uri.parse('https://example.test/api/v1'),
          tokenProvider: () async => 't',
          client: MockClient(
            (r) async => http.Response(
              jsonEncode({
                'code': 200,
                'data': r.url.path.endsWith('/experience')
                    ? {'session': null}
                    : {},
              }),
              200,
            ),
          ),
        ),
      );
      final snapshot = await repo.load(date, 'en');
      expect(snapshot.hasNight, isFalse);
      expect(snapshot.value(SleepMetric.duration), isNull);
      repo.dispose();
    },
  );
  test(
    'plan and preferences writes preserve explicit false and minute precision',
    () async {
      final requests = <http.Request>[];
      final repo = RemoteSleepRepository(
        ApiClient(
          baseUrl: Uri.parse('https://example.test/api/v1'),
          tokenProvider: () async => 't',
          client: MockClient((r) async {
            requests.add(r);
            return http.Response(
              jsonEncode({
                'code': 200,
                'data': r.body.isEmpty ? {} : jsonDecode(r.body),
              }),
              200,
            );
          }),
        ),
      );
      await repo.savePreferences(
        const SleepPreferences({
          'targetSleepMinutes': 450,
          'targetBedtimeHour': 0,
          'targetBedtimeMinute': 15,
          'showStages': false,
          'timezone': 'America/Sao_Paulo',
        }),
      );
      final body = jsonDecode(requests.last.body) as Map;
      expect(body['showStages'], false);
      expect(body['targetSleepMinutes'], 450);
      expect(body['targetBedtimeMinute'], 15);
      await repo.savePlan({
        'enabled': false,
        'week': 62,
        'timezone': 'America/Sao_Paulo',
        'bedtimeHour': 0,
        'bedtimeMinute': 15,
        'remindBeforeMinutes': 30,
      });
      expect(requests.last.method, 'POST');
      expect(jsonDecode(requests.last.body)['enabled'], false);
      await repo.deletePlan('00000000-0000-4000-8000-000000000001');
      expect(requests.last.method, 'DELETE');
      repo.dispose();
    },
  );
  test('late night loads cannot replace a newer selected date', () async {
    final a = Completer<SleepSnapshot>(), b = Completer<SleepSnapshot>();
    final repo = MemorySleepRepository();
    repo.onLoad = (d) => d.day == 14 ? a.future : b.future;
    final c = SleepController(repository: repo, date: date);
    final first = c.load();
    final other = date.subtract(const Duration(days: 1));
    final second = c.load(date: other);
    b.complete(sleepSnapshotFixture(other));
    await second;
    a.complete(sleepSnapshotFixture(date));
    await first;
    expect(c.snapshot!.date, other);
    c.dispose();
  });
  test(
    'account change immediately clears sleep and ignores in-flight results',
    () async {
      final session = AuthSession(storage: MemoryAccessStorage());
      await session.setAccessToken('a');
      final pending = Completer<SleepSnapshot>();
      final repo = MemorySleepRepository()..onLoad = (_) => pending.future;
      final c = SleepController(repository: repo, date: date, session: session);
      final load = c.load();
      await session.setAccessToken('b');
      pending.complete(sleepSnapshotFixture(date));
      await load;
      expect(c.accountChanged, true);
      expect(c.snapshot, isNull);
      c.dispose();
      await session.signOut();
      session.dispose();
    },
  );
  test('history averages ignore missing days and null measurements', () {
    final t = SleepTrend(
      days: [
        {'hasData': true, 'sleepScore': 80},
        {'hasData': false, 'sleepScore': 0},
        {'hasData': true, 'sleepScore': null},
      ],
    );
    expect(t.average('sleepScore'), 80);
    expect(t.average('hrvMs'), isNull);
  });
}
