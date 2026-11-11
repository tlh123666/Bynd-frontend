enum AppEnvironment { development, testing, production }

/// Application identity and service defaults retained from JCVital.
/// Only public client configuration belongs here or in a bundled .env file.
class AppConfig {
  const AppConfig._({
    required this.environment,
    required this.apiBaseUrl,
    required this.deviceDemo,
    required this.demoData,
    required this.enableNetworkLogs,
    required this.connectTimeout,
    required this.receiveTimeout,
    required this.googleWebClientId,
    required this.googleIosClientId,
    required this.cartoBasemapApiKey,
    required this.cartoAndroidCertSha1,
    required this.revenueCatGoogleApiKey,
    required this.revenueCatAppleApiKey,
    required this.revenueCatEntitlementId,
  });

  static const applicationId = 'com.byndhealth.app';
  static const applicationName = 'ByndHealth';
  static const defaultApiBaseUrl = 'https://api.byndhealth.com.br';
  static const defaultGoogleWebClientId =
      '537472521708-b4tpq2sk0vqo9blj4slanijckc07pd9i.apps.googleusercontent.com';

  static const buildValues = <String, String>{
    'APP_ENV': String.fromEnvironment('APP_ENV'),
    'API_BASE_URL': String.fromEnvironment('API_BASE_URL'),
    'DEVICE_DEMO': String.fromEnvironment('DEVICE_DEMO'),
    'MAPA_USE_DEMO_DATA': String.fromEnvironment('MAPA_USE_DEMO_DATA'),
    'ENABLE_NETWORK_LOGS': String.fromEnvironment('ENABLE_NETWORK_LOGS'),
    'API_CONNECT_TIMEOUT_SECONDS': String.fromEnvironment(
      'API_CONNECT_TIMEOUT_SECONDS',
    ),
    'API_RECEIVE_TIMEOUT_SECONDS': String.fromEnvironment(
      'API_RECEIVE_TIMEOUT_SECONDS',
    ),
    'GOOGLE_WEB_CLIENT_ID': String.fromEnvironment('GOOGLE_WEB_CLIENT_ID'),
    'GOOGLE_IOS_CLIENT_ID': String.fromEnvironment('GOOGLE_IOS_CLIENT_ID'),
    'CARTO_BASEMAP_API_KEY': String.fromEnvironment('CARTO_BASEMAP_API_KEY'),
    'CARTO_ANDROID_CERT_SHA1': String.fromEnvironment(
      'CARTO_ANDROID_CERT_SHA1',
    ),
    'REVENUECAT_GOOGLE_API_KEY': String.fromEnvironment(
      'REVENUECAT_GOOGLE_API_KEY',
    ),
    'REVENUECAT_APPLE_API_KEY': String.fromEnvironment(
      'REVENUECAT_APPLE_API_KEY',
    ),
    'REVENUECAT_ENTITLEMENT_ID': String.fromEnvironment(
      'REVENUECAT_ENTITLEMENT_ID',
    ),
  };

  static AppConfig? _current;
  static AppConfig get current => _current ??= AppConfig.resolve(
    defines: buildValues,
    releaseMode: const bool.fromEnvironment('dart.vm.product'),
  );
  static void configure(AppConfig config) => _current = config;

  final AppEnvironment environment;

  /// Same origin setting as JCVital; a legacy /api/v1 suffix is also accepted.
  final Uri apiBaseUrl;
  final bool deviceDemo;
  final bool demoData;
  final bool enableNetworkLogs;
  final Duration connectTimeout;
  final Duration receiveTimeout;
  final String googleWebClientId;
  final String googleIosClientId;
  final String cartoBasemapApiKey;
  final String cartoAndroidCertSha1;
  final String revenueCatGoogleApiKey;
  final String revenueCatAppleApiKey;
  final String revenueCatEntitlementId;

  Uri get apiV1BaseUrl {
    final path = apiBaseUrl.path.replaceFirst(RegExp(r'/+$'), '');
    return apiBaseUrl.replace(
      path: path.endsWith('/api/v1') ? path : '$path/api/v1',
    );
  }

  factory AppConfig.resolve({
    Map<String, String> defines = const {},
    Map<String, String> values = const {},
    bool releaseMode = false,
  }) {
    String read(String key, [String fallback = '']) {
      final build = defines[key]?.trim();
      if (build != null && build.isNotEmpty) return build;
      final local = values[key]?.trim();
      return local == null || local.isEmpty ? fallback : local;
    }

    bool flag(String key, bool fallback) {
      return switch (read(key, fallback.toString()).toLowerCase()) {
        'true' || '1' => true,
        'false' || '0' => false,
        _ => throw FormatException('$key must be true or false'),
      };
    }

    Duration timeout(String key, int fallback) {
      final seconds = int.tryParse(read(key, '$fallback'));
      if (seconds == null || seconds < 1 || seconds > 300) {
        throw FormatException('$key must be between 1 and 300 seconds');
      }
      return Duration(seconds: seconds);
    }

    final environment = switch (read(
      'APP_ENV',
      releaseMode ? 'production' : 'development',
    ).toLowerCase()) {
      'dev' || 'development' => AppEnvironment.development,
      'test' || 'testing' => AppEnvironment.testing,
      'prod' || 'production' => AppEnvironment.production,
      _ => throw const FormatException(
        'APP_ENV must be development, testing or production',
      ),
    };
    final base = Uri.tryParse(read('API_BASE_URL', defaultApiBaseUrl));
    if (base == null ||
        !base.hasAuthority ||
        base.host.isEmpty ||
        !{'http', 'https'}.contains(base.scheme) ||
        base.userInfo.isNotEmpty ||
        base.hasQuery ||
        base.hasFragment) {
      throw const FormatException(
        'API_BASE_URL must be an HTTP(S) service URL without credentials, query or fragment',
      );
    }
    final demoData = flag('MAPA_USE_DEMO_DATA', false);
    final deviceDemo = flag('DEVICE_DEMO', demoData);
    if (environment == AppEnvironment.production &&
        (base.scheme != 'https' || deviceDemo || demoData)) {
      throw const FormatException(
        'Production requires HTTPS and disabled demo data',
      );
    }
    return AppConfig._(
      environment: environment,
      apiBaseUrl: base,
      deviceDemo: deviceDemo,
      demoData: demoData,
      enableNetworkLogs:
          environment != AppEnvironment.production &&
          flag('ENABLE_NETWORK_LOGS', true),
      connectTimeout: timeout('API_CONNECT_TIMEOUT_SECONDS', 15),
      receiveTimeout: timeout('API_RECEIVE_TIMEOUT_SECONDS', 30),
      googleWebClientId: read('GOOGLE_WEB_CLIENT_ID', defaultGoogleWebClientId),
      googleIosClientId: read('GOOGLE_IOS_CLIENT_ID'),
      cartoBasemapApiKey: read('CARTO_BASEMAP_API_KEY'),
      cartoAndroidCertSha1: read('CARTO_ANDROID_CERT_SHA1'),
      revenueCatGoogleApiKey: read('REVENUECAT_GOOGLE_API_KEY'),
      revenueCatAppleApiKey: read('REVENUECAT_APPLE_API_KEY'),
      revenueCatEntitlementId: read('REVENUECAT_ENTITLEMENT_ID', 'premium'),
    );
  }
}
