import 'dart:math' as math;
import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../../../core/auth/auth_session.dart';
import '../../../core/network/api_client.dart';
import '../../../core/utils/local_timezone.dart';
import '../../device/domain/device_models.dart';
import '../data/heart_band_gateway.dart';
import '../domain/heart_models.dart';
import '../domain/heart_rate_sample_upload.dart';
import '../domain/heart_vital_history.dart';

class HeartHistorySync {
  HeartHistorySync(this.client, this.gateway, {AuthSession? session})
    : session = session ?? AuthSession.instance;
  final ApiClient client;
  final HeartBandGateway gateway;
  final AuthSession session;
  bool _busy = false;
  Future<int> sync(DeviceSnapshot device) async {
    if (_busy) throw const ApiException('Sync in progress', code: 'busy');
    final token = session.accessToken;
    if (token == null) {
      throw const ApiException(
        'Sign in to sync',
        code: 'authentication_required',
      );
    }
    _busy = true;
    void check() {
      if (token != session.accessToken) {
        throw const ApiException('Account changed', code: 'account_changed');
      }
    }

    try {
      final data = await gateway.readHistory(device);
      check();
      final history = heartMap(data['history']);
      final samples = heartRateSamplesFromHistory({
        for (final e in history.entries) e.key: heartMaps(e.value),
      });
      var written = 0;
      for (var start = 0; start < samples.length; start += 500) {
        check();
        final batch = samples.sublist(
          start,
          math.min(start + 500, samples.length),
        );
        final r = await client.request(
          'POST',
          '/me/heart-rate/samples',
          expectedAccessToken: token,
          body: HeartRateSampleUploadCommand(
            timezone: localIanaTimezone(),
            deviceSerial: device.serialNumber,
            deviceId: device.id,
            samples: batch,
          ).toJson(),
        );
        check();
        written += (r['accepted'] as num? ?? 0).round();
        if ((r['filtered'] as num? ?? 0) > 0) {
          throw const ApiException(
            'Some samples were rejected',
            code: 'partial_sync',
          );
        }
      }
      // Keep a complete day's ancillary samples together: the existing health
      // batch service materializes a daily mean from the submitted facts.
      for (final group in heartVitalsFromHistory(history).values) {
        check();
        if (group.length > 5000) {
          throw const ApiException(
            'Too many vital samples in one day',
            code: 'vital_batch_too_large',
          );
        }
        final fingerprint = sha256.convert(
          utf8.encode(
            jsonEncode([device.serialNumber, localIanaTimezone(), group]),
          ),
        );
        final r = await client.request(
          'POST',
          '/me/health-data/batches',
          expectedAccessToken: token,
          body: {
            'clientBatchId': 'heart-vitals-$fingerprint',
            'deviceId': device.id,
            'deviceSerial': device.serialNumber,
            'timezone': localIanaTimezone(),
            'source': 'device',
            'records': group,
          },
        );
        check();
        if ((r['rejectedCount'] as num? ?? 0) > 0) {
          throw const ApiException(
            'Some vital samples were rejected',
            code: 'partial_sync',
          );
        }
      }
      return written;
    } finally {
      _busy = false;
    }
  }
}
