import 'package:flutter/material.dart';
import 'package:flutter/physics.dart' show SpringDescription, SpringSimulation;

import '../../../../l10n/app_localizations_context.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// Memória 子层 —— 按客户源码复刻（Assistente.jsx 的 `at-tela at-sub` 区 +
/// atlas-caixa.css `.at-heroi/.at-faixa/.at-lem` 定稿）。
///
/// **不是推入页**：与主对话同为 Atlas 浮层内的一个 tela，由宿主
/// （AtlasChatPage）叠放——打开时主对话左移淡出（`atras`：-22%）、
/// 本层从右滑入；头部支持下滑（velocity > 600）返回对话，‹ 按钮同效。
///
/// 结构（对照 vercel 截图）：
/// * 顶栏：‹ 返回（左）/ Memória（中），44/1fr/44；
/// * hero：`O que o Atlas sabe de você`（Urbanist 300/30）+ 副题；
/// * kicker `O QUE ELE GUARDOU`（11 大写 .16em）；
/// * 分类 tab 条 `.at-faixa`：横滑、选中项滚到正中、下方 110px 白线 +
///   下指小三角（`.marca::after` 的 border-top-color 形态——尖端朝下）；
/// * 记忆卡 `.at-lem`：标题 + X 删除、状态行（Atual 绿 / Passou 灰 ·
///   Você contou / O Atlas percebeu · desde 日期）、正文 60% 灰。
///
/// ⚠️ 数据现状：后端尚无记忆端点，这里用与原型 Clara 场景一致的演示
/// 夹具撑起 UI；端点就绪后把 [_fixture] 换成接口数据即可，界面不动。
class AtlasMemoryLayer extends StatefulWidget {
  const AtlasMemoryLayer({required this.onClose, super.key});

  /// 返回对话（‹ 按钮与下滑共用）。
  final VoidCallback onClose;

  @override
  State<AtlasMemoryLayer> createState() => _AtlasMemoryLayerState();
}

class _MemoryItem {
  const _MemoryItem(
    this.title,
    this.detail, {
    required this.since,
    this.passou = false,
    this.percebeu = false,
  });

  final String title;
  final String detail;
  final String since;
  final bool passou;
  final bool percebeu;
}

/// 演示夹具：结构与源码 MEMORIA 完全一致（title, detail, date, passou,
/// percebeu）。日期格式按原型（dd MMM yyyy，葡语缩写）。
final Map<String, List<_MemoryItem>> _fixture = {
  'Rotina': [
    _MemoryItem(
      'Trabalha das 9h às 19h',
      'Quase sempre sentada; se mexe mais no fim de semana e na segunda.',
      since: '15 set 2026',
    ),
    _MemoryItem(
      'Reunião de status toda sexta às 14h',
      'É o pico de estresse da semana.',
      since: '18 set 2026',
    ),
    _MemoryItem(
      'Dorme perto das 23h',
      'Acorda às 6h40 nos dias de trabalho; dorme em média 7h05.',
      since: '22 set 2026',
      percebeu: true,
    ),
  ],
  'Treino': [
    _MemoryItem(
      'Força de segunda a sexta',
      'Às 7h15; sábado corrida às 7h30, domingo de descanso.',
      since: '31 ago 2026',
    ),
    _MemoryItem(
      'Corre melhor depois de noites boas',
      'Corridas de sábado em média 13,1 km.',
      since: '19 set 2026',
      percebeu: true,
    ),
  ],
  'Objetivos': [
    _MemoryItem(
      'Perder gordura sem perder massa',
      'Déficit de cerca de 350 kcal e 120 g de proteína por dia.',
      since: '31 ago 2026',
    ),
  ],
  'Saúde': [
    _MemoryItem(
      'Resfriado em setembro',
      'Garganta e nariz de 14 a 17/09; a pulseira viu 2 dias antes.',
      since: '14 set 2026',
      passou: true,
    ),
  ],
};

class _AtlasMemoryLayerState extends State<AtlasMemoryLayer> {
  late final List<String> _tabs = _fixture.keys.toList();
  final Map<String, Set<String>> _removed = {};
  final ScrollController _tabScroll = ScrollController();
  int _active = 0;

  // ── 整卡下滑关闭（用户要求：整个卡片往下滑就收起）──────────────────
  // 用裸 Listener 而不是手势 arena：内层 ListView 的纵向滚动不与之竞争。
  // 只有列表处于顶部时才累积位移（否则是正常滚动列表内容）。
  double _dragDy = 0;
  bool _dragging = false;
  bool _listAtTop = true;
  Duration? _lastMoveAt;
  double? _lastMoveDy;
  double _velocity = 0;

  void _onPointerDown(PointerDownEvent event) {
    _dragDy = 0;
    _dragging = false;
    _velocity = 0;
    _lastMoveAt = null;
    _lastMoveDy = null;
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (!_listAtTop) return;
    final delta = event.delta.dy;
    if (delta <= 0 && _dragDy <= 0) return;
    // 速度估计（px/s），用于松手时的甩动判定
    final dt = _lastMoveAt == null
        ? null
        : (event.timeStamp - _lastMoveAt!).inMicroseconds / 1e6;
    if (dt != null && dt > 0 && _lastMoveDy != null) {
      _velocity = (delta - _lastMoveDy!) / dt;
    }
    _lastMoveAt = event.timeStamp;
    _lastMoveDy = delta;
    if (delta > 0 || _dragDy > 0) {
      setState(() {
        _dragging = true;
        _dragDy = (_dragDy + delta).clamp(0.0, double.infinity);
      });
    }
  }

  void _onPointerUp() {
    final shouldClose = _dragDy > 140 || _velocity > 800;
    if (shouldClose) {
      // 立即恢复对话层（避免滑出后露出暗底），卡片自身继续滑出动画
      setState(() {
        _dragging = false;
        _dragDy = 1400;
      });
      widget.onClose();
    } else {
      setState(() {
        _dragging = false;
        _dragDy = 0;
      });
    }
  }

  bool _onListScroll(ScrollNotification notification) {
    final atTop = notification.metrics.pixels <= 0.5;
    if (atTop != _listAtTop) setState(() => _listAtTop = atTop);
    return false;
  }

  @override
  void initState() {
    super.initState();
    // 首帧后把默认 tab 滚到正中，marca（固定居中）正好压住它。
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _scrollTabTo(_active, jump: true),
    );
  }

  /// 客户源码 centraAba：点 tab → 条带横向滑动把它带到正中；marca 固定
  /// 居中不动。tab 与两端 spacer 等宽（各 1/3 条带宽），吸附偏移 = i×宽/3。
  void _selectTab(int index) {
    setState(() => _active = index);
    _scrollTabTo(index);
  }

  void _scrollTabTo(int index, {bool jump = false}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_tabScroll.hasClients) return;
      final step = _tabScroll.position.viewportDimension / 3;
      final target = (index * step).clamp(
        0.0,
        _tabScroll.position.maxScrollExtent,
      );
      if (jump) {
        _tabScroll.jumpTo(target);
      } else {
        _tabScroll.animateTo(
          target,
          duration: const Duration(milliseconds: 320),
          curve: const Cubic(0.32, 0.72, 0, 1),
        );
      }
    });
  }

  /// 吸附物理上报目标档位 → 立即高亮（松手瞬间切换，无 ~1s 滞后）。
  void _onSnapTarget(int index) {
    if (index != _active && mounted) setState(() => _active = index);
  }

  /// 源码 rolouAbas：拖动松手时，吸附到离中心最近的 tab。
  void _onTabStripScroll() {
    if (!_tabScroll.hasClients) return;
    final step = _tabScroll.position.viewportDimension / 3;
    final index = (_tabScroll.offset / step).round().clamp(0, _tabs.length - 1);
    if (index != _active) setState(() => _active = index);
  }

  void _remove(String tab, _MemoryItem item) {
    setState(() => _removed.putIfAbsent(tab, () => {}).add(item.title));
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    // 整卡下滑关闭：裸 Listener 追踪下拖位移（不与内层列表滚动手势竞争），
    // 列表在顶部时才累积；松手超过阈值或快速下甩 → onClose，否则弹回。
    return Listener(
      onPointerDown: _onPointerDown,
      onPointerMove: _onPointerMove,
      onPointerUp: (_) => _onPointerUp(),
      onPointerCancel: (_) => _onPointerUp(),
      child: AnimatedSlide(
        duration: _dragging ? Duration.zero : const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        offset: Offset(0, _dragDy / 900),
        child: ColoredBox(
          color: _MemCss.bgBottom,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0, 0.2, 0.55],
                colors: [_MemCss.bgTop, _MemCss.bgMid, _MemCss.bgBottom],
              ),
            ),
            child: Column(
              children: [
                _buildHeader(strings),
                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: _onListScroll,
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(21, 8, 21, 40),
                      children: [
                        // .at-heroi
                        Text(
                          strings.memoriaHeroTitle,
                          style: const TextStyle(
                            color: _MemCss.textFull,
                            fontSize: 30,
                            fontWeight: FontWeight.w200,
                            height: 1.1,
                            letterSpacing: -0.01,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            strings.memoriaHeroSub,
                            style: const TextStyle(
                              color: _MemCss.text2,
                              fontSize: 13.5,
                            ),
                          ),
                        ),
                        // kicker：O QUE ELE GUARDOU
                        Padding(
                          padding: const EdgeInsets.only(top: 26),
                          child: Text(
                            strings.memoriaKicker.toUpperCase(),
                            style: const TextStyle(
                              color: _MemCss.text3,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              letterSpacing: .16,
                            ),
                          ),
                        ),
                        _buildTabs(strings),
                        for (final item in _visibleItems(_tabs[_active]))
                          _MemoryCard(
                            item: item,
                            onDelete: () => _remove(_tabs[_active], item),
                          ),
                        if (_visibleItems(_tabs[_active]).isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: Text(
                              'Nada guardado aqui.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: _MemCss.text3,
                                fontSize: 14,
                              ),
                            ),
                          ),
                      ],
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

  /// `.at-subcab`：‹ 返回（左）/ Memória（中）；头部下滑返回对话
  Widget _buildHeader(AppLocalizations strings) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onVerticalDragEnd: (details) {
        if ((details.primaryVelocity ?? 0) > 600) widget.onClose();
      },
      child: SizedBox(
        height: 56,
        child: Row(
          children: [
            IconButton(
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              icon: const Icon(Icons.arrow_back_ios_new, size: 20),
              color: _MemCss.textFull,
              onPressed: widget.onClose,
            ),
            Expanded(
              child: Text(
                strings.memoriaTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: _MemCss.textFull,
                  fontSize: 19,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(width: 48),
          ],
        ),
      ),
    );
  }

  List<_MemoryItem> _visibleItems(String tab) => (_fixture[tab] ?? const [])
      .where((item) => !(_removed[tab]?.contains(item.title) ?? false))
      .toList();

  /// `.at-faixa`：tab 条——可横向滑动 + scroll-snap（源码 trilho），但
  /// **marca 固定居中永不移动**。布局按源码：两端各 1/3 宽的 `<i>` spacer、
  /// 每个 tab 也占 1/3 宽、snap 对中。点 tab → 条带横向滑把它带到正中；
  /// 拖动松手 → 吸附到离中心最近的 tab（rolouAbas）。
  Widget _buildTabs(AppLocalizations strings) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final third = constraints.maxWidth / 3;
          return SizedBox(
            height: 54,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                // trilho：spacer + tabs + spacer，全部 1/3 宽、snap 对中
                NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification is ScrollEndNotification) {
                      _onTabStripScroll();
                    }
                    return false;
                  },
                  child: ListView(
                    controller: _tabScroll,
                    scrollDirection: Axis.horizontal,
                    physics: _TabSnapPhysics(
                      step: third,
                      onSnapTarget: _onSnapTarget,
                    ),
                    children: [
                      SizedBox(width: third, height: 54), // <i> 首占位
                      for (var i = 0; i < _tabs.length; i++)
                        GestureDetector(
                          onTap: () => _selectTab(i),
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            width: third,
                            height: 54,
                            alignment: Alignment.topCenter,
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              _tabs[i],
                              style: TextStyle(
                                color: i == _active
                                    ? _MemCss.textFull
                                    : _MemCss.text42,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      SizedBox(width: third, height: 54), // <i> 尾占位
                    ],
                  ),
                ),
                // .at-marca：固定居中，永不移动（源码 left:50%; margin-left:-55px）
                Positioned(
                  bottom: 12,
                  child: Column(
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: _MemCss.textFull,
                          borderRadius: BorderRadius.circular(1),
                        ),
                        child: const SizedBox(width: 110, height: 1.5),
                      ),
                      ClipRect(
                        child: CustomPaint(
                          size: const Size(12, 6),
                          painter: _NotchPainter(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// `.marca::after`：贴着线的下指三角（平底在上、尖朝下）。
class _NotchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = _MemCss.textFull;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 吸附物理：松手（含快速滑动）后弹簧滑到最近的整数档位——档位 = 条带宽
/// 的 1/3（与 tab/spacer 同宽）。保证松手时必有一个 tab 与 marca 对齐，
/// 下划线永远不可能停在两个 tab 之间。快速滑动按速度方向多走一档。
class _TabSnapPhysics extends ScrollPhysics {
  // 非常量构造：携带吸附目标回调（函数字段无法 const）
  // ignore: prefer_const_constructors_in_immutables
  _TabSnapPhysics({
    required this.step,
    required this.onSnapTarget,
    super.parent,
  });

  final double step;
  final ValueChanged<int> onSnapTarget;

  // 弹簧比默认更硬：吸附到位 ~0.25s（默认要 ~1s）
  @override
  SpringDescription get spring =>
      SpringDescription(damping: 30, stiffness: 280, mass: 1);

  @override
  _TabSnapPhysics applyTo(ScrollPhysics? ancestor) => _TabSnapPhysics(
    step: step,
    onSnapTarget: onSnapTarget,
    parent: buildParent(ancestor),
  );

  double _snapTarget(double pixels, double velocity, double maxExtent) {
    final base = pixels / step;
    final maxSteps = (maxExtent / step).round();
    int index;
    if (velocity > minFlingVelocity) {
      index = base.ceil();
    } else if (velocity < -minFlingVelocity) {
      index = base.floor();
    } else {
      index = base.round();
    }
    return index.clamp(0, maxSteps) * step;
  }

  @override
  SpringSimulation? createBallisticSimulation(
    ScrollMetrics position,
    double velocity,
  ) {
    final target = _snapTarget(
      position.pixels,
      velocity,
      position.maxScrollExtent,
    ).clamp(position.minScrollExtent, position.maxScrollExtent);
    // 吸附目标一出就高亮对应 tab——不等弹簧停完（此前高亮滞后 ~1s 的根因）
    onSnapTarget((target / step).round());
    if ((target - position.pixels).abs() < toleranceFor(position).distance) {
      return null;
    }
    return SpringSimulation(spring, position.pixels, target, velocity);
  }
}

/// `.at-lem`：记忆卡片。
class _MemoryCard extends StatelessWidget {
  const _MemoryCard({required this.item, required this.onDelete});

  final _MemoryItem item;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _MemCss.card,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(color: _MemCss.insetHighlight, blurRadius: 0),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  item.title,
                  style: const TextStyle(
                    color: _MemCss.textFull,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              // .at-lem-x：删除
              GestureDetector(
                onTap: onDelete,
                child: const Icon(Icons.close, size: 18, color: _MemCss.text2),
              ),
            ],
          ),
          const SizedBox(height: 2),
          // 状态行：Atual/Passou · Você contou/O Atlas percebeu · desde 日期
          Text.rich(
            TextSpan(
              style: const TextStyle(fontSize: 12, color: _MemCss.text42),
              children: [
                TextSpan(
                  text: item.passou
                      ? strings.memoriaPast
                      : strings.memoriaCurrent,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: item.passou
                        ? _MemCss.text42
                        : const Color(0xFF86D4A3),
                  ),
                ),
                const TextSpan(text: ' · '),
                TextSpan(
                  text: item.percebeu
                      ? strings.memoriaPerceived
                      : strings.memoriaTold,
                ),
                TextSpan(text: ' · ${strings.memoriaSince} ${item.since}'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.detail,
            style: const TextStyle(
              color: _MemCss.text2,
              fontSize: 13.5,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

/// atlas-caixa.css 的定稿色值（与聊天页同一族）。
class _MemCss {
  static const bgTop = Color(0xFF222C38);
  static const bgMid = Color(0xFF1A2029);
  static const bgBottom = Color(0xFF121418);
  static const textFull = Color(0xFFF4F5F7);
  static const text2 = Color(0xB8F4F5F7);
  static const text3 = Color(0x73F4F5F7);
  static const text42 = Color(0x6BF4F5F7); // rgba(244,245,247,.42)
  static const card = Color(0xFF1C1F24);
  static const insetHighlight = Color(0x0DFFFFFF);
}
