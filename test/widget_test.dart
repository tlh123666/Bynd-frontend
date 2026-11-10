import 'package:new_jcvital/core/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_jcvital/design_system/design_system.dart';
import 'package:new_jcvital/main.dart';
import 'package:new_jcvital/features/profile/profile_page.dart';
import 'package:new_jcvital/shared/navigation/app_side_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));
  testWidgets('主页显示底部导航并更新选中入口', (tester) async {
    await tester.pumpWidget(
      ByndApp(
        config: AppConfig.resolve(
          defines: const {'MAPA_USE_DEMO_DATA': 'true'},
        ),
      ),
    );

    expect(find.byType(AppBottomNav), findsOneWidget);
    for (final asset in [
      AppSvgAssets.home,
      AppSvgAssets.atlas,
      AppSvgAssets.community,
      AppSvgAssets.health,
      AppSvgAssets.more,
    ]) {
      // 只查底部导航内部：侧边菜单里也有 atlas（Mapa 入口），而抽屉关闭时
      // 仍留在树上，按整棵树找会出现两个。
      expect(
        find.descendant(
          of: find.byType(AppBottomNav),
          matching: find.byWidgetPredicate(
            (widget) => widget is AppSvgIcon && widget.asset == asset,
          ),
        ),
        findsOneWidget,
      );
    }
    expect(
      tester.widget<AppBottomNav>(find.byType(AppBottomNav)).selectedIndex,
      0,
    );

    await tester.tap(find.byTooltip('Comunidade'));
    await tester.pump();

    expect(
      tester.widget<AppBottomNav>(find.byType(AppBottomNav)).selectedIndex,
      2,
    );
  });

  testWidgets('更多按钮展开六项快捷导航并可关闭', (tester) async {
    await tester.pumpWidget(
      ByndApp(
        config: AppConfig.resolve(
          defines: const {'MAPA_USE_DEMO_DATA': 'true'},
        ),
      ),
    );

    await tester.tap(find.byTooltip('Ações rápidas'));
    await tester.pump();

    expect(find.byType(AppQuickActionsOverlay), findsOneWidget);
    final closedControl = find.byWidgetPredicate(
      (widget) => widget is AppQuickActionsButton && !widget.isOpen,
    );
    final openControl = find.byWidgetPredicate(
      (widget) => widget is AppQuickActionsButton && widget.isOpen,
    );
    expect(closedControl, findsOneWidget);
    expect(openControl, findsOneWidget);
    expect(tester.getRect(closedControl), tester.getRect(openControl));
    expect(find.text('AÇÕES RÁPIDAS'), findsOneWidget);
    expect(
      tester
          .widget<Opacity>(find.byKey(const Key('quick-backdrop-opacity')))
          .opacity,
      0,
    );
    await tester.pump(const Duration(milliseconds: 120));
    final backdropOpacity = tester
        .widget<Opacity>(find.byKey(const Key('quick-backdrop-opacity')))
        .opacity;
    expect(backdropOpacity, greaterThan(0));
    expect(backdropOpacity, lessThan(1));
    final firstBubble = tester
        .widget<Opacity>(find.byKey(const Key('quick-bubble-breathe')))
        .opacity;
    final lastBubble = tester
        .widget<Opacity>(find.byKey(const Key('quick-bubble-ecg')))
        .opacity;
    expect(firstBubble, greaterThan(lastBubble));

    await tester.pumpAndSettle();
    for (final action in AppQuickAction.values) {
      expect(find.text(action.label), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (widget) => widget is AppSvgIcon && widget.asset == action.iconAsset,
        ),
        findsOneWidget,
      );
    }
    expect(
      tester.getRect(find.byKey(const Key('quick-close-button'))),
      tester.getRect(
        find.byKey(
          tester.widget<AppBottomNav>(find.byType(AppBottomNav)).moreButtonKey!,
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('quick-close-button')));
    await tester.pump();
    expect(find.byType(AppQuickActionsOverlay), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 100));
    expect(
      tester
          .widget<Opacity>(find.byKey(const Key('quick-backdrop-opacity')))
          .opacity,
      lessThan(1),
    );
    await tester.pumpAndSettle();
    expect(find.byType(AppQuickActionsOverlay), findsNothing);
  });

  testWidgets('公共按钮的点击和禁用状态', (tester) async {
    var count = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        home: Scaffold(
          body: Column(
            children: [
              AppButton(label: '可点击', onPressed: () => count++),
              const AppButton(label: '不可点击', onPressed: null),
            ],
          ),
        ),
      ),
    );

    await tester.tap(find.text('可点击'));
    await tester.pump();

    expect(count, 1);
    final disabled = tester.widget<FilledButton>(
      find.ancestor(of: find.text('不可点击'), matching: find.byType(FilledButton)),
    );
    expect(disabled.onPressed, isNull);
  });

  testWidgets('快捷入口触发对应反馈并关闭菜单', (tester) async {
    await tester.pumpWidget(
      ByndApp(
        config: AppConfig.resolve(
          defines: const {'MAPA_USE_DEMO_DATA': 'true'},
        ),
      ),
    );
    await tester.tap(find.byTooltip('Ações rápidas'));
    await tester.pumpAndSettle();

    await tester.tap(find.text(AppQuickAction.breathe.label));
    await tester.pump();

    expect(find.byType(AppQuickActionsOverlay), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.byType(AppQuickActionsOverlay), findsNothing);
    expect(find.text('Respirar 5 min: em breve.'), findsOneWidget);
  });

  testWidgets('系统返回键收起快捷菜单并保留当前页面', (tester) async {
    await tester.pumpWidget(
      ByndApp(
        config: AppConfig.resolve(
          defines: const {'MAPA_USE_DEMO_DATA': 'true'},
        ),
      ),
    );
    await tester.tap(find.byTooltip('Ações rápidas'));
    await tester.pumpAndSettle();

    await tester.binding.handlePopRoute();
    await tester.pump();
    expect(find.byType(AppQuickActionsOverlay), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.byType(AppQuickActionsOverlay), findsNothing);
    expect(find.byType(AppBottomNav), findsOneWidget);
  });

  testWidgets('侧边菜单滑入，设置关闭菜单后从右侧进入资料页', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    await tester.pumpWidget(
      ByndApp(
        config: AppConfig.resolve(
          defines: const {'MAPA_USE_DEMO_DATA': 'true'},
        ),
      ),
    );

    await tester.tap(find.byTooltip('Menu'));
    await tester.pump();
    expect(find.byType(AppSideMenu), findsOneWidget);
    final firstX = tester.getTopLeft(find.text('Ajustes')).dx;
    await tester.pump(const Duration(milliseconds: 150));
    final movingX = tester.getTopLeft(find.text('Ajustes')).dx;
    expect(movingX, greaterThan(firstX));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Ajustes'));
    await tester.pump(AppMotion.drawer);
    await tester.pump();
    final enteringX = tester.getTopLeft(find.text('Perfil')).dx;
    await tester.pump(const Duration(milliseconds: 150));
    final movingPageX = tester.getTopLeft(find.text('Perfil')).dx;
    expect(movingPageX, lessThan(enteringX));
    await tester.pumpAndSettle();

    expect(find.byType(ProfilePage), findsOneWidget);
    expect(find.text('Perfil'), findsOneWidget);
    expect(find.text('Clara Nunes'), findsOneWidget);
    expect(find.byType(AppBottomNav), findsOneWidget);

    await tester.tap(find.byTooltip('Voltar'));
    await tester.pumpAndSettle();
    expect(find.byType(ProfilePage), findsNothing);
  });

  testWidgets('共享 loading 可显示与隐藏，并遵守减少动画设置', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(disableAnimations: true),
          child: Scaffold(
            body: AppLoadingOverlay(
              loading: true,
              label: 'Carregando perfil',
              child: Text('Conteúdo'),
            ),
          ),
        ),
      ),
    );
    expect(find.byType(AppLoadingIndicator), findsOneWidget);
    expect(find.text('Carregando perfil'), findsOneWidget);
    await tester.pumpAndSettle();
    expect(tester.binding.transientCallbackCount, 0);
  });

  testWidgets('导入的 SVG 资源均可解析', (tester) async {
    await tester.pumpWidget(
      ByndApp(
        config: AppConfig.resolve(
          defines: const {'MAPA_USE_DEMO_DATA': 'true'},
        ),
      ),
    );
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final assets = manifest
        .listAssets()
        .where(
          (asset) =>
              asset.startsWith('assets/icons/site/') && asset.endsWith('.svg'),
        )
        .toList();
    expect(assets.length, greaterThanOrEqualTo(147));
    expect(
      assets,
      containsAll([
        AppSvgAssets.homeDirection,
        AppSvgAssets.homeCustomize,
        AppSvgAssets.homeBrain,
      ]),
    );

    for (final referencedAsset in [
      AppSvgAssets.logo,
      AppSvgAssets.menu,
      AppSvgAssets.photoCounter,
      AppSvgAssets.home,
      AppSvgAssets.atlas,
      AppSvgAssets.community,
      AppSvgAssets.health,
      AppSvgAssets.more,
      AppSvgAssets.breathe,
      AppSvgAssets.meal,
      AppSvgAssets.startActivity,
      AppSvgAssets.dayReview,
      AppSvgAssets.logActivity,
      AppSvgAssets.ecg,
      AppSvgAssets.close,
      AppSvgAssets.loadingSymbol,
      AppSvgAssets.settings,
      AppSvgAssets.back,
      AppSvgAssets.edit,
      AppSvgAssets.device,
      AppSvgAssets.devicePair,
      AppSvgAssets.deviceUnpair,
      AppSvgAssets.deviceFirmware,
      AppSvgAssets.deviceRestart,
      AppSvgAssets.deviceSafety,
      AppSvgAssets.deviceErase,
      AppSvgAssets.deviceInfo,
      AppSvgAssets.deviceCheck,
    ]) {
      expect(assets, contains(referencedAsset));
    }

    for (final asset in assets) {
      final contents = await rootBundle.loadString(asset);
      try {
        final picture = await vg.loadPicture(SvgStringLoader(contents), null);
        picture.picture.dispose();
      } catch (error) {
        fail('$asset 无法解析: $error');
      }
    }
  });
}
