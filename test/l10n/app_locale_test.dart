import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_jcvital/design_system/design_system.dart';
import 'package:new_jcvital/l10n/app_locale_controller.dart';
import 'package:new_jcvital/l10n/generated/app_localizations.dart';
import 'package:new_jcvital/main.dart';
import 'package:new_jcvital/features/activity/domain/models/activity_type_catalog.dart';
import 'package:new_jcvital/features/activity/domain/models/activity_type.dart';
import 'package:new_jcvital/features/activity/presentation/localization/activity_type_localizations.dart';
import 'package:new_jcvital/shared/navigation/app_side_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('语言偏好可恢复并持久化', () async {
    SharedPreferences.setMockInitialValues({'bynd_locale': 'en'});
    final controller = AppLocaleController();
    await controller.load();
    expect(controller.locale, const Locale('en'));

    expect(await controller.setLocale(const Locale('pt', 'BR')), isTrue);
    expect(controller.locale, const Locale('pt', 'BR'));
    expect(
      (await SharedPreferences.getInstance()).getString('bynd_locale'),
      'pt',
    );
    controller.dispose();
  });

  test('所有活动目录 ID 都有英文展示名称且不改动稳定 ID', () {
    expect(activityEnglishNamesCoverCatalog, isTrue);
    final running = ActivityTypeCatalog.findById('corrida')!;
    expect(
      activityTypeLocalizedName(
        running,
        lookupAppLocalizations(const Locale('en')),
      ),
      'Running',
    );
    expect(running.id, 'corrida');
    expect(
      activityCategoryLocalizedName(
        ActivityCategory.cardio,
        lookupAppLocalizations(const Locale('en')),
      ),
      'Cardio',
    );
  });

  testWidgets('侧边栏语言入口可切换整棵应用树', (tester) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const ByndApp());
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Menu'));
    await tester.pumpAndSettle();
    expect(
      find.descendant(
        of: find.byType(AppSideMenu),
        matching: find.byIcon(Icons.language),
      ),
      findsOneWidget,
    );
    await tester.tap(find.text('Idioma'));
    await tester.pumpAndSettle();

    expect(find.byType(AppFrostedModalSheet), findsOneWidget);
    expect(find.byType(AppFrostedSurface), findsOneWidget);
    expect(
      tester.getSize(find.byType(AppFrostedModalSheet)).height,
      lessThan(tester.view.physicalSize.height),
    );
    expect(find.byType(BackdropFilter), findsAtLeastNWidgets(2));
    expect(find.text('Escolha o idioma'), findsOneWidget);
    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();

    expect(find.byTooltip('Menu'), findsOneWidget);
    await tester.tap(find.byTooltip('Menu'));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Language'), findsOneWidget);
    expect(
      (await SharedPreferences.getInstance()).getString('bynd_locale'),
      'en',
    );
  });

  testWidgets('英文模式下活动入口和运动目录完整使用英文文案', (tester) async {
    SharedPreferences.setMockInitialValues({'bynd_locale': 'en'});
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const ByndApp());
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Quick actions'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start\nactivity'));
    await tester.pumpAndSettle();

    expect(find.text('Search 140 activities'), findsOneWidget);
    expect(find.text('RECENT'), findsOneWidget);
    expect(find.text('Running'), findsWidgets);
    expect(find.text('Strength training'), findsOneWidget);
  });
}
