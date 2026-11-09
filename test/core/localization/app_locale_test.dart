import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:new_jcvital/core/localization/app_locale_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('语言使用原 app_locale 键，并优先恢复用户选择', () async {
    SharedPreferences.setMockInitialValues({'app_locale': 'zh'});
    final controller = AppLocaleController();
    addTearDown(controller.dispose);
    await controller.initialize(systemLocale: const Locale('en'));
    expect(controller.acceptLanguage, 'zh-CN');
    await controller.setLocale(const Locale('pt'));
    expect(
      (await SharedPreferences.getInstance()).getString('app_locale'),
      'pt',
    );
    expect(controller.acceptLanguage, 'pt-BR');
  });
  test('未保存语言跟随系统，未支持的语言回退葡语', () {
    expect(
      AppLocaleController.resolve(null, const Locale('en')).languageCode,
      'en',
    );
    expect(
      AppLocaleController.resolve(null, const Locale('zh')).toLanguageTag(),
      'zh-CN',
    );
    expect(
      AppLocaleController.resolve(null, const Locale('ja')).toLanguageTag(),
      'pt-BR',
    );
  });
}
