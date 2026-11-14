# Android 真机蓝牙接入

## 原因

此前设备页提示“此版本尚未提供蓝牙”，是 Dart 捕获 `MissingPluginException` 后显示的文案。新项目只有 `com.bynd/device_management` 的 Dart 调用，`MainActivity` 没有注册处理器，也没有引入厂商 SDK。APK 编译安装成功不代表自定义原生通道已经实现。

本次从 JCVital 迁入 Android V8 SDK 和已经使用的原生控制器，保持旧后端与硬件型号标识。未修改 JCVital 源文件。

## 结构与复用

```text
android/app/libs/v8sdk1.0.jar                 # 与 JCVital 的 SDK 字节相同
android/app/src/main/kotlin/com/bynd/bynd/
├── MainActivity.kt                         # 注册通道、转发权限结果、销毁清理
└── ble/
    ├── JStyleBleController.kt               # 从旧项目迁入，补充管理状态读取
    ├── DeviceManagementChannelHandler.kt   # 适配新 Dart 合同及系统权限申请
    └── BandDeviceIdentity.kt               # 复用旧项目的嵌套身份字段规则
android/app/src/test/kotlin/.../ble/
└── BandDeviceIdentityTest.kt
```

Gradle 引入原 `v8sdk1.0.jar` 和旧项目使用的 `desugar_jdk_libs:2.1.5`；无需仅为本通道新增 `flutter_blue_plus` 或 `permission_handler`，系统权限由 Android 原生桥接处理。

## 已接通的能力

- `scanDevices`：真实 BLE 扫描，8 秒收集窗口，返回设备地址、名称和 RSSI。
- `connect`：发现 V8 的 FFF0 服务、FFF6 写入、FFF7 通知特征，开启通知后读取设备 MAC、电量、固件版本，再返回。
- `readStatus`：按已保存的本机地址连接或恢复连接，读取状态并核对硬件身份。
- `readSleepHistory`：先连接并校验序列号，再读取 V8 历史；睡眠页将已结束的睡眠分段幂等上传到当前账号，详见 [睡眠功能](sleep.md)。
- `disconnect`：只断开指定地址；旧设备清理不会断开已经换绑的新连接。
- `stopScan`、`close`：离开扫描页或销毁应用时结束扫描、待处理结果与本机连接。
- `capabilities`：如实声明当前原生支持的功能，未支持的写操作会在创建后端操作记录之前拒绝。

仍保留原站设计和原有云端绑定流程。Native 不写后端账号，不绕过 JWT、体质问卷、设备归属校验。真实绑定继续沿用 JCVital 的 `V5` 硬件型号标识；BLE 本机地址和云端设备 UUID 分开保存。

身份优先取 SDK 真实上报的序列号/设备 MAC；SDK 未返回身份或返回全零 MAC 时不会用展示名代替，也不会假装连接成功。电量 0 是有效值，未收到电量回包保持未知。读取设备元信息不等于完成健康数据同步，不因此更新 `lastSyncedAt`。

连接管理默认不启动旧项目的自动心率测量循环。旧控制器的历史读取代码保留，但完整健康数据同步、后台重连与上传流程还没有从旧前端迁完。

## 权限

Android 12 及以上扫描请求“附近设备”（`BLUETOOTH_SCAN` / `BLUETOOTH_CONNECT`）；Android 6–11 扫描请求定位权限，并检查定位服务是否开启。未授权、蓝牙关闭、定位服务关闭分别显示可操作提示，不统一冒充 SDK 缺失。

首次点击“Parear pulseira”后，在手机弹出的系统授权框选择允许。永久拒绝时，进入系统应用权限设置重新开启，再重试。

## 边界

旧 V8 SDK 的 `Reset()` 不等于“仅清除未同步记录”。重启的硬件确认流程、仅清未同步数据、厂商签名 OTA 暂未实现；均报告 `unsupported_operation`，不会写入成功回执，也不会拿恢复出厂代替清除。iOS 的原生驱动本次未迁移。

扫描设备不需要伪造账号。云端绑定和睡眠上传需要有效登录会话，使用当前项目已接入的登录流程。没有会话时可验证扫描，但绑定会如实提示先登录。演示模式仅用于 UI，不替代真机测试。

## 编译与验证

原生代码变化必须重新安装 APK，热重载/热重启无法把缺失的原生通道加入已安装应用：

```powershell
flutter run -d 1e496b7c --dart-define-from-file=config/dev.json
```

```sh
flutter analyze --no-pub
flutter test --no-pub
flutter build apk --debug --no-pub --dart-define-from-file=config/dev.json
# android/，使用与 Flutter 一致的 JDK
./gradlew :app:testDebugUnitTest
```

测试覆盖真实通道合同、云端 UUID 与本机地址分离、缺失/不匹配身份、权限错误、扫描取消、换绑回滚和不支持的硬件操作预检。实际手环的连接与元信息回包需在用户允许系统权限并选择手环后验收，不自动连接附近的其他蓝牙设备。

2026-11-09：Android APK 构建和原生身份解析测试通过，修复包已更新到连接的开发手机；用户反馈已可以连接手环。该反馈确认基础连接可用，不代表云端绑定、完整健康同步或 OTA 已验收。

运行日志中的 `Skipped frames`、Vulkan、MIUI 输入和窗口日志不是此次缺失蓝牙通道的原因。`Lost connection to device` 仅说明 Flutter 调试连接中断；需结合当时进程、USB/ADB 状态和崩溃堆栈判断，不能仅凭这行认定应用崩溃。
