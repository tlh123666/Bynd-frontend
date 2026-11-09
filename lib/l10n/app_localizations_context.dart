import 'package:flutter/widgets.dart';

import 'generated/app_localizations.dart';

/// 本地化访问扩展。独立组件测试未安装 delegate 时回退到巴西葡萄牙语。
extension AppLocalizationsContext on BuildContext {
  AppLocalizations get l10n =>
      Localizations.of<AppLocalizations>(this, AppLocalizations) ??
      lookupAppLocalizations(const Locale('pt', 'BR'));
}
