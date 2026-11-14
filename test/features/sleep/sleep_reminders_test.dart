import 'package:flutter_test/flutter_test.dart';
import 'package:new_jcvital/features/sleep/application/sleep_reminders.dart';
import 'package:timezone/data/latest.dart' as data;
import 'package:timezone/timezone.dart' as tz;

void main() {
  test('a Monday reminder before midnight belongs to Sunday', () {
    expect(SleepReminders.reminderSlot(15, 30, 1), (weekday: 0, minute: 1425));
    expect(SleepReminders.reminderSlot(15, 0, 1), (weekday: 1, minute: 15));
    expect(SleepReminders.reminderSlot(0, 15, 0), (weekday: 6, minute: 1425));
  });
  test('weekly scheduling preserves wall clock time across DST', () {
    data.initializeTimeZones();
    final location = tz.getLocation('America/New_York');
    final at = SleepReminders.nextOccurrence(
      location,
      tz.TZDateTime(location, 2026, 3, 7, 18),
      0,
      450,
    );
    expect(at.year, 2026);
    expect(at.month, 3);
    expect(at.day, 8);
    expect(at.hour, 7);
    expect(at.minute, 30);
    final next = SleepReminders.nextOccurrence(location, at, 0, 450);
    expect(next.day, 15);
    expect(next.hour, 7);
  });
}
