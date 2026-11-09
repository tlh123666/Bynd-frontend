import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_jcvital/design_system/components/app_page_header.dart';

void main() {
  testWidgets('标题在两侧操作宽度不一致时仍保持居中', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AppPageHeader(
            title: Text('页面标题'),
            leading: SizedBox(width: 42, child: Text('返回')),
            trailing: SizedBox(width: 16, child: Text('更多')),
          ),
        ),
      ),
    );

    expect(tester.getCenter(find.text('页面标题')).dx, closeTo(160, 0.1));
    expect(tester.takeException(), isNull);
  });
}
