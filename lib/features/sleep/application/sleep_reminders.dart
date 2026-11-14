import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Native bedtime reminders use the same ID range as JCVital so upgrading the
/// installed app replaces old schedules. Only this range is ever cancelled.
class SleepReminders {
  SleepReminders._();
  static final instance = SleepReminders._();
  final _plugin = FlutterLocalNotificationsPlugin();
  Future<void>? _initialization;
  Future<void> _pending = Future.value();
  int _revision = 0;
  bool get supported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);
  Future<void> _initialize() => _initialization ??= () async {
    tz_data.initializeTimeZones();
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('ic_stat_sleep'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
    );
  }();
  Future<bool> requestPermission() async {
    if (!supported) return false;
    await _initialize();
    final android = await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
    final ios = await _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: false, sound: true);
    return android ?? ios ?? false;
  }

  Future<void> _serialize(Future<void> Function() work) {
    final f = _pending.then((_) => work());
    _pending = f.catchError((Object _) {});
    return f;
  }

  Future<void> clear() {
    final revision = ++_revision;
    return _serialize(() async {
      if (!supported || revision != _revision) return;
      await _initialize();
      await _cancel();
    });
  }

  Future<void> _cancel() async {
    for (var id = 43000; id < 43035; id++) {
      await _plugin.cancel(id: id);
    }
  }

  Future<void> apply(
    List<Map<String, dynamic>> plans, {
    required bool portuguese,
  }) {
    final revision = ++_revision;
    return _serialize(() async {
      if (!supported || revision != _revision) return;
      await _initialize();
      await _cancel();
      for (var index = 0; index < plans.length && index < 5; index++) {
        final p = plans[index];
        if (p['enabled'] != true) continue;
        final location = tz.getLocation('${p['timezone']}');
        final minute =
            (p['bedtimeHour'] as num).toInt() * 60 +
            (p['bedtimeMinute'] as num).toInt();
        final lead = (p['remindBeforeMinutes'] as num?)?.toInt() ?? 0;
        for (var day = 0; day < 7; day++) {
          if (revision != _revision) return;
          if (((p['week'] as num).toInt() & (1 << day)) == 0) continue;
          final slot = reminderSlot(minute, lead, day);
          final when = nextOccurrence(
            location,
            tz.TZDateTime.now(location),
            slot.weekday,
            slot.minute,
          );
          await _plugin.zonedSchedule(
            id: 43000 + index * 7 + day,
            title: '${p['title'] ?? ''}'.trim().isNotEmpty
                ? '${p['title']}'
                : portuguese
                ? 'Hora de desacelerar'
                : 'Time to wind down',
            body: '${p['body'] ?? ''}'.trim().isNotEmpty
                ? '${p['body']}'
                : portuguese
                ? 'Seu horário de dormir está chegando.'
                : 'Your bedtime is coming up.',
            scheduledDate: when,
            notificationDetails: const NotificationDetails(
              android: AndroidNotificationDetails(
                'sleep_schedule',
                'Sleep reminders',
                channelDescription: 'Bedtime reminders',
                importance: Importance.high,
                priority: Priority.high,
                icon: 'ic_stat_sleep',
              ),
              iOS: DarwinNotificationDetails(),
            ),
            androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
            matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
            payload: 'sleep-plan:${p['id']}',
          );
        }
      }
    });
  }

  @visibleForTesting
  static ({int weekday, int minute}) reminderSlot(
    int bedtime,
    int lead,
    int weekday,
  ) {
    final total = bedtime - lead;
    return (
      weekday:
          (weekday +
              (total ~/ 1440) -
              (total < 0 && total % 1440 != 0 ? 1 : 0) +
              7) %
          7,
      minute: (total % 1440 + 1440) % 1440,
    );
  }

  @visibleForTesting
  static tz.TZDateTime nextOccurrence(
    tz.Location location,
    tz.TZDateTime now,
    int weekday,
    int minute,
  ) {
    final dartDay = weekday == 0 ? 7 : weekday,
        offset = (dartDay - now.weekday + 7) % 7;
    var at = tz.TZDateTime(
      location,
      now.year,
      now.month,
      now.day + offset,
      minute ~/ 60,
      minute % 60,
    );
    if (!at.isAfter(now)) {
      at = tz.TZDateTime(
        location,
        now.year,
        now.month,
        now.day + offset + 7,
        minute ~/ 60,
        minute % 60,
      );
    }
    return at;
  }
}
