import 'package:flutter/material.dart';
import '../tokens/app_dimensions.dart';
import '../tokens/app_typography.dart';
import 'app_icon.dart';

class AppDetailHeader extends StatelessWidget {
  const AppDetailHeader({
    required this.title,
    required this.onClose,
    this.onInfo,
    this.closeLabel = 'Fechar',
    super.key,
  });
  final String title;
  final VoidCallback? onClose;
  final VoidCallback? onInfo;
  final String closeLabel;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: AppSizes.detailHeaderHeight,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          SizedBox(
            width: AppSizes.detailTouchTarget,
            height: AppSizes.detailTouchTarget,
            child: IconButton(
              tooltip: closeLabel,
              onPressed: onClose,
              icon: const AppSvgIcon(AppSvgAssets.close, size: 22),
            ),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: AppFontFamilies.geist,
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(
            width: AppSizes.detailTouchTarget,
            height: AppSizes.detailTouchTarget,
            child: onInfo == null
                ? null
                : IconButton(
                    tooltip: 'Sobre',
                    onPressed: onInfo,
                    icon: const AppSvgIcon(AppSvgAssets.deviceInfo, size: 22),
                  ),
          ),
        ],
      ),
    ),
  );
}
