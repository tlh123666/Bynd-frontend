import 'package:flutter/cupertino.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_typography.dart';

/// 等间距吸附滚轮；保留初始值，滚动停止前也会即时通知调用方。
class AppNumberWheel extends StatefulWidget {
  const AppNumberWheel({
    required this.values,
    required this.initialValue,
    required this.label,
    required this.unit,
    required this.format,
    required this.onChanged,
    super.key,
  });
  final List<double> values;
  final double initialValue;
  final String label, unit;
  final String Function(double) format;
  final ValueChanged<double> onChanged;

  @override
  State<AppNumberWheel> createState() => _AppNumberWheelState();
}

class _AppNumberWheelState extends State<AppNumberWheel> {
  late int _selected = widget.values.indexOf(widget.initialValue);
  late final _controller = FixedExtentScrollController(
    initialItem: _selected < 0 ? 0 : _selected,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Semantics(
    label: widget.label,
    child: Stack(
      children: [
        CupertinoPicker.builder(
          key: ValueKey('wheel-${widget.label}'),
          scrollController: _controller,
          itemExtent: 32,
          selectionOverlay: null,
          onSelectedItemChanged: (index) {
            setState(() => _selected = index);
            widget.onChanged(widget.values[index]);
          },
          childCount: widget.values.length,
          itemBuilder: (context, index) => Center(
            child: Text(
              widget.format(widget.values[index]),
              style: AppTypography.page.copyWith(
                fontSize: 24,
                height: 1,
                fontWeight: FontWeight.w300,
                color: index == _selected
                    ? AppColors.textPrimary
                    : (index - _selected).abs() == 1
                    ? AppColors.textMuted
                    : const Color(0x59f4f5f7),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: Align(
              alignment: const Alignment(.63, 0),
              child: Text(
                widget.unit,
                style: AppTypography.caption.copyWith(
                  fontSize: 13,
                  color: AppColors.textMuted,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
