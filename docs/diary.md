# 日记模块

## 2026-11-14 原站更新

已对照本地 `V8 SDK/Reference-source-code` 的新版 `diario.html`、`base.css`、`catalogo.js` 和线上实际页面更新。主页直接记录习惯，顶部历史按钮进入独立时间线；“Como foi o dia”合并评分与私人备注。页面使用原站山峰背景图、随滚动移动的遮罩、Urbanist 字体、无圆圈的 ✓/×、磨砂“Escrever”和白色“Falar”。

主页的习惯回答直接调用现有工作区 PUT 保存；失败保留当前修改，允许重试或丢弃，并暂时阻止换日与离开。弹层内评分、备注、数量及餐食仍先修改本地草稿，确认后提交。明确“未发生”以 `details.answer:false` 保存，再次点击同一回答才清除；旧记录缺少 answer 时保持原有发生语义。

新版目录新增 75 个此前未打包的定义，前后端均为 516 个定义（其中 508 个非餐食、非流感定义）。页面按新版分类排除饮食饮料并隐藏已合并的别名；这些数字是接口完整兼容目录数量，不是原站当前用户的可选项计数。旧目录键、用户偏好和历史事件仍可读取，餐食快捷入口与时间线保留旧饮食记录。别名及分类依据见 `diary_catalog_policy.dart`。

必须同时更新后端，使工作区接口接受布尔 `details.answer`；本轮不新增表迁移，已有 `000061_diary_workspace` 仍是基础要求。接口路径、后端地址和账户隔离机制不变。

以下为最初版本的功能与接口说明；涉及旧时间线首页、旧字体/背景和旧目录数量的描述以本节为准。

参考 [BYND 原站](https://bynd-app.vercel.app/) 的日记入口、`cartoes-oura/final/diario.html`、`base.css`、`base.js`、`catalogo.js`、`pratos.js` 以及“Seus capítulos”页面。2026-11-09 通过隔离浏览器查看 DOM、CSS 和实际点击流程，不操作用户的日常浏览器或手机。

## 页面与交互

- 按日期查看时间线；复用日期带与日历。今天及前七天可编辑，更早的日子只读，服务端同样校验。
- 顶部加号、底部“Registrar o dia”、侧栏“Diário”，以及首页／设置页／活动页的记录快捷入口共用此模块。
- “Registrar”是同页上方的磨砂弹层。评分、数量、时间、餐食、备注和目录是其上的独立弹层，关闭后回到原草稿。
- 整日草稿保存前不提交事件和备注；取消会丢弃修改。追踪项设置、自定义习惯是独立保存的账户偏好。
- 支持习惯打卡、数量、时间选择、1–10 感受评分、编辑时间、编辑／删除记录、私人备注、搜索和分组筛选追踪项、自定义习惯。
- 433 个行为选项另加餐食定义。Whey 按份数记录，咖啡时间和服药时间使用时间选项，不能当作数字强制解析。
- 餐食支持份量、食物文字、24 个原站餐食组合及矢量插画、可修改的热量／三大营养素、拍照和相册附件。组合值来自原站示例，用户需要按实际食物和份量修改；照片附件不冒充食物识别结果。
- 文字和语音调用现有 `/events/parse`，先显示待核对结果，用户确认后才加入草稿。语音不可用或权限被拒绝时可以继续打字。后端 LLM 不可用时保留既有规则解析。
- “Seus capítulos”展示两周窗口、数字、已有成就和记录。真实模式从健康汇总、日记、已有 Journey 里程碑取数；演示模式展示原站五个章节。不会生成不存在的健康趋势或因果结论。

## 文件结构

```text
lib/features/diary/
  domain/
    diary_models.dart                 # 日期、追踪项、事件、整日及仓库接口
    diary_media.dart                  # 随包媒体白名单
  data/
    remote_diary_repository.dart      # 真实鉴权接口，账户变化后拒绝旧请求
    demo_diary_repository.dart        # 明确开启演示时使用；本地持久化
  presentation/
    diary_page.dart                   # 日期、时间线、全局快捷菜单、账户隔离
    diary_record_sheet.dart           # 整日草稿、备注、保存及冲突提示
    diary_catalog_sheet.dart          # 搜索、分组、偏好、自定义习惯
    diary_moment_editor.dart          # 评分、数量、时间、餐食、照片
    diary_capture_sheet.dart          # 语音／文字及结果核对
    diary_chapters_page.dart          # 两周章节
    diary_widgets.dart                # 日记行、时间线、分区与 SVG
lib/design_system/tokens/app_diary_style.dart
lib/shared/widgets/app_sheet_controls.dart
assets/data/diary-{catalog,meals,demo,demo-pulse,demo-chapters}.json
assets/icons/site/diary-*.svg
assets/images/diary/*.svg
assets/images/diary/*.png             # 浏览器原样渲染，保留原站 SVG 滤镜阴影
assets/images/diary-band.png
assets/images/diary-assets.json        # 原始来源和 SHA-256
```

首页原 `HomeDiaryPage` 保留为薄入口，携带首页选中的日期；功能实现已经移到 diary feature。原 Home 仓库的旧日记方法保留兼容，不再用于新日记页面。

## CSS 对照

Flutter 不运行 CSS，原站变量映射为共享 Dart token。

| 原站规则 | Flutter |
| --- | --- |
| `--b: #f4f5f7`，`.72/.5/.35` 透明度 | `AppColors`，`AppDiaryStyle.faint` |
| `--cartao: rgba(255,255,255,.043)` | `AppDiaryStyle.surface` |
| `--traco: rgba(255,255,255,.08)` | `AppDiaryStyle.line` |
| `.tel` 底色 `#151a24 → #121620 45% → #0e1118` | `AppDiaryStyle.background` |
| `.tel` 顶部蓝色渐变在 `0/140/260/380px` 衰减 | `AppDiaryStyle.headerWash` |
| `.fl` `rgba(20,24,30,.62)`，磨砂 14px | `AppColors.contentSheetGlass`，`showAppContentSheet(glass:true)` |
| `.t1` Urbanist 26 / 300 / 31 | `AppDiaryStyle.title` |
| `.sec` Urbanist 20 / 300 / 25 | `AppDiaryStyle.section` |
| 行标题 Geist 15 / 400 / 19 | `AppDiaryStyle.label` |
| 说明 Geist 13 / 300 / 17 | `AppDiaryStyle.caption` |

页面继续使用本地 Geist、Urbanist 字体；标题通过公共 `AppPageHeader` 居中。公共内容弹层增加可选磨砂模式，其他页面保留原默认背景。

## 真实接口

全部路径位于原后端 `/api/v1` 下，使用原 JWT 和当前账户。后端地址、应用身份和环境约定未改变。

| 方法 | 路径 | 用途 |
| --- | --- | --- |
| GET / PUT | `/me/diary/:date/workspace` | 读取／原子保存整日事件、备注和修订号 |
| GET / PUT | `/me/diary/catalog` | 原站目录、账户偏好 |
| POST | `/me/diary/catalog/custom` | 创建个人习惯 |
| POST | `/me/diary/events/parse` | 复用文字／语音解析，返回待核对事件 |
| POST | `/me/diary/photos` | JPG/PNG 附件上传，2MB 上限 |
| GET | `/me/diary/chapters` | 近 70 天、最多五个两周章节 |

整日 PUT 包含 `revision`、稳定的事件 UUID 和 `mutationId`。数据库事务锁定日记父行；旧修订返回 409，完全相同的最近一次请求重试不会重复写入。事件 ID 必须属于当前账户和日期，已删除 ID 不能复活。旧版追加／删除接口仍保留，并同步增加修订号。

照片使用现有私有对象存储，保存对象键，读取时生成短期签名 URL；事件只能引用自己账户、该日期下的图片。需要后端已配置可用的 Object Storage。取消记录后已上传但未引用的对象暂时不会自动清除；删除事件也保留附件对象，服务端存储清理任务尚未接入。

真实时间线只从已有、带真实时间戳的设备睡眠和设备运动记录生成自动事件，不拿日汇总虚构“压力峰值发生在几点”。历史同步的数据覆盖范围取决于既有采集与同步链路。本次不改变手环 SDK 或补写 BLE 健康数据同步。

## 接入和运行

1. 后端先执行新增 `000061_diary_workspace.up.sql`，再启动新后端；默认跳过 AutoMigrate 的环境不会自动增加这些字段。详见后端 `internal/module/diary/README.md`。
2. 保持现有登录账户／JWT 接入及 Object Storage 配置。真实模式没有登录令牌时显示登录要求，不回退到原站样例。
3. 开发运行：`flutter run --dart-define-from-file=config/dev.json`。
4. 单独验收原站样例：`flutter run -d chrome --dart-define-from-file=config/demo.json`。演示日记使用独立的 `bynd.diary.demo.v1.*` 本地键。

Android 已添加录音权限和语音服务可见性；iOS 已补齐相机说明并更新语音／相册用途。Android 构建通过；iOS 构建和相机、语音的手机权限弹窗尚未在本次 Windows 环境真机验收。

## 验证

新增测试覆盖整日取消与保存、评分、时间型输入、演示持久化、真实请求的 JWT／日期／修订／稳定 UUID；后端隔离 MySQL 验证迁移升降级、整日保存、重试、并发冲突、无效输入回滚、账户隔离、禁用偏好及真实健康章节。完整 Flutter／Go 回归和构建结果以本次任务交付说明为准。

浏览器实点已检查侧栏进入日记、记录弹层、餐食编辑、目录搜索、文字核对后保存、更新时间线与打开章节。演示版截图：[时间线](screenshots/diary-timeline.png)、[记录弹层](screenshots/diary-record.png)、[章节](screenshots/diary-chapters.png)。
