import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:new_jcvital/shared/widgets/day_strip.dart';

void main() {
  testWidgets('日期带按原型顺序显示今天、昨天和更早日期', (tester) async {
    var selectedDay = 0;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('pt', 'BR'),
        supportedLocales: const [Locale('pt', 'BR')],
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        home: StatefulBuilder(
          builder: (context, setState) => Scaffold(
            body: DayStrip(
              day: selectedDay,
              onDayChanged: (day) => setState(() => selectedDay = day),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Hoje'), findsOneWidget);
    expect(find.text('Ontem'), findsOneWidget);
    expect(find.byKey(const ValueKey('day-strip-2')), findsOneWidget);
  });

  testWidgets('点昨天会同步选择值，再点当前日打开日历', (tester) async {
    tester.view.physicalSize = const Size(471, 990);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    var selectedDay = 0;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('pt', 'BR'),
        supportedLocales: const [Locale('pt', 'BR')],
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        home: StatefulBuilder(
          builder: (context, setState) => Scaffold(
            body: Column(
              children: [
                DayStrip(
                  day: selectedDay,
                  onDayChanged: (day) => setState(() => selectedDay = day),
                ),
                Text('selected:$selectedDay'),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('day-strip-1')));
    await tester.pumpAndSettle();
    expect(find.text('selected:1'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('day-strip-1')));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Mês anterior'), findsOneWidget);
    expect(find.text('SEG'), findsOneWidget);
    expect(find.text('DOM'), findsOneWidget);
    expect(find.text('recuperação boa'), findsOneWidget);
    expect(find.text('recuperação média'), findsOneWidget);
    expect(find.text('recuperação baixa'), findsOneWidget);
    expect(
      tester.getSize(find.byKey(const ValueKey('day-calendar-background'))),
      const Size(471, 990),
    );
    expect(
      tester.getTopLeft(find.text('recuperação baixa')).dy,
      greaterThan(tester.getTopLeft(find.text('recuperação boa')).dy),
    );

    await tester.tap(find.byKey(const ValueKey('day-calendar-date-0')));
    await tester.pumpAndSettle();
    expect(selectedDay, 0);
    expect(find.byTooltip('Fechar calendário'), findsNothing);
  });

  testWidgets('横向滑动日期带会更新当前选中日', (tester) async {
    var selectedDay = 0;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('pt', 'BR'),
        supportedLocales: const [Locale('pt', 'BR')],
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        home: StatefulBuilder(
          builder: (context, setState) => Scaffold(
            body: Column(
              children: [
                DayStrip(
                  day: selectedDay,
                  onDayChanged: (day) => setState(() => selectedDay = day),
                ),
                Text('selected:$selectedDay'),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.drag(
      find.byType(SingleChildScrollView).first,
      const Offset(250, 0),
    );
    await tester.pumpAndSettle();

    expect(selectedDay, 1);
    expect(find.text('selected:$selectedDay'), findsOneWidget);
  });
}
