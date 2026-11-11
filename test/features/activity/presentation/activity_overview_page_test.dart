import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:new_jcvital/design_system/components/app_frosted_surface.dart';
import 'package:new_jcvital/design_system/components/app_frosted_modal_sheet.dart';
import 'package:new_jcvital/design_system/tokens/app_colors.dart';
import 'package:new_jcvital/features/activity/presentation/pages/activity_overview_page.dart';
import 'package:new_jcvital/features/activity/presentation/pages/activity_history_page.dart';
import 'package:new_jcvital/features/activity/presentation/widgets/activity_detail_sheet.dart';
import 'package:new_jcvital/features/activity/presentation/models/demo_history_activity.dart';
import 'package:new_jcvital/l10n/generated/app_localizations.dart';
import 'package:new_jcvital/design_system/components/app_page_header.dart';
import 'package:new_jcvital/design_system/components/app_icon.dart';

void main() {
  testWidgets('示例详情菜单可复制、校验编辑和确认删除', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(400, 804);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    String? copied;
    var failCopy = false;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          if (failCopy) throw PlatformException(code: 'clipboard_unavailable');
          copied = (call.arguments as Map)['text'] as String?;
        }
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );

    await tester.pumpWidget(const MaterialApp(home: ActivityHistoryPage()));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Sauna'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Sauna'));
    await tester.pumpAndSettle();
    expect(
      tester.getTopLeft(find.byType(AppFrostedModalSheet).last).dy,
      closeTo(54, .1),
    );

    await tester.tap(find.bySemanticsLabel('Opções'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Compartilhar'));
    await tester.pumpAndSettle();
    expect(copied, contains('Sauna'));
    expect(find.text('Resumo de exemplo copiado.'), findsOneWidget);
    await tester.tap(find.text('Fechar').last);
    await tester.pumpAndSettle();

    failCopy = true;
    await tester.tap(find.bySemanticsLabel('Opções'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Compartilhar'));
    await tester.pumpAndSettle();
    expect(
      find.text('Não foi possível copiar o resumo de exemplo.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Fechar').last);
    await tester.pumpAndSettle();

    await tester.tap(find.bySemanticsLabel('Opções'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Editar horário e duração'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, '25:00');
    await tester.enterText(find.byType(TextField).last, '0');
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();
    expect(
      find.text('Informe um horário válido e uma duração de 1 a 720 minutos.'),
      findsOneWidget,
    );
    await tester.enterText(find.byType(TextField).first, '20:05');
    await tester.enterText(find.byType(TextField).last, '25');
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();
    expect(find.text('Ontem, 20:05 a 20:30'), findsOneWidget);

    await tester.tap(
      find.descendant(
        of: find.byType(ActivityDetailSheet),
        matching: find.bySemanticsLabel('Fechar'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('ontem 20:05'), findsOneWidget);
    await tester.tap(find.text('Sauna'));
    await tester.pumpAndSettle();
    expect(find.text('Ontem, 20:05 a 20:30'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Opções'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Apagar atividade'));
    await tester.pumpAndSettle();
    expect(find.text('Apagar este exemplo?'), findsOneWidget);
    await tester.tap(find.text('Cancelar').last);
    await tester.pumpAndSettle();
    expect(find.byType(ActivityDetailSheet), findsOneWidget);
    await tester.tap(find.bySemanticsLabel('Opções'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Apagar atividade'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Apagar atividade').last);
    await tester.pumpAndSettle();
    expect(find.byType(ActivityDetailSheet), findsNothing);
    expect(find.text('Sauna'), findsNothing);
    expect(find.text('1 atividade · 35 min no total'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('活动详情支持英文文案和示例数据标识', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => ActivityDetailSheet.show(
                context,
                DemoHistoryActivity.examples.last,
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(find.text('Yesterday, 19:40 to 20:00'), findsOneWidget);
    expect(find.text('Example · illustrative data'), findsOneWidget);
    expect(find.text('Average HR'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('历史入口打开演示历史，图表可拖动并返回活动页', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 640);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const MaterialApp(home: ActivityOverviewPage()));
    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel('Histórico'));
    await tester.pumpAndSettle();

    expect(find.byType(ActivityHistoryPage), findsOneWidget);
    expect(
      find.text('Dados ilustrativos de demonstração · não sincronizados'),
      findsOneWidget,
    );
    final chart = find.byKey(const ValueKey('activity-history-chart'));
    expect(tester.widget<Semantics>(chart).properties.label, endsWith('66'));
    await tester.drag(chart, const Offset(100, 0));
    await tester.pumpAndSettle();
    expect(
      tester.widget<Semantics>(chart).properties.label,
      isNot(endsWith('66')),
    );
    await tester.scrollUntilVisible(
      find.text('Musculação'),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Musculação'));
    await tester.pumpAndSettle();
    var sheet = find.byType(ActivityDetailSheet);
    expect(sheet, findsOneWidget);
    expect(
      tester.widget<ActivityDetailSheet>(sheet).activity.kind,
      DemoActivityKind.strength,
    );
    expect(find.text('Exemplo · dados ilustrativos'), findsOneWidget);
    await tester.tap(
      find.descendant(of: sheet, matching: find.bySemanticsLabel('Fechar')),
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Sauna'),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Sauna'));
    await tester.pumpAndSettle();
    sheet = find.byType(ActivityDetailSheet);
    expect(
      tester.widget<ActivityDetailSheet>(sheet).activity.kind,
      DemoActivityKind.sauna,
    );
    expect(find.text('Ontem, 19:40 a 20:00'), findsOneWidget);
    expect(find.text('FC média'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Zona 5'),
      180,
      scrollable: find.descendant(of: sheet, matching: find.byType(Scrollable)),
    );
    expect(find.text('Zonas da FC'), findsOneWidget);
    expect(find.text('Zona 5'), findsOneWidget);
    await tester.tap(
      find.descendant(of: sheet, matching: find.bySemanticsLabel('Fechar')),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.tap(find.bySemanticsLabel('Voltar').first);
    await tester.pumpAndSettle();
    expect(find.byType(ActivityHistoryPage), findsNothing);
    expect(find.byType(ActivityOverviewPage), findsOneWidget);
  });

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
