import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

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
    await _pumpSelectionSheet(tester);

    expect(find.text('RECENTES'), findsOneWidget);
    expect(find.text('CARDIO'), findsOneWidget);
    expect(find.text('Corrida'), findsWidgets);
    expect(find.text('Buscar entre 140 modalidades'), findsOneWidget);
    expect(activityTypeNamesPtBr['barrys'], "Barry's (corrida + força)");
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
    expect(find.byIcon(Icons.pool), findsWidgets);
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
