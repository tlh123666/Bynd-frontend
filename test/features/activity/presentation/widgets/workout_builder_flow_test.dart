import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:new_jcvital/features/activity/data/local_workout_store.dart';
import 'package:new_jcvital/design_system/components/app_frosted_modal_sheet.dart';
import 'package:new_jcvital/features/activity/presentation/widgets/workout_builder_sheet.dart';
import 'package:new_jcvital/l10n/generated/app_localizations.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Future<void> openBuilder(
    WidgetTester tester,
    ValueChanged<LocalWorkoutPlan?> onResult, {
    LocalWorkoutStore? store,
  }) async {
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
              onPressed: () async => onResult(
                await WorkoutBuilderSheet.show(context, store: store),
              ),
              child: const Text('Abrir'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel('Adicionar exercícios').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Supino reto com barra'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Adicionar (1)'));
    await tester.pumpAndSettle();
  }

  testWidgets('编辑组数后保存本地并保留修改', (tester) async {
    await openBuilder(tester, (_) {});
    await tester.enterText(find.byType(TextField), 'Meu treino');
    tester.testTextInput.hide();
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.more_horiz));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Editar séries'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Série 1'));
    await tester.pumpAndSettle();
    final fields = find.descendant(
      of: find.byType(AppFrostedModalSheet).last,
      matching: find.byType(TextField),
    );
    await tester.enterText(fields.at(0), '8');
    await tester.enterText(fields.at(1), '20');
    await tester.tap(find.text('Concluir'));
    await tester.pumpAndSettle();
    expect(find.text('360'), findsOneWidget);
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();
    final plans = await LocalWorkoutStore(null).load();
    expect(plans.single.name, 'Meu treino');
    expect(plans.single.exercises.single.sets.first.amount, 8);
    expect(plans.single.exercises.single.sets.first.weight, 20);
  });

  testWidgets('开始返回独立计划，不保存或虚报已开始运动', (tester) async {
    LocalWorkoutPlan? result;
    await openBuilder(tester, (value) => result = value);
    await tester.tap(find.text('Começar'));
    await tester.pumpAndSettle();
    expect(result, isNotNull);
    expect(result!.setCount, 3);
    expect(result!.liftedWeight, 300);
    expect(await LocalWorkoutStore(null).load(), isEmpty);
  });
  testWidgets('保存失败时显示错误并保留草稿', (tester) async {
    final key =
        'activity.workouts.v1.${base64Url.encode(utf8.encode('guest:'))}';
    SharedPreferences.setMockInitialValues({key: '{broken'});
    await openBuilder(tester, (_) {});
    expect((await SharedPreferences.getInstance()).getString(key), '{broken');
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();
    expect(
      find.text('Não foi possível salvar neste dispositivo. Tente novamente.'),
      findsOneWidget,
    );
    expect(find.text('Supino reto com barra'), findsOneWidget);
    expect((await SharedPreferences.getInstance()).getString(key), '{broken');
  });
  testWidgets('保存期间返回后完成保存不会关闭新页面', (tester) async {
    final store = _DelayedStore();
    await openBuilder(tester, (_) {}, store: store);
    await tester.tap(find.text('Salvar'));
    await tester.pump();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    final context = tester.element(find.text('Abrir'));
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const Scaffold(body: Text('Novo destino')),
      ),
    );
    await tester.pumpAndSettle();
    store.completer.complete();
    await tester.pumpAndSettle();
    expect(find.text('Novo destino'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

class _DelayedStore extends LocalWorkoutStore {
  _DelayedStore() : super(null);
  final completer = Completer<void>();
  @override
  Future<void> add(LocalWorkoutPlan plan) => completer.future;
}
