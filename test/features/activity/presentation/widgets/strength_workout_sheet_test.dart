import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_jcvital/design_system/components/app_frosted_modal_sheet.dart';
import 'package:new_jcvital/features/activity/presentation/activity_selection_flow.dart';
import 'package:new_jcvital/features/activity/presentation/pages/activity_preparation_page.dart';
import 'package:new_jcvital/features/activity/presentation/widgets/activity_selection_sheet.dart';
import 'package:new_jcvital/features/activity/presentation/widgets/strength_workout_sheet.dart';
import 'package:new_jcvital/features/activity/presentation/widgets/workout_builder_sheet.dart';
import 'package:new_jcvital/features/activity/presentation/widgets/exercise_selection_sheet.dart';
import 'package:new_jcvital/l10n/generated/app_localizations.dart';

void main() {
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
    await tester.tap(find.text('Demonstração'));
    await tester.pumpAndSettle();
    expect(
      find.text('Os modelos e o editor ainda não estão conectados.'),
      findsOneWidget,
    );
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
    expect(
      find.text('2 exercícios selecionados · demonstração'),
      findsOneWidget,
    );
    expect(find.text('Supino reto com barra'), findsOneWidget);
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
}
