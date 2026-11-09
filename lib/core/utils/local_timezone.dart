import 'package:flutter_timezone/flutter_timezone.dart';

String? _detectedIanaTimezone;
Future<void> initializeLocalTimezone({
  Future<String> Function()? loader,
}) async {
  try {
    final name = loader == null
        ? (await FlutterTimezone.getLocalTimezone()).identifier
        : await loader();
    if (name.trim().contains('/')) _detectedIanaTimezone = name.trim();
  } catch (_) {
    /* Keep the original app's non-fatal startup behavior. */
  }
}

String localIanaTimezone([DateTime? date]) {
  if (_detectedIanaTimezone != null) return _detectedIanaTimezone!;
  final local = date ?? DateTime.now();
  if (local.timeZoneName.contains('/')) return local.timeZoneName;
  return local.timeZoneOffset == const Duration(hours: 8)
      ? 'Asia/Shanghai'
      : 'UTC';
}
