# 睡眠

入口：Home 的 Sono 信号卡片，以及全部信号列表中的 Sono。跟随首页选中的日期；可在睡眠页切换日期、下拉刷新，点击图表查看详情。

## 设计依据

本次核对的是原站实际加载的 `/sono.html?app`，以及下载目录 `V8 SDK/Reference-source-code/BYND App_files/sono.html` 和 `mini-diario.js.下载`。没有采用主 JS 中已经停用的旧版睡眠路由。

复用 Urbanist、公共页头、DayStrip、玻璃弹层、按钮、通知提示、底栏和快捷操作。睡眠专用 CSS 值集中在 `AppSleepStyle`：分数 64/200、标题 28/300、时长 34/300、正文 15；卡片白色透明度 .035 → .01、圆角 12。睡眠阶段颜色取原页面最终覆盖后的计算值，四类均为白色。背景采用原站蓝灰天空配色的渐变；网页的程序化天空动画没有位图资源需要下载，当前 Flutter 使用静态渐变。

页头返回和设置 SVG 直接提取自原 HTML，保存在 `assets/icons/site/sleep-*.svg`，来源、选择器与哈希记录于 `sleep-source.json`。

包含评分、夜间时长/卧床时间、阶段与心率图、每日方向、目标规划、睡眠债、觉醒、呼吸/血氧入口、小睡、周表现、三项日记问题、测量指标和 Atlas 入口。图表支持点按/拖动；详情提供日/周/月切换。未测得的呼吸频率、体温、鼾声和翻身次数显示缺失说明，不生成个人读数；觉醒次数明确按后端 wakeCount 展示。

## 目录

```text
lib/features/sleep/
  application/   # 日期/请求状态、账号隔离、手环上传、原生提醒与会话生命周期
  data/          # RemoteSleepRepository、独立 DemoSleepRepository
  domain/        # API 模型、指标、V8 睡眠分段拼接
  presentation/
    pages/       # SleepPage
    sheets/      # 指标详情、偏好、规划、提醒编辑
    widgets/     # 阶段图、历史图、时钟弧、日记问题
lib/design_system/tokens/app_sleep_style.dart
assets/data/sleep-demo.json
test/features/sleep/
```

## 数据与接口

使用环境配置中的原 API 地址与登录令牌，接口前缀 `/api/v1`：

| 接口 | 用途 |
| --- | --- |
| GET `/me/sleep/experience?date=YYYY-MM-DD` | 选中夜晚的 session、summary、实测 vitals |
| GET `/me/sleep/insight` | 日期、语言和时区对应的方向文案 |
| GET/PUT `/me/sleep/preferences` | 就寝/起床时间、目标分钟数、提前提醒及显示开关 |
| GET `/me/sleep/sessions` | 当日小睡列表 |
| GET `/me/sleep/sessions/:id` | 小睡详情 |
| GET `/me/sleep/trend` | 周/月历史，保留服务端 Premium 权限校验 |
| POST `/me/sleep/sessions` | Android 手环真实睡眠分段上传 |
| GET/POST `/me/sleep-plans` | 读取/新增提醒，最多五条 |
| PUT/DELETE `/me/sleep-plans/:id` | 更新/删除提醒 |

三项日记问题使用现有 Diary workspace 接口，键为 `cafe15`、`alc`、`tela`。每次回答先获取最新 revision，只替换对应习惯，保留其他记录与备注；重复点选会清除该回答。只读日期不能编辑。接口失败不显示保存成功。

睡眠债按最近七个日历日内有完整夜间记录的日期计算：`max(0, 有效夜数 × 用户目标分钟 − 这些日期的总睡眠分钟)`。总睡眠已含小睡，不重复减去；缺失和部分记录不算作零分钟。返回 `sleepDebtNights`，不把少量记录当作完整七天。无有效记录返回缺失。历史接口仍受 PremiumGuard 保护，前端显示锁定状态。

真实模式不回退演示数据。`config/demo.json` 显式启用参考样本，包含原站六十晚演示值与原站生成的演示心率曲线，仅用于演示。演示偏好和提醒使用单独的 SharedPreferences 键，不请求手机通知权限。

## 后端部署

在已具备原有 sleep、sleepplan 和 Diary 表的数据库执行 `BYND-backend/migrations/000063_sleep_display_preferences.up.sql`，然后重启后端。增加 `target_sleep_minutes`（默认 480）和三个显示开关（默认开启），旧客户端不传新增字段时保留原值。目标范围 360–600 分钟。迁移提供 down 文件；回滚会删除新增偏好字段。

本次没有自动操作用户数据库。后端关闭 AutoMigrate 的环境必须执行迁移后再试设置保存。

## 手环与通知

Android 真实模式提供同步按钮，调用现有 V8 蓝牙驱动读取历史并校验手环序列号。复用 JCVital 的分段拼接规则，结束不足三十分钟的记录等待下次同步，按最多 24 个 session 一批上传。确定性的 clientRequestId 与服务端唯一键保证重复同步幂等；上传只包含时间和阶段事实，分数、总时长由后端重算。此功能不清除手环历史，不伪造呼吸/体温。iOS 尚无本项目手环驱动，Web 不提供原生蓝牙同步。

提醒计划保存到服务端；Android/iOS 使用本地通知，按计划 IANA 时区和周掩码安排，提前提醒跨午夜时会调整星期。Android 使用 inexactAllowWhileIdle，重启由插件接收器恢复；系统节电策略可能延后通知。权限在用户启用并保存提醒时请求，拒绝时仍保存云端计划并明确提示。Web 仅保存计划。登出清除当前设备的睡眠提醒；登录后重新读取当前账号的计划，保留其他业务通知。沿用旧 JCVital 的 43000–43034 通知 ID，避免升级后重复提醒。

新增原生插件后需要 `flutter pub get` 并完全停止后重启应用，热重载不足以注册插件。Android 已编译检查；本次没有连接实际手环或在手机上验证通知送达，iOS 也未在 Windows 上编译。

## 验证

测试覆盖真实 API 合同、Premium 锁定、偏好 false 值与分钟精度、日期请求竞争、账号隔离、阶段拼接、分批幂等上传、提前提醒跨日/DST、日记合并、详情与设置失败、小屏及大字体。页面资源和截图检查使用 `.codex-temp`，不向项目添加验收截图。
