import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/network/api_client.dart';
import '../domain/diary_models.dart';

/// Reference fixtures are available only when DEMO_DATA is explicitly enabled.
class DemoDiaryRepository implements DiaryRepository {
  DemoDiaryRepository({DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;
  final DateTime Function() _clock;
  static const _prefix = 'bynd.diary.demo.v1.';
  Future<List<DiaryTracker>>? _catalog;
  @override
  Future<List<DiaryTracker>> catalog() => _catalog ??= _readCatalog();
  Future<List<DiaryTracker>> _readCatalog() async {
    final prefs = await SharedPreferences.getInstance();
    final raw =
        prefs.getString('${_prefix}catalog') ??
        await rootBundle.loadString('assets/data/diary-catalog.json');
    return (jsonDecode(raw) as List)
        .map((e) => DiaryTracker(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  @override
  Future<void> saveCatalog(List<DiaryTracker> entries) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(
      '${_prefix}catalog',
      jsonEncode(entries.map((e) => e.json).toList()),
    );
    _catalog = Future.value(entries);
  }

  @override
  Future<DiaryTracker> createTracker(
    String name,
    String kind,
    String unit,
  ) async {
    final t = DiaryTracker({
      'key': 'u_${diaryId()}',
      'label': name,
      'prompt': name,
      'kind': kind,
      'unit': unit,
      'icon': 'ok',
      'group': 'Seus hábitos',
      'category': 'custom',
      'enabled': true,
      'values': List.generate(100, (i) => i + 1),
      'custom': true,
    });
    await saveCatalog([...await catalog(), t]);
    return t;
  }

  @override
  Future<DiaryDay> load(DateTime date) async {
    final p = await SharedPreferences.getInstance();
    final now = _clock();
    final diff = DateTime(
      now.year,
      now.month,
      now.day,
    ).difference(DateTime(date.year, date.month, date.day)).inDays;
    final stored = p.getString('$_prefix${diaryDate(date)}');
    if (stored != null) {
      final j = jsonDecode(stored) as Map<String, dynamic>;
      return DiaryDay.fromJson({...j, 'editable': diff >= 0 && diff <= 7});
    }
    if (diff > 1 || diff < 0) {
      return DiaryDay(
        date: date,
        events: const [],
        editable: diff >= 0 && diff <= 7,
      );
    }
    final samples =
        jsonDecode(await rootBundle.loadString('assets/data/diary-demo.json'))
            as Map<String, dynamic>;
    final source = Map<String, dynamic>.from(
      samples[diff == 0 ? '2026-11-09' : '2026-11-08'] as Map,
    );
    final cat = await catalog();
    final events = <DiaryMoment>[];
    for (final raw in source['reg'] as List) {
      final r = Map<String, dynamic>.from(raw as Map);
      final key = '${r['id']}'.replaceFirst('r-', '');
      final t = cat.where((t) => t.key == key).firstOrNull;
      final h = '${r['h'] ?? '12:00'}'.split(':');
      final at = DateTime(
        date.year,
        date.month,
        date.day,
        int.parse(h[0]),
        int.parse(h[1]),
      );
      final mac = (r['mac'] as Map?) ?? {};
      final response = (source['r'] as Map?)?[key] as Map?;
      final meal = (source['ref'] as Map?)?[key] as Map?;
      events.add(
        DiaryMoment({
          'id': diaryId(),
          'valueKey': key,
          'category': t?.category ?? 'custom',
          'label': r['k'],
          'occurredAt': at.toIso8601String(),
          'note': meal == null
              ? ''
              : (meal['it'] as List? ?? [])
                    .map((v) => (v as List).join(' · '))
                    .join('\n'),
          'unit': t?.unit ?? r['u'] ?? '',
          'inputMethod': 'quick',
          if (response?['q'] is num) 'numericValue': response!['q'],
          if (key == 'whey') 'numericValue': meal?['q'] ?? 1,
          if (t?.kind == 'scale') 'numericValue': response?['v'],
          'details': {
            'icon': r['ic'],
            'kind':
                t?.kind == 'quantity' &&
                    t!.values.isNotEmpty &&
                    response?['q'] == null &&
                    key != 'whey'
                ? 'boolean'
                : t?.kind ?? 'boolean',
            if (mac.isNotEmpty) ...{
              'illustration': mac['tipo'],
              'calories': mac['kc'],
              'protein': mac['p'],
              'carbs': mac['c'],
              'fat': mac['g'],
            },
            if (meal != null) 'portion': meal['t'],
          },
        }),
      );
    }
    final pulse =
        jsonDecode(
              await rootBundle.loadString('assets/data/diary-demo-pulse.json'),
            )
            as Map<String, dynamic>;
    final automatic = (pulse[diff == 0 ? '0' : '-1'] as List? ?? []).map((raw) {
      final r = Map<String, dynamic>.from(raw as Map);
      final h = '${r['h']}'.split(':');
      return DiaryMoment({
        'id': 'demo-pulse-${r['h']}',
        'label': r['k'],
        'occurredAt': DateTime(
          date.year,
          date.month,
          date.day,
          int.parse(h[0]),
          int.parse(h[1]),
        ).toIso8601String(),
        'note': '${r['v']} ${r['u']} · ${r['n']}',
        'details': {'icon': r['ic']},
        'inputMethod': 'device',
      }, automatic: true);
    }).toList();
    return DiaryDay(
      date: date,
      events: events,
      automatic: automatic,
      note: source['nota'] as String? ?? '',
    );
  }

  @override
  Future<DiaryDay> save(
    DiaryDay base,
    List<DiaryMoment> events,
    String note,
    String mutationId,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_prefix${diaryDate(base.date)}';
    final payload = jsonEncode({
      'events': events.map((e) => e.json).toList(),
      'note': note,
    });
    final prior = prefs.getString(key);
    if (prior != null) {
      final j = jsonDecode(prior) as Map<String, dynamic>;
      if (j['mutationId'] == mutationId && j['mutationPayload'] == payload) {
        return load(base.date);
      }
    }
    final current = await load(base.date);
    if (!current.editable || current.revision != base.revision) {
      throw const ApiException(
        'O Diário mudou. Atualize antes de salvar.',
        code: 'http_409',
      );
    }
    final day = DiaryDay(
      date: base.date,
      events: events,
      automatic: base.automatic,
      note: note,
      revision: base.revision + 1,
    );
    final p = await SharedPreferences.getInstance();
    await p.setString(
      '$_prefix${diaryDate(base.date)}',
      jsonEncode({
        ...day.toJson(),
        'mutationId': mutationId,
        'mutationPayload': payload,
      }),
    );
    return day;
  }

  @override
  Future<List<DiaryMoment>> parse(
    String text,
    DateTime date,
    String locale, {
    bool voice = false,
  }) async => [
    DiaryMoment({
      'id': diaryId(),
      'category': 'custom',
      'label': locale.startsWith('en') ? 'Your note' : 'Seu relato',
      'note': text,
      'inputMethod': voice ? 'voice' : 'text',
      'occurredAt': DateTime(
        date.year,
        date.month,
        date.day,
        12,
      ).toIso8601String(),
      'details': {'icon': 'nota'},
    }),
  ];
  @override
  Future<Map<String, String>> photo(DateTime date, Uint8List bytes) async => {
    'photoUrl': 'data:image/jpeg;base64,${base64Encode(bytes)}',
  };
  @override
  Future<List<Map<String, dynamic>>> chapters() async =>
      (jsonDecode(
                await rootBundle.loadString(
                  'assets/data/diary-demo-chapters.json',
                ),
              )
              as List)
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
  @override
  void dispose() {}
}
