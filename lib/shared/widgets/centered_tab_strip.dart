import 'dart:async';

import 'package:flutter/material.dart';

import '../../design_system/tokens/app_colors.dart';

/// 可横向滚动并将当前选项停在中央标记处的通用标签轨道。
///
/// 具体选项含义和点击后的业务行为由调用方决定，例如日期选择或分类切换。
/// 组件需要放在具有有限宽度的布局中；选中值由调用方持有并通过参数回传。
class CenteredTabStrip extends StatefulWidget {
  const CenteredTabStrip({
    required this.itemCount,
    required this.selectedIndex,
    required this.itemBuilder,
    required this.onSelectedIndexChanged,
    required this.onItemTap,
    this.height = 46,
    this.markerWidth = 110,
    super.key,
  }) : assert(itemCount > 0),
       assert(selectedIndex >= 0 && selectedIndex < itemCount);

  final int itemCount;

  /// 当前处于中心位置的索引，由调用方在收到变化后更新。
  final int selectedIndex;

  /// 构建单个选项；外层会提供固定宽度和点击区域。
  final Widget Function(BuildContext context, int index, double itemWidth)
  itemBuilder;

  /// 用户拖动轨道并停在另一项后触发，不代表点击事件。
  final ValueChanged<int> onSelectedIndexChanged;

  /// 点击任一项时触发；调用方负责更新 [selectedIndex]。
  final ValueChanged<int> onItemTap;
  final double height;
  final double markerWidth;

  @override
  State<CenteredTabStrip> createState() => _CenteredTabStripState();
}

class _CenteredTabStripState extends State<CenteredTabStrip> {
  final ScrollController _scrollController = ScrollController();
  double _itemExtent = 0;
  bool _isProgrammaticScroll = false;
  int _programmaticScrollToken = 0;
  Timer? _programmaticScrollTimer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) => _centerSelected());
  }

  @override
  void didUpdateWidget(covariant CenteredTabStrip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex ||
        oldWidget.itemCount != widget.itemCount) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _centerSelected());
    }
  }

  @override
  void dispose() {
    _programmaticScrollTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final nextItemExtent = constraints.maxWidth / 3;
          if (_itemExtent > 0 && _itemExtent != nextItemExtent) {
            // 屏幕旋转或父布局宽度变化后，按新的标签宽度重新居中。
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) _centerSelected();
            });
          }
          _itemExtent = nextItemExtent;
          return Stack(
            children: [
              NotificationListener<ScrollNotification>(
                onNotification: _handleScrollNotification,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      SizedBox(width: _itemExtent),
                      for (var index = 0; index < widget.itemCount; index++)
                        SizedBox(
                          key: ValueKey('centered-tab-$index'),
                          width: _itemExtent,
                          child: Semantics(
                            selected: index == widget.selectedIndex,
                            child: InkWell(
                              onTap: () => widget.onItemTap(index),
                              child: widget.itemBuilder(
                                context,
                                index,
                                _itemExtent,
                              ),
                            ),
                          ),
                        ),
                      SizedBox(width: _itemExtent),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 4.5,
                child: IgnorePointer(
                  child: _SelectedMarker(width: widget.markerWidth),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    // 只处理本组件的水平轨道，避免子项中的嵌套滚动影响选中状态。
    if (notification.depth != 0) return false;
    if (notification is ScrollStartNotification &&
        notification.dragDetails != null) {
      _programmaticScrollToken++;
      _programmaticScrollTimer?.cancel();
      _isProgrammaticScroll = false;
      return false;
    }
    if (notification is! ScrollEndNotification || _isProgrammaticScroll) {
      return false;
    }

    if (_itemExtent <= 0 || !_scrollController.hasClients) return false;
    final centeredIndex = (_scrollController.offset / _itemExtent)
        .round()
        .clamp(0, widget.itemCount - 1);
    if (centeredIndex != widget.selectedIndex) {
      widget.onSelectedIndexChanged(centeredIndex);
    } else {
      _scrollToOffset(centeredIndex * _itemExtent, animate: true);
    }
    return false;
  }

  void _centerSelected({bool animate = false}) {
    if (!_scrollController.hasClients || _itemExtent <= 0) return;
    final target = (widget.selectedIndex * _itemExtent).clamp(
      0.0,
      _scrollController.position.maxScrollExtent,
    );
    if ((_scrollController.offset - target).abs() < 1) return;
    _scrollToOffset(target, animate: animate);
  }

  void _scrollToOffset(double target, {required bool animate}) {
    _programmaticScrollTimer?.cancel();
    final token = ++_programmaticScrollToken;
    _isProgrammaticScroll = true;
    if (animate) {
      _scrollController
          .animateTo(
            target,
            duration: const Duration(milliseconds: 320),
            curve: Curves.easeOutCubic,
          )
          .whenComplete(() => _finishProgrammaticScroll(token));
    } else {
      _scrollController.jumpTo(target);
      _finishProgrammaticScroll(token);
    }
  }

  void _finishProgrammaticScroll(int token) {
    if (!mounted || token != _programmaticScrollToken) return;
    _programmaticScrollTimer?.cancel();
    _programmaticScrollTimer = Timer(const Duration(milliseconds: 80), () {
      if (mounted && token == _programmaticScrollToken) {
        _isProgrammaticScroll = false;
      }
    });
  }
}

class _SelectedMarker extends StatelessWidget {
  const _SelectedMarker({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: width,
        height: 8,
        child: CustomPaint(painter: _MarkerPainter()),
      ),
    );
  }
}

class _MarkerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.textPrimary;
    const lineY = 1.0;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, lineY, size.width, 1.5),
        const Radius.circular(1),
      ),
      paint,
    );
    final path = Path()
      ..moveTo(size.width / 2 - 6, lineY)
      ..lineTo(size.width / 2 + 6, lineY)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _MarkerPainter oldDelegate) => false;
}
