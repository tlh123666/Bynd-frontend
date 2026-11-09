import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:new_jcvital/core/network/api_client.dart';
import 'package:new_jcvital/features/home/data/remote_home_repository.dart';
import 'package:new_jcvital/features/home/domain/home_models.dart';

http.Response response(Object? data, {int status = 200}) => http.Response(
  jsonEncode({'code': status == 200 ? 200 : status, 'data': data}),
  status,
  headers: {'content-type': 'application/json'},
);
RemoteHomeRepository repository(
  Future<http.Response> Function(http.Request) handler,
) => RemoteHomeRepository(
  ApiClient(
    baseUrl: Uri.parse('https://example.test/api/v1'),
    tokenProvider: () async => 'test-token',
    client: MockClient(handler),
  ),
  timezone: () => 'Asia/Shanghai',
);
void main() {
  test(
    'reads existing contracts with date, timezone and auth; zero is preserved, absent VO2 is not invented',
    () async {
      final requests = <http.Request>[];
      final remote = repository((request) async {
        requests.add(request);
        if (request.url.path.endsWith('today-direction')) {
          return response({
            'title': 'Direção',
            'insight': 'Leitura',
            'recommendation': 'Pausa',
            'healthMetrics': [],
          });
        }
        if (request.url.path.endsWith('daily-summary')) {
          return response({'steps': 0, 'sleepMinutes': 462, 'hrvMs': 54});
        }
        if (request.url.path.endsWith('profile')) {
          return response({'userId': 'user-1', 'fullName': 'Ana Silva'});
        }
        return response({'display_relationships': []});
      });
      final result = await remote.fetch(DateTime(2026, 11, 8), 'pt-BR');
      expect(result.firstName, 'Ana');
      expect(result.userId, 'user-1');
      expect(result.measurement(HomeSignal.steps).value, 0);
      expect(result.measurement(HomeSignal.vo2).value, isNull);
      final direction = requests.singleWhere(
        (r) => r.url.path.endsWith('today-direction'),
      );
      expect(direction.url.queryParameters, {
        'statDate': '2026-11-08',
        'timezone': 'Asia/Shanghai',
        'locale': 'pt-BR',
      });
      expect(
        requests.every(
          (r) => r.headers['Authorization'] == 'Bearer test-token',
        ),
        isTrue,
      );
      expect(
        requests.every((r) => !r.url.path.contains('/api/v1/api/v1')),
        isTrue,
      );
      remote.dispose();
    },
  );
  test(
    'missing summary is an empty measurement day; server failure stays an error',
    () async {
      var status = 404;
      final remote = repository((request) async {
        if (request.url.path.endsWith('daily-summary')) {
          return response(null, status: status);
        }
        return response({});
      });
      final result = await remote.fetch(DateTime(2026, 11, 8), 'pt');
      expect(result.measurement(HomeSignal.sleep).value, isNull);
      status = 503;
      await expectLater(
        remote.fetch(DateTime(2026, 11, 8), 'pt'),
        throwsA(isA<ApiException>()),
      );
      remote.dispose();
    },
  );
  test(
    'history retains gaps and zero, rather than joining missing days as measurements',
    () async {
      final remote = repository((request) async {
        final date = request.url.queryParameters['statDate'];
        if (date == '2026-11-07') return response(null, status: 404);
        return response({'steps': date == '2026-11-08' ? 0 : 1000});
      });
      final points = await remote.history(
        HomeSignal.steps,
        DateTime(2026, 11, 8),
        'pt',
      );
      expect(points.length, 7);
      expect(points.first.date, DateTime(2026, 11, 2));
      expect(points[5].value, isNull);
      expect(points.last.value, 0);
      remote.dispose();
    },
  );
  test(
    'diary save uses existing authenticated batch contract and selected historical date',
    () async {
      final remote = repository((request) async {
        expect(request.method, 'POST');
        expect(request.url.path, '/api/v1/me/diary/events/batch');
        final body = jsonDecode(request.body) as Map;
        expect(body['date'], '2026-11-08');
        expect(body['timezone'], 'Asia/Shanghai');
        expect(body['events'], [
          {
            'category': 'meal',
            'label': 'Almoço',
            'note': 'Leve',
            'inputMethod': 'quick',
          },
        ]);
        expect(body.containsKey('userId'), false);
        return response({});
      });
      await remote.saveDiary(
        DateTime(2026, 11, 8),
        'pt-BR',
        category: 'meal',
        label: 'Almoço',
        note: 'Leve',
      );
      remote.dispose();
    },
  );
}
