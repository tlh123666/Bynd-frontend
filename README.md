# new_jcvital

BYND 的 Flutter 客户端。参考 [线上原型](https://bynd-app.vercel.app/) 实现主页外壳、底部导航、“更多”快捷菜单、左侧导航和“设置”进入的个人资料页。

## 目录规划

```text
assets/icons/site/                   # 从线上页面提取的 139 个 SVG 与 manifest.json
assets/images/avatar.webp           # 原型中的个人头像
lib/
├── main.dart                         # 应用入口，安装统一主题
├── design_system/
│   ├── design_system.dart            # 公共导出入口
│   ├── tokens/
│   │   ├── app_colors.dart           # 品牌、语义、玻璃和导航颜色
│   │   ├── app_dimensions.dart       # 间距、圆角、边框、触控尺寸
│   │   ├── app_typography.dart       # 字号与文本样式
│   │   └── app_motion.dart           # 全局动效时长、曲线和减少动画设置
│   ├── navigation/
│   │   └── app_page_transitions.dart # 全局页面推入、返回过渡
│   ├── theme/
│   │   └── app_theme.dart            # Flutter 主题
│   ├── components/
│   │   ├── app_bottom_nav.dart       # 四入口胶囊导航和“更多”按钮
│   │   ├── app_button.dart           # 主、次、文字、危险按钮
│   │   ├── app_card.dart             # 玻璃、实色卡片
│   │   ├── app_icon.dart             # SVG 资源映射与通用图标
│   │   ├── app_loading.dart          # 品牌符号 loading 与页面遮罩
│   │   ├── app_notice.dart           # 成功、失败、警告、信息提醒
│   │   └── app_quick_actions_overlay.dart # 六入口快捷菜单
│   └── preview/
│       └── design_system_page.dart   # 开发期组件预览
├── shared/navigation/
│   └── app_side_menu.dart            # 多页面可复用的侧边菜单
└── features/
    ├── home/home_page.dart           # 主页外壳与导航选中状态
    └── profile/profile_page.dart     # 设置入口对应的个人资料页
```

## 使用方式

业务页面统一从 `design_system/design_system.dart` 导入组件与变量。例如：

```dart
import 'package:new_jcvital/design_system/design_system.dart';

AppCard(
  child: AppButton(
    label: 'Continuar',
    onPressed: () => AppNotice.success(context, 'Concluído'),
  ),
)
```

按钮可用 `variant` 选择 `primary / secondary / ghost / danger`，用 `loading` 和 `expanded` 控制状态与宽度，`iconAsset` 接入 SVG。圆形图标按钮用 `AppIconButton(asset: AppSvgAssets.home, ...)`。卡片可用 `variant` 选择 `glass / solid`。提醒可以直接嵌入页面，也可以用 `AppNotice.show`、`AppNotice.success` 或 `AppNotice.error` 临时显示。文案由调用方提供，公共组件不固定语言。

底栏使用原站的“Hoje / Atlas / Comunidade / Saúde”SVG，右侧按钮展开原站六项快捷操作。提取的图标存放在 `assets/icons/site/`，其中常用图标有语义文件名，其余按内容哈希命名；`manifest.json` 记录了每个文件在原站的首次使用位置。资源覆盖检查当时可见的主页、快捷菜单、Atlas、侧边栏及其主要一级页面。网页里的一个 Lottie 动画 SVG 使用了 Flutter 不支持的 CSS 变换，因此同名资源改为同形的静态 BYND 标记。

菜单从左侧滑入，带背景遮罩；点击“Ajustes”后先收起菜单，再从右侧进入“Perfil”，返回时反向过渡。全局页面过渡在主题里设置，`AppLoadingIndicator` 和 `AppLoadingOverlay` 可供异步页面复用；按钮的 `loading` 状态也使用同一标记。系统要求减少动画时，菜单和 loading 会停止动效。

目前底栏只切换选中态，快捷操作和未接入的菜单项点击后显示“即将提供”提示；业务页入口留给后续阶段连接。顶部背景颜色按原型截图近似；获得正式设计稿与字体资源后，可集中调整 `tokens/` 下的值。SVG 通过 `flutter_svg` 渲染。开发期组件预览仍在 `lib/design_system/preview/`，可通过 `MaterialPageRoute` 从调试入口打开。

## 运行

```sh
flutter run
flutter analyze
flutter test
```

如果在 IDE 中持续运行 Flutter Web，新增 SVG 或修改 `pubspec.yaml` 后出现 `Unable to load asset`，请停止当前调试进程，执行 `flutter pub get` 并重新启动应用；仅热重载不能保证旧调试服务更新资源清单。若浏览器仍使用旧页面，再强制刷新一次。
