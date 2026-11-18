import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:new_jcvital/design_system/components/app_frosted_modal_sheet.dart';
import 'package:new_jcvital/design_system/components/app_button.dart';
import 'package:new_jcvital/features/activity/data/local_workout_store.dart';
import 'package:new_jcvital/features/activity/presentation/models/exercise_catalog_item.dart';
import 'package:new_jcvital/features/activity/presentation/models/workout_draft_exercise.dart';
import 'package:new_jcvital/features/activity/presentation/activity_selection_flow.dart';
import 'package:new_jcvital/features/activity/presentation/pages/activity_preparation_page.dart';
import 'package:new_jcvital/features/activity/presentation/widgets/activity_selection_sheet.dart';
import 'package:new_jcvital/features/activity/presentation/widgets/strength_workout_sheet.dart';
import 'package:new_jcvital/features/activity/presentation/widgets/workout_builder_sheet.dart';
import 'package:new_jcvital/features/activity/presentation/widgets/workout_delete_confirmation_sheet.dart';
import 'package:new_jcvital/features/activity/presentation/widgets/exercise_selection_sheet.dart';
import 'package:new_jcvital/features/activity/presentation/widgets/exercise_anatomy.dart';
import 'package:new_jcvital/l10n/generated/app_localizations.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });
  testWidgets('运动列表退出后才打开训练磨砂叶片，无计划开始进入准备页', (tester) async {
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
              onPressed: () => openActivitySelection(context),
              child: const Text('Abrir'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Musculação').first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.byType(ActivitySelectionSheet), findsOneWidget);
    expect(find.byType(StrengthWorkoutSheet), findsNothing);
    await tester.pumpAndSettle();
    expect(find.byType(ActivitySelectionSheet), findsNothing);
    expect(find.byType(StrengthWorkoutSheet), findsOneWidget);
    expect(find.byType(AppFrostedModalSheet), findsOneWidget);
    expect(find.text('Começar sem plano'), findsOneWidget);
    expect(
      find.text('Modelos de demonstração · não são treinos salvos'),
      findsOneWidget,
    );
    expect(find.text('Demonstração'), findsOneWidget);
    expect(find.text('4 exercícios · 9 séries'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.more_horiz).first);
    await tester.pumpAndSettle();
    expect(find.text('Editar'), findsOneWidget);
    expect(find.text('Duplicar'), findsOneWidget);
    expect(find.text('Apagar'), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Começar sem plano'));
    await tester.pumpAndSettle();
    expect(find.byType(ActivityPreparationPage), findsOneWidget);
    expect(find.byType(StrengthWorkoutSheet), findsNothing);
    expect(tester.takeException(), isNull);
  });
  testWidgets('窄屏取消力量训练面板后不会进入准备页', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => openActivitySelection(context),
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Strength training').first);
    await tester.pumpAndSettle();
    expect(find.text('Demo templates · not saved workouts'), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byType(StrengthWorkoutSheet), findsNothing);
    expect(find.byType(ActivityPreparationPage), findsNothing);
    expect(find.text('Open'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('新建训练等待列表退出，空训练禁用保存并可返回列表', (tester) async {
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
              onPressed: () => openActivitySelection(context),
              child: const Text('Abrir'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Musculação').first);
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Montar treino novo'),
      200,
      scrollable: find
          .descendant(
            of: find.byType(StrengthWorkoutSheet),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.tap(find.text('Montar treino novo'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byType(WorkoutBuilderSheet), findsNothing);
    await tester.pumpAndSettle();
    expect(find.byType(StrengthWorkoutSheet), findsNothing);
    expect(find.byType(WorkoutBuilderSheet), findsOneWidget);
    expect(find.text('Montar treino'), findsOneWidget);
    expect(find.text('0 EXERCÍCIOS · 0 SÉRIES'), findsOneWidget);
    expect(find.text('Monte o seu treino'), findsOneWidget);
    expect(
      tester
          .widget<FilledButton>(find.widgetWithText(FilledButton, 'Salvar'))
          .onPressed,
      isNull,
    );
    expect(
      tester
          .widget<FilledButton>(find.widgetWithText(FilledButton, 'Começar'))
          .onPressed,
      isNull,
    );
    await tester.enterText(find.byType(TextField), 'a' * 45);
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text.length,
      40,
    );
    tester.testTextInput.hide();
    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel('Adicionar exercícios').first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byType(ExerciseSelectionSheet), findsNothing);
    await tester.pumpAndSettle();
    expect(find.byType(ExerciseSelectionSheet), findsOneWidget);
    expect(find.text('218 exercícios'), findsOneWidget);
    expect(find.text('Supino reto com barra'), findsOneWidget);
    expect(
      tester
          .widget<FilledButton>(
            find.widgetWithText(FilledButton, 'Marque os exercícios'),
          )
          .onPressed,
      isNull,
    );
    await tester.tap(find.text('Supino reto com barra'));
    await tester.tap(find.text('Supino inclinado com barra'));
    await tester.pumpAndSettle();
    expect(find.text('Adicionar (2)'), findsOneWidget);
    await tester.tap(find.text('Adicionar (2)'));
    await tester.pumpAndSettle();
    expect(find.byType(WorkoutBuilderSheet), findsOneWidget);
    expect(find.text('2 EXERCÍCIOS · 6 SÉRIES'), findsOneWidget);
    expect(find.text('Supino reto com barra'), findsOneWidget);
    expect(find.text('600'), findsOneWidget);
    expect(find.text('3 séries · 10 × 10 kg'), findsNWidgets(2));
    expect(find.byType(ExerciseAnatomy), findsNWidgets(2));
    await tester.tap(find.text('Adicionar exercício'));
    await tester.pumpAndSettle();
    expect(find.byType(ExerciseSelectionSheet), findsOneWidget);
    await tester.tap(find.text('Adicionar (2)'));
    await tester.pumpAndSettle();
    expect(find.text('600'), findsOneWidget);
    expect(find.text('2 EXERCÍCIOS · 6 SÉRIES'), findsOneWidget);
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text.length,
      40,
    );
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byType(WorkoutBuilderSheet), findsNothing);
    expect(find.byType(StrengthWorkoutSheet), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('窄屏软键盘弹出时编辑器不发生溢出', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('pt', 'BR'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(viewInsets: const EdgeInsets.only(bottom: 300)),
          child: child!,
        ),
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => WorkoutBuilderSheet.show(context),
              child: const Text('Abrir'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    expect(find.byType(WorkoutBuilderSheet), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('保存后列表可重新选择，并将计划带到准备页', (tester) async {
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
              onPressed: () => openActivitySelection(context),
              child: const Text('Abrir'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Musculação').first);
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Montar treino novo'),
      200,
      scrollable: find
          .descendant(
            of: find.byType(StrengthWorkoutSheet),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.tap(find.text('Montar treino novo'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Treino local');
    tester.testTextInput.hide();
    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel('Adicionar exercícios').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Supino reto com barra'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Adicionar (1)'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();
    expect(find.text('Treino local'), findsOneWidget);
    expect(
      find.text('Salvo apenas neste dispositivo · não sincronizado'),
      findsOneWidget,
    );
    await tester.tap(find.text('Treino local'));
    await tester.pumpAndSettle();
    expect(find.byType(ActivityPreparationPage), findsOneWidget);
    expect(find.text('Treino local'), findsOneWidget);
    expect(
      find.text('Plano local · atividade ainda não iniciada'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
  testWidgets('本地训练菜单支持编辑、复制及取消或确认删除', (tester) async {
    final exercise = (await ExerciseCatalogItem.load()).first;
    final store = LocalWorkoutStore(null);
    await store.add(
      LocalWorkoutPlan(
        name: 'Treino local',
        exercises: [WorkoutDraftExercise(exercise)],
      ),
    );
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
              onPressed: () => openActivitySelection(context),
              child: const Text('Abrir'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Musculação').first);
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.more_horiz).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Editar'));
    await tester.pumpAndSettle();
    expect(find.text('Treino de força'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Treino alterado');
    tester.testTextInput.hide();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();
    expect(find.text('Treino alterado'), findsOneWidget);
    expect((await store.load()).length, 1);
    await tester.tap(find.byIcon(Icons.more_horiz).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Duplicar'));
    await tester.pumpAndSettle();
    expect(find.text('Treino alterado (2)'), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('Treino alterado (2)')).dy,
      lessThan(tester.getTopLeft(find.text('Treino alterado')).dy),
    );
    final copiedPlans = await store.load();
    expect(copiedPlans.length, 2);
    expect(copiedPlans.first.setCount, copiedPlans.last.setCount);
    await tester.tap(find.byIcon(Icons.more_horiz).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Apagar'));
    await tester.pumpAndSettle();
    expect(find.text('Apagar treino?'), findsOneWidget);
    expect(find.text('Cancelar'), findsNothing);
    expect(find.textContaining('continuam no histórico.'), findsOneWidget);
    final deleteButton = tester.widget<AppButton>(
      find.widgetWithText(AppButton, 'Apagar').last,
    );
    expect(deleteButton.variant, AppButtonVariant.primary);
    await tester.tap(find.byIcon(Icons.close).last);
    await tester.pumpAndSettle();
    expect((await store.load()).length, 2);
    await tester.tap(find.byIcon(Icons.more_horiz).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Apagar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Apagar').last);
    await tester.pumpAndSettle();
    expect(find.text('Treino alterado (2)'), findsNothing);
    expect((await store.load()).single.name, 'Treino alterado');
    expect(tester.takeException(), isNull);
  });
  testWidgets('示例训练可编辑、复制和删除，重新打开后状态保持', (tester) async {
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
              onPressed: () => openActivitySelection(context),
              child: const Text('Abrir'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Musculação').first);
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.more_horiz).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Editar'));
    await tester.pumpAndSettle();
    expect(find.text('4 EXERCÍCIOS · 9 SÉRIES'), findsOneWidget);
    expect(find.text('Supino reto com barra'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Modelo alterado');
    tester.testTextInput.hide();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();
    expect(find.text('Modelo alterado'), findsOneWidget);
    expect(find.text('Demonstração'), findsNothing);
    await tester.tap(find.byIcon(Icons.more_horiz).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Duplicar'));
    await tester.pumpAndSettle();
    expect(find.text('Modelo alterado (2)'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.more_horiz).at(1));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Apagar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Apagar').last);
    await tester.pumpAndSettle();
    expect(find.text('Modelo alterado'), findsNothing);
    expect(find.text('Modelo alterado (2)'), findsOneWidget);
    expect(await LocalWorkoutStore(null).hiddenDemoIds(), contains('demo:0'));
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Musculação').first);
    await tester.pumpAndSettle();
    expect(find.text('Demonstração'), findsNothing);
    expect(find.text('Modelo alterado (2)'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('编辑已有训练显示删除和动作区排序，确认删除后返回列表', (tester) async {
    final exercise = (await ExerciseCatalogItem.load()).first;
    final store = LocalWorkoutStore(null);
    await store.add(
      LocalWorkoutPlan(
        name: 'Treino local',
        exercises: [WorkoutDraftExercise(exercise)],
      ),
    );
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
              onPressed: () => openActivitySelection(context),
              child: const Text('Abrir'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Musculação').first);
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.more_horiz).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Editar'));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.delete_outline), findsOneWidget);
    expect(find.text('EXERCÍCIOS'), findsOneWidget);
    expect(find.byIcon(Icons.edit_outlined), findsOneWidget);
    expect(find.text('Valores iniciais de exemplo'), findsNothing);
    await tester.tap(find.byIcon(Icons.edit_outlined));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.drag_handle), findsOneWidget);
    await tester.tap(find.byIcon(Icons.check));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pumpAndSettle();
    expect(find.text('Apagar treino?'), findsOneWidget);
    expect(find.text('Cancelar'), findsNothing);
    expect(find.textContaining('continuam no histórico.'), findsOneWidget);
    final deleteButton = tester.widget<AppButton>(
      find.widgetWithText(AppButton, 'Apagar').last,
    );
    expect(deleteButton.variant, AppButtonVariant.primary);
    await tester.tap(find.byIcon(Icons.close).last);
    await tester.pumpAndSettle();
    expect(find.byType(WorkoutBuilderSheet), findsOneWidget);
    expect((await store.load()).length, 1);
    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Apagar').last);
    await tester.pumpAndSettle();
    expect(find.byType(WorkoutBuilderSheet), findsNothing);
    expect(find.byType(StrengthWorkoutSheet), findsOneWidget);
    expect(await store.load(), isEmpty);
    expect(tester.takeException(), isNull);
  });
  testWidgets('拖动手柄调整动作顺序并保存，退出编辑后恢复菜单', (tester) async {
    final catalog = await ExerciseCatalogItem.load();
    final store = LocalWorkoutStore(null);
    final plan = LocalWorkoutPlan(
      name: 'Treino para ordenar',
      exercises: [
        for (final item in catalog.take(3)) WorkoutDraftExercise(item),
      ],
    );
    await store.add(plan);
    final saved = (await store.load()).single;
    tester.view.physicalSize = const Size(400, 900);
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
              onPressed: () => WorkoutBuilderSheet.show(
                context,
                store: store,
                initialPlan: saved,
              ),
              child: const Text('Abrir'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.drag_handle), findsNothing);
    await tester.tap(find.byIcon(Icons.edit_outlined));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.drag_handle), findsNWidgets(3));
    final firstHandle = find.byIcon(Icons.drag_handle).first;
    final thirdHandle = find.byIcon(Icons.drag_handle).last;
    final gesture = await tester.startGesture(tester.getCenter(firstHandle));
    await tester.pump();
    await gesture.moveTo(tester.getCenter(thirdHandle) + const Offset(0, 40));
    await tester.pump(const Duration(milliseconds: 500));
    await gesture.up();
    await tester.pumpAndSettle();
    final names = catalog.take(3).map((item) => item.name).toList();
    expect(
      tester.getTopLeft(find.text(names[1])).dy,
      lessThan(tester.getTopLeft(find.text(names[0])).dy),
    );
    await tester.tap(find.byIcon(Icons.check));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.drag_handle), findsNothing);
    expect(find.byIcon(Icons.more_horiz), findsNWidgets(3));
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();
    expect(
      (await store.load()).single.exercises.map((e) => e.exercise.id).toList(),
      [catalog[1].id, catalog[0].id, catalog[2].id],
    );
    expect(tester.takeException(), isNull);
  });
  testWidgets('动作较多时拖动至列表边缘会自动滚动', (tester) async {
    final catalog = await ExerciseCatalogItem.load();
    final plan = LocalWorkoutPlan(
      name: 'Treino longo',
      exercises: [
        for (final item in catalog.take(12)) WorkoutDraftExercise(item),
      ],
    );
    tester.view.physicalSize = const Size(400, 700);
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
                  WorkoutBuilderSheet.show(context, initialPlan: plan),
              child: const Text('Abrir'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.edit_outlined));
    await tester.pumpAndSettle();
    final handle = find.byIcon(Icons.drag_handle).first;
    final scrollable = find
        .ancestor(of: handle, matching: find.byType(Scrollable))
        .first;
    final position = tester.state<ScrollableState>(scrollable).position;
    final start = position.pixels;
    final list = find.byType(CustomScrollView).last;
    final gesture = await tester.startGesture(tester.getCenter(handle));
    await tester.pump();
    await gesture.moveTo(tester.getBottomLeft(list) + const Offset(200, -5));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(seconds: 1));
    expect(position.pixels, greaterThan(start));
    await gesture.up();
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
  testWidgets('删除确认在窄屏长名称下仍可关闭和确认', (tester) async {
    tester.view.physicalSize = const Size(320, 320);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    bool? result;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('pt', 'BR'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () async {
                result = await WorkoutDeleteConfirmationSheet.show(
                  context,
                  name: 'Treino de demonstração muito comprido',
                );
              },
              child: const Text('Abrir'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    expect(find.text('Apagar treino?'), findsOneWidget);
    expect(find.text('Apagar'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.tap(find.byIcon(Icons.close).last);
    await tester.pumpAndSettle();
    expect(result, isFalse);
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Apagar'));
    await tester.pumpAndSettle();
    expect(result, isTrue);
    expect(tester.takeException(), isNull);
  });
  testWidgets('复制示例及其副本后按原型置顶并保留组数', (tester) async {
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
              onPressed: () => openActivitySelection(context),
              child: const Text('Abrir'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Musculação').first);
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.more_horiz).at(1));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Duplicar'));
    await tester.pumpAndSettle();
    expect(find.text('Pernas e glúteos (2)'), findsOneWidget);
    var plans = await LocalWorkoutStore(null).load();
    expect(plans.first.exercises.length, 5);
    expect(plans.first.setCount, 17);
    await tester.tap(find.byIcon(Icons.more_horiz).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Duplicar'));
    await tester.pumpAndSettle();
    expect(find.text('Pernas e glúteos (2) (2)'), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('Pernas e glúteos (2) (2)')).dy,
      lessThan(tester.getTopLeft(find.text('Pernas e glúteos (2)')).dy),
    );
    plans = await LocalWorkoutStore(null).load();
    expect(plans.map((p) => p.setCount), [17, 17]);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Musculação').first);
    await tester.pumpAndSettle();
    expect(find.text('Pernas e glúteos (2) (2)'), findsOneWidget);
    expect(find.text('Pernas e glúteos (2)'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
