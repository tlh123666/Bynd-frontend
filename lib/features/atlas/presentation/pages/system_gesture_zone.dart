import 'package:flutter/material.dart';

/// Android/MIUI 手势导航在屏幕左右边缘与底部条区域判定系统手势
/// （返回 / 回到桌面）。浮层卡片的整卡拖拽若起手落在这些区域，
/// 同一次滑动会被系统同时判定为导航手势：返回落在根路由上会把整个
/// 应用退到后台——表现为「卡片正常关闭、上个页面好好的一闪，突然
/// 黑屏」（实际是被踢回桌面的转场，logcat 证据：17:58:59
/// `onBackNavigationDone triggerBack=true` + `moveTaskToFront(home)`）。
///
/// 因此卡片拖拽一律不允许在系统手势区内起手，这些区域留给系统导航。
/// （起手在手势区内的滑动系统横竖都会接管，应用侧无法阻止，只能不
/// 与之叠加自己的关闭动画。）
bool offsetInSystemGestureZone(Offset p, BuildContext context) {
  final size = MediaQuery.sizeOf(context);
  final gestures = MediaQuery.systemGestureInsetsOf(context);
  const margin = 24.0;
  return p.dx < margin ||
      p.dx > size.width - margin ||
      p.dy > size.height - gestures.bottom - margin;
}

/// PointerDownEvent 便捷封装。
bool pointerStartsInSystemGestureZone(
  PointerDownEvent event,
  BuildContext context,
) => offsetInSystemGestureZone(event.position, context);
