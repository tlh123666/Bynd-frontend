import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_jcvital/features/activity/presentation/models/exercise_catalog_item.dart';
import 'package:new_jcvital/features/activity/presentation/widgets/exercise_selection_sheet.dart';
import 'package:new_jcvital/l10n/generated/app_localizations.dart';

void main() {
  testWidgets('资源请求失败时目录仍可加载且与原型数据一致', (tester) async {
    var assetRequests = 0;
    tester.binding.defaultBinaryMessenger.setMockMessageHandler(
      'flutter/assets',
      (message) async {
        assetRequests++;
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMessageHandler(
        'flutter/assets',
        null,
      ),
    );
    final items = await ExerciseCatalogItem.load();
    final source =
        jsonDecode(File('assets/data/exercise_catalog.json').readAsStringSync())
            as List<dynamic>;
    expect(assetRequests, 0);
    expect(items, hasLength(218));
    expect(items.map((e) => e.id).toSet(), hasLength(218));
    for (var index = 0; index < source.length; index++) {
      final row = source[index] as Map<String, dynamic>;
      expect(items[index].id, row['id']);
      expect(items[index].name, row['name']);
      expect(items[index].muscles, row['muscles']);
      expect(items[index].equipment, row['equipment']);
      expect(items[index].group, row['group']);
    }
  });
  testWidgets('目录按肌肉、器械和不带重音的搜索过滤并支持多选', (tester) async {
    tester.view.physicalSize = const Size(400, 804);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    List<ExerciseCatalogItem>? result;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('pt', 'BR'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () async =>
                  result = await ExerciseSelectionSheet.show(context),
              child: const Text('Abrir'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    expect(find.text('218 exercícios'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'supino inclinado');
    await tester.pumpAndSettle();
    expect(find.text('Supino inclinado com barra'), findsOneWidget);
    await tester.tap(find.text('Supino inclinado com barra'));
    await tester.enterText(find.byType(TextField), 'triceps');
    await tester.pumpAndSettle();
    expect(find.text('Adicionar (1)'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'nenhum-exercicio-xyz');
    await tester.pumpAndSettle();
    expect(find.text('Nenhum exercício encontrado.'), findsOneWidget);
    await tester.tap(find.text('Adicionar (1)'));
    await tester.pumpAndSettle();
    expect(result?.single.id, 'supino-incl-barra');
    expect(tester.takeException(), isNull);
  });
  testWidgets('再次选择时可以取消最后一项并确认清空', (tester) async {
    tester.view.physicalSize = const Size(400, 804);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    List<ExerciseCatalogItem>? result;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('pt', 'BR'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () async => result = await ExerciseSelectionSheet.show(
                context,
                initialIds: {'supino'},
              ),
              child: const Text('Abrir'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Supino reto com barra'));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<FilledButton>(find.widgetWithText(FilledButton, 'Confirmar'))
          .onPressed,
      isNotNull,
    );
    await tester.tap(find.text('Confirmar'));
    await tester.pumpAndSettle();
    expect(result, isEmpty);
    expect(tester.takeException(), isNull);
  });
}
