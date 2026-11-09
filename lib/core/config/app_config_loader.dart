import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app_config.dart';

abstract final class AppConfigLoader {
  static Future<AppConfig> load({AssetBundle? bundle}) async {
    final assetBundle = bundle ?? rootBundle;
    const path = String.fromEnvironment(
      'ENV_FILE',
      defaultValue: 'assets/config/.env',
    );
    final manifest = await AssetManifest.loadFromAssetBundle(assetBundle);
    final local = <String, String>{};
    if (manifest.listAssets().contains(path)) {
      final env = DotEnv();
      env.testLoad(fileInput: await assetBundle.loadString(path));
      local.addAll(env.env);
    }
    // Server model credentials are intentionally never part of client config.
    final config = AppConfig.resolve(
      defines: AppConfig.buildValues,
      values: local,
      releaseMode: kReleaseMode,
    );
    AppConfig.configure(config);
    return config;
  }
}
