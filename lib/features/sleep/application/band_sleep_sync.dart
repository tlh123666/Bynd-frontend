import 'dart:math' as math;
import 'package:flutter/services.dart';
import '../../../core/auth/auth_session.dart';
import '../../../core/network/api_client.dart';
import '../../../core/utils/local_timezone.dart';
import '../../device/domain/device_models.dart';
import '../domain/band_sleep_builder.dart';
import '../domain/sleep_models.dart';

/// Uses the existing verified V8 driver and JCVital's stitching algorithm.
/// Only raw stage facts cross the wire; the server recomputes scores/totals.
class BandSleepSync {
  BandSleepSync(
    this.client, {
    this.channel = const MethodChannel('com.bynd/device_management'),
    AuthSession? session,
    DateTime Function()? clock,
    String Function()? timezone,
  }) : _session = session ?? AuthSession.instance,
       _clock = clock ?? DateTime.now,
       _timezone = timezone ?? localIanaTimezone;
  final ApiClient client;
  final MethodChannel channel;
  final AuthSession _session;
  final DateTime Function() _clock;
  final String Function() _timezone;
  bool _busy = false;
  Future<int> sync(DeviceSnapshot device) async {
    if (_busy) {
      throw const ApiException(
        'Sleep sync is already in progress',
        code: 'sync_busy',
      );
    }
    final token = _session.accessToken;
    if (token == null || device.transportId == null) {
      throw const ApiException(
        'Connect your linked band before syncing',
        code: 'device_not_connected',
      );
    }
    _busy = true;
    void check() {
      if (_session.accessToken != token) {
        throw const ApiException('Account changed', code: 'account_changed');
      }
    }

    try {
      final result = await channel
          .invokeMethod<Map>('readSleepHistory', {
            'deviceId': device.transportId,
            'serialNumber': device.serialNumber,
          })
          .timeout(const Duration(seconds: 120));
      check();
      final history = sleepMap(result?['history']);
      final drafts =
          buildSleepSessions(
                sleepMaps(history['sleep']),
                deviceSerial: device.serialNumber,
              )
              .where(
                (d) =>
                    _clock().toUtc().difference(d.endAt) >=
                    kSleepRecordGapTolerance,
              )
              .toList();
      var written = 0;
      for (var i = 0; i < drafts.length; i += 24) {
        check();
        final batch = drafts.sublist(i, math.min(i + 24, drafts.length));
        final data = await client.request(
          'POST',
          '/me/sleep/sessions',
          body: {
            'deviceId': device.id,
            'deviceSerial': device.serialNumber,
            'timezone': _timezone(),
            'source': 'device',
            'sessions': [
              for (final d in batch)
                {
                  'clientRequestId': d.clientRequestId,
                  'startAt': d.startAt.toUtc().toIso8601String(),
                  'endAt': d.endAt.toUtc().toIso8601String(),
                  'stageIntervalMinutes': d.stageIntervalMinutes,
                  'segments': [
                    for (final segment in d.segments)
                      {
                        'stage': segment.stage.name,
                        'offset': segment.offsetMinutes,
                        'minutes': segment.minutes,
                      },
                  ],
                },
            ],
          },
        );
        check();
        if ((data['filtered'] as num? ?? 0) > 0) {
          throw const ApiException(
            'Some sleep records were rejected. Please sync again.',
            code: 'partial_sleep_sync',
          );
        }
        written +=
            ((data['accepted'] as num? ?? 0) + (data['updated'] as num? ?? 0))
                .toInt();
      }
      return written;
    } finally {
      _busy = false;
    }
  }
}
