import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:new_jcvital/design_system/components/app_bottom_nav.dart';
import 'package:new_jcvital/features/activity/presentation/pages/activity_overview_page.dart';
import 'package:new_jcvital/core/network/api_client.dart';
import 'package:new_jcvital/features/atlas/application/atlas_scope.dart';
import 'package:new_jcvital/features/atlas/data/atlas_repository.dart';
import 'package:new_jcvital/features/home/home_page.dart';
import 'package:new_jcvital/features/home/home_sky_background.dart';
import 'package:new_jcvital/features/profile/profile_page.dart';

void main() {
  // IndexedStack 现在包含 ATLAS 会话页（didChangeDependencies 里取 AtlasScope），
  // 与真实树一致：auth_gate 用 AtlasScope 包住整个 app。
  Future<void> pumpHome(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AtlasScope(
          repository: AtlasRepository(
            ApiClient(
              baseUrl: Uri.parse('https://api.example.com'),
              tokenProvider: () async => null,
            ),
          ),
          child: const HomePage(),
        ),
      ),
    );
  }

  testWidgets('活动页与首页复用同一个底部导航且只应用一次安全区', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ActivityOverviewPage()));

    expect(find.byType(AppBottomNav), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(AppBottomNav),
        matching: find.byType(SafeArea),
      ),
      findsOneWidget,
    );
    expect(
      find.ancestor(
        of: find.byType(AppBottomNav),
        matching: find.byType(SafeArea),
      ),
      findsNothing,
    );
  });

  testWidgets('活动页点首页后返回并同步首页选中标签', (tester) async {
    await pumpHome(tester);

    await tester.tap(
      find.descendant(
        of: find.byType(AppBottomNav),
        matching: find.bySemanticsLabel('Comunidade'),
      ),
    );
    await tester.pump();
    expect(
      tester.widget<AppBottomNav>(find.byType(AppBottomNav)).selectedIndex,
      2,
    );

    await tester.tap(find.bySemanticsLabel('Ações rápidas'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Iniciar\natividade'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Fechar'));
    await tester.pumpAndSettle();

    await tester.tap(
      find.descendant(
        of: find.byType(AppBottomNav),
        matching: find.bySemanticsLabel('Hoje'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(ActivityOverviewPage), findsNothing);
    expect(
      tester.widget<AppBottomNav>(find.byType(AppBottomNav)).selectedIndex,
      0,
    );
  });

  testWidgets('从资料页进入活动后点首页会正确返回根页面', (tester) async {
    await pumpHome(tester);

    await tester.tap(find.byTooltip('Menu'));
    await tester.pumpAndSettle();
    // 侧菜单在加入 ATLAS 会话与洞察入口后条目超出首屏，「Ajustes」
    // 需要滚动到可视区才能点到。
    await tester.scrollUntilVisible(
      find.text('Ajustes'),
      120,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ajustes'));
    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel('Ações rápidas'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Iniciar\natividade'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Fechar'));
    await tester.pumpAndSettle();

    await tester.tap(
      find.descendant(
        of: find.byType(AppBottomNav),
        matching: find.bySemanticsLabel('Hoje'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(ProfilePage), findsNothing);
    expect(find.byType(ActivityOverviewPage), findsNothing);
    expect(
      tester.widget<AppBottomNav>(find.byType(AppBottomNav)).selectedIndex,
      0,
    );
  });

  testWidgets('首页背景覆盖完整手机视口且没有渲染异常', (tester) async {
    tester.view.physicalSize = const Size(456, 990);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await pumpHome(tester);

    expect(
      tester.getSize(find.byType(HomeSkyBackground)),
      const Size(456, 990),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('首页容忍浏览器初始化时的 1×1 临时视口', (tester) async {
    tester.view.physicalSize = const Size(1, 1);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await pumpHome(tester);

    expect(tester.takeException(), isNull);
  });

  testWidgets('首页快捷入口先进入活动页，再自动打开选择面板', (tester) async {
    await pumpHome(tester);

    await tester.tap(find.bySemanticsLabel('Ações rápidas'));
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
    await pumpHome(tester);

    await tester.tap(find.bySemanticsLabel('Ações rápidas'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Iniciar\natividade'));
    await tester.pumpAndSettle();

    expect(find.text('Buscar entre 140 modalidades'), findsOneWidget);
    // 页面下方也会展示最近运动，选择目录中的最后一个可见同名项目。
    await tester.tap(find.text('Corrida').last);
    await tester.pumpAndSettle();

    expect(find.text('Pulseira não integrada'), findsOneWidget);
    expect(find.text('Iniciar atividade'), findsOneWidget);
    expect(find.text('Registrar o percurso'), findsOneWidget);
  });

  testWidgets('资料页快捷入口复用目录并进入准备页', (tester) async {
    await pumpHome(tester);

    await tester.tap(find.byTooltip('Menu'));
    await tester.pumpAndSettle();
    // 侧菜单在加入 ATLAS 会话与洞察入口后条目超出首屏，「Ajustes」
    // 需要滚动到可视区才能点到。
    await tester.scrollUntilVisible(
      find.text('Ajustes'),
      120,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ajustes'));
    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel('Ações rápidas'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Iniciar\natividade'));
    await tester.pumpAndSettle();

    expect(find.text('Buscar entre 140 modalidades'), findsOneWidget);
    await tester.tap(find.text('Caminhada').last);
    await tester.pumpAndSettle();

    expect(find.text('Pulseira não integrada'), findsOneWidget);
    expect(find.text('Iniciar atividade'), findsOneWidget);
  });

  testWidgets('选择肌肉训练先进入无计划/计划入口', (tester) async {
    await pumpHome(tester);

    await tester.tap(find.bySemanticsLabel('Ações rápidas'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Iniciar\natividade'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Musculação').last);
    await tester.pumpAndSettle();

    expect(
      find.text('Modelos de demonstração · não são treinos salvos'),
      findsOneWidget,
    );
    expect(find.text('SEUS TREINOS'), findsOneWidget);
    expect(find.text('Demonstração'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Montar treino novo'),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('OUTRAS FORMAS'), findsOneWidget);
    await tester.drag(find.byType(Scrollable).last, const Offset(0, 1000));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Começar sem plano'));
    await tester.pumpAndSettle();

    expect(find.text('Pulseira não integrada'), findsOneWidget);
    expect(find.text('Musculação'), findsOneWidget);
  });
}
