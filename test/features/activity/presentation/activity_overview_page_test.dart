import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:new_jcvital/features/activity/presentation/pages/activity_overview_page.dart';

void main() {
  testWidgets('活动总览在手机视口下布局无横向溢出', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(456, 990);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const MaterialApp(home: ActivityOverviewPage()));
    await tester.pumpAndSettle();

    expect(find.text('DADOS INDISPONÍVEIS'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
