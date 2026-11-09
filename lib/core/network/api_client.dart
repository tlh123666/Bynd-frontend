import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../auth/auth_session.dart';
import '../config/app_config.dart';
import '../localization/app_locale_controller.dart';

class ApiException implements Exception {
  const ApiException(this.message, {this.code = 'api_error'});
  final String message;
  final String code;
  @override
  String toString() => message;
}

class ApiClient {
  ApiClient({
    required this.baseUrl,
    required this.tokenProvider,
    this.connectTimeout = const Duration(seconds: 15),
    this.receiveTimeout = const Duration(seconds: 30),
    this.onUnauthorized,
    this.enableLogging = false,
    String Function()? localeProvider,
    http.Client? client,
  }) : _client = client ?? http.Client(),
       _localeProvider = localeProvider ?? (() => 'pt-BR');

  factory ApiClient.configured({
    AppConfig? config,
    AuthSession? session,
    AppLocaleController? locale,
    Future<String?> Function()? tokenProvider,
    http.Client? client,
  }) {
    final settings = config ?? AppConfig.current;
    final auth = session ?? AuthSession.instance;
    final language = locale ?? AppLocaleController.instance;
    return ApiClient(
      baseUrl: settings.apiV1BaseUrl,
      tokenProvider: tokenProvider ?? () async => auth.accessToken,
      connectTimeout: settings.connectTimeout,
      receiveTimeout: settings.receiveTimeout,
      localeProvider: () => language.acceptLanguage,
      onUnauthorized: tokenProvider == null ? auth.invalidate : null,
      enableLogging: settings.enableNetworkLogs,
      client: client,
    );
  }
  final Uri baseUrl;
  final Future<String?> Function() tokenProvider;
  final Duration connectTimeout;
  final Duration receiveTimeout;
  final Future<void> Function(String rejectedToken)? onUnauthorized;
  final bool enableLogging;
  final String Function() _localeProvider;
  final http.Client _client;

  Uri endpoint(String path, {Map<String, String>? queryParameters}) {
    final relative = Uri.parse(path);
    if (relative.hasScheme || relative.hasAuthority || relative.hasFragment) {
      throw ArgumentError(
        'API paths must be relative to the configured backend',
      );
    }
    var suffix = path.startsWith('/') ? path : '/$path';
    if (baseUrl.path.replaceFirst(RegExp(r'/+$'), '').endsWith('/api/v1')) {
      suffix = suffix.replaceFirst(RegExp(r'^/api/v1(?=/|\?|$)'), '');
    }
    final uri = Uri.parse(
      '${baseUrl.toString().replaceFirst(RegExp(r'/+$'), '')}$suffix',
    );
    return queryParameters == null
        ? uri
        : uri.replace(
            queryParameters: {...uri.queryParameters, ...queryParameters},
          );
  }

  Future<Map<String, dynamic>> request(
    String method,
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParameters,
    bool requiresAuth = true,
  }) async {
    final token = requiresAuth ? await tokenProvider() : null;
    if (requiresAuth && (token == null || token.isEmpty)) {
      throw const ApiException(
        'Entre na sua conta para gerenciar a pulseira.',
        code: 'authentication_required',
      );
    }
    final url = endpoint(path, queryParameters: queryParameters);
    try {
      final request = http.Request(method, url)
        ..headers.addAll({
          if (token != null) 'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Accept-Language': _localeProvider(),
        });
      if (body != null) request.body = jsonEncode(body);
      final response = await http.Response.fromStream(
        await _client.send(request).timeout(connectTimeout),
      ).timeout(receiveTimeout);
      if (kDebugMode && enableLogging) {
        debugPrint('[BYND HTTP] $method ${url.path} -> ${response.statusCode}');
      }
      if (response.statusCode == 401) {
        if (token != null && onUnauthorized != null) {
          try {
            await onUnauthorized!(token);
          } catch (_) {
            /* Preserve the original authentication error. */
          }
        }
        throw const ApiException(
          'Sua sessão expirou. Entre novamente.',
          code: 'authentication_required',
        );
      }
      final envelope =
          jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      if (response.statusCode < 200 ||
          response.statusCode >= 300 ||
          (envelope['code'] != null &&
              envelope['code'] != 0 &&
              envelope['code'] != 200)) {
        throw ApiException(
          response.statusCode == 409
              ? 'A pulseira ou esta operação mudou. Atualize e tente novamente.'
              : response.statusCode == 404
              ? 'Esta pulseira não está mais vinculada à sua conta.'
              : 'Não foi possível concluir. Tente novamente.',
          code: 'http_${response.statusCode}',
        );
      }
      return (envelope['data'] as Map?)?.cast<String, dynamic>() ??
          <String, dynamic>{};
    } on ApiException {
      rethrow;
    } on TimeoutException {
      throw const ApiException(
        'O servidor demorou para responder. Tente novamente.',
        code: 'request_timeout',
      );
    } on FormatException {
      throw const ApiException(
        'A resposta do servidor não pôde ser lida.',
        code: 'invalid_response',
      );
    } catch (_) {
      throw const ApiException(
        'Sem conexão com o servidor. Tente novamente.',
        code: 'network_error',
      );
    }
  }

  void close() => _client.close();
}
