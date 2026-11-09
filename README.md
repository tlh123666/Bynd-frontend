# new_jcvital

BYND 的 Flutter 客户端。参考 [线上原型](https://bynd-app.vercel.app/) 实现首页（到“了解更多”之前）、底部导航、“更多”快捷菜单、左侧导航和个人资料页。

首页已包含原图切换、每日方向、六项健康信号、自定义选择与拖动排序、全部信号、周历史及日记记录入口。结构、原站 CSS、数据合同和范围说明见 [首页实现文档](docs/home.md)。

## 目录规划

```text
assets/icons/site/                   # 原站 SVG 与来源清单，含首页信号图标
assets/images/avatar.webp           # 原型中的个人头像
assets/fonts/                       # Geist、Urbanist、Newsreader TTF 与 OFL 许可
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
    ├── home/home_page.dart           # 首页导航与依赖装配
    ├── home/home_sky_background.dart # 原站照片、遮罩、时段天空及切换
    ├── home/application/            # 日期、加载、账号隔离和偏好状态
    ├── home/domain/                 # 首页数据与仓储合同
    ├── home/data/                   # 真实接口、显式演示、资源及本地偏好
    ├── home/presentation/           # 每日方向、信号、自定义、历史与日记
    └── profile/profile_page.dart     # 设置入口对应的个人资料页
```

设备管理已接入左上角菜单顶部的 BYND ONE 卡片，包含状态/高级页、重新配对、解绑、固件检查与升级流程、重启、设备本地数据清除、安全说明和设备信息。公共页头、标签、渐变操作卡片、确认面板放在 `design_system/components/`；设备状态、账号接口、持久化与蓝牙适配分别放在 `features/device/application/`、`data/` 和 `domain/`。目录规划、原站 CSS 依据、环境配置和真实设备接口见 [设备管理文档](docs/device-management.md)。后端新增迁移与 API 见 `BYND-backend/doc/device-management.md`。

环境与基础设施已按 `JCVital` 对齐：默认后端 `https://api.byndhealth.com.br`、应用ID `com.byndhealth.app`、原安全令牌键和语言键保持一致。使用 `config/dev.json / test.json / prod.json` 运行真实接口模式，页面演示使用 `config/demo.json`。会话在启动时从安全存储恢复。完整的环境优先级、运行命令、本地后端、签名及平台说明见 [环境配置](docs/environments.md)。真实手环通信仍需接入厂商驱动。

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

底栏使用原站的“Hoje / Atlas / Comunidade / Saúde”SVG，右侧按钮在当前页面展开六项快捷操作。展开时遮罩渐显、入口错峰上浮，关闭时一起淡出；点击遮罩或系统返回键也会收起。动效时长集中在 `AppMotion`，系统要求减少动画时直接切换。提取的图标存放在 `assets/icons/site/`，其中常用图标有语义文件名，其余按内容哈希命名；`manifest.json` 记录了每个文件在原站的首次使用位置。资源覆盖检查当时可见的主页、快捷菜单、Atlas、侧边栏及其主要一级页面。网页里的一个 Lottie 动画 SVG 使用了 Flutter 不支持的 CSS 变换，因此同名资源改为同形的静态 BYND 标记。

菜单从左侧滑入，带背景遮罩；点击“Ajustes”后先收起菜单，再从右侧进入“Perfil”，返回时反向过渡。全局页面过渡在主题里设置，`AppLoadingIndicator` 和 `AppLoadingOverlay` 可供异步页面复用；按钮的 `loading` 状态也使用同一标记。系统要求减少动画时，菜单和 loading 会停止动效。

首页读取现有后端的方向、健康汇总、资料、Mapa 与日记接口，缺失的读数显示空态。后端新增五个可选健康指标，部署时需要执行 `000060_home_signal_measurements` 迁移；不自动填入演示数据。首页照片与信号偏好可保存，演示预览使用 `config/demo.json`。底栏的其他主标签仍只切换选中态；未接入的快捷操作保留“即将提供”提示。配色与字体依据见 [CSS 配色对照](docs/reference-css-colors.md)、[字体对照](docs/reference-css-typography.md)和[首页文档](docs/home.md)。SVG 通过 `flutter_svg` 渲染。

## 运行

```sh
flutter run
flutter run --dart-define-from-file=config/demo.json
flutter analyze
flutter test
```

如果在 IDE 中持续运行 Flutter Web，新增 SVG 或修改 `pubspec.yaml` 后出现 `Unable to load asset`，请停止当前调试进程，执行 `flutter pub get` 并重新启动应用；仅热重载不能保证旧调试服务更新资源清单。若浏览器仍使用旧页面，再强制刷新一次。
