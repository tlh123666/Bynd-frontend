import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_jcvital/features/activity/presentation/models/exercise_catalog_item.dart';
import 'package:new_jcvital/features/activity/presentation/widgets/exercise_selection_sheet.dart';
import 'package:new_jcvital/features/activity/presentation/widgets/exercise_detail_sheet.dart';
import 'package:new_jcvital/features/activity/presentation/widgets/exercise_anatomy.dart';
import 'package:new_jcvital/features/activity/presentation/models/exercise_anatomy_assets.dart';
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
      expect(items[index].tip, row['tip']);
      expect(items[index].level, row['level']);
      expect(items[index].unit, row['unit']);
      expect(items[index].bodyweight, row['bodyweight']);
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
  testWidgets('动作缩略图独立打开详情，未选时可标记，已选时不重复显示按钮', (tester) async {
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
              onPressed: () => ExerciseSelectionSheet.show(context),
              child: const Text('Abrir'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    expect(
      find.byKey(
        const ValueKey<String>('anatomy-supino-still'),
        skipOffstage: false,
      ),
      findsOneWidget,
    );
    await tester.tap(
      find.bySemanticsLabel('Como fazer: Supino reto com barra'),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.byType(ExerciseDetailSheet), findsOneWidget);
    expect(find.text('Marcar para adicionar'), findsOneWidget);
    expect(
      find.text('Escápulas juntas, barra desce até o meio do peito.'),
      findsOneWidget,
    );
    final motionFinder = find.byKey(
      const ValueKey<String>('anatomy-supino-motion'),
      skipOffstage: false,
    );
    expect(motionFinder, findsOneWidget);
    expect(
      (tester.widget<Image>(motionFinder).image as AssetImage).assetName,
      endsWith('supino-motion-hd.webp'),
    );
    await tester.binding.handlePopRoute();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump();
    expect(find.text('Marque os exercícios'), findsOneWidget);
    await tester.tap(
      find.bySemanticsLabel('Como fazer: Supino reto com barra'),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    await tester.tap(find.text('Marcar para adicionar'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.byType(ExerciseDetailSheet), findsNothing);
    await tester.pump();
    expect(find.text('Adicionar (1)'), findsOneWidget);
    await tester.tap(
      find.bySemanticsLabel('Como fazer: Supino reto com barra'),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.byType(ExerciseDetailSheet), findsOneWidget);
    expect(find.text('Marcar para adicionar'), findsNothing);
    await tester.binding.handlePopRoute();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.text('Adicionar (1)'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  test('原型动作素材均已生成且与目录中的动作匹配', () async {
    final catalog = await ExerciseCatalogItem.load();
    final ids = catalog.map((item) => item.id).toSet();
    expect(exerciseAnatomyLegends, hasLength(181));
    final referencedAssets = <String>{};
    for (final id in exerciseAnatomyLegends.keys) {
      expect(ids, contains(id));
      final assetId = exerciseAnatomyAssetId(id);
      expect(exerciseAnatomyLegends, contains(assetId));
      referencedAssets.add(assetId);
      expect(
        File('assets/images/exercise_anatomy/$assetId-still.webp').existsSync(),
        isTrue,
      );
      expect(
        File(
          'assets/images/exercise_anatomy/$assetId-motion-hd.webp',
        ).existsSync(),
        isTrue,
      );
      expect(
        File(
          'assets/images/exercise_anatomy/$assetId-still-hd.webp',
        ).existsSync(),
        isTrue,
      );
    }
    expect(referencedAssets, hasLength(139));
    final files = Directory(
      'assets/images/exercise_anatomy',
    ).listSync().whereType<File>().where((file) => file.path.endsWith('.webp'));
    expect(files, hasLength(referencedAssets.length * 3));
  });
  testWidgets('减少动态效果时使用静态动作，已选择的详情不显示添加按钮', (tester) async {
    tester.view.physicalSize = const Size(400, 804);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final exercise = (await ExerciseCatalogItem.load()).firstWhere(
      (item) => item.id == 'supino',
    );
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('pt', 'BR'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(disableAnimations: true),
          child: child!,
        ),
        home: Scaffold(
          body: ExerciseDetailSheet(exercise: exercise, selected: true),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      find.byKey(
        const ValueKey<String>('anatomy-supino-still'),
        skipOffstage: false,
      ),
      findsOneWidget,
    );
    expect(
      find.byKey(
        const ValueKey<String>('anatomy-supino-motion'),
        skipOffstage: false,
      ),
      findsNothing,
    );
    final still = tester.widget<Image>(
      find.byKey(
        const ValueKey<String>('anatomy-supino-still'),
        skipOffstage: false,
      ),
    );
    expect(
      (still.image as AssetImage).assetName,
      endsWith('supino-still-hd.webp'),
    );
    expect(find.text('Marcar para adicionar'), findsNothing);
    expect(tester.takeException(), isNull);
  });
  test('动画素材可通过 Flutter 资源包加载并解码为多帧', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final data = await rootBundle.load(
      'assets/images/exercise_anatomy/supino-motion-hd.webp',
    );
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    expect(codec.frameCount, greaterThan(1));
    final frame = await codec.getNextFrame();
    expect(frame.image.width, 600);
    frame.image.dispose();
    codec.dispose();
  });
  testWidgets('原型未提供人体模型时显示回退并保留添加入口', (tester) async {
    tester.view.physicalSize = const Size(400, 804);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final item = (await ExerciseCatalogItem.load()).firstWhere(
      (item) => !exerciseAnatomyLegends.containsKey(item.id),
    );
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('pt', 'BR'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: ExerciseDetailSheet(exercise: item, selected: false),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      find.bySemanticsLabel('Animação não disponível para este exercício.'),
      findsOneWidget,
    );
    expect(find.text('Marcar para adicionar'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('重复动作通过别名加载同一图片并保留原动作 ID', (tester) async {
    final items = await ExerciseCatalogItem.load();
    final alias = items.firstWhere((item) => item.id == 'flexao-diamante');
    expect(exerciseAnatomyAssetId(alias.id), 'flexao');
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: ExerciseAnatomy(exercise: alias, size: 40)),
      ),
    );
    await tester.pump();
    final image = tester.widget<Image>(
      find.byKey(const ValueKey<String>('anatomy-flexao-diamante-still')),
    );
    expect(
      (image.image as AssetImage).assetName,
      'assets/images/exercise_anatomy/flexao-still.webp',
    );
    expect(tester.takeException(), isNull);
  });
}
