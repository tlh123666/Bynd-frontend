import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

/// 一个不联网的 http 客户端。
///
/// 用官方 `MockClient` 而不是 mock 库：能覆盖 ApiClient 真正的请求构造
/// （头、query、body），不引入额外依赖，测试与生产走同一套代码路径。
///
/// [requests] 记录所有经过的请求，便于断言「到底发了什么」。
class FakeHttpClient {
  FakeHttpClient(this._handler);

  final Future<http.Response> Function(http.Request request) _handler;
  final List<http.Request> requests = [];

  http.Client get client => MockClient((request) {
    requests.add(request);
    return _handler(request);
  });

  http.Request get lastRequest => requests.last;
}

/// 构造 JSON 响应体。
///
/// 一律走 bytes：`http.Response(String)` 在未显式声明 charset 时按 latin1
/// 编码，中文错误文案会变成乱码，断言就永远对不上。
http.Response jsonResponse(Object? body, {int statusCode = 200}) {
  final text = body is String ? body : jsonEncode(body);
  return http.Response.bytes(
    utf8.encode(text),
    statusCode,
    headers: {'content-type': 'application/json; charset=utf-8'},
  );
}

/// 后端成功响应：`{code:200,msg:"OK",data:...}`。
http.Response okResponse(Object? data) =>
    jsonResponse({'code': 200, 'msg': 'OK', 'data': data});

/// 后端业务失败：HTTP 200 但 code 非 200。
http.Response businessErrorResponse(int code, String msg) =>
    jsonResponse({'code': code, 'msg': msg, 'data': null});

/// 鉴权失败：HTTP 401 + 业务码。
http.Response unauthorizedResponse({
  int code = 100003,
  String msg = 'token 失效，请重新登录',
}) => jsonResponse({'code': code, 'msg': msg}, statusCode: 401);
