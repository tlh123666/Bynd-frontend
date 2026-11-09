# 设备管理

## 参考范围与实现

参考站：<https://bynd-app.vercel.app/>。2026-11-08 实际点击侧栏 BYND ONE、状态/高级标签和全部六项操作，并读取 `main-ClJ891p2.js`、`main-al-ufcvR.css`。原站高级操作和“Sobre”按钮没有业务处理函数；新增确认、配对、执行与错误流程沿用原站视觉语言。

按以下顺序实现并验收：

1. 下载原图和六项 SVG，记录来源与摘要；将 `.pl-*` 颜色、尺寸、字体映射到 Flutter token。
2. 实现侧栏入口、状态页、可滚动高级页、说明页，以及可复用的页头、下划线标签、渐变卡片和确认面板。
3. 用 controller/repository/gateway 分离界面、账号数据和设备通信；演示环境可持久化配对/解绑状态，真实模式不回退到模拟成功。
4. 扩展现有 Go 设备模块：原子换绑、遥测状态、固件发布查询、带幂等键和结果确认的操作记录。
5. 检查加载/空设备/离线/失败状态、危险操作取消、连点、换绑失败、持久化恢复，并构建 Web 后用浏览器实际点击。

```text
lib/
  core/network/                         # 跨平台 HTTP 与统一错误
  design_system/components/             # 公共页头、标签、卡片、确认面板
  features/device/
    domain/                             # 设备、固件、扫描结果、仓库/通信契约
    data/                               # 演示持久化、HTTP 仓库、平台通信适配
    application/                        # 状态与操作时序、环境装配
    presentation/pages/                 # 状态/高级、配对、固件、说明
    presentation/widgets/               # 手环连接插画与侧栏设备卡片
assets/images/device-band.png           # 原站透明 PNG
assets/images/device-assets.json        # 原图/SVG 来源与 SHA-256
```

## 样式依据

Flutter 项目使用 `AppColors/AppSizes/AppTypography` 承接 CSS 变量，不在页面中硬编码重复颜色。状态/高级共用同一页头和标签。原站 `.pl` 自身的渐变被 `background:transparent!important` 覆盖，最终可见背景来自当前 `.screen`：`linear-gradient(#222c38 0%, #1a2029 22%, #121418 50%)`。字号、字重和字距均按计算样式核对，避免继承 Material 默认字距。

主要尺寸：页头 52、图标触控 44、左右边距 22/高级 21、标签间隔 26、卡片圆角 20。状态插画高 260，原图高 224，左侧溢出 46；手机框 118×210。标题 Geist 17/500；操作标题 15.5/400、说明 13/400/1.45；指标 Urbanist 24/300。

## 环境与真实设备边界

默认沿用 JCVital 的原后端与非演示配置；页面演示使用 `--dart-define-from-file=config/demo.json`。演示操作与对话框明确标注“Demonstração”，数据只保存在当前安装/浏览器。真实模式从统一 AppConfig 和 AuthSession 读取服务地址及 bearer token；测试可注入 controller/repository/gateway。详见 [环境配置](environments.md)。

真实设备使用 `com.bynd/device_management` MethodChannel。Android 已从 JCVital 接入 V8 SDK，实现系统权限、扫描、连接、设备状态读取及断开；详情见 [Android 真机蓝牙](android-ble.md)。重启、仅清除未同步记录、签名 OTA 和 iOS 驱动尚未接通，能力预检会明确拒绝，避免创建虚假的成功记录。以下表格中这些方法保留为待接入合同。设备身份来自硬件上报；云端 UUID 与本机传输地址分开保存。

原生适配方法：

| 方法 | 输入与返回 |
|---|---|
| `scanDevices` | 返回 `{deviceId,name,rssi}` 数组；处理蓝牙权限、开关和扫描超时 |
| `connect` | 输入本机 `deviceId`；读取厂商稳定 `serialNumber`、`manufacturer/modelCode/modelName`、`firmwareVersion/hardwareRevision` 和电量，再返回成功 |
| `readStatus` | 输入本机设备 ID 和稳定序列号；返回真实 `connected/batteryPercent/rssi`，以及已确认的 `firmwareVersion/lastSyncedAt` |
| `disconnect` | 关闭本机链路，完成后返回 |
| `restart` | 收到手环重启命令应答后返回；不能在写入 GATT 队列时提前返回成功 |
| `eraseUnsyncedData` | 仅清除厂商 SDK 对应的未同步健康记录；收到应答后返回，不恢复出厂、不删除账号数据 |
| `installFirmware` | 接收固件元数据；校验 SHA-256、型号和厂商签名，等待安装及版本确认成功；进度通过 `com.bynd/device_management_events` 的 `{type:firmwareProgress,deviceId,progress:0..1}` 上报 |

约定错误码包含 `permission_denied`、`bluetooth_off`、`device_disconnected`。原生方法缺失、超时或失败都会进入可重试错误状态。绑定沿用后端已有的“完成或跳过体质问卷”前置条件，不绕过账号或设备归属验证。

## 后端契约

复用 `/api/v1/me/devices` 的 JWT 鉴权和绑定模型；所有管理查询/写入先验证当前用户拥有该设备。新增管理 API、表和迁移见 `BYND-backend/doc/device-management.md`。

关键约束：换绑在数据库事务中完成；账号失败不能删除旧绑定；请求 ID 保持幂等；设备操作创建后为 pending，只有客户端收到硬件应答才提交结果；清除设备数据不会删除云端健康历史；固件无已发布包时不会伪造升级包或下载链接。

## 本次验证

- `flutter analyze --no-pub` 无问题；全部 57 项 Flutter 测试通过；Web 构建通过。
- 浏览器以 390×844 实际点击原站和本地构建页，核对最终计算样式；本地实测重启确认/取消、固件检查、安全页、清除取消、解绑、配对、刷新恢复，未捕获页面异常。
- Go 设备模块测试通过。在独立启动的临时 MySQL 8.0.26 上运行 `TestDeviceManagementMySQL`，验证迁移 up/down/up、状态时序、归属隔离、操作幂等、固件兼容与确认、失败换绑回滚、成功换绑和解绑历史保留。
- 未对已有业务数据库执行迁移，未向真实手环发送命令。部署时先执行新增迁移，再通过登录会话和厂商驱动接入真实模式。
