import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_jcvital/design_system/components/app_pull_to_refresh.dart';

void main() {
  testWidgets('刷新任务完成前不展示成功，完成后提示并自动消失', (tester) async {
    final refresh = Completer<void>();
    var calls = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppPullToRefresh(
            onRefresh: () {
              calls++;
              return refresh.future;
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [SizedBox(height: 300, child: Text('内容'))],
            ),
          ),
        ),
      ),
    );
    await tester.drag(find.text('内容'), const Offset(0, 300));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(calls, 1);
    expect(find.text('Atualizado'), findsNothing);
    refresh.complete();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1600));
    expect(find.text('Atualizado'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 2300));
    expect(find.text('Atualizado'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('刷新失败不会显示成功', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppPullToRefresh(
            onRefresh: () async => throw StateError('failed'),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [SizedBox(height: 300, child: Text('内容'))],
            ),
          ),
        ),
      ),
    );
    await tester.drag(find.text('内容'), const Offset(0, 300));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Não foi possível atualizar'), findsOneWidget);
    expect(find.text('Atualizado'), findsNothing);
    await tester.pump(const Duration(milliseconds: 2300));
    expect(tester.takeException(), isNull);
  });

  testWidgets('刷新期间页面销毁不会更新已卸载组件', (tester) async {
    final refresh = Completer<void>();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppPullToRefresh(
            onRefresh: () => refresh.future,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [SizedBox(height: 300, child: Text('内容'))],
            ),
          ),
        ),
      ),
    );
    await tester.drag(find.text('内容'), const Offset(0, 300));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpWidget(const MaterialApp(home: SizedBox()));
    refresh.complete();
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));
    expect(tester.takeException(), isNull);
  });
}
