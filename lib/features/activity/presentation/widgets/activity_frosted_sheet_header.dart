import 'package:flutter/material.dart';

import '../../../../design_system/design_system.dart';
import '../../../../l10n/app_localizations_context.dart';

/// 活动相关磨砂叶片共用的标题栏，保留固定把手、关闭按钮和居中标题。
class ActivityFrostedSheetHeader extends StatelessWidget {
  const ActivityFrostedSheetHeader({
    required this.title,
    this.height = 62,
    super.key,
  });
  final String title;
  final double height;

  @override
  Widget build(BuildContext context) =>
      height < 62 || MediaQuery.sizeOf(context).width < 120
      ? SizedBox(height: height)
      : SizedBox(
          height: height,
          child: Stack(
            children: [
              Positioned(
                top: 8,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 38,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0x47ffffff),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                top: 12,
                child: Row(
                  children: [
                    SizedBox(
                      width: 56,
                      child: Semantics(
                        label: context.l10n.close,
                        button: true,
                        child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.close,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: AppTypography.title.copyWith(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 56),
                  ],
                ),
              ),
            ],
          ),
        );
}
