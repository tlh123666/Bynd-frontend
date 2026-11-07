import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:new_jcvital/features/activity/domain/models/activity_type_catalog.dart';
import 'package:new_jcvital/features/activity/presentation/pages/activity_preparation_page.dart';

void main() {
  testWidgets('小屏准备页不溢出且不伪造设备数据', (tester) async {
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

    expect(find.text('Pulseira não integrada'), findsOneWidget);
    expect(find.text('Clima indisponível'), findsOneWidget);
    expect(find.text('Carga sugerida indisponível'), findsOneWidget);
    expect(find.text('Preparação'), findsNothing);
    final startButton = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Iniciar atividade'),
    );
    expect(startButton.onPressed, isNull);
    await tester.drag(find.byType(Scrollable).first, const Offset(0, -180));
    await tester.pumpAndSettle();
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
    await tester.tap(find.byKey(const ValueKey('route-recording-switch')));
    await tester.pumpAndSettle();

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
