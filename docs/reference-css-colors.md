# BYND 原站 CSS 配色对照

来源：[原站 CSS](https://bynd-app.vercel.app/assets/main-BSoQRcP6.css)（2026-11-07 核对）。Flutter 的全局色值集中在 `lib/design_system/tokens/app_colors.dart`；页面只组合这些色值。

| 原站规则 | CSS 原值 | Flutter 变量或使用位置 |
| --- | --- | --- |
| `:root --bg` | `#14181d` | `AppColors.background` |
| `:root --surface` | `#1b1f25` | `AppColors.surface` |
| `:root --surface-dock` | `#1d2127` | `AppColors.surfaceDock` |
| `:root --text` | `#f4f5f7` | `AppColors.textPrimary` |
| `:root --text-2` | `rgba(244,245,247,.72)` | `AppColors.textSecondary` |
| `:root --text-3` | `rgba(244,245,247,.54)` | `AppColors.textMuted` |
| `:root --stroke` | `rgba(255,255,255,.08)` | `AppColors.glassBorder` |
| `:root --stroke-strong` | `rgba(255,255,255,.14)` | `AppColors.glassBorderStrong` |
| `.device` | `#0f141b` | `AppColors.canvas` |
| `.ml-painel` | `#161a20e6` | `AppColors.menuPanel` |
| `.ml-veu` | `#0006` | `AppColors.menuVeil` |
| `.ml-gr`, `.ml-pul2` | `linear-gradient(180deg,#ffffff0d,#ffffff05)` | 菜单卡片渐变 |
| `.ml-it svg` | `#f4f5f799` | `AppColors.menuIcon` |
| `.ml-it em` | `#f4f5f74d` | `AppColors.menuChevron` |
| `.ml-sair2` | `#ff7a6e` | `AppColors.menuExit` |
| `.ml-pul2-t small i` | `#86d4a3` | `AppColors.success` |
| `.dock3-pill`, `.dock3-mais` | `#282c348c` | `AppColors.navGlass` |
| `.dock3-ativo` | `#ffffff1f` | `AppColors.navSelected` |
| `.dock3-pill` 边框 | `rgba(255,255,255,.12)` | `AppColors.navBorder` |
| `.hd-per` | `#14181e59` | `AppColors.homeCounter` |
| `.ar-fundo` | `#0c0f14b8` | `AppColors.quickActionsVeil` |
| `.pf` | `linear-gradient(180deg,#2b3644,#1a2029 260px,#121418 560px)` | 资料页背景 |

首页当前对应参考图的夜间样式：`.hn-noite .hn-ceu` 从上到下依次为 `#2c3a4e`、`#2e3d52 25%`、`#2a384c 48%`、`#212c3b 68%`、`#171d27 86%`、`#14181d`；云层是 `#aabed714`。这些值用于 `HomeSkyBackground`，底部遮罩也按 `.hn-fundo` 的 `62%` 到 `100%` 渐隐。

原站还会按时段切换 `.hn-manha`、`.hn-tarde`、`.hn-noite`，并在 `.app-ceu.is-live` 时通过画布绘制天空。当前 Flutter 首页固定使用参考截图里的夜间 CSS 样式，因此实时画布和时段切换尚未复刻。
