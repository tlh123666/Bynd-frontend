import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../auth/auth_session.dart';
import '../config/app_config.dart';
import '../config/app_config_loader.dart';
import '../localization/app_locale_controller.dart';
import '../utils/local_timezone.dart';

abstract final class AppBootstrap {
  static Future<AppConfig> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    final config = await AppConfigLoader.load();
    try {
      await AuthSession.instance.restore();
    } catch (_) {
      if (kDebugMode) {
        debugPrint('BYND: secure session unavailable; continuing signed out.');
      }
    }
    try {
      await AppLocaleController.instance.initialize();
    } catch (_) {
      if (kDebugMode) debugPrint('BYND: using the default application locale.');
    }
    await initializeLocalTimezone();
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    if (kDebugMode) {
      debugPrint(
        'BYND ${config.environment.name}: ${config.apiV1BaseUrl} (device demo: ${config.deviceDemo})',
      );
    }
    return config;
  }
}
