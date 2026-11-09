import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:new_jcvital/core/network/api_client.dart';
import 'package:new_jcvital/features/device/data/device_store.dart';
import 'package:new_jcvital/features/device/data/remote_device_repository.dart';
import 'package:new_jcvital/features/device/domain/device_models.dart';

void main() {
  test('未登录和过期会话会返回明确错误', () async {
    var requests = 0;
    final api = ApiClient(
      baseUrl: Uri.parse('https://example.org/api/v1'),
      tokenProvider: () async => null,
      client: MockClient((r) async {
        requests++;
        return http.Response('{}', 401);
      }),
    );
    addTearDown(api.close);
    await expectLater(
      api.request('GET', '/me/devices'),
      throwsA(
        isA<ApiException>().having(
          (e) => e.code,
          'code',
          'authentication_required',
        ),
      ),
    );
    expect(requests, 0);
    final expired = ApiClient(
      baseUrl: Uri.parse('https://example.org/api/v1'),
      tokenProvider: () async => 'test-token',
      client: MockClient((r) async => http.Response('{}', 401)),
    );
    addTearDown(expired.close);
    await expectLater(
      expired.request('GET', '/me/devices'),
      throwsA(
        isA<ApiException>().having(
          (e) => e.code,
          'code',
          'authentication_required',
        ),
      ),
    );
  });
  test('未发送成功的硬件回执刷新时重发，物理命令不会重放', () async {
    final store = MemoryDeviceStore();
    final paths = <String>[];
    var failReceipt = true;
    ApiClient makeApi() => ApiClient(
      baseUrl: Uri.parse('https://example.org/api/v1'),
      tokenProvider: () async => 'test-token',
      client: MockClient((request) async {
        expect(request.headers['Authorization'], 'Bearer test-token');
        paths.add('${request.method} ${request.url.path}');
        if (request.method == 'PATCH') {
          return failReceipt
              ? http.Response('{"code":500}', 500)
              : http.Response('{"code":0,"data":{}}', 200);
        }
        return http.Response(
          jsonEncode({
            'code': 0,
            'data': {'items': []},
          }),
          200,
        );
      }),
    );
    final first = RemoteDeviceRepository(makeApi(), store);
    const operation = DeviceOperation(
      id: 'operation-id',
      type: DeviceOperationType.restart,
      status: 'pending',
    );
    await expectLater(
      first.finishOperation(
        DeviceSnapshot.reference(),
        operation,
        succeeded: true,
      ),
      throwsA(isA<ApiException>()),
    );
    first.close();
    failReceipt = false;
    final second = RemoteDeviceRepository(makeApi(), store);
    addTearDown(second.close);
    expect(await second.restore(), isNull);
    expect(paths.where((path) => path.startsWith('PATCH')).length, 2);
    expect(paths.where((path) => path.startsWith('POST')), isEmpty);
    expect(jsonDecode(store.values['bynd.device.receipts.v1']!), isEmpty);
  });
}
