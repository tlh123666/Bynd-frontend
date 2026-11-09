import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/auth_token_store.dart';

class AppLocaleController extends ValueNotifier<Locale> {
  AppLocaleController() : super(const Locale('pt', 'BR'));
  static final instance = AppLocaleController();
  static const supportedLocales = [
    Locale('pt', 'BR'),
    Locale('zh', 'CN'),
    Locale('en'),
  ];

  static Locale resolve(String? stored, Locale system) {
    final language =
        (stored == null || stored.isEmpty ? system.languageCode : stored)
            .split(RegExp('[-_]'))
            .first
            .toLowerCase();
    return supportedLocales.firstWhere(
      (locale) => locale.languageCode == language,
      orElse: () => const Locale('pt', 'BR'),
    );
  }

  Future<void> initialize({
    SharedPreferences? preferences,
    Locale? systemLocale,
  }) async {
    final prefs = preferences ?? await SharedPreferences.getInstance();
    value = resolve(
      prefs.getString(AuthStorageKeys.locale),
      systemLocale ?? WidgetsBinding.instance.platformDispatcher.locale,
    );
  }

  Future<void> setLocale(Locale locale) async {
    final normalized = resolve(locale.languageCode, const Locale('pt', 'BR'));
    await (await SharedPreferences.getInstance()).setString(
      AuthStorageKeys.locale,
      normalized.languageCode,
    );
    value = normalized;
  }

  String get acceptLanguage => value.toLanguageTag();
}
