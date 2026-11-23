import '../../../core/auth/auth_session.dart';
import '../../../core/network/api_client.dart';
import '../../../core/utils/local_timezone.dart';
import '../domain/vitality_models.dart';

class RemoteVitalityRepository implements VitalityRepository {
  RemoteVitalityRepository(
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

  @override
  Future<VitalitySnapshot> load(
    VitalityKind kind,
    DateTime date, {
    int days = 7,
  }) async {
    _check();
    try {
      return await _load(kind, date, days);
    } on ApiException catch (error) {
      if (days != 30 || error.statusCode != 403) rethrow;
      _check();
      return _load(kind, date, 7);
    }
  }

  Future<VitalitySnapshot> _load(
    VitalityKind kind,
    DateTime date,
    int days,
  ) async {
    final data = await client.request(
      'GET',
      '/me/health-data/vitality/${kind.name}/experience',
      queryParameters: {
        'date': vitalityDate(date),
        'timezone': _timezone(),
        'days': '$days',
      },
      expectedAccessToken: _token,
    );
    _check();
    return VitalitySnapshot.fromJson(data);
  }

  @override
  Future<VitalityPreferences> savePreferences(VitalityPreferences p) async {
    _check();
    final data = await client.request(
      'PUT',
      '/me/health-data/vitality/preferences',
      body: p.toJson(),
      expectedAccessToken: _token,
    );
    _check();
    return VitalityPreferences(data);
  }

  @override
  void dispose() => client.close();
}
