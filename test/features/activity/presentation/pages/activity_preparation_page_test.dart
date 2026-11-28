import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:new_jcvital/features/activity/domain/models/activity_type_catalog.dart';
import 'package:new_jcvital/features/activity/presentation/pages/activity_preparation_page.dart';

void main() {
  testWidgets('较小屏幕放大文字时心率环和面板不溢出', (tester) async {
    tester.view.physicalSize = const Size(320, 480);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: const TextScaler.linear(1.5)),
          child: child!,
        ),
        home: ActivityPreparationPage(
          initialActivity: ActivityTypeCatalog.findById('musculacao')!,
        ),
      ),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('准备页下拉刷新明确标识为演示数据', (tester) async {
    tester.view.physicalSize = const Size(400, 840);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        home: ActivityPreparationPage(
          initialActivity: ActivityTypeCatalog.findById('musculacao')!,
        ),
      ),
    );
    await tester.drag(find.byType(Scrollable).first, const Offset(0, 300));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 1600));
    expect(find.text('Demonstração atualizada'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 2300));
    expect(tester.takeException(), isNull);
  });

  testWidgets('小屏准备页展示标记明确的演示数据且不能启动真实会话', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: ActivityPreparationPage(
          initialActivity: ActivityTypeCatalog.findById('corrida')!,
        ),
      ),
    );

    expect(find.text('Pulseira 82% · demonstração'), findsOneWidget);
    expect(find.text('Dados ilustrativos · não conectados'), findsOneWidget);
    expect(find.text('74'), findsOneWidget);
    expect(find.text('ZONA 0'), findsOneWidget);
    expect(find.text('Exemplo · não conectado'), findsOneWidget);
    expect(
      find.text('Carga sugerida · LEVE', findRichText: true),
      findsOneWidget,
    );
    expect(find.text('Preparação'), findsNothing);
    final startButton = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Iniciar atividade'),
    );
    expect(startButton.onPressed, isNotNull);
    await tester.ensureVisible(find.text('Iniciar atividade'));
    await tester.tap(find.text('Iniciar atividade'));
    await tester.pump();
    expect(
      find.text('Aguardando integração de sensores e sessão'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('较矮屏幕可滚动查看演示面板并切换负荷', (tester) async {
    tester.view.physicalSize = const Size(320, 480);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        home: ActivityPreparationPage(
          initialActivity: ActivityTypeCatalog.findById('musculacao')!,
        ),
      ),
    );
    expect(find.byType(Scrollable), findsWidgets);
    await tester.ensureVisible(
      find.text('Carga sugerida · LEVE', findRichText: true),
    );
    await tester.tap(find.byType(Switch).last);
    await tester.pumpAndSettle();
    expect(find.text('Carga sugerida · desligada'), findsOneWidget);
    await tester.ensureVisible(find.text('Iniciar atividade'));
    expect(tester.takeException(), isNull);
  });

  testWidgets('路线开关只改变预览状态，不声称已经记录 GPS', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ActivityPreparationPage(
          initialActivity: ActivityTypeCatalog.findById('corrida')!,
        ),
      ),
    );

    expect(
      find.text('GPS indisponível; nenhum percurso será gravado'),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('route-recording-switch')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('preparation-heart-rate')),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const ValueKey('route-recording-switch')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('preparation-heart-rate')), findsNothing);

    expect(
      find.text('GPS indisponível; nenhum percurso será gravado'),
      findsOneWidget,
    );
  });

  testWidgets('常规屏幕的准备控制面板贴齐底部', (tester) async {
    tester.view.physicalSize = const Size(720, 1280);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: ActivityPreparationPage(
          initialActivity: ActivityTypeCatalog.findById('corrida')!,
        ),
      ),
    );

    final panel = tester.getRect(
      find.byKey(const ValueKey('activity-preparation-controls')),
    );
    final routeSwitch = tester.getRect(
      find.byKey(const ValueKey('route-recording-switch')),
    );
    expect(routeSwitch.bottom, lessThan(panel.top));
    expect(panel.bottom, greaterThan(1200));
    expect(tester.takeException(), isNull);
  });
}
