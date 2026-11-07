import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:new_jcvital/shared/widgets/centered_tab_strip.dart';

void main() {
  testWidgets('点击标签会通知调用方并由外部状态更新选中项', (tester) async {
    tester.view.physicalSize = const Size(456, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    var selectedIndex = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(
          builder: (context, setState) => Scaffold(
            body: CenteredTabStrip(
              itemCount: 3,
              selectedIndex: selectedIndex,
              onSelectedIndexChanged: (index) {
                setState(() => selectedIndex = index);
              },
              onItemTap: (index) => setState(() => selectedIndex = index),
              itemBuilder: (context, index, itemWidth) => Center(
                child: Text(
                  'tab:$index',
                  key: ValueKey('label-$index'),
                  style: TextStyle(
                    color: selectedIndex == index ? Colors.white : Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('centered-tab-1')));
    await tester.pumpAndSettle();

    expect(selectedIndex, 1);
    expect(find.text('tab:1'), findsOneWidget);
  });

  testWidgets('拖动标签轨道会将停在中央的选项通知调用方', (tester) async {
    tester.view.physicalSize = const Size(456, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    var selectedIndex = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(
          builder: (context, setState) => Scaffold(
            body: CenteredTabStrip(
              itemCount: 5,
              selectedIndex: selectedIndex,
              onSelectedIndexChanged: (index) {
                setState(() => selectedIndex = index);
              },
              onItemTap: (index) => setState(() => selectedIndex = index),
              itemBuilder: (context, index, itemWidth) =>
                  Center(child: Text('tab:$index')),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(-150, 0),
    );
    await tester.pumpAndSettle();

    expect(selectedIndex, 1);
  });

  testWidgets('可用宽度变化后仍将选中项保持在中央', (tester) async {
    tester.view.physicalSize = const Size(456, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CenteredTabStrip(
            itemCount: 5,
            selectedIndex: 2,
            onSelectedIndexChanged: _ignoreIndex,
            onItemTap: _ignoreIndex,
            itemBuilder: _buildTab,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    tester.view.physicalSize = const Size(600, 900);
    await tester.pumpAndSettle();

    expect(
      tester.getCenter(find.byKey(const ValueKey('centered-tab-2'))).dx,
      300,
    );
  });
}

void _ignoreIndex(int _) {}

Widget _buildTab(BuildContext context, int index, double itemWidth) =>
    Center(child: Text('tab:$index'));
