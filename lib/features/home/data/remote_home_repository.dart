import '../../../core/network/api_client.dart';
import '../../../core/utils/local_timezone.dart';
import '../domain/home_models.dart';
import '../domain/home_repository.dart';

/// Reuses the authenticated APIs already shared with JCVital. No prototype
/// numbers, reference ranges or health judgements are invented in this adapter.
class RemoteHomeRepository implements HomeRepository {
  RemoteHomeRepository(this.client, {String Function()? timezone})
    : _timezone = timezone ?? localIanaTimezone;
  final ApiClient client;
  final String Function() _timezone;

  Map<String, String> _query(DateTime date, String locale) => {
    'statDate': homeDateKey(date),
    'timezone': _timezone(),
    'locale': locale,
  };

  Future<Map<String, dynamic>> _summary(DateTime date) async {
    try {
      return await client.request(
        'GET',
        '/me/health-data/daily-summary',
        queryParameters: {'statDate': homeDateKey(date)},
      );
    } on ApiException catch (e) {
      if (e.code == 'http_404') return {};
      rethrow;
    }
  }

  @override
  Future<HomeSnapshot> fetch(DateTime date, String locale) async {
    var partial = false;
    Future<Map<String, dynamic>> optional(
      Future<Map<String, dynamic>> future,
    ) async {
      try {
        return await future;
      } on ApiException catch (e) {
        if (e.code == 'authentication_required') rethrow;
        partial = true;
        return {};
      }
    }

    final responses = await Future.wait([
      client.request(
        'GET',
        '/me/health-data/today-direction',
        queryParameters: _query(date, locale),
      ),
      _summary(date),
      optional(client.request('GET', '/me/profile')),
      // Mapa describes current relationships, not a historical day's snapshot.
      if (homeDay(date) == homeDay(DateTime.now()))
        optional(client.request('GET', '/mapa/overview')),
    ]);
    final direction = responses[0],
        summary = responses[1],
        profile = responses[2];
    final descriptions = <String, Map<String, dynamic>>{};
    for (final raw in direction['healthMetrics'] as List? ?? []) {
      if (raw is Map<String, dynamic>) descriptions['${raw['type']}'] = raw;
    }
    final measurements = <HomeSignal, HomeMeasurement>{};
    const aliases = {
      HomeSignal.rhr: 'heart_rate',
      HomeSignal.oxygen: 'blood_oxygen',
    };
    for (final signal in HomeSignal.values) {
      final value = summary[signal.jsonKey];
      final description = descriptions[aliases[signal] ?? signal.name];
      // Heart-rate analysis can concern average HR, not resting HR. Do not
      // attach that status to the resting measurement.
      final message = signal == HomeSignal.rhr
          ? ''
          : description?['message'] as String? ?? '';
      measurements[signal] = HomeMeasurement(
        signal,
        value: value is num && value.isFinite ? value : null,
        caption: message,
      );
    }
    final mapa = responses.length == 4 ? responses[3] : <String, dynamic>{};
    final relationships = mapa['display_relationships'];
    return HomeSnapshot(
      date: date,
      title: direction['title'] as String? ?? '',
      paragraphs: [
        if ((direction['insight'] as String? ?? '').isNotEmpty)
          direction['insight'] as String,
      ],
      recommendation: direction['recommendation'] as String? ?? '',
      measurements: measurements,
      userId: profile['id'] as String? ?? profile['userId'] as String? ?? '',
      firstName: (profile['fullName'] as String? ?? '')
          .trim()
          .split(RegExp(r'\s+'))
          .first,
      avatarUrl: profile['avatarUrl'] as String?,
      patterns: relationships is List ? relationships.length : null,
      partial: partial,
    );
  }

  @override
  Future<List<HomeHistoryPoint>> history(
    HomeSignal signal,
    DateTime date,
    String locale,
  ) async {
    // Bounded to 7 days. Missing days stay gaps; zero is a valid measurement.
    return Future.wait(
      List.generate(7, (i) async {
        final day = homeDay(date, 6 - i);
        final summary = await _summary(day);
        final value = summary[signal.jsonKey];
        return HomeHistoryPoint(
          day,
          value is num && value.isFinite ? value : null,
        );
      }),
    );
  }

  @override
  Future<List<HomeDiaryEvent>> diary(DateTime date, String locale) async {
    final data = await client.request(
      'GET',
      '/me/diary/${homeDateKey(date)}',
      queryParameters: {'timezone': _timezone(), 'locale': locale},
    );
    return [
      for (final item in data['events'] as List? ?? [])
        if (item is Map<String, dynamic>) HomeDiaryEvent.fromJson(item),
    ];
  }

  @override
  Future<void> saveDiary(
    DateTime date,
    String locale, {
    required String category,
    required String label,
    required String note,
  }) async {
    await client.request(
      'POST',
      '/me/diary/events/batch',
      body: {
        'date': homeDateKey(date),
        'timezone': _timezone(),
        'locale': locale,
        'events': [
          {
            'category': category,
            'label': label,
            'note': note,
            'inputMethod': 'quick',
          },
        ],
      },
    );
  }

  @override
  void dispose() => client.close();
}
