import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:new_jcvital/features/home/home_page.dart';

void main() {
  testWidgets('首页快捷入口先进入活动页，再自动打开选择面板', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomePage()));

    await tester.tap(find.byTooltip('Ações rápidas'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Iniciar\natividade'));
    await tester.pumpAndSettle();

    expect(find.text('Atividades'), findsOneWidget);
    expect(find.text('O que vamos fazer hoje?'), findsOneWidget);
    expect(find.text('Buscar entre 140 modalidades'), findsOneWidget);

    await tester.tap(find.byTooltip('Fechar'));
    await tester.pumpAndSettle();

    expect(find.text('O que vamos fazer hoje?'), findsOneWidget);
    expect(find.text('Iniciar atividade'), findsOneWidget);
  });

  testWidgets('首页选择普通活动后进入准备页', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomePage()));

    await tester.tap(find.byTooltip('Ações rápidas'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Iniciar\natividade'));
    await tester.pumpAndSettle();

    expect(find.text('Buscar entre 140 modalidades'), findsOneWidget);
    await tester.tap(find.text('Corrida').first);
    await tester.pumpAndSettle();

    expect(find.text('Pulseira não integrada'), findsOneWidget);
    expect(find.text('Iniciar atividade'), findsOneWidget);
    expect(find.text('Registrar o percurso'), findsOneWidget);
  });

  testWidgets('资料页快捷入口复用目录并进入准备页', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomePage()));

    await tester.tap(find.byTooltip('Menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ajustes'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Ações rápidas'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Iniciar\natividade'));
    await tester.pumpAndSettle();

    expect(find.text('Buscar entre 140 modalidades'), findsOneWidget);
    await tester.tap(find.text('Caminhada').first);
    await tester.pumpAndSettle();

    expect(find.text('Pulseira não integrada'), findsOneWidget);
    expect(find.text('Iniciar atividade'), findsOneWidget);
  });

  testWidgets('选择肌肉训练先进入无计划/计划入口', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomePage()));

    await tester.tap(find.byTooltip('Ações rápidas'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Iniciar\natividade'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Musculação').first);
    await tester.pumpAndSettle();

    expect(find.text('Como deseja começar?'), findsOneWidget);
    expect(find.text('Treinos salvos ainda não disponíveis'), findsOneWidget);
    expect(find.text('SEUS TREINOS'), findsOneWidget);
    expect(find.text('OUTRAS FORMAS'), findsOneWidget);
    expect(find.text('Montar treino novo'), findsOneWidget);

    await tester.tap(find.text('Começar sem plano'));
    await tester.pumpAndSettle();

    expect(find.text('Pulseira não integrada'), findsOneWidget);
    expect(find.text('Musculação'), findsOneWidget);
  });
}
