# 心率、心脏与脉搏记录

参考地址：<https://bynd-app.vercel.app/coracao.html?app&p=coracao>，核对日期 2026-11-14。按当前生效的页面与弹层实现，未采用源码中已被提前 return 的旧版详情屏。

## 入口

- 首页「FC repouso」或「Saúde → Coração e corpo → FC em repouso」进入心率总览。
- 首页 VFC、Oxigênio 和呼吸信号进入对应详情。
- 各页面右下角「更多 → Fazer ECG」打开采集说明。
- 总览「FAZER NOVO ECG」开始新记录，「Ver todos os registros」打开历史；右上角齿轮进入设置。

## 目录与复用

```text
lib/features/heart/
  application/       # 日期/账号状态、真实采集、历史同步、PDF/CSV
  data/              # 已认证 API、独立 demo 仓库、Android/EventChannel
  domain/            # 数据合同、带时间戳的 SDK 历史转换
  presentation/
    pages/           # 总览、30 秒采集
    sheets/          # 日/周/月、设置、记录列表、报告
    widgets/         # 曲线、趋势、原始波形与账号保护
lib/features/diary/presentation/diary_quick_questions.dart
lib/design_system/components/app_metric_card.dart
lib/design_system/components/app_atmosphere_background.dart
lib/design_system/tokens/app_heart_style.dart
```

`AppHeartStyle` 对照最终 computed CSS：Geist、64/200 的主数值、28/300 标题、34/300 卡片读数、15/400 正文、13/400 次级文本、11/500 字母间距 1.54 的标签。心脏色 `#f2b1ad`，正文 `#f4f5f7` 的 72%/50% 透明度，卡片白色 3.5%→1.2% 渐变、12 圆角。背景移植原站 `ceuVivo` 的线性颜色、分形噪声、光带和暗角公式，Flutter 使用插值网格替代原站 WebGL；尊重减少动画设置。原站 CSS 渐变只是 Canvas 启用前的后备背景。

原站说明图片 `assets/images/heart-ecg-band.png` 来自 `/img/pulseira-ecg.png`；两个原站 SVG 与哈希记录在 `assets/icons/site/heart-source.json`。`assets/data/heart-demo.json` 是参考站生成的 60 日演示人物读数，只供 `config/demo.json`。演示采集和 ECG 历史波形为显式模拟数据，绝不在接口错误时填入真实账号。

## 接口与数据

继续使用项目现有 API 地址、登录令牌、错误处理与设备云端序列号。后端须执行 `000064_heart_experience`，本次没有修改真实数据库。

| 接口（前缀 `/api/v1`） | 用途 |
| --- | --- |
| `GET /me/heart-rate/experience?date&timezone` | 当日汇总、最新读数、个人基线、关联 HRV/血氧/血压/呼吸、运动后恢复 |
| `GET/POST /me/heart-rate/samples` | 真实时间序列与 SDK 批量上传 |
| `GET /me/heart-rate/trend?endDate&days&timezone` | 7/30 日趋势；保留原有 Premium 权限 |
| `GET/PUT /me/heart-rate/settings` | 三个展示/提醒偏好，保存 false，保留旧版训练区配置 |
| `GET/POST /me/heart-rate/ecg/records` | 记录列表（日期与游标分页）、幂等保存采集 |
| `GET/PATCH/DELETE /me/heart-rate/ecg/records/:id` | 原始波形、测量情境/症状、删除 |
| `POST /me/health-data/batches` | SDK 带时间戳的 HRV/血氧/血压事实 |
| 现有日记 workspace API | 心悸、较咸饮食、饮酒三个问题，复用 `c_palpit/c_sal/alc` |

曲线展示已保存的一分钟聚合样本；大间隔断线，不插值伪造。趋势平均值忽略缺失日期。当前读数超过五分钟不标为「现在」。基线至少需要此前 28 日中 7 个质量正常且有睡眠读数的夜晚。提醒页比较最近 30 个日期内有读数的夜晚；未实现「连续 10 分钟」实时设备告警或推送，设置描述按实际能力说明。

运动后恢复仅在最新训练结束前 30 秒内、结束后 45–75 秒内同时存在真实心率样本时计算，并返回实际测量时间；不支持的历史周期不显示。血压仅展示设备估计值。无数据、部分加载失败、权限限制与离线均有对应状态，不代入参考人物值。

恢复值的前后样本限定为训练对应的同一设备，排除归属于其他训练的样本；结束前读数不得早于训练开始。优先按设备序列号匹配，旧记录缺少序列号时按设备 ID 匹配，设备身份不明则留空。距离一分钟相同的读数采用固定顺序选取，避免数据库返回顺序影响结果。

日记保存先读取最新版本再合并目标条目，保留其他习惯与备注。切换日期时忽略旧请求；切换账号立即清空心率与采集状态。保存失败保留原始波形与幂等请求 ID，可重试。未保存的报告备注关闭时确认；导出前先保存备注。波形沿用后端 90 天保留策略，过期后仍可查看摘要。

## 真机能力与运行

Android 复用原 JCVital 的 V8 驱动，并新增 `com.bynd/heart_events`。已核对当前 SDK 的 `BleConst.Getppg / DeviceKey.arrayPpgRawData`：它返回**光学脉搏波 PPG**，不能称为电极 ECG，也不能据此输出「正常心律」或房颤分类。界面沿用原站 ECG 入口，但采集说明、报告、PDF 和 CSV 均按实际信号标识 PPG，未验证的节律保持「未分类」。未知旧记录标为 SENSOR。

真实采集仅 Android：验证连接与绑定序列号后采集 30 秒；中断、无波形超时、切换账号、退出和应用进入后台会停止采集。Web/iOS 可查看服务端历史和导出，真实蓝牙入口显示不可用。demo 环境独立模拟完整过程，不需要真实手环。

进入后台会同时取消「正在启动」和「正在测量」两种状态，恢复前台不会自动重新测量。重新开始时读取当前设备快照；正在进行的采集和保存重试保留原设备归属。新启动会等待旧的停止命令与事件订阅清理完成，旧启动的延迟响应不能停止新采集。

```sh
flutter pub get
flutter run --dart-define-from-file=config/dev.json
# 独立演示
flutter run -d chrome --dart-define-from-file=config/demo.json
```

本次含 Android 原生通道和插件变化，需要停止应用后完整重启/重新安装，热重载不足以加载新通道。

若旧的 Web 构建出现分享/PDF 的 `MissingPluginException`，先 `flutter clean`、`flutter pub get` 后重新构建。当前 Flutter SDK 的 Web 入口构建标记未将新增插件列入依赖，可能保留旧插件注册文件；本次已重新生成并检查注册了 PrintingPlugin 和 SharePlusWebPlugin。

验证包含 Flutter 静态分析、心率/睡眠及全量回归、Android debug APK、Web 构建、独立浏览器实际点击。真实数据库迁移和物理手环采集仍需在对应环境进行联调；本次未登录或改动真实用户数据。
