import 'package:flutter/material.dart';
import 'package:flutter/physics.dart' show SpringDescription, SpringSimulation;

/// FaixaDias —— 客户源码 `src/components/FaixaDias.jsx` 的 Flutter 复刻
/// （comunidade.css `.cmb .cmb-dias` + home-dia.css `.hdx-*`）：
///
/// * 天数 tab 横向滑动 + scroll-snap，每个 tab 占可视宽 1/3；
/// * `.hdx-marca` 固定居中永不移动：110px 白线 + 下指小三角；
/// * 点 tab → 横向滑动把它带到正中；拖动松手 → 吸附到最近的 tab；
/// * 未选中 rgba(244,245,247,.45) 15px，选中 #f4f5f7。
///
/// 与 Memória 页的 `.at-faixa` tab 条同一族结构（那里是分类、这里是天数），
/// 源码两处都靠「两端各 1/3 spacer + snap 对中」实现居中。
class DayStrip extends StatefulWidget {
  const DayStrip({
    required this.labels,
    required this.selectedIndex,
    required this.onSelect,
    super.key,
  });

  /// 从左到右的 tab 文案（源码 N=2 时渲染为 Ontem, Hoje）。
  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  State<DayStrip> createState() => _DayStripState();
}

class _DayStripState extends State<DayStrip> {
  final ScrollController _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _centerOn(widget.selectedIndex, jump: true),
    );
  }

  @override
  void didUpdateWidget(DayStrip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      _centerOn(widget.selectedIndex);
    }
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  // centraAba：点 tab → 条带横滑带到正中；marca 固定居中。
  void _centerOn(int index, {bool jump = false}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      final step = _scroll.position.viewportDimension / 3;
      final target = (index * step).clamp(
        0.0,
        _scroll.position.maxScrollExtent,
      );
      if (jump) {
        _scroll.jumpTo(target);
      } else {
        _scroll.animateTo(
          target,
          duration: const Duration(milliseconds: 320),
          curve: const Cubic(0.32, 0.72, 0, 1),
        );
      }
    });
  }

  // rolouAbas：拖动松手 → 吸附到离中心最近的 tab。
  void _onStripScroll() {
    if (!_scroll.hasClients) return;
    final step = _scroll.position.viewportDimension / 3;
    final index = (_scroll.offset / step)
        .round()
        .clamp(0, widget.labels.length - 1);
    if (index != widget.selectedIndex) widget.onSelect(index);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final third = constraints.maxWidth / 3;
          return SizedBox(
            height: 46,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification is ScrollEndNotification) {
                      _onStripScroll();
                    }
                    return false;
                  },
                  child: ListView(
                    controller: _scroll,
                    scrollDirection: Axis.horizontal,
                    physics: _DaySnapPhysics(
                      step: third,
                      count: widget.labels.length,
                    ),
                    children: [
                      SizedBox(width: third, height: 46), // 首占位
                      for (var i = 0; i < widget.labels.length; i++)
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            widget.onSelect(i);
                            _centerOn(i);
                          },
                          child: Container(
                            width: third,
                            height: 46,
                            alignment: Alignment.topCenter,
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              widget.labels[i],
                              style: TextStyle(
                                fontSize: 15,
                                color: i == widget.selectedIndex
                                    ? const Color(0xFFF4F5F7)
                                    : const Color(0x73F4F5F7),
                              ),
                            ),
                          ),
                        ),
                      SizedBox(width: third, height: 46), // 尾占位
                    ],
                  ),
                ),
                // .hdx-marca：固定居中的白线 + 下指三角
                Positioned(
                  bottom: 10,
                  child: Column(
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4F5F7),
                          borderRadius: BorderRadius.circular(1),
                        ),
                        child: const SizedBox(width: 110, height: 1.5),
                      ),
                      ClipRect(
                        child: CustomPaint(
                          size: const Size(12, 6),
                          painter: _DayNotchPainter(),
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

/// `.hdx-marca::after`：贴线的下指三角。
class _DayNotchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFFF4F5F7);
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

/// 吸附物理：与 Memória 页 `.at-faixa` 相同的弹簧吸附（松手必停在
/// 与 marca 对齐的档位；快速滑动按速度方向多走一档）。
class _DaySnapPhysics extends ScrollPhysics {
  // ignore: prefer_const_constructors_in_immutables
  _DaySnapPhysics({required this.step, required this.count, super.parent});

  final double step;
  final int count;

  @override
  SpringDescription get spring =>
      SpringDescription(damping: 30, stiffness: 280, mass: 1);

  @override
  _DaySnapPhysics applyTo(ScrollPhysics? ancestor) => _DaySnapPhysics(
    step: step,
    count: count,
    parent: buildParent(ancestor),
  );

  @override
  SpringSimulation? createBallisticSimulation(
    ScrollMetrics position,
    double velocity,
  ) {
    final maxExtent = position.maxScrollExtent;
    final base = position.pixels / step;
    final maxSteps = (maxExtent / step).round();
    int index;
    if (velocity > minFlingVelocity) {
      index = base.ceil();
    } else if (velocity < -minFlingVelocity) {
      index = base.floor();
    } else {
      index = base.round();
    }
    final target = (index.clamp(0, maxSteps) * step).clamp(
      position.minScrollExtent,
      maxExtent,
    );
    if ((target - position.pixels).abs() <
        toleranceFor(position).distance) {
      return null;
    }
    return SpringSimulation(spring, position.pixels, target, velocity);
  }
}
