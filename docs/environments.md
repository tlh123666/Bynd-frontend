# 环境与基础配置

`new_jcvital` 是 `JCVital` 的重构。默认服务和应用身份沿用原项目，不创建新的后端或商店应用。

## 保持一致的值

| 配置 | 值 | 原项目依据 |
|---|---|---|
| 后端 origin | `https://api.byndhealth.com.br` | `lib/providers/api_client_provider.dart` |
| API 路径 | `/api/v1` | `lib/core/network/api_endpoints.dart` |
| Android/iOS Application ID | `com.byndhealth.app` | Android Gradle / Xcode 项目 |
| Android namespace | `com.bynd.bynd` | 原 Android Gradle 与 MainActivity |
| Apple Team | `A5HHXX46ZH` | 原 Xcode 项目 |
| 版本基线 | `1.1.0+25` | 原 pubspec.yaml |
| Google OAuth Web Client | 原 `537472521708-…apps.googleusercontent.com` 客户端 | `google_auth_service.dart` |
| 安全令牌键 | `auth.access_token` | 原 `auth_repository_impl.dart` |
| 用户缓存键 | `auth.user_id / user_phone / user_email / user_nickname / user_avatar_url` | 原登录仓库 |
| 语言键 | `app_locale` | 原 locale provider |
| RevenueCat entitlement | `premium` | 原 SubscriptionService |
| 超时 | 连接15秒、接收30秒 | 原 ApiClient |

`AppConfig.apiBaseUrl` 对应原来的 origin；`apiV1BaseUrl` 统一补上 `/api/v1`。旧地址带 `/api/v1` 或接口常量已带该前缀时只保留一份。原项目的 API 路径常量已迁入 `core/network/api_endpoints.dart`。

## 目录

```text
config/
  dev.json / test.json / prod.json / demo.json
  local.android.example.json / local.desktop.example.json
assets/config/
  .env.example                 # 只含公开客户端配置
  .env                         # 可选本机覆盖，Git忽略
lib/core/
  config/                      # 参数解析、校验与可选环境加载
  bootstrap/                   # 配置→会话→语言→时区→方向→runApp
  auth/                        # 原令牌键的安全存储和内存桥接
  localization/                # 原语言键恢复和 Accept-Language
  network/                     # 统一URL、Bearer、401、超时及脱敏请求摘要
  utils/local_timezone.dart
.vscode/launch.json
tool/flutter_env.dart
android/key.properties.example
```

## 运行与构建

在 `new_jcvital` 下执行：

```sh
flutter run --dart-define-from-file=config/dev.json
flutter run -d chrome --dart-define-from-file=config/demo.json
flutter run --dart-define-from-file=config/test.json
flutter build web --dart-define-from-file=config/prod.json
flutter build appbundle --dart-define-from-file=config/prod.json --build-number=26
```

开发、测试、生产三份配置均使用**原后端地址**；`test.json` 表示客户端测试配置，没有假设另一个未提供的测试服务器。演示配置显式启用模拟设备，其他配置沿用原项目 `MAPA_USE_DEMO_DATA=false` 的默认行为。后续若有独立测试服务，修改对应配置即可。

也可在 VS Code 打开 `new_jcvital` 文件夹，选择 `BYND · 开发/测试/生产/页面演示`；或使用跨平台包装命令：

```sh
dart run tool/flutter_env.dart run dev -d chrome
dart run tool/flutter_env.dart run demo -d chrome
dart run tool/flutter_env.dart build prod web
dart run tool/flutter_env.dart build prod appbundle --build-number=26
```

包装命令先验证配置文件，再将参数交给 Flutter；`--dry-run` 只打印命令。Flutter 不在 PATH 时可设置 `FLUTTER_BIN` 指向本机 flutter/flutter.bat。

## 覆盖顺序与配置边界

优先级：`--dart-define`/`--dart-define-from-file` > 可选 `assets/config/.env` > 原项目默认值。`DEVICE_DEMO` 未设置时继承旧开关 `MAPA_USE_DEMO_DATA`，默认关闭。生产环境必须使用 HTTPS、关闭演示数据，并强制关闭网络日志。

本机已将原 `.env` 中 CARTO、RevenueCat 等公开客户端项按白名单迁入忽略的 `.env`；Google 客户端 ID、Android Firebase 配置保持原值。新检出仓库可从 `.env.example` 创建本机配置，文件缺失不影响启动。客户端配置会进入安装包，只放公开 SDK 参数；原 ARK 服务端密钥不迁入客户端。

会话在启动时从安全存储恢复，沿用原键。HTTP 客户端每次请求读取当前令牌与语言，401 清除对应旧会话；迟到的旧请求不会清掉刚登录的新会话。登录模块可以调用 `AuthSession.instance.setAccessToken(token)`，登出调用 `signOut()`，不通过编译参数传访问令牌。语言优先恢复 `app_locale`，其次系统语言（pt/zh/en），再回退葡语；现有页面的业务文案按页面迁移。

## 本地后端

`BYND-backend/etc/config_dev.yaml` 使用8081，常规 `config.yaml` 使用8080。示例分别为 Android 模拟器的 `http://10.0.2.2:8081` 和桌面/Web/iOS模拟器的 `http://localhost:8081`：

```sh
flutter run --dart-define-from-file=config/local.android.example.json
flutter run -d chrome --dart-define-from-file=config/local.desktop.example.json
```

真机使用电脑的局域网地址，不能用真机自身的 localhost。可复制示例为 `config/dev.local.json`（Git忽略），填写实际地址；Android Debug 若使用局域网HTTP，还需在 `android/app/src/debug/res/xml/network_security_config.xml` 增加对应主机的 domain。默认仅放行 localhost、127.0.0.1、10.0.2.2；release 保持 HTTPS。iOS Debug 的独立 Info-Debug.plist 仅配置本地网络和 localhost 例外，Release/Profile 使用无该例外的 Info.plist。Web 的后端仍须允许当前 origin 的 CORS。

## 平台与发布

- Android 已加入正式包联网、蓝牙、定位等原项目能力声明；硬件保持可选。未迁入的通知接收器或原生服务不在 Manifest 中注册空类。Windows Kotlin 增量缓存关闭，沿用原项目设置；机器级代理和 SDK 路径由本机配置。
- Android release 使用 `android/key.properties`，格式和相对路径规则与原项目一致，必须引用原上传证书。原项目本机没有这些私有文件，已提供示例；缺失会阻止 release 构建，不使用 debug 证书替代。下一次商店上传 build number 必须高于原25。
- iOS 已沿用原应用ID、Team、iOS15最低版本和权限说明，加入安全存储 Keychain entitlement；macOS 补客户端联网及 Keychain 配置。iOS/macOS 签名和构建仍需在有原 Team 证书的 Mac 验证。
- Web、桌面显示名称统一为 ByndHealth；桌面可执行文件名保持项目构建约定。Linux 安全存储还需要系统 `libsecret` 开发依赖。
- Android Firebase客户端文件已复制，Google Services 构建插件已接入。推送、Google登录、订阅、地图、蓝牙驱动等业务 SDK 的服务初始化仍随各功能迁移；配置就绪不代表这些功能已经全部迁移。原项目没有可用的 iOS Firebase配置文件，因此没有生成虚假配置。

参考：[Dart Code 启动配置](https://dartcode.org/docs/launch-configuration/)、[Android网络配置](https://developer.android.com/privacy-and-security/security-config)、[flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage/versions/10.3.1)。

## 本次验证

- 69项 Flutter 测试通过，静态检查无问题。
- Android Debug APK 构建通过；产物确认包名 `com.byndhealth.app`、版本 `1.1.0`/25、显示名 ByndHealth 以及 INTERNET 权限。
- `:app:verifyReleaseSigning` 在缺少原签名材料时按预期报错，未回退到 debug 签名。
- 生产 Web 构建通过；本地浏览器实测启动无异常、无模拟设备数据，未登录时显示会话要求，没有向原后端发送未授权业务请求。
- iOS/macOS 已核对 plist、bundle ID、Team、网络和 Keychain配置；Windows 环境不能替代 Mac 上的 Xcode 编译和签名验证。
