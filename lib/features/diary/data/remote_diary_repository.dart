import 'dart:convert';
import 'dart:typed_data';
import '../../../core/auth/auth_session.dart';
import '../../../core/network/api_client.dart';
import '../../../core/utils/local_timezone.dart';
import '../domain/diary_models.dart';

class RemoteDiaryRepository implements DiaryRepository {
  RemoteDiaryRepository(
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
    Map<String, dynamic>? body,
  }) async {
    _check();
    final data = await client.request(
      method,
      '/me/diary$path',
      body: body,
      queryParameters: method == 'GET' ? {'timezone': _timezone()} : null,
    );
    _check();
    return data;
  }

  void _check() {
    if (_session != null && _session.accessToken != _token) {
      throw const ApiException(
        'Sua conta mudou. Abra o Diário novamente.',
        code: 'account_changed',
      );
    }
  }

  @override
  Future<DiaryDay> load(DateTime date) async =>
      DiaryDay.fromJson(await _call('GET', '/${diaryDate(date)}/workspace'));
  @override
  Future<DiaryDay> save(
    DiaryDay base,
    List<DiaryMoment> events,
    String note,
    String mutationId,
  ) async => DiaryDay.fromJson(
    await _call(
      'PUT',
      '/${diaryDate(base.date)}/workspace',
      body: {
        'timezone': _timezone(),
        'revision': base.revision,
        'mutationId': mutationId,
        'note': note,
        'events': events
            .map(
              (e) => {
                ...e.json,
                'occurredAt': e.time?.toUtc().toIso8601String(),
              },
            )
            .toList(),
      },
    ),
  );
  @override
  Future<List<DiaryTracker>> catalog() async =>
      ((await _call('GET', '/catalog'))['items'] as List)
          .map((e) => DiaryTracker(Map<String, dynamic>.from(e as Map)))
          .toList();
  @override
  Future<void> saveCatalog(List<DiaryTracker> entries) async {
    await _call(
      'PUT',
      '/catalog',
      body: {
        'items': entries
            .asMap()
            .entries
            .map(
              (e) => {
                'key': e.value.key,
                'enabled': e.value.enabled,
                'displayOrder': e.key,
              },
            )
            .toList(),
      },
    );
  }

  @override
  Future<DiaryTracker> createTracker(
    String name,
    String kind,
    String unit,
  ) async => DiaryTracker(
    await _call(
      'POST',
      '/catalog/custom',
      body: {'label': name, 'kind': kind, 'unit': unit},
    ),
  );
  @override
  Future<List<DiaryMoment>> parse(
    String text,
    DateTime date,
    String locale, {
    bool voice = false,
  }) async {
    final data = await _call(
      'POST',
      '/events/parse',
      body: {
        'text': text,
        'date': diaryDate(date),
        'timezone': _timezone(),
        'locale': locale,
        'inputMethod': voice ? 'voice' : 'text',
      },
    );
    return (data['events'] as List? ?? [])
        .map(
          (e) => DiaryMoment({
            'id': diaryId(),
            ...Map<String, dynamic>.from(e as Map),
          }),
        )
        .toList();
  }

  @override
  Future<Map<String, String>> photo(DateTime date, Uint8List bytes) async =>
      (await _call(
        'POST',
        '/photos',
        body: {'date': diaryDate(date), 'data': base64Encode(bytes)},
      )).cast<String, String>();
  @override
  Future<List<Map<String, dynamic>>> chapters() async =>
      ((await _call('GET', '/chapters'))['items'] as List)
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
  @override
  void dispose() => client.close();
}
