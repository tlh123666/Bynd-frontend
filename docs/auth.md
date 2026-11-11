# 登录与会话

2026-11-10 对照原站 HTML、`main-DN5h_XhA.js`、`main-CRUZ18wL.css`，并在浏览器实际点击菜单的 `Sair`：原站没有登录页面，退出回调只关闭菜单。因此本次登录页沿用原站照片、BYND 标志、Urbanist/Geist 字体、深色背景、磨砂弹层和灰白按钮，登录逻辑沿用 JCVital 与现有后端。

## 已实现

- 未登录先显示欢迎页；邮箱验证码登录；首次登录自动建号，不增加后端不支持的密码注册、密码找回入口。
- 邮箱格式检查、6 位数字验证码、验证码有效期、60 秒重新发送倒计时、网络/服务/验证码错误和加载状态。
- 新用户必须主动勾选健康数据处理同意；Google 登录先展示同意面板，取消不会启动 Google SDK 或请求后端。勾选默认关闭。
- 葡语、英语切换，跟随现有全局语言与接口语言设置；小屏幕、大字体和键盘避让。
- 启动恢复、旧版有效 JWT 迁移、会话过期、受保护请求 401 后回登录、退出确认与本地退出。
- 账号变化替换整个内部导航栈，销毁页面、表单和应用持有的设备/Atlas 服务，避免退出后返回旧账号页面；系统返回键仍交给当前内部页面处理。

登录的“Privacidade”是本地数据用途与选择说明，未伪造官网政策链接或额外的后端功能。

## 目录

```text
lib/core/auth/
  auth_api.dart                  # 已有认证接口
  auth_controller.dart           # 会话发布、恢复、过期与退出
  auth_tokens.dart                # 返回值和旧 JWT 元数据
  token_store.dart                # 完整会话安全存储、旧版迁移
  google_identity.dart            # 原生 Google SDK 适配
lib/features/auth/
  application/login_controller.dart
  presentation/
    auth_gate.dart                # 登录守卫、独立导航栈、账号服务生命周期
    login_page.dart               # 欢迎页、照片、语言与登录方式
    email_login_sheet.dart        # 邮箱、验证码、倒计时
    health_consent_sheet.dart     # 复用同意内容和面板
    auth_privacy_page.dart
    auth_error_message.dart
lib/design_system/
  components/app_input_field.dart # 公共输入框
  tokens/app_auth_style.dart      # 登录布局、字重与背景渐变
assets/images/auth-assets.json   # 来源和 SHA-256
test/core/auth/auth_controller_test.dart
test/features/auth/
```

继续复用 `AppButton`、`AppNotice`、`AppConfirmationSheet`、`AppGradientCard`、`showAppContentSheet`、公共语言弹层、`AppColors`、`AppTypography` 和 `AppMotion`。没有橙色按钮背景。Google 官方彩色标志来自旧 JCVital。

## 后端合同

基础地址和应用身份不变：`https://api.byndhealth.com.br`、`com.byndhealth.app`。不需要新增数据库迁移或修改后端。

| 接口 | 请求 | 用途 |
| --- | --- | --- |
| `POST /api/v1/auth/email/code` | `{email}` | 返回 `expiresIn`、`newUser` |
| `POST /api/v1/auth/email/login` | `{email, code, consent}` | 登录或首次建号，返回令牌及秒级有效期 |
| `POST /api/v1/auth/google` | `{idToken, consent}` | 后端校验 Google ID token 后登录 |

重发倒计时采用实际截止时间；编辑邮箱不会重置同一邮箱的截止时间。HTTP 429 的数字 `Retry-After` 会覆盖默认冷却时间。验证码不持久化、不写日志。

后端当前没有注册 `/auth/refresh`、`/auth/logout`。客户端保存服务端返回的 refresh token，但不会调用不存在的刷新接口。访问令牌过期前 60 秒回到登录页；退出是本地会话清除，并退出已使用的 Google SDK 会话，不承诺撤销服务端已签发令牌。

## 会话与迁移

完整元数据保存于 `flutter_secure_storage` 的 `br.com.byndhealth.auth.tokens`；访问令牌继续使用旧键 `auth.access_token`，供现有 API/BLE 账户链路使用。

旧版仅有 access token 时读取 JWT 的 `uid`、`sub`、`typ` 和 `exp`，并读取旧 `auth.user_email`。这只是恢复路由所需的元数据解析，不是客户端验签；后端仍负责验证每个受保护请求。不完整、过期或 refresh 类型 JWT 不用于登录恢复。退出同时清理旧缓存身份键。

会话持久化与发布串行化；慢恢复不会覆盖新登录，退出后迟到的登录响应不会复活会话。公开登录接口返回 401 作为登录错误；受保护接口返回 401 才清理当前会话。

`config/demo.json` 仍可直接预览已有首页。它不会生成假登录凭据；明确退出后会进入登录页。其余环境未登录时进入登录页。

## Google 与平台配置

- Android 使用与 JCVital 一致的 `google_sign_in` 6.x、包名和 Google Web/server client ID。Google Console 中的 Android OAuth 客户端需要对应实际安装包的包名与签名 SHA；换签名时仍需配置对应指纹。
- `GOOGLE_WEB_CLIENT_ID` 保持原值，作为后端 ID token 的 audience，不要替换成 Android/iOS 客户端 ID。
- 邮箱登录支持 Android、iOS、Web；Google 登录提供 Android 原生入口。Web 当前采用邮箱登录，未增加 Google Identity Services 网页集成。
- 旧 JCVital 和本项目都没有可复用的 iOS OAuth 客户端或 URL scheme。iOS 默认隐藏 Google 按钮。要启用，先取得真实 iOS OAuth 客户端，通过 `--dart-define=GOOGLE_IOS_CLIENT_ID=...` 或本地 `.env` 配置，再把该客户端的 **reversed client ID** URL scheme 加入 `ios/Runner/Info.plist` 的 `CFBundleURLTypes`。不要把 Web client ID 填成 iOS client ID。没有实际凭据时不添加虚假的 scheme。

新增了原生插件，首次运行需完整停止后重新 `flutter run`，热重载无法注册原生插件。

```sh
flutter pub get
flutter run --dart-define-from-file=config/dev.json
flutter analyze --no-pub
flutter test --no-pub
```

## 验证

151 项 Flutter 测试通过，覆盖 API 合同、明确同意、冷却与过期、旧版迁移、写入失败、迟到请求、受保护/公开 401、导航栈和原有功能。Android debug APK 构建通过。

浏览器使用隔离的本地测试 API 验证登录、刷新恢复、退出与会话失效，不发送真实邮件或操作真实 Google 账户。真实邮件投递、Google 账号授权和 iOS 真机授权仍需对应运行环境联调。

页面截图见 `screenshots/auth-landing.png`、`auth-email.png`、`auth-consent.png`。
