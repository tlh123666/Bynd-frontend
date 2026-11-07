# BYND 原站字体对照

来源：[原站 CSS](https://bynd-app.vercel.app/assets/main-BSoQRcP6.css) 及页面计算样式（2026-11-07）。全局字体在 `lib/design_system/tokens/app_typography.dart` 定义，页面局部的字号和字重按对应 CSS 选择器覆盖。

| 位置 | 字体 | 大小 | 字重 | 其他 |
| --- | --- | --- | --- | --- |
| 正文默认 | Geist | 16px | 400 | 原站 `--font` |
| 首页“Ontem / Hoje” | Geist | 15px | 400 | 未选中透明度 45% |
| 菜单设备名称 | Geist | 15px | 500 | `.ml-pul2-t b` |
| 菜单设备状态 | Geist | 12px | 400 | `.ml-pul2-t small` |
| 菜单分组 | Geist | 11px | 500 | 字距 1.76px |
| 菜单条目 / “Sair” | Geist | 15.5px | 400 | `.ml-it` / `.ml-sair2` |
| 资料页标题 | Geist | 17px | 500 | `.pf-cab h1` 最终覆盖值 |
| 资料页姓名 | Geist | 24px | 400 | 字距 −0.48px |
| 资料页简介 | Geist | 13.5px | 400 | `.pf-id p` |
| 资料页统计标签 | Geist | 11.5px | 400 | `.pf-nums span` |
| 资料页统计值 | Urbanist | 24px | 300 | `.pf-nums b` |
| 资料页分组 | Geist | 11px | 500 | 字距 1.76px |
| 资料页信息行 | Geist | 15.5px | 400 | `.pf-lin` |
| 资料页信息值 | Geist | 14px | 400 | `.pf-lin em` |
| 资料页补充说明 | Geist | 12.5px | 400 | 行高 1.4 |
| 快捷层标题 | Geist | 11px | 500 | 字距 1.76px |
| 快捷层说明 | Geist | 15px | 400 | 行高 1.4 |
| 快捷操作名称 | Geist | 12.5px | 500 | 行高 1.25 |

原站还在标题和长文中使用 Urbanist、Newsreader。项目内的 `assets/fonts/` 已放入三款可变 TTF，并在 `pubspec.yaml` 中注册；同目录的 `OFL-*.txt` 是各字体的许可文件。字体来源为 [Google Fonts 的 Geist](https://github.com/google/fonts/tree/main/ofl/geist)、[Urbanist](https://github.com/google/fonts/tree/main/ofl/urbanist)、[Newsreader](https://github.com/google/fonts/tree/main/ofl/newsreader)。
