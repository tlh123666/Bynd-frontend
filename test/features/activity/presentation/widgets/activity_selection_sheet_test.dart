import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:new_jcvital/design_system/tokens/app_colors.dart';
import 'package:new_jcvital/features/activity/domain/models/activity_type_catalog.dart';
import 'package:new_jcvital/features/activity/presentation/localization/activity_type_hints_pt_br.dart';
import 'package:new_jcvital/features/activity/presentation/localization/activity_type_names_pt_br.dart';
import 'package:new_jcvital/features/activity/presentation/widgets/activity_selection_sheet.dart';

void main() {
  test('pt-BR 标签覆盖目录中的每个活动 ID', () {
    expect(activityTypeNamesPtBr, hasLength(ActivityTypeCatalog.all.length));
    expect(
      activityTypeNamesPtBr.keys.toSet(),
      ActivityTypeCatalog.byId.keys.toSet(),
    );
  });

  test('所有活动都有副标题，且关键分流文案匹配原型', () {
    for (final type in ActivityTypeCatalog.all) {
      expect(activityTypeHintPtBr(type), isNotEmpty, reason: type.id);
    }

    expect(
      activityTypeHintPtBr(ActivityTypeCatalog.findById('hyrox')!),
      '16 etapas da prova',
    );
    expect(
      activityTypeHintPtBr(ActivityTypeCatalog.findById('natacao')!),
      'piscina e ritmo',
    );
    expect(
      activityTypeHintPtBr(ActivityTypeCatalog.findById('futebol')!),
      '2 tempos',
    );
    expect(
      activityTypeHintPtBr(ActivityTypeCatalog.findById('mma')!),
      'rounds',
    );
    expect(
      activityTypeHintPtBr(ActivityTypeCatalog.findById('games')!),
      'coração sem movimento',
    );
    expect(
      activityTypeHintPtBr(ActivityTypeCatalog.findById('esteira')!),
      'distância da máquina',
    );
  });

  testWidgets('展示最近活动和分组目录', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(456, 990);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await _pumpSelectionSheet(tester);

    final panel = find.byType(AnimatedSlide);
    final media = MediaQuery.of(tester.element(panel));
    final expectedTop =
        (media.viewPadding.top < 20 ? 20.0 : media.viewPadding.top) + 34;
    expect(tester.getTopLeft(panel).dy, closeTo(expectedTop, 1));
    expect(
      tester.getSize(panel).height,
      closeTo(media.size.height - expectedTop, 1),
    );
    expect(expectedTop, 54);
    expect(find.byType(BackdropFilter), findsNWidgets(2));
    expect(find.byType(ColorFiltered), findsOneWidget);
    expect(find.byType(ShaderMask), findsOneWidget);
    expect(find.text('RECENTES'), findsOneWidget);
    expect(find.text('CARDIO'), findsOneWidget);
    expect(find.text('Corrida'), findsWidgets);
    expect(find.byType(SvgPicture), findsWidgets);
    expect(find.text('Buscar entre 140 modalidades'), findsOneWidget);
    expect(tester.getSize(find.byType(TextField)).height, closeTo(44, 4));
    final searchField = tester.widget<TextField>(find.byType(TextField));
    expect(searchField.decoration?.prefixIconConstraints?.minWidth, 38);
    expect(searchField.decoration?.hintStyle?.color, AppColors.textPlaceholder);
    final searchIcon = tester.widget<Icon>(find.byIcon(Icons.search));
    expect(searchIcon.size, 18);
    expect(searchIcon.color, AppColors.textHalf);
    expect(
      tester.getTopLeft(find.byType(TextField)).dy -
          tester.getTopLeft(panel).dy,
      closeTo(74, 1),
    );
    expect(
      (tester.getCenter(find.text('Iniciar atividade')).dy -
              tester.getCenter(find.byIcon(Icons.close)).dy)
          .abs(),
      lessThan(1),
    );
    expect(activityTypeNamesPtBr['barrys'], "Barry's (corrida + força)");
  });

  testWidgets('运动条目悬停不铺底色，按下时只显示轻微反馈', (tester) async {
    await _pumpSelectionSheet(tester);

    final itemInkWell = tester.widget<InkWell>(
      find
          .ancestor(
            of: find.text('Corrida').first,
            matching: find.byType(InkWell),
          )
          .first,
    );
    final overlay = itemInkWell.overlayColor!;

    expect(overlay.resolve({WidgetState.hovered}), Colors.transparent);
    expect(overlay.resolve({WidgetState.pressed}), const Color(0x08FFFFFF));
  });

  testWidgets('点击面板外的遮罩会关闭面板', (tester) async {
    var selectionCompleted = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () async {
                await ActivitySelectionSheet.show(context);
                selectionCompleted = true;
              },
              child: const Text('Abrir'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(20, 20));
    await tester.pumpAndSettle();

    expect(selectionCompleted, isTrue);
    expect(find.text('Iniciar atividade'), findsNothing);
  });

  testWidgets('进场动画只移动面板本身，不多移动顶部留白', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(456, 990);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => ActivitySelectionSheet.show(context),
              child: const Text('Abrir'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Abrir'));
    await tester.pump(const Duration(milliseconds: 1));

    final panel = find.byType(AnimatedSlide);
    final top = tester.getTopLeft(panel).dy;
    expect(top, inInclusiveRange(900, 1010));

    await tester.pumpAndSettle();
    expect(tester.getTopLeft(panel).dy, closeTo(54, 1));
  });

  testWidgets('向下拖动面板把手会关闭面板', (tester) async {
    await _pumpSelectionSheet(tester);

    await tester.drag(find.text('Iniciar atividade'), const Offset(0, 300));
    await tester.pumpAndSettle();

    expect(find.text('Iniciar atividade'), findsNothing);
  });

  testWidgets('搜索忽略大小写和葡语重音，选择后返回稳定 ID', (tester) async {
    String? selectedId;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () async {
                final selected = await ActivitySelectionSheet.show(context);
                selectedId = selected?.id;
              },
              child: const Text('Abrir'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'NATACAO');
    await tester.pumpAndSettle();

    expect(find.text('Natação'), findsOneWidget);
    expect(find.text('piscina e ritmo'), findsOneWidget);
    expect(find.byType(SvgPicture), findsNWidgets(2));
    expect(find.text('Corrida'), findsNothing);

    await tester.tap(find.text('Natação'));
    await tester.pumpAndSettle();

    expect(selectedId, 'natacao');
  });

  testWidgets('无匹配搜索会给出明确的空结果提示', (tester) async {
    await _pumpSelectionSheet(tester);
    await tester.enterText(find.byType(TextField), 'atividade inexistente');
    await tester.pumpAndSettle();

    expect(
      find.text('Nenhuma modalidade com “atividade inexistente”. Use “Outro”.'),
      findsOneWidget,
    );
  });
}

Future<void> _pumpSelectionSheet(WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          body: TextButton(
            onPressed: () => ActivitySelectionSheet.show(context),
            child: const Text('Abrir'),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('Abrir'));
  await tester.pumpAndSettle();
}
