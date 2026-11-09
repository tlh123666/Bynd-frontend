import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:new_jcvital/core/network/api_client.dart';
import 'package:new_jcvital/features/atlas/data/atlas_repository.dart';
import 'package:new_jcvital/features/atlas/data/models/capabilities.dart';

import '../../support/fake_http_client.dart';

/// 线上 dev 环境的真实响应（2026-11-08 采集，用户 16859ab2）。
///
/// 刻意不用手工构造的 JSON：手写的样例总是恰好长得跟模型一致，
/// 而真实响应会带上 omitempty 缺字段、空字符串、`status: "available"`
/// 这类只有上线才知道的细节。第一版在这里就抓到了 `status` 判断写错。
String fixture(String name) =>
    File('test/fixtures/$name.json').readAsStringSync();

AtlasRepository _repository(FakeHttpClient fake) {
  return AtlasRepository(
    ApiClient(
      baseUrl: Uri.parse('https://api.test.local'),
      tokenProvider: () async => 'tok',
      localeProvider: () => 'pt-BR',
      enableLogging: false,
      client: fake.client,
    ),
  );
}

/// 用真实 fixture 原样返回。fixture 里已经是完整的 `{code,msg,data}`。
FakeHttpClient _fakeReturning(String name) =>
    FakeHttpClient((_) async => jsonResponse(fixture(name)));

void main() {
  group('workspace（真实响应）', () {
    late final AtlasRepository repository;
    late final FakeHttpClient fake;

    setUpAll(() {
      fake = _fakeReturning('workspace');
      repository = _repository(fake);
    });

    test('解析核心时间字段，dataDate 为空时保持空而不是编造今天', () async {
      final workspace = await repository.fetchWorkspace();

      expect(workspace.analysisDate, '2026-11-08');
      // 该用户当天没有同步数据，后端下发空串。界面必须显示「未知」，
      // 不能回落到 analysisDate——那正好是「把旧数据当成今天」。
      expect(workspace.dataDate, isEmpty);
      expect(workspace.generatedAt, isNotEmpty);
    });

    test('方向带 identity 三元组，可跨页面引用同一条', () async {
      final workspace = await repository.fetchWorkspace();
      final direction = workspace.dailyDirection;

      expect(direction, isNotNull);
      expect(direction!.directionId, isNotEmpty);
      expect(direction.version, greaterThanOrEqualTo(1));
      expect(direction.evidenceSnapshotId, isNotEmpty);
      expect(direction.action, isNotEmpty);
      expect(direction.revised, isTrue);
      expect(direction.revisionReason, isNotEmpty);
    });

    test('训练建议在数据不足时仍可解析，score 与 plan 缺失保持 null', () async {
      final workspace = await repository.fetchWorkspace();
      final training = workspace.trainingReadiness;

      expect(training, isNotNull);
      expect(training!.level, 'insufficient');
      // 该用户数据不足，后端不返回 score 与 plan（omitempty）。
      // 缺失时不能当 0 分——那会被读成「状态极差」。
      expect(training.score, isNull);
      expect(training.plan, isNull);
      expect(training.disclaimer, isNotEmpty);
    });

    test('早期信号解析出 level/state 与版本号', () async {
      final workspace = await repository.fetchWorkspace();
      final signal = workspace.earlySignal;

      expect(signal, isNotNull);
      expect(signal!.state, 'watching');
      expect(signal.algorithmVersion, isNotEmpty);
      expect(signal.baselineVersion, isNotEmpty);
      expect(signal.changedSignals, isEmpty);
    });

    test('能力切片 8 条全部可导航，state 取值是 available 而非 active', () async {
      final workspace = await repository.fetchWorkspace();
      final slice = workspace.capabilities;

      expect(slice.capabilities.length, 8);
      expect(slice.visibleCapabilities.length, 8);
      // 锁定真实取值。曾经把可导航判定写成 status == 'active'，
      // 状态机里没有这个值，结果 8 个入口全部静默消失。
      expect(slice.capabilities.map((c) => c.status).toSet(), {'available'});
      expect(slice.has('home.daily_direction'), isTrue);
      expect(slice.byKey('home.daily_direction')!.route, isNotEmpty);
    });

    test('一条能力带多个导航入口与动作，不能只取顶层 route', () async {
      // home.daily_direction 在真实响应里有 3 个入口，顶层 route 只是其中一个
      // （/home）。只读 route 会让「查看完整方向」「看支撑这条方向的洞察」
      // 两个入口连文案都拿不到。
      final workspace = await repository.fetchWorkspace();
      final capability = workspace.capabilities.byKey('home.daily_direction')!;

      expect(capability.navigation.length, 3);
      expect(capability.navigation.map((n) => n.route),
          contains('/direction/today'));

      final detail = capability.navigation
          .firstWhere((n) => n.route == '/direction/today');
      expect(detail.label, '查看完整方向');
      expect(detail.precondition, '当天已生成方向');
      expect(detail.isConditional, isTrue);

      // 动作是动作链的客户端一半：是否要确认、能否撤销都从这里读。
      expect(capability.actions, isNotEmpty);
      final navigate =
          capability.actions.firstWhere((a) => a.id == 'navigate.direction_detail');
      expect(navigate.isNavigation, isTrue);
      expect(navigate.requiresConfirmation, isFalse);
      expect(navigate.reversible, isTrue);
    });

    test('首次进入时每个入口都带文案，动作按能力区分', () async {
      final workspace = await repository.fetchWorkspace();

      for (final capability in workspace.capabilities.capabilities) {
        expect(capability.navigation, isNotEmpty,
            reason: '${capability.key} 没有任何导航入口');
        expect(capability.navigation.every((n) => n.label.isNotEmpty), isTrue,
            reason: '${capability.key} 的入口缺少文案');
      }

      // community.groups 只有入口、没有动作，不能因为缺字段就伪造一个。
      final community = workspace.capabilities.byKey('community.groups')!;
      expect(community.navigation, hasLength(1));
      expect(community.actions, isEmpty);
    });

    test('能力门槛字段当前为空，解析不崩也不伪造默认门槛', () async {
      // 对应已知问题 B3：8 条能力的 Platforms/MinAppVersion 全空，
      // 后端不做任何平台或版本过滤。客户端拿到空列表应理解为「无限制」，
      // 而不是「什么都不允许」。
      final workspace = await repository.fetchWorkspace();
      final capability = workspace.capabilities.byKey('exercise.summary')!;

      expect(capability.tiers, isEmpty);
      expect(capability.platforms, isEmpty);
      expect(capability.minAppVersion, isNull);
      expect(capability.consentCategory, isNull);
    });

    test('quickPrompts 解析为可发送的建议', () async {
      final workspace = await repository.fetchWorkspace();

      expect(workspace.quickPrompts.length, 3);
      expect(workspace.quickPrompts.first.id, 'sleep');
      expect(workspace.quickPrompts.first.text, isNotEmpty);
    });

    test('readiness 如实反映历史天数', () async {
      final workspace = await repository.fetchWorkspace();

      expect(workspace.readiness.historyDays, 0);
      expect(workspace.readiness.readyForInsights, isFalse);
    });

    test('请求带上时区与语言，避免用 UTC 日期算「今天」', () async {
      await repository.fetchWorkspace();

      final query = fake.lastRequest.url.queryParameters;
      expect(query['timezone'], 'America/Sao_Paulo');
      expect(query['locale'], 'pt-BR');
      // compact 为 false 时不传，避免每个请求都多一个无意义参数。
      expect(query.containsKey('compact'), isFalse);
    });
  });

  group('capabilities（真实响应）', () {
    test('档位与来源状态分开表达，能说清「为什么读不到」', () async {
      final repository = _repository(_fakeReturning('capabilities'));

      final capabilities = await repository.fetchCapabilities();

      expect(capabilities.tier, 'free');
      expect(capabilities.rawHistoryDays, 30);
      expect(capabilities.baselineWindows, [7, 30]);
      expect(capabilities.sources, isNotEmpty);

      final diary = capabilities.sources
          .firstWhere((source) => source.key == 'diary.context_items');
      // 这个来源需要授权但用户没给，界面应提示去授权，而不是「暂无数据」。
      expect(diary.available, isTrue);
      expect(diary.consentRequired, isTrue);
      expect(diary.consentGranted, isFalse);
      expect(diary.blocker, CapabilitySourceBlocker.consent);
      expect(diary.isReadable, isFalse);

      final dailyMetrics = capabilities.sources
          .firstWhere((source) => source.key == 'health.daily_metrics');
      expect(dailyMetrics.isReadable, isTrue);
      expect(dailyMetrics.blocker, CapabilitySourceBlocker.none);
    });
  });

  group('insights（真实响应）', () {
    test('没有可展示洞察时得到空列表', () async {
      final repository = _repository(_fakeReturning('insights'));

      final insights = await repository.fetchInsights();

      expect(insights.items, isEmpty);
      expect(insights.isEmpty, isTrue);
    });

    test('data 为 null 时按空列表处理，列表页不报错', () async {
      final repository = _repository(
        FakeHttpClient((_) async => okResponse(null)),
      );

      final insights = await repository.fetchInsights();

      expect(insights.items, isEmpty);
    });
  });

  group('异常路径', () {
    test('workspace 缺 payload 时得到空工作台，界面不崩', () async {
      final repository = _repository(
        FakeHttpClient((_) async => okResponse(null)),
      );

      // ApiClient 把 `data:null` 归一成空 map，与「空工作台」已不可区分；
      // 模型每个字段都有默认值，所以这里得到空态而不是异常——这比让整页
      // 报错更合理（后端加字段或暂时无快照时用户仍能进主页）。
      final workspace = await repository.fetchWorkspace();

      expect(workspace.analysisDate, isEmpty);
      expect(workspace.capabilities.capabilities, isEmpty);
    });

    test('业务错误向上抛 ApiException，由界面决定提示', () async {
      final repository = _repository(
        FakeHttpClient((_) async => businessErrorResponse(100002, '参数错误')),
      );

      await expectLater(
        repository.fetchInsights(),
        throwsA(isA<ApiException>()),
      );
    });
  });

  group('字段缺失的容错', () {
    test('空对象也能解析出空工作台，不抛异常', () async {
      // 后端加字段、改可空性时客户端应该还能跑。只有真正必需的字段
      // （洞察 id、登录令牌）才允许抛错。
      final repository = _repository(
        FakeHttpClient((_) async => okResponse(<String, dynamic>{})),
      );

      final workspace = await repository.fetchWorkspace();

      expect(workspace.analysisDate, isEmpty);
      expect(workspace.dailyDirection, isNull);
      expect(workspace.readiness.historyDays, 0);
      expect(workspace.capabilities.capabilities, isEmpty);
    });

    test('数值被序列化成字符串时仍然解析', () async {
      // 旧版本后端有几处 int64 在 JSON 里是字符串，解析器必须容错。
      final repository = _repository(
        FakeHttpClient(
          (_) async => okResponse({
            'readiness': {
              'historyDays': '12',
              'hasTodaySummary': 'true',
              'readyForInsights': 1,
            },
          }),
        ),
      );

      final workspace = await repository.fetchWorkspace();

      expect(workspace.readiness.historyDays, 12);
      expect(workspace.readiness.hasTodaySummary, isTrue);
      expect(workspace.readiness.readyForInsights, isTrue);
    });
  });
}
