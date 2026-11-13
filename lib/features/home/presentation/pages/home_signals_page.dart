import 'package:flutter/material.dart';
import '../../../../design_system/design_system.dart';
import '../../../../l10n/app_localizations_context.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/widgets/day_strip.dart';
import '../../application/home_controller.dart';
import '../../domain/home_models.dart';
import 'home_signal_detail_page.dart';
import '../widgets/home_account_guard.dart';

/// Saúde（Sinais）tab —— 按 BYND UI 源码复刻（public/sinais.html，modelo B：
/// 「o resumo de TODO o app em cartões」）。
///
/// 视觉对齐（03/11 Luiz 定稿的 `html.borda` 模式——卡片到屏幕边缘、
/// 圆角 24、中性底色 #1C1F24）：
/// * 背景 `--fundo-neutro`：#222C38 0% → #1A2029 22% → #121418 50%，固定不滚；
/// * 顶栏 54px、标题 17 居中（TabBar 里 Saúde 是一级 tab，无返回语义）；
/// * 分组标题 Urbanist 300 / 24 / -0.01em，图标 19；
/// * 卡片 170 高、radius 24、内边距 18/20/17、inset 高光；
/// * `.e` 状态词按 cor 着色（bom #8FCDB9 / atenção #F0C27A / neutro 灰）；
/// * `.v` 大数字 Urbanist 300：整行 46、并排 40，单位 small 14；
/// * 布局规则：1 卡整行；2 卡并排；3 卡 = 第一张整行 + 两张并排。
class HomeSignalsPage extends StatelessWidget {
  const HomeSignalsPage({
    required this.controller,
    this.showClose = true,
    super.key,
  });
  final HomeController controller;

  /// 作为底部 tab 根时没有上一页可关，隐藏头部关闭钮。
  final bool showClose;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _SinaisCss.bgBottom,
    body: DecoratedBox(
      // .topo：固定渐变背景，滚动时不动
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0, 0.22, 0.5],
          colors: [_SinaisCss.bgTop, _SinaisCss.bgMid, _SinaisCss.bgBottom],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: ListenableBuilder(
          listenable: controller,
          builder: (context, _) {
            final strings = context.l10n;
            return Column(
              children: [
                // .barra：54px、标题 17 居中
                SizedBox(
                  height: 54,
                  child: Center(
                    child: Text(
                      strings.health,
                      style: const TextStyle(
                        color: _SinaisCss.text,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                DayStrip(day: controller.day, onDayChanged: controller.setDay),
                Expanded(
                  child: controller.loading
                      ? const Center(child: AppLoadingIndicator())
                      : controller.error != null
                      ? Center(
                          child: AppButton(
                            label: context.l10n.homeRetry,
                            onPressed: controller.reload,
                          ),
                        )
                      : ListView(
                          padding: const EdgeInsets.only(bottom: 130),
                          children: [
                            for (final group in _groups(strings))
                              _SignalGroup(
                                title: group.title,
                                cards: group.cards,
                                controller: controller,
                              ),
                          ],
                        ),
                ),
              ],
            );
          },
        ),
      ),
    ),
  );

  /// 分组与卡片（sinais.html 的 G 表，映射到后端实际有的 13 项信号）。
  List<_SignalGroupData> _groups(AppLocalizations strings) {
    final snapshot = controller.snapshot;
    Measurement of(HomeSignal signal) {
      final measurement = snapshot?.measurement(signal);
      return Measurement(
        signal,
        value: measurement?.value,
        caption: measurement?.caption ?? '',
        status: measurement?.status ?? HomeSignalStatus.neutral,
      );
    }

    return [
      _SignalGroupData(strings.healthGroupSleep, [of(HomeSignal.sleep)]),
      _SignalGroupData(strings.healthGroupEnergy, [
        of(HomeSignal.steps),
        of(HomeSignal.distance),
        of(HomeSignal.activeMinutes),
      ]),
      _SignalGroupData(strings.healthGroupMetabolism, [
        of(HomeSignal.calories),
        of(HomeSignal.activeCalories),
        of(HomeSignal.basal),
      ]),
      _SignalGroupData(strings.healthGroupHeartBody, [
        of(HomeSignal.rhr),
        of(HomeSignal.hrv),
        of(HomeSignal.temperature),
      ]),
      _SignalGroupData(strings.healthGroupBreathOxygen, [
        of(HomeSignal.respiration),
        of(HomeSignal.oxygen),
      ]),
      _SignalGroupData(strings.healthGroupLongevity, [of(HomeSignal.vo2)]),
    ];
  }
}

/// sinais.html 的定稿色值。
class _SinaisCss {
  static const bgTop = Color(0xFF222C38);
  static const bgMid = Color(0xFF1A2029);
  static const bgBottom = Color(0xFF121418);
  static const text = Color(0xFFF4F5F7);
  static const text2 = Color(0xB8F4F5F7); // rgba(244,245,247,.72)
  static const text3 = Color(0x80F4F5F7); // rgba(244,245,247,.5)
  static const card = Color(0xFF1C1F24);
  static const bom = Color(0xFF8FCDB9);
  static const atencao = Color(0xFFF0C27A);
  // baixo (#E8A0B0) 客户源码里有但后端目前没有「低」状态，先不接入
  static const insetHighlight = Color(0x0DFFFFFF); // inset 白 5%

  static Color statusColor(HomeSignalStatus status) => switch (status) {
    HomeSignalStatus.good => bom,
    HomeSignalStatus.attention => atencao,
    HomeSignalStatus.neutral => text2,
  };
}

class _SignalGroupData {
  const _SignalGroupData(this.title, this.cards);
  final String title;
  final List<Measurement> cards;
}

typedef Measurement = HomeMeasurement;

/// `.gr`：分组标题 + `.par` 卡片网格（1 整行 / 2 并排 / 3 = 首张整行）。
class _SignalGroup extends StatelessWidget {
  const _SignalGroup({
    required this.title,
    required this.cards,
    required this.controller,
  });

  final String title;
  final List<Measurement> cards;
  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    final rows = <List<Measurement>>[];
    if (cards.length == 2) {
      rows.addAll([cards]);
    } else if (cards.length >= 3) {
      // .par:has(> .c:nth-child(3))：第一张整行，其余两张并排
      rows.add([cards.first]);
      for (var i = 1; i < cards.length; i += 2) {
        rows.add(cards.sublist(i, i + 2 > cards.length ? cards.length : i + 2));
      }
    } else {
      rows.add(cards);
    }
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // .gr h2：Urbanist 300 / 24 / -0.01em
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              title,
              style: const TextStyle(
                color: _SinaisCss.text,
                fontSize: 24,
                fontWeight: FontWeight.w300,
                letterSpacing: -0.01,
              ),
            ),
          ),
          const SizedBox(height: 14),
          for (final row in rows)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  for (final card in row)
                    Expanded(
                      child: _SignalCard(card: card, controller: controller),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// `.c`：170 高卡片，label + 状态词 + 大数字，点击进该信号的详情页。
class _SignalCard extends StatelessWidget {
  const _SignalCard({required this.card, required this.controller});

  final Measurement card;
  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    final locale = strings.localeName;
    final value = card.signal.format(card.value, locale);
    final side = card.value != null; // 占位：字号在下方按行宽自适应
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Material(
        color: _SinaisCss.card,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (_) => HomeAccountGuard(
                controller: controller,
                child: HomeSignalDetailPage(
                  controller: controller,
                  signal: card.signal,
                ),
              ),
            ),
          ),
          child: Container(
            height: 170,
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 17),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(24)),
              boxShadow: [
                BoxShadow(color: _SinaisCss.insetHighlight, blurRadius: 0),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // .k：标签 + ›
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        card.signal.label(locale),
                        style: const TextStyle(
                          color: _SinaisCss.text2,
                          fontSize: 14.5,
                          height: 1.25,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      size: 14,
                      color: _SinaisCss.text2,
                    ),
                  ],
                ),
                // .e：状态词，按 cor 着色
                if (card.caption.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      card.caption,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: _SinaisCss.statusColor(card.status),
                        fontSize: 14.5,
                      ),
                    ),
                  ),
                const Spacer(),
                // .v：大数字（整行 46 / 并排 40），单位 small 14
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: _SinaisCss.text,
                    fontSize: side ? 40 : 46,
                    fontWeight: FontWeight.w300,
                    letterSpacing: -0.03,
                    height: 1,
                  ),
                ),
                if (card.signal.unit.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      card.signal.unit,
                      style: const TextStyle(
                        color: _SinaisCss.text3,
                        fontSize: 14,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
