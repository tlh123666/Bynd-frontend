import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:new_jcvital/features/activity/data/local_workout_store.dart';
import 'package:new_jcvital/design_system/components/app_frosted_modal_sheet.dart';
import 'package:new_jcvital/design_system/components/app_frosted_surface.dart';
import 'package:new_jcvital/design_system/tokens/app_colors.dart';
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
    final footer = find.byKey(const ValueKey('workout-builder-footer'));
    expect(tester.widget<Visibility>(footer).visible, isFalse);
    // 仅上层滚轮面板加深，原训练面板仍使用公共默认玻璃色。
    final sheets = tester
        .widgetList<AppFrostedModalSheet>(find.byType(AppFrostedModalSheet))
        .toList();
    expect(sheets.first.surfaceTint, AppColors.sheetGlassTint);
    expect(sheets.last.surfaceTint, const Color(0xe614181e));
    final glass = find.descendant(
      of: find.byType(AppFrostedModalSheet).last,
      matching: find.byType(AppFrostedSurface),
    );
    expect(
      tester.widget<AppFrostedSurface>(glass.first).tintColor,
      const Color(0xe614181e),
    );
    final pickers = find.byType(CupertinoPicker);
    expect(pickers, findsNWidgets(2));
    (tester.widget<CupertinoPicker>(pickers.first).scrollController!)
        .jumpToItem(7);
    (tester.widget<CupertinoPicker>(pickers.last).scrollController!).jumpToItem(
      8,
    );
    await tester.pumpAndSettle();
    expect(find.text('360'), findsOneWidget);
    await tester.tap(find.bySemanticsLabel('Concluir').last);
    await tester.pumpAndSettle();
    expect(find.text('360'), findsOneWidget);
    expect(tester.widget<Visibility>(footer).visible, isTrue);
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();
    final plans = await LocalWorkoutStore(null).load();
    expect(plans.single.name, 'Meu treino');
    expect(plans.single.exercises.single.sets.first.amount, 8);
    expect(plans.single.exercises.single.sets.first.weight, 20);
  });

  testWidgets('点击遮罩关闭后保留滚轮的即时修改', (tester) async {
    await openBuilder(tester, (_) {});
    await tester.tap(find.byIcon(Icons.more_horiz));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Editar séries'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Série 1'));
    await tester.pumpAndSettle();
    final picker = tester.widget<CupertinoPicker>(
      find.byType(CupertinoPicker).first,
    );
    (picker.scrollController!).jumpToItem(7);
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(8, 8));
    await tester.pumpAndSettle();
    expect(find.text('280'), findsOneWidget);
    expect(
      tester
          .widget<Visibility>(
            find.byKey(const ValueKey('workout-builder-footer')),
          )
          .visible,
      isTrue,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('展开组数单行显示，新增和移除同步更新总量', (tester) async {
    await openBuilder(tester, (_) {});
    await tester.tap(find.byIcon(Icons.more_horiz));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Editar séries'));
    await tester.pumpAndSettle();
    final setName = tester.getCenter(find.text('Série 1'));
    final setValue = find.byWidgetPredicate(
      (w) => w is Text && w.textSpan?.toPlainText() == '10 × 10 kg',
    );
    expect(setValue, findsNWidgets(3));
    expect(tester.getCenter(setValue.first).dy, closeTo(setName.dy, 1));
    expect(find.byIcon(Icons.remove_circle_outline), findsNothing);
    await tester.tap(find.text('Adicionar série'));
    await tester.pumpAndSettle();
    expect(find.text('400'), findsOneWidget);
    await tester.tap(find.text('Série 1'));
    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel('Remover série').last);
    await tester.pumpAndSettle();
    expect(find.text('300'), findsOneWidget);
    expect(find.text('Série 4'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('删除最后一组时移除动作并恢复空状态', (tester) async {
    await openBuilder(tester, (_) {});
    await tester.tap(find.byIcon(Icons.more_horiz));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Editar séries'));
    await tester.pumpAndSettle();
    for (var i = 0; i < 3; i++) {
      await tester.tap(find.text('Série 1'));
      await tester.pumpAndSettle();
      await tester.tap(find.bySemanticsLabel('Remover série').last);
      await tester.pumpAndSettle();
    }
    expect(find.text('Monte o seu treino'), findsOneWidget);
    expect(find.text('0 EXERCÍCIOS · 0 SÉRIES'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('切换动作时只展开一个动作，标题可收起组数', (tester) async {
    await openBuilder(tester, (_) {});
    await tester.tap(find.byIcon(Icons.more_horiz));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Duplicar'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.more_horiz).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Editar séries'));
    await tester.pumpAndSettle();
    expect(find.text('Série 1'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.more_horiz).last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Editar séries'));
    await tester.pumpAndSettle();
    expect(find.text('Série 1'), findsOneWidget);
    await tester.tap(find.text('Supino reto com barra').last);
    await tester.pumpAndSettle();
    expect(find.text('Série 1'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('玻璃菜单包含五个操作，替换动作保留组数并可返回', (tester) async {
    await openBuilder(tester, (_) {});
    await tester.tap(find.byIcon(Icons.more_horiz));
    await tester.pumpAndSettle();
    expect(find.text('Editar séries'), findsOneWidget);
    expect(find.text('Trocar exercício'), findsOneWidget);
    expect(find.text('Duplicar'), findsOneWidget);
    expect(find.text('Ver como fazer'), findsOneWidget);
    expect(find.text('Remover'), findsOneWidget);
    await tester.tap(find.text('Trocar exercício'));
    await tester.pumpAndSettle();
    expect(find.text('Trocar exercício'), findsOneWidget);
    await tester.tap(find.text('Supino inclinado com barra'));
    await tester.pumpAndSettle();
    expect(find.text('Supino inclinado com barra'), findsOneWidget);
    expect(find.text('3 séries · 10 × 10 kg'), findsOneWidget);
    expect(find.text('300'), findsOneWidget);
    expect(tester.takeException(), isNull);
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
