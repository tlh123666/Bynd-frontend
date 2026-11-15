import '../../../core/auth/auth_session.dart';
import '../../../core/network/api_client.dart';
import '../../../core/utils/local_timezone.dart';
import '../domain/heart_models.dart';

class RemoteHeartRepository implements HeartRepository {
  RemoteHeartRepository(
    this.client, {
    AuthSession? session,
    String Function()? timezone,
  }) : _session = session,
       _token = session?.accessToken,
       _timezone = timezone ?? localIanaTimezone;
  final ApiClient client;
  final AuthSession? _session;
  final String? _token;
  final String Function() _timezone;
  void _check() {
    if (_session != null && _session.accessToken != _token) {
      throw const ApiException('Account changed', code: 'account_changed');
    }
  }

  Future<Map<String, dynamic>> _call(
    String method,
    String path, {
    Map<String, String>? query,
    Map<String, dynamic>? body,
  }) async {
    _check();
    final out = await client.request(
      method,
      path,
      queryParameters: query,
      body: body,
      expectedAccessToken: _token,
    );
    _check();
    return out;
  }

  bool _auth(Object e) =>
      e is ApiException &&
      ['account_changed', 'authentication_required'].contains(e.code);
  @override
  Future<HeartSnapshot> load(DateTime date, String locale) async {
    final unavailable = <String>{};
    Future<Map<String, dynamic>> optional(
      String key,
      Future<Map<String, dynamic>> f,
    ) async {
      try {
        return await f;
      } catch (e) {
        if (_auth(e)) rethrow;
        unavailable.add(key);
        return {};
      }
    }

    final responses = await Future.wait([
      _call(
        'GET',
        '/me/heart-rate/experience',
        query: {'date': heartDate(date), 'timezone': _timezone()},
      ),
      optional(
        'samples',
        _call(
          'GET',
          '/me/heart-rate/samples',
          query: {
            'date': heartDate(date),
            'timezone': _timezone(),
            'interval': '60',
            'limit': '2000',
          },
        ),
      ),
      optional('preferences', _call('GET', '/me/heart-rate/settings')),
      optional(
        'recordings',
        _call(
          'GET',
          '/me/heart-rate/ecg/records',
          query: {
            'date': heartDate(date),
            'timezone': _timezone(),
            'limit': '3',
          },
        ),
      ),
    ]);
    HeartTrend history;
    try {
      history = await trend(date, 7);
    } catch (e) {
      if (_auth(e)) rethrow;
      unavailable.add('trend');
      history = const HeartTrend();
    }
    return HeartSnapshot(
      date: date,
      experience: responses[0],
      preferences: HeartPreferences(responses[2]),
      points: heartMaps(
        responses[1]['items'],
      ).where((j) => j['bpm'] is num).map(HeartPoint.fromJson).toList(),
      records: heartMaps(
        responses[3]['items'],
      ).map(HeartRecording.new).toList(),
      trend: history,
      unavailable: unavailable,
    );
  }

  @override
  Future<HeartTrend> trend(DateTime date, int days) async {
    try {
      final r = await _call(
        'GET',
        '/me/heart-rate/trend',
        query: {
          'endDate': heartDate(date),
          'days': '$days',
          'timezone': _timezone(),
        },
      );
      return HeartTrend(days: heartMaps(r['days']));
    } on ApiException catch (e) {
      if (e.statusCode == 403 || e.serverCode == 100011) {
        return const HeartTrend(locked: true);
      }
      rethrow;
    }
  }

  @override
  Future<HeartPreferences> savePreferences(HeartPreferences p) async =>
      HeartPreferences(
        await _call('PUT', '/me/heart-rate/settings', body: p.toJson()),
      );
  @override
  Future<HeartRecordPage> recordings({DateTime? date, String? cursor}) async {
    final r = await _call(
      'GET',
      '/me/heart-rate/ecg/records',
      query: {
        'limit': '20',
        'timezone': _timezone(),
        if (date != null) 'date': heartDate(date),
        'cursor': ?cursor,
      },
    );
    return HeartRecordPage(
      heartMaps(r['items']).map(HeartRecording.new).toList(),
      next: r['nextCursor'] as String?,
    );
  }

  String _path(String id) =>
      '/me/heart-rate/ecg/records/${Uri.encodeComponent(id)}';
  @override
  Future<HeartRecording> recording(String id) async =>
      HeartRecording(await _call('GET', _path(id)));
  @override
  Future<HeartRecording> createRecording(Map<String, dynamic> payload) async =>
      HeartRecording(
        await _call('POST', '/me/heart-rate/ecg/records', body: payload),
      );
  @override
  Future<HeartRecording> annotate(
    String id,
    String context,
    List<String> symptoms,
  ) async => HeartRecording(
    await _call(
      'PATCH',
      _path(id),
      body: {'measurementContext': context, 'symptoms': symptoms},
    ),
  );
  @override
  Future<void> deleteRecording(String id) async {
    await _call('DELETE', _path(id));
  }

  @override
  void dispose() => client.close();
}
