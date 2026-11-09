/// 解析后端 JSON 的取值辅助。
///
/// 存在的理由：后端字段大量是 `*string` / `*float64`（omitempty），
/// 同一字段有时不出现、有时是 null、有时是数字被 JSON 序列化成字符串。
/// 如果在每个模型里手写 `json['x'] as String?`，一个类型不符就整页崩掉，
/// 而且崩的位置离原因很远。这里统一做「取不到就退到默认值」，
/// 只有真正必需的值才用 [_required*] 抛错。
library;

String readString(Map<String, dynamic> json, String key, {String fallback = ''}) {
  final value = json[key];
  if (value is String) return value;
  if (value == null) return fallback;
  return value.toString();
}

String? readNullableString(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is String) return value.isEmpty ? null : value;
  return value?.toString();
}

/// 缺失或为空时返回 [fallback]。
String readNonEmptyString(
  Map<String, dynamic> json,
  String key, {
  required String fallback,
}) {
  final value = readNullableString(json, key);
  return value ?? fallback;
}

int readInt(Map<String, dynamic> json, String key, {int fallback = 0}) {
  final value = json[key];
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? fallback;
  return fallback;
}

int? readNullableInt(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

double readDouble(Map<String, dynamic> json, String key, {double fallback = 0}) {
  final value = json[key];
  if (value is double) return value;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? fallback;
  return fallback;
}

double? readNullableDouble(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is double) return value;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

bool readBool(Map<String, dynamic> json, String key, {bool fallback = false}) {
  final value = json[key];
  if (value is bool) return value;
  if (value == null) return fallback;
  if (value is String) return value == 'true' || value == '1';
  if (value is num) return value != 0;
  return fallback;
}

List<String> readStringList(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! List) return const [];
  return value.whereType<String>().toList(growable: false);
}

Map<String, dynamic>? readMap(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return value.cast<String, dynamic>();
  return null;
}

/// 解析数组字段。元素不是对象时跳过而不是整体失败——
/// 一条脏数据不该让整页空白。
List<T> readObjectList<T>(
  Map<String, dynamic> json,
  String key,
  T Function(Map<String, dynamic> item) mapper,
) {
  final value = json[key];
  if (value is! List) return const [];
  final items = <T>[];
  for (final raw in value) {
    if (raw is Map<String, dynamic>) {
      items.add(mapper(raw));
    } else if (raw is Map) {
      items.add(mapper(raw.cast<String, dynamic>()));
    }
  }
  return items;
}

/// 必需字段缺失时抛 [FormatException]。
///
/// 只用于「没有它这条数据就没有意义」的字段（例如洞察 id、登录令牌）。
/// 其余字段一律退到默认值：后端加字段、改可空性时，客户端应该还能跑。
String requireString(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is String && value.isNotEmpty) return value;
  throw FormatException('campo obrigatório "$key" ausente ou vazio');
}
