import 'package:flutter/widgets.dart';

import '../config/app_config.dart';
import '../network/api_client.dart';
import 'auth_api.dart';
import 'auth_controller.dart';
import 'token_store.dart';

/// 把 [AuthController] 放进 widget 树（会随会话状态重建监听者）。
///
/// 与 DeviceScope / AtlasScope 同构：会话状态用 InheritedNotifier 广播，
/// 页面拿 `AuthScope.of(context)` 就能读到 status / email 并监听变化。
class AuthScope extends InheritedNotifier<AuthController> {
  const AuthScope({
    required AuthController controller,
    required super.child,
    super.key,
  }) : super(notifier: controller);

  static AuthController of(BuildContext context) {
    final controller = maybeOf(context);
    if (controller == null) {
      throw FlutterError(
        'AuthScope não encontrado. Envolva a árvore com AuthScope em main() '
        'antes de acessar a sessão.',
      );
    }
    return controller;
  }

  static AuthController? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AuthScope>()?.notifier;
}

/// 按当前配置装配会话控制器。
abstract final class AuthRuntime {
  static AuthController create({AppConfig? config, TokenStore? store}) {
    return AuthController(
      api: AuthApi(ApiClient.configured(config: config)),
      store: store ?? SecureTokenStore(),
    );
  }
}
