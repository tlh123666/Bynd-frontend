import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:new_jcvital/design_system/components/app_frosted_surface.dart';
import 'package:new_jcvital/design_system/tokens/app_colors.dart';
import 'package:new_jcvital/features/activity/presentation/pages/activity_overview_page.dart';
import 'package:new_jcvital/design_system/components/app_page_header.dart';
import 'package:new_jcvital/design_system/components/app_icon.dart';

void main() {
  testWidgets('活动行动区匹配原型的按钮尺寸、字级与玻璃高光', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(456, 990);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const MaterialApp(home: ActivityOverviewPage()));
    await tester.pumpAndSettle();

    final actionRow = find.byKey(
      const ValueKey('activity-overview-action-row'),
    );
    final registerButton = find.byKey(
      const ValueKey('activity-overview-register-button'),
    );
    final startButton = find.byKey(
      const ValueKey('activity-overview-start-button'),
    );
    expect(tester.getSize(actionRow), const Size(328, 48));
    expect(tester.getSize(registerButton), const Size(159, 48));
    expect(tester.getSize(startButton), const Size(159, 48));

    final registerLabel = tester.widget<Text>(find.text('Registrar'));
    expect(registerLabel.style?.fontSize, 13);
    expect(registerLabel.style?.fontWeight, FontWeight.w400);
    final startButtonStyle = tester.widget<FilledButton>(startButton).style!;
    final startTextStyle = startButtonStyle.textStyle!.resolve(
      const <WidgetState>{},
    );
    expect(
      startButtonStyle.backgroundColor!.resolve(const <WidgetState>{}),
      AppColors.textPrimary,
    );
    expect(
      startButtonStyle.foregroundColor!.resolve(const <WidgetState>{}),
      AppColors.onAction,
    );
    expect(startTextStyle?.fontSize, 13);
    expect(startTextStyle?.fontWeight, FontWeight.w500);

    final glassSurface = tester.widget<AppFrostedSurface>(
      find.byKey(const ValueKey('activity-overview-register-surface')),
    );
    expect(glassSurface.blurSigma, 14);
    expect(glassSurface.saturation, 1.5);
    expect(glassSurface.tintColor, AppColors.sheetGlassTint);
    final highlight = tester.widget<DecoratedBox>(
      find.byKey(const ValueKey('activity-overview-register-highlight')),
    );
    final border = (highlight.decoration as BoxDecoration).border! as Border;
    expect(border.top.color, AppColors.sheetGlassBorder);
    expect(border.left, BorderSide.none);
    expect(tester.takeException(), isNull);
  });

  testWidgets('活动总览在手机视口下布局无横向溢出', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(456, 990);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const MaterialApp(home: ActivityOverviewPage()));
    await tester.pumpAndSettle();

    expect(find.byType(AppPageHeader), findsOneWidget);
    final trackImage = find.byWidgetPredicate(
      (widget) =>
          widget is Image &&
          widget.image is AssetImage &&
          (widget.image as AssetImage).assetName ==
              'assets/images/activity-track.webp',
    );
    expect(trackImage, findsOneWidget);
    final initialTrackTop = tester.getTopLeft(trackImage).dy;
    final header = find.byType(AppPageHeader);
    final initialHeaderTop = tester.getTopLeft(header).dy;
    final frostedHeader = find.byKey(
      const ValueKey('activity-scroll-frosted-header'),
    );
    expect(
      tester.widget<TweenAnimationBuilder<double>>(frostedHeader).tween.end,
      0,
    );
    expect(
      find.byWidgetPredicate(
        (widget) => widget is AppSvgIcon && widget.asset == AppSvgAssets.back,
      ),
      findsOneWidget,
    );
    expect(find.text('ABAIXO DO ALVO'), findsOneWidget);
    expect(find.text('Falta pouco para o alvo.'), findsOneWidget);
    expect(
      find.text('Dados ilustrativos de demonstração · não sincronizados'),
      findsOneWidget,
    );
    expect(find.text('28'), findsOneWidget);
    expect(find.textContaining('399'), findsOneWidget);
    expect(find.textContaining('6.240'), findsOneWidget);
    expect(find.text('Ver todas'), findsOneWidget);
    expect(find.text('1 treino · 35 min no total'), findsOneWidget);
    expect(find.text('07:50'), findsOneWidget);
    expect(find.text('97 bpm'), findsOneWidget);
    expect(find.text('28 carga'), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('O que vamos fazer hoje?')).dy,
      lessThan(tester.getTopLeft(find.text('O dia em números')).dy),
    );
    await tester.drag(
      find.text('Falta pouco para o alvo.'),
      const Offset(0, -260),
    );
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(trackImage).dy, lessThan(initialTrackTop));
    expect(tester.getTopLeft(header).dy, initialHeaderTop);
    expect(
      tester.widget<TweenAnimationBuilder<double>>(frostedHeader).tween.end,
      1,
    );
    expect(
      find.descendant(of: frostedHeader, matching: find.byType(BackdropFilter)),
      findsOneWidget,
    );
    expect(
      find.descendant(of: frostedHeader, matching: find.byType(ShaderMask)),
      findsNothing,
    );
    expect(
      find.descendant(of: frostedHeader, matching: find.byType(Opacity)),
      findsNothing,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('活动总览在窄屏仍可滚动查看示例指标且无布局异常', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 640);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const MaterialApp(home: ActivityOverviewPage()));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Atividades de hoje'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Musculação'), findsWidgets);
    expect(find.text('Atividades de hoje'), findsOneWidget);
    expect(find.text('4h44'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
