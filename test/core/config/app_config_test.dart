import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_jcvital/core/config/app_config.dart';
import 'package:new_jcvital/core/config/app_config_loader.dart';
import 'package:new_jcvital/core/network/api_client.dart';
import 'package:new_jcvital/core/network/api_endpoints.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('默认配置保留 JCVital 后端、应用身份和关闭演示的约定', () {
    final config = AppConfig.resolve();
    expect(config.apiBaseUrl.toString(), 'https://api.byndhealth.com.br');
    expect(
      config.apiV1BaseUrl.toString(),
      'https://api.byndhealth.com.br/api/v1',
    );
    expect(AppConfig.applicationId, 'com.byndhealth.app');
    expect(config.deviceDemo, isFalse);
    expect(config.demoData, isFalse);
    expect(config.connectTimeout, const Duration(seconds: 15));
    expect(config.receiveTimeout, const Duration(seconds: 30));
    expect(config.revenueCatEntitlementId, 'premium');
    expect(config.googleWebClientId, AppConfig.defaultGoogleWebClientId);
  });
  test('构建参数优先于本地配置，保留旧 MAPA 演示开关', () {
    final config = AppConfig.resolve(
      defines: {
        'DEVICE_DEMO': 'false',
        'API_BASE_URL': 'https://api.byndhealth.com.br',
      },
      values: {'DEVICE_DEMO': 'true', 'API_BASE_URL': 'http://localhost:8081'},
    );
    expect(config.deviceDemo, isFalse);
    expect(config.apiBaseUrl.host, 'api.byndhealth.com.br');
    expect(
      AppConfig.resolve(values: {'MAPA_USE_DEMO_DATA': '1'}).deviceDemo,
      isTrue,
    );
    expect(
      AppConfig.resolve(
        defines: {'MAPA_USE_DEMO_DATA': 'false'},
        values: {'MAPA_USE_DEMO_DATA': 'true'},
      ).deviceDemo,
      isFalse,
    );
  });
  test('生产配置拒绝 HTTP、模拟数据与无效基础参数', () {
    for (final values in [
      {'APP_ENV': 'production', 'API_BASE_URL': 'http://localhost:8081'},
      {'APP_ENV': 'production', 'DEVICE_DEMO': 'true'},
      {'APP_ENV': 'production', 'MAPA_USE_DEMO_DATA': 'true'},
      {'API_BASE_URL': 'https://user:password@example.org'},
      {'API_BASE_URL': 'https://example.org?access_token=invalid'},
      {'APP_ENV': 'unknown'},
      {'DEVICE_DEMO': 'maybe'},
      {'API_CONNECT_TIMEOUT_SECONDS': '0'},
    ]) {
      expect(() => AppConfig.resolve(defines: values), throwsFormatException);
    }
    expect(
      AppConfig.resolve(releaseMode: true).environment,
      AppEnvironment.production,
    );
    expect(
      AppConfig.resolve(
        defines: {'APP_ENV': 'production', 'ENABLE_NETWORK_LOGS': 'true'},
      ).enableNetworkLogs,
      isFalse,
    );
  });
  test('全部环境文件保持原后端，只有演示配置启用模拟数据', () {
    for (final name in ['dev', 'test', 'prod', 'demo']) {
      final file =
          (jsonDecode(File('config/$name.json').readAsStringSync()) as Map).map(
            (key, value) => MapEntry(key.toString(), value.toString()),
          );
      final config = AppConfig.resolve(defines: file);
      expect(config.apiBaseUrl.host, 'api.byndhealth.com.br');
      expect(config.deviceDemo, name == 'demo');
    }
  });
  test('原 API 常量和带前缀地址不会造成重复 api/v1', () {
    for (final base in [
      'https://api.byndhealth.com.br',
      'https://api.byndhealth.com.br/api/v1/',
    ]) {
      final config = AppConfig.resolve(defines: {'API_BASE_URL': base});
      final client = ApiClient(
        baseUrl: config.apiV1BaseUrl,
        tokenProvider: () async => null,
      );
      addTearDown(client.close);
      expect(
        client.endpoint('/me/devices').toString(),
        'https://api.byndhealth.com.br/api/v1/me/devices',
      );
      expect(
        client.endpoint(ApiEndpoints.deviceList).toString(),
        'https://api.byndhealth.com.br/api/v1/me/devices',
      );
      expect(
        () => client.endpoint('https://another.example/me/devices'),
        throwsArgumentError,
      );
    }
  });
  test('可选本地环境文件缺失不会阻止启动', () async {
    final previous = AppConfig.current;
    addTearDown(() => AppConfig.configure(previous));
    final config = await AppConfigLoader.load();
    expect(config.apiBaseUrl.host, 'api.byndhealth.com.br');
    final assets = (await AssetManifest.loadFromAssetBundle(
      rootBundle,
    )).listAssets();
    expect(assets, contains('assets/config/.env.example'));
    if (assets.contains('assets/config/.env')) {
      final local = await rootBundle.loadString('assets/config/.env');
      expect(
        RegExp(
          r'^ARK_(API_KEY|BASE_URL|MODEL)\s*=',
          multiLine: true,
        ).hasMatch(local),
        isFalse,
      );
    }
  });
}
