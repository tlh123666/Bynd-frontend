import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_jcvital/design_system/components/app_frosted_context_menu.dart';

void main() {
  testWidgets('窄屏靠底部展开时菜单位于视口内，点击遮罩取消', (tester) async {
    tester.view.physicalSize = const Size(320, 400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    String? selected;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () async =>
                  selected = await AppFrostedContextMenu.show<String>(
                    context,
                    anchor: const Rect.fromLTWH(270, 360, 40, 40),
                    items: [
                      for (var i = 0; i < 5; i++)
                        AppFrostedMenuItem(
                          value: '$i',
                          label: 'Item $i',
                          icon: Icons.edit,
                        ),
                    ],
                  ),
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    final menu = tester.getRect(find.text('Item 4'));
    expect(menu.bottom, lessThanOrEqualTo(400));
    expect(menu.left, greaterThanOrEqualTo(0));
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();
    expect(find.text('Item 0'), findsNothing);
    expect(selected, isNull);
    expect(tester.takeException(), isNull);
  });
  testWidgets('遮罩首帧显示，菜单面板独立渐显并可正常关闭', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => AppFrostedContextMenu.show<int>(
                context,
                anchor: const Rect.fromLTWH(180, 100, 40, 40),
                items: const [
                  AppFrostedMenuItem(
                    value: 1,
                    label: 'Option',
                    icon: Icons.edit,
                  ),
                ],
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pump();
    final backdrop = find.byKey(const ValueKey('frosted-menu-backdrop'));
    final panel = find.byKey(const ValueKey('frosted-menu-panel-transition'));
    expect(backdrop, findsOneWidget);
    expect(
      find.ancestor(of: backdrop, matching: find.byType(FadeTransition)),
      findsNothing,
    );
    final transition = tester.widget<FadeTransition>(panel);
    expect(transition.opacity.value, 0);
    await tester.pump(const Duration(milliseconds: 120));
    expect(transition.opacity.value, greaterThan(0));
    expect(transition.opacity.value, lessThan(1));
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(5, 5));
    await tester.pumpAndSettle();
    expect(backdrop, findsNothing);
    expect(tester.takeException(), isNull);
  });
}
