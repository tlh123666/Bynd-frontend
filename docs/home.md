# 首页实现与原站依据

范围：从顶部导航到 `Descubra mais`（了解更多）之前，包括照片、日期、每日方向、六个信号卡片、信号自定义、Mapa 和日记入口。下方推广内容不在本次范围内。

## 源码核对

2026-11-09 使用隔离的本地 Edge 读取原站 DOM、JavaScript 和最终计算样式，并实际点击日期、完整方向、健康卡片和自定义入口。参考版本：

- https://bynd-app.vercel.app/assets/main-DN5h_XhA.js
- https://bynd-app.vercel.app/assets/main-CRUZ18wL.css

CSS 有多轮覆盖，应以最终计算样式为准：

| 原站选择器 | Flutter 对应 | 最终值 |
|---|---|---|
| `.hd-titulo` | `AppTypography.homeTitle` | Urbanist 36 / 300，行高 1.18，字距 -.36；小屏 32 |
| `.hd-texto` | `AppTypography.homeBody` | Geist 17 / 400，行高 1.55，`#f4f5f7db` |
| `.hd-data` | `HomeDirectionHero` | Geist 11 / 600，字距 1.98，白色 .75 |
| `.ss-gr .ss-c` | `AppSignalCard` | `#1c1f24`，150 高，12 圆角，间距 6 |
| `.ss-n` | `AppTypography.signalValue` | Urbanist 40 / 300，行高 1，字距 -.6 |
| `.ss-k`, `.ss-e` | `AppTypography.signalLabel` | Geist 14.5 / 400，行高 1.25 |
| `.ss-e.ok`, `.ss-e.fora` | `AppColors.sage/signalAttention` | `#86d4a3` / `#ecd27c` |
| `.he-t`, `.he-p` | `HomeExploreSection` | Urbanist 23 / 300；Geist 14.5 / 400 |
| `.ln` | `HomeCustomizeSheet` | 56 高、18 圆角，横排数值及拖动手柄 |
| `.hn-fundo.hn-hero` | `HomeSkyBackground` | 原图 cover，顶部裁切、原 CSS 渐变遮罩及底部渐隐 |

实际复核了 390×844 的今日、昨日页面；额外测试 320×600、大字体及浏览器初始 1×1 视口。Flutter 和浏览器文字光栅化仍可能有细微差异。

## 文件结构

```text
lib/features/home/
├── home_page.dart                  # 导航、生命周期、依赖装配
├── home_sky_background.dart        # 原图、时段天空、渐变和切换
├── application/home_controller.dart # 日期、加载、竞态、账号切换
├── domain/
│   ├── home_models.dart            # 13 个信号、读数、方向、历史、日记
│   └── home_repository.dart
├── data/
│   ├── remote_home_repository.dart # 复用原后端合同
│   ├── demo_home_repository.dart   # 仅显式 demo 配置使用
│   ├── home_preferences.dart       # 本地照片、按账号保存信号顺序
│   └── home_photo_assets.dart
└── presentation/
    ├── widgets/                    # 方向、信号、探索入口、自定义弹层、账号保护
    └── pages/                      # 全部信号、7 天历史、日记及记录表单

lib/design_system/components/
├── app_signal_card.dart            # 共享读数卡片
├── app_glass_pill.dart             # 共享磨砂胶囊操作
└── app_content_sheet.dart          # 共享内容弹层、过渡、安全区
```

公共配色、字号、尺寸、时长在 `design_system/tokens/`；文案在 `l10n/arb/`，支持葡语、英语。13 个信号使用原站 SVG；25 张背景及原天空照片全部本地打包，顺序和 `0/25` 天空选项与原站一致。来源、大小和 SHA-256 在 `assets/images/home-assets.json`。

内容弹层的遮罩使用原站 `rgba(8,10,14,.35)` 与随过渡渐入的 14px 背景模糊；保留 Flutter 原生的拖动关闭和返回手势。全局隐藏浏览器端自动滚动条，与原站 `scrollbar-width: none` 对齐。

## 数据与行为

| 接口（统一 `/api/v1` 前缀） | 用途 |
|---|---|
| `GET /me/health-data/today-direction` | 指定日期的方向、解读和建议 |
| `GET /me/health-data/daily-summary?statDate=...` | 13 个信号的原始读数 |
| `GET /me/profile` | 当前账号名字及头像 |
| `GET /mapa/overview` | 当前关系数量与既有 Mapa 入口 |
| `GET /me/diary/:date` | 所选日期的记录 |
| `POST /me/diary/events/batch` | 分类、标题、备注写入现有日记表 |

所有业务请求继续使用原后端地址及现有 Bearer 会话；日期按本地日历计算，携带检测到的 IANA 时区和当前语言。历史读取限定 7 天；404 日显示缺口，0 保留为真实读数。后端暂时不可用、无会话、无读数分别处理；没有健康资料时不套用演示用户的正常范围和评分。Mapa 仅在今天查询当前关系，历史日期不冒用当前数量。

刷新、重试、返回前台会重新加载。日期或语言快速切换时丢弃旧请求；退出或更换账号立即清理首页，已打开的历史和表单也会隐藏旧账号内容。照片和信号保存失败会提示，六个信号必须互不重复，可拖动排序；取消弹层不提交。

“查看完整方向”本次打开共享弹层，显示真实后端方向和建议。原站此入口进入 Atlas 聊天；完整聊天是独立功能，本次没有模拟其对话。日记入口提供记录列表与真实保存表单，本次不包含整个日记产品及 AI 日记生成。Mapa 复用项目已有页面与接口。

后端新增迁移 `000060_home_signal_measurements`，为已有健康汇总表添加五个 nullable 字段，详见 `BYND-backend/doc/home.md`。部署后端新版本前执行该迁移；它不会创建样例数据，也不会替代真实设备上传。原生驱动需要上传这些可选读数，缺测时继续为 null。

目前项目的登录页面仍未迁移。正式模式需要已有安全会话，未登录显示账号提示和重试；不会自动进入演示模式。

## 预览与验证

```sh
flutter run --dart-define-from-file=config/demo.json
flutter analyze --no-pub
flutter test --no-pub
flutter build web --no-pub --no-wasm-dry-run --dart-define-from-file=config/demo.json
```

`dev/test/prod` 仍接原后端，`demo` 才使用原站样例。演示日记在当前进程内保存；正式环境写入现有后端。

2026-11-09 验证结果：Flutter 静态检查无问题，116 项测试通过，Web 演示构建通过。隔离浏览器完成 13 项真实点击检查，覆盖图片及信号顺序的刷新恢复、日期切换、拖动排序、历史、全部信号、完整方向和日记保存，未出现运行时异常。后端健康汇总、日记和 intelligence 测试通过；独立 MySQL 8.0 实测了 `000060` 迁移、保存读取、部分更新、用户隔离及回滚。
