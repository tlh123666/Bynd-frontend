import 'dart:convert';
import 'package:http/http.dart' as http;

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
    http.Client? client,
  }) : _client = client ?? http.Client();
  final Uri baseUrl;
  final Future<String?> Function() tokenProvider;
  final http.Client _client;

  Future<Map<String, dynamic>> request(
    String method,
    String path, {
    Map<String, dynamic>? body,
  }) async {
    final token = await tokenProvider();
    if (token == null || token.isEmpty) {
      throw const ApiException(
        'Entre na sua conta para gerenciar a pulseira.',
        code: 'authentication_required',
      );
    }
    final url = Uri.parse(
      '${baseUrl.toString().replaceAll(RegExp(r'/$'), '')}$path',
    );
    try {
      final request = http.Request(method, url)
        ..headers.addAll({
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        });
      if (body != null) request.body = jsonEncode(body);
      final response = await http.Response.fromStream(
        await _client.send(request).timeout(const Duration(seconds: 20)),
      ).timeout(const Duration(seconds: 20));
      if (response.statusCode == 401) {
        throw const ApiException(
          'Sua sessão expirou. Entre novamente.',
          code: 'authentication_required',
        );
      }
      final envelope = jsonDecode(response.body) as Map<String, dynamic>;
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
    } catch (_) {
      throw const ApiException(
        'Sem conexão com o servidor. Tente novamente.',
        code: 'network_error',
      );
    }
  }

  void close() => _client.close();
}
