import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/auth/auth_controller.dart';
import 'core/auth/auth_scope.dart';
import 'core/bootstrap/app_bootstrap.dart';
import 'core/config/app_config.dart';
import 'core/localization/app_locale_controller.dart';
import 'l10n/app_locale_controller.dart' as legacy_l10n;
import 'l10n/generated/app_localizations.dart';

import 'design_system/theme/app_theme.dart';
import 'features/atlas/data/atlas_repository.dart';
import 'features/device/application/device_controller.dart';
import 'features/home/application/home_controller.dart';
import 'features/auth/presentation/auth_gate.dart';

Future<void> main() async {
  final config = await AppBootstrap.initialize();
  runApp(ByndApp(config: config));
}

class ByndApp extends StatefulWidget {
  const ByndApp({
    this.deviceController,
    this.homeController,
    this.atlasRepository,
    this.authController,
    this.config,
    this.localeController,
    super.key,
  });
  final DeviceController? deviceController;
  final HomeController? homeController;
  final AtlasRepository? atlasRepository;
  final AuthController? authController;
  final AppConfig? config;
  final AppLocaleController? localeController;
  @override
  State<ByndApp> createState() => _ByndAppState();
}

class _ByndAppState extends State<ByndApp> {
  late final AuthController _auth;
  late final legacy_l10n.AppLocaleController _legacyLocale;

  // 根路由返回拦截：Android/MIUI 的边缘返回手势落在根路由上等于「退出
  // 应用」——用户关闭 Atlas 卡片后的顺手一划常起手在左边缘手势区，MIUI
  // 返回帘（用户描述的「左侧栏」）随后把应用退到桌面（logcat 三次实锤：
  // TYPE_RETURN_TO_HOME）。根路由 canPop:false + 2 秒内双击返回才退出，
  // 误触返回只弹提示。
  final GlobalKey<ScaffoldMessengerState> _messengerKey =
      GlobalKey<ScaffoldMessengerState>();
  DateTime? _lastRootBackAt;

  void _onRootBackInvoked(bool didPop, Object? result) {
    if (didPop) return;
    final now = DateTime.now();
    if (_lastRootBackAt != null &&
        now.difference(_lastRootBackAt!) < const Duration(seconds: 2)) {
      SystemNavigator.pop();
      return;
    }
    _lastRootBackAt = now;
    final isPt = Localizations.localeOf(context).languageCode == 'pt';
    _messengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(isPt ? 'Toque em voltar de novo para sair' : 'Tap back again to exit'),
        duration: const Duration(milliseconds: 1500),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _auth = widget.authController ?? AuthRuntime.create(config: widget.config);
    _legacyLocale = legacy_l10n.AppLocaleController(
      initialLocale:
          (widget.localeController ?? AppLocaleController.instance).value,
    )..load();
    _legacyLocale.addListener(_syncApiLocale);
    _syncApiLocale();
    // 恢复会话元数据；不阻塞首帧，进程被杀后重进也能带回登录态。
    unawaited(_auth.restore());
  }

  @override
  void dispose() {
    if (widget.authController == null) _auth.dispose();
    _legacyLocale.removeListener(_syncApiLocale);
    _legacyLocale.dispose();
    super.dispose();
  }

  void _syncApiLocale() {
    (widget.localeController ?? AppLocaleController.instance).value =
        _legacyLocale.locale;
  }

  @override
  Widget build(BuildContext context) {
    return AuthScope(
      controller: _auth,
      child: ListenableBuilder(
        listenable: _legacyLocale,
        builder: (context, _) => MaterialApp(
          title: AppConfig.applicationName,
          debugShowCheckedModeBanner: false,
          scaffoldMessengerKey: _messengerKey,
          scrollBehavior: const MaterialScrollBehavior().copyWith(
            scrollbars: false,
          ),
          locale: _legacyLocale.locale,
          supportedLocales: const [Locale('pt', 'BR'), Locale('en')],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            ...GlobalMaterialLocalizations.delegates,
          ],
          theme: AppTheme.dark,
          home: legacy_l10n.AppLocaleScope(
            controller: _legacyLocale,
            child: PopScope<bool>(
              canPop: false,
              onPopInvokedWithResult: _onRootBackInvoked,
              child: AuthGate(
                homeController: widget.homeController,
                deviceController: widget.deviceController,
                atlasRepository: widget.atlasRepository,
                localeController: widget.localeController,
                config: widget.config ?? AppConfig.current,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
