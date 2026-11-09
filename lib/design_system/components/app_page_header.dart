import 'package:flutter/material.dart';

import '../tokens/app_dimensions.dart';

/// 页面共用的顶部导航布局，左右区域等宽，确保标题始终相对屏幕居中。
///
/// 具体页面传入自己的返回、菜单或操作按钮；没有操作的一侧留空，避免标题偏移。
class AppPageHeader extends StatelessWidget {
  const AppPageHeader({
    required this.title,
    this.leading,
    this.trailing,
    this.height = 56,
    this.actionWidth = 48,
    this.padding = const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
    super.key,
  });

  final Widget title;
  final Widget? leading;
  final Widget? trailing;
  final double height;
  final double actionWidth;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Padding(
        padding: padding,
        child: Row(
          children: [
            SizedBox(
              width: actionWidth,
              child: Align(
                alignment: Alignment.centerLeft,
                child: leading ?? const SizedBox.shrink(),
              ),
            ),
            Expanded(child: Center(child: title)),
            SizedBox(
              width: actionWidth,
              child: Align(
                alignment: Alignment.centerRight,
                child: trailing ?? const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
