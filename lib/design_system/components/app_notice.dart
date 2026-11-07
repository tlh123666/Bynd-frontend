import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_dimensions.dart';
import '../tokens/app_typography.dart';
import 'app_icon.dart';

enum AppNoticeKind { success, error, warning, info }

/// 可直接放进页面，也可以通过 [AppNotice.show] 显示为浮动提醒。
class AppNotice extends StatelessWidget {
  const AppNotice({
    required this.kind,
    required this.message,
    this.title,
    super.key,
  });

  final AppNoticeKind kind;
  final String message;
  final String? title;

  static void show(
    BuildContext context, {
    required AppNoticeKind kind,
    required String message,
    String? title,
  }) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        padding: EdgeInsets.zero,
        content: AppNotice(kind: kind, message: message, title: title),
      ),
    );
  }

  static void success(BuildContext context, String message, {String? title}) =>
      show(
        context,
        kind: AppNoticeKind.success,
        message: message,
        title: title,
      );

  static void error(BuildContext context, String message, {String? title}) =>
      show(context, kind: AppNoticeKind.error, message: message, title: title);

  @override
  Widget build(BuildContext context) {
    final (accent, background, icon) = switch (kind) {
      AppNoticeKind.success => (
        AppColors.success,
        AppColors.successSurface,
        AppIcons.check,
      ),
      AppNoticeKind.error => (
        AppColors.error,
        AppColors.errorSurface,
        AppIcons.error,
      ),
      AppNoticeKind.warning => (
        AppColors.warning,
        AppColors.warningSurface,
        AppIcons.warning,
      ),
      AppNoticeKind.info => (
        AppColors.info,
        AppColors.infoSurface,
        AppIcons.info,
      ),
    };
    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadii.controlBorder,
          border: Border.all(color: accent, width: AppBorders.hairline),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.xs),
              decoration: BoxDecoration(
                color: background,
                shape: BoxShape.circle,
              ),
              child: AppIcon(icon, size: AppSizes.iconSmall, color: accent),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title != null) ...[
                    Text(
                      title!,
                      style: AppTypography.label.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                  ],
                  Text(
                    message,
                    style: AppTypography.body.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
