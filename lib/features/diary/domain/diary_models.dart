import 'dart:math';
import 'dart:typed_data';
import 'diary_catalog_policy.dart';

String diaryCanonicalKey(String key) => DiaryCatalogPolicy.aliases[key] ?? key;

List<DiaryTracker> diaryDisplayCatalog(List<DiaryTracker> items) {
  final enabled = items
      .where((t) => t.enabled)
      .map((t) => diaryCanonicalKey(t.key))
      .toSet();
  return items
      .map(
        (t) => t.enable(
          t.key == diaryCanonicalKey(t.key) && enabled.contains(t.key),
        ),
      )
      .toList();
}

String diaryDate(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
String diaryId() {
  final r = Random.secure();
  final b = List.generate(16, (_) => r.nextInt(256));
  b[6] = (b[6] & 15) | 64;
  b[8] = (b[8] & 63) | 128;
  final h = b.map((v) => v.toRadixString(16).padLeft(2, '0')).join();
  return '${h.substring(0, 8)}-${h.substring(8, 12)}-${h.substring(12, 16)}-${h.substring(16, 20)}-${h.substring(20)}';
}

class DiaryTracker {
  const DiaryTracker(this.json);
  final Map<String, dynamic> json;
  String get key => json['key'] as String;
  String get label => json['label'] as String;
  String get prompt => json['prompt'] as String? ?? label;
  String get kind => json['kind'] as String? ?? 'boolean';
  String get icon => json['icon'] as String? ?? 'ok';
  String get group =>
      DiaryCatalogPolicy.groups[key] ??
      json['group'] as String? ??
      'Seus hábitos';
  String get category => json['category'] as String? ?? 'custom';
  String get unit => json['unit'] as String? ?? '';
  bool get meal => json['meal'] == true || kind == 'meal';
  bool get enabled => json['enabled'] == true;
  bool get diaryHabit =>
      key == diaryCanonicalKey(key) &&
      !meal &&
      group != 'Alimentação' &&
      group != 'Bebidas' &&
      key != 'gripe';
  List<double> get values => (json['values'] as List? ?? [])
      .whereType<num>()
      .map((e) => e.toDouble())
      .toList();
  List<String> get timeValues =>
      (json['values'] as List? ?? []).whereType<String>().toList();
  List<String> get scaleLabels =>
      (json['scaleLabels'] as List? ?? []).cast<String>();
  DiaryTracker enable(bool enabled) =>
      DiaryTracker({...json, 'enabled': enabled});
}

class DiaryMoment {
  const DiaryMoment(this.json, {this.automatic = false});
  final Map<String, dynamic> json;
  final bool automatic;
  String get id => json['id'] as String;
  String get key => json['valueKey'] as String? ?? '';
  String get label => json['label'] as String? ?? '';
  String get note => json['note'] as String? ?? '';
  Map<String, dynamic> get details =>
      (json['details'] as Map?)?.cast<String, dynamic>() ?? {};
  String get icon => details['icon'] as String? ?? 'nota';
  String get kind => details['kind'] as String? ?? 'boolean';
  bool get happened => details['answer'] != false;
  double? get value => (json['numericValue'] as num?)?.toDouble();
  String get unit => json['unit'] as String? ?? '';
  DateTime? get time => DateTime.tryParse('${json['occurredAt']}')?.toLocal();
  String get timeLabel => time == null
      ? ''
      : '${time!.hour.toString().padLeft(2, '0')}:${time!.minute.toString().padLeft(2, '0')}';
  String get valueLabel {
    if (!happened) return 'Não aconteceu';
    if (kind == 'quantity' && value == null) return timeLabel;
    if (kind == 'meal') {
      return details['calories'] == null
          ? note
          : '${number(details['calories'] as num)} kcal';
    }
    if (value != null) {
      return '${number(value!)} ${kind == 'scale' ? '/ 10' : unit}';
    }
    return automatic ? note : 'Feito';
  }

  DiaryMoment copy(Map<String, dynamic> patch) =>
      DiaryMoment({...json, ...patch}, automatic: automatic);
  static String number(num v) =>
      v == v.roundToDouble() ? v.toInt().toString() : v.toString();
  factory DiaryMoment.forTracker(DiaryTracker t, DateTime date) {
    final now = DateTime.now();
    final hh = '${t.json['defaultTime'] ?? t.timeValues.firstOrNull ?? ''}'
        .split(':');
    final time = DateTime(
      date.year,
      date.month,
      date.day,
      hh.length == 2 ? int.parse(hh[0]) : now.hour,
      hh.length == 2 ? int.parse(hh[1]) : now.minute,
    );
    return DiaryMoment({
      'id': diaryId(),
      'valueKey': t.key,
      'category': t.category,
      'label': t.label,
      'note': '',
      'occurredAt': time.toIso8601String(),
      'inputMethod': 'quick',
      'unit': t.unit,
      'details': {'icon': t.icon, 'kind': t.kind},
      if (t.kind == 'scale') 'numericValue': 5,
      if (t.kind == 'quantity' && t.timeValues.isEmpty)
        'numericValue': t.values.isEmpty ? 1 : t.values.first,
    });
  }
}

class DiaryDay {
  const DiaryDay({
    required this.date,
    required this.events,
    this.automatic = const [],
    this.note = '',
    this.revision = 0,
    this.editable = true,
  });
  final DateTime date;
  final List<DiaryMoment> events, automatic;
  final String note;
  final int revision;
  final bool editable;
  List<DiaryMoment> get timeline =>
      [...events, ...automatic]
        ..sort((a, b) => (a.time ?? date).compareTo(b.time ?? date));
  factory DiaryDay.fromJson(Map<String, dynamic> j) => DiaryDay(
    date: DateTime.parse(j['date'] as String),
    events: (j['events'] as List? ?? [])
        .map((v) => DiaryMoment(Map<String, dynamic>.from(v as Map)))
        .toList(),
    automatic: (j['automatic'] as List? ?? [])
        .map(
          (v) =>
              DiaryMoment(Map<String, dynamic>.from(v as Map), automatic: true),
        )
        .toList(),
    note: j['note'] as String? ?? '',
    revision: (j['revision'] as num?)?.toInt() ?? 0,
    editable: j['editable'] != false,
  );
  Map<String, dynamic> toJson() => {
    'date': diaryDate(date),
    'events': events.map((v) => v.json).toList(),
    'automatic': automatic.map((v) => v.json).toList(),
    'note': note,
    'revision': revision,
    'editable': editable,
  };
}

abstract interface class DiaryRepository {
  Future<DiaryDay> load(DateTime date);
  Future<DiaryDay> save(
    DiaryDay base,
    List<DiaryMoment> events,
    String note,
    String mutationId,
  );
  Future<List<DiaryTracker>> catalog();
  Future<void> saveCatalog(List<DiaryTracker> entries);
  Future<DiaryTracker> createTracker(String name, String kind, String unit);
  Future<List<DiaryMoment>> parse(
    String text,
    DateTime date,
    String locale, {
    bool voice = false,
  });
  Future<Map<String, String>> photo(DateTime date, Uint8List bytes);
  Future<List<Map<String, dynamic>>> chapters();
  void dispose();
}
