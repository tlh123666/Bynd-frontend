import '../../../core/auth/auth_session.dart';
import '../../../core/network/api_client.dart';
import '../../../core/utils/local_timezone.dart';
import '../domain/sleep_models.dart';

class RemoteSleepRepository implements SleepRepository {
  RemoteSleepRepository(
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
    );
    _check();
    return out;
  }

  void _check() {
    if (_session != null && _token != _session.accessToken) {
      throw const ApiException('Account changed', code: 'account_changed');
    }
  }

  bool _auth(Object e) =>
      e is ApiException &&
      ['account_changed', 'authentication_required'].contains(e.code);
  @override
  Future<SleepSnapshot> load(DateTime date, String locale) async {
    final unavailable = <String>{};
    Future<Map<String, dynamic>> optional(
      String name,
      Future<Map<String, dynamic>> future,
    ) async {
      try {
        return await future;
      } catch (e) {
        if (_auth(e)) rethrow;
        unavailable.add(name);
        return {};
      }
    }

    final d = sleepDate(date);
    // Start independent requests together; a missing optional measurement must
    // not replace the selected night or hide a real API/authentication error.
    final responses = await Future.wait([
      _call('GET', '/me/sleep/experience', query: {'date': d}),
      optional(
        'insight',
        _call(
          'GET',
          '/me/sleep/insight',
          query: {'date': d, 'locale': locale, 'timezone': _timezone()},
        ),
      ),
      optional('preferences', _call('GET', '/me/sleep/preferences')),
      optional(
        'naps',
        _call(
          'GET',
          '/me/sleep/sessions',
          query: {
            'startDate': d,
            'endDate': d,
            'sessionType': 'nap',
            'pageSize': '100',
          },
        ),
      ),
    ]);
    SleepTrend history;
    try {
      history = await trend(date, 7);
    } catch (e) {
      if (_auth(e)) rethrow;
      unavailable.add('trend');
      history = const SleepTrend();
    }
    _check();
    return SleepSnapshot(
      date: date,
      preferences: SleepPreferences({
        ...responses[2],
        'timezone': responses[2]['timezone'] ?? _timezone(),
      }),
      session: responses[0]['session'] is Map
          ? SleepSession(sleepMap(responses[0]['session']))
          : null,
      summary: sleepMap(responses[0]['summary']),
      vitals: sleepMap(responses[0]['vitals']),
      insight: responses[1],
      naps: sleepMaps(responses[3]['items']).map(SleepSession.new).toList(),
      trend: history,
      unavailable: unavailable,
    );
  }

  @override
  Future<SleepTrend> trend(DateTime date, int days) async {
    try {
      final data = await _call(
        'GET',
        '/me/sleep/trend',
        query: {
          'endDate': sleepDate(date),
          'days': '$days',
          'timezone': _timezone(),
        },
      );
      return SleepTrend(days: sleepMaps(data['days']));
    } on ApiException catch (e) {
      if (e.statusCode == 403 || e.serverCode == 100011) {
        return const SleepTrend(locked: true);
      }
      rethrow;
    }
  }

  @override
  Future<SleepSession> session(String id) async => SleepSession(
    await _call('GET', '/me/sleep/sessions/${Uri.encodeComponent(id)}'),
  );
  @override
  Future<SleepPreferences> savePreferences(SleepPreferences p) async =>
      SleepPreferences(
        await _call('PUT', '/me/sleep/preferences', body: p.toJson()),
      );
  @override
  Future<List<Map<String, dynamic>>> plans() async =>
      sleepMaps((await _call('GET', '/me/sleep-plans'))['items']);
  @override
  Future<Map<String, dynamic>> savePlan(Map<String, dynamic> p) => _call(
    p['id'] == null ? 'POST' : 'PUT',
    '/me/sleep-plans${p['id'] == null ? '' : '/${Uri.encodeComponent('${p['id']}')}'}',
    body: p,
  );
  @override
  Future<void> deletePlan(String id) async {
    await _call('DELETE', '/me/sleep-plans/${Uri.encodeComponent(id)}');
  }

  @override
  void dispose() => client.close();
}
