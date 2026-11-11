import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_jcvital/design_system/components/app_frosted_modal_sheet.dart';
import 'package:new_jcvital/features/activity/presentation/widgets/activity_registration_sheet.dart';
import 'package:new_jcvital/features/activity/presentation/widgets/activity_detail_sheet.dart';
import 'package:new_jcvital/l10n/generated/app_localizations.dart';

void main() {
  testWidgets('登记后直接展示公共详情并标识模拟数据', (tester) async {
    tester.view.physicalSize = const Size(400, 804);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('pt', 'BR'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () =>
                  ActivityRegistrationSheet.show(context, initialDay: 1),
              child: const Text('Abrir'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    expect(find.byType(AppFrostedModalSheet), findsOneWidget);
    expect(find.text('Registrar atividade'), findsOneWidget);
    expect(find.text('53'), findsOneWidget);
    expect(find.textContaining('carga estimada de exemplo'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.byKey(const Key('registration-effort')),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    final scale = find.byKey(const Key('registration-effort'));
    await tester.tapAt(tester.getTopLeft(scale) + const Offset(10, 40));
    await tester.pumpAndSettle();
    expect(find.text('12'), findsOneWidget);
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
    expect(find.byType(ActivityDetailSheet), findsOneWidget);
    expect(find.byType(AppFrostedModalSheet), findsOneWidget);
    expect(find.text('Funcional'), findsOneWidget);
    expect(find.text('Ontem, 07:15 a 08:00'), findsOneWidget);
    expect(find.text('Prévia · dados simulados · não salvo'), findsOneWidget);
    expect(find.text('Alta intensidade'), findsOneWidget);
    expect(find.text('Picos de esforço'), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Abrir'), findsOneWidget);
    expect(find.text('Registrar atividade'), findsNothing);
    expect(tester.takeException(), isNull);
  });
  testWidgets('窄屏可选择运动并取消时间滚轮', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('pt', 'BR'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () =>
                  ActivityRegistrationSheet.show(context, initialDay: 1),
              child: const Text('Abrir'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Funcional'));
    await tester.pumpAndSettle();
    expect(find.text('MODALIDADE'), findsWidgets);
    await tester.tap(find.text('Corrida').first);
    await tester.pumpAndSettle();
    expect(find.text('Corrida'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Começou às'),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Começou às'));
    await tester.pumpAndSettle();
    expect(find.byType(AppFrostedModalSheet), findsNWidgets(2));
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('07:15'), findsOneWidget);
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();
    expect(find.text('Corrida'), findsOneWidget);
    expect(find.text('Ontem, 07:15 a 08:00'), findsOneWidget);
    expect(find.byType(ActivityDetailSheet), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
