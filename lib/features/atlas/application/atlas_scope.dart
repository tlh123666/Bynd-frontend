import 'package:flutter/widgets.dart';

import '../../../core/config/app_config.dart';
import '../../../core/localization/app_locale_controller.dart';
import '../../../core/network/api_client.dart';
import '../data/atlas_repository.dart';

/// 把 [AtlasRepository] 放进 widget 树。
///
/// 与 DeviceScope 同构：只负责「向下提供同一份依赖」，不做状态广播。
/// 分散 new 的后果很具体：每页各建一个 ApiClient 就有各自的连接池与
/// 令牌读取时机，某处登出后别处还拿着旧令牌继续请求。
class AtlasScope extends InheritedWidget {
  const AtlasScope({
    required this.repository,
    required super.child,
    super.key,
  });

  final AtlasRepository repository;

  static AtlasRepository of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AtlasScope>();
    if (scope == null) {
      throw FlutterError(
        'AtlasScope não encontrado. Envolva a árvore com AtlasScope antes de '
        'acessar a API.',
      );
    }
    return scope.repository;
  }

  @override
  bool updateShouldNotify(AtlasScope oldWidget) =>
      repository != oldWidget.repository;
}

/// 按当前配置装配 ATLAS 仓储。
abstract final class AtlasRuntime {
  static AtlasRepository create({
    AppConfig? config,
    AppLocaleController? locale,
  }) {
    return AtlasRepository(
      ApiClient.configured(config: config, locale: locale),
    );
  }
}
