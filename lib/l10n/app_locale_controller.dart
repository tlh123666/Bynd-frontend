import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 保存用户选择的应用语言；不依赖设备系统语言，默认使用 pt-BR。
class AppLocaleController extends ChangeNotifier {
  AppLocaleController({Locale initialLocale = const Locale('pt', 'BR')})
    : _locale = _normalize(initialLocale);

  static const _preferenceKey = 'bynd_locale';

  Locale _locale;
  int _revision = 0;
  bool _disposed = false;
  Locale get locale => _locale;

  Future<void> load() async {
    final revisionAtStart = _revision;
    try {
      final preferences = await SharedPreferences.getInstance();
      if (_disposed || revisionAtStart != _revision) return;
      final savedLanguage = preferences.getString(_preferenceKey);
      if (savedLanguage == null) return;
      final restoredLocale = switch (savedLanguage) {
        'en' => const Locale('en'),
        'pt' => const Locale('pt', 'BR'),
        _ => null,
      };
      if (restoredLocale == null || restoredLocale == _locale) return;
      _locale = restoredLocale;
      notifyListeners();
    } catch (_) {
      // 偏好读取失败时沿用默认语言，不能阻止应用启动。
    }
  }

  Future<bool> setLocale(Locale locale) async {
    final nextLocale = _normalize(locale);
    // 用户操作优先于启动时尚未完成的偏好读取。
    _revision++;
    if (nextLocale != _locale) {
      _locale = nextLocale;
      notifyListeners();
    }

    try {
      final preferences = await SharedPreferences.getInstance();
      // 必须 await：否则 setString 的异步失败会绕过下面的 catch，
      // 设置界面拿不到 false，会误报「已保存」。
      return await preferences.setString(_preferenceKey, nextLocale.languageCode);
    } catch (_) {
      // 当前会话立即生效；返回失败状态供设置界面提示用户未能保存。
      return false;
    }
  }

  static Locale _normalize(Locale locale) => locale.languageCode == 'en'
      ? const Locale('en')
      : const Locale('pt', 'BR');

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

/// 在应用树中共享语言设置；测试中的独立页面可不挂载此作用域。
class AppLocaleScope extends InheritedNotifier<AppLocaleController> {
  const AppLocaleScope({
    required AppLocaleController controller,
    required super.child,
    super.key,
  }) : super(notifier: controller);

  static AppLocaleController? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppLocaleScope>()?.notifier;
}
