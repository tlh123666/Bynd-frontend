import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../design_system/tokens/app_colors.dart';
import '../../domain/models/activity_type.dart';

/// 使用 BYND 原型的线性图形绘制活动图标；未迁移的图标暂用 Material 图标兜底。
class ActivityTypeIcon extends StatelessWidget {
  const ActivityTypeIcon({
    required this.type,
    required this.fallback,
    this.size = 20,
    super.key,
  });

  final ActivityType type;
  final IconData fallback;
  final double size;

  @override
  Widget build(BuildContext context) {
    final svg = _svgFor(type);
    if (svg == null) {
      return Icon(fallback, size: size, color: AppColors.textSecondary);
    }

    return SvgPicture.string(
      svg,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(AppColors.textSecondary, BlendMode.srcIn),
      excludeFromSemantics: true,
    );
  }

  String? _svgFor(ActivityType activity) {
    // 这些是目录首屏和最近项目中实际出现的原型图标；路径与 BYND SVG 组件一致。
    return switch (activity.id) {
      'corrida' || 'esteira' || 'carrinho-corrida' => _runner,
      'caminhada' ||
      'passear-cao' ||
      'carrinho-bebe' ||
      'carregar-bebe' ||
      'trajeto' => _walk,
      'ciclismo' || 'mountain-bike' || 'spinning' || 'assault-bike' => _bike,
      'musculacao' || 'powerlifting' || 'strongman' => _dumbbell,
      'natacao' || 'natacao-aberta' || 'hidroginastica' => _swim,
      'sauna' => _flame,
      _ => null,
    };
  }
}

const _runner =
    '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="#f4f5f7" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><circle cx="14.5" cy="4.6" r="1.6"/><path d="M7.5 9.2 11 7.6l3 1.6 1.6 2.8 2.6.6M11 7.6l-1.6 5.2 3.2 2.6-1 4.6M9.4 12.8 7.6 16l-3.1.6"/></svg>''';

const _walk =
    '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="#f4f5f7" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><circle cx="12.5" cy="4.6" r="1.6"/><path d="m10 21 1.5-5.5-2-2.5.8-4.5 2.7.4 2 3M10.3 8.5 8 10.5l-.5 3M13.5 15.5l1 5.5"/></svg>''';

const _bike =
    '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="#f4f5f7" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><circle cx="6" cy="16" r="3.5"/><circle cx="18" cy="16" r="3.5"/><path d="m6 16 4-7h5l3 7M10 9l2.5 7H6M14 6.5h2.5"/></svg>''';

const _dumbbell =
    '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="#f4f5f7" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M3.5 12h17M6.5 8.5v7M9 7v10M15 7v10M17.5 8.5v7"/></svg>''';

const _swim =
    '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="#f4f5f7" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><circle cx="16.5" cy="7" r="1.6"/><path d="m6 12 4.5-3 3 2.6 2.5-1.6M3.5 16.5c2.8-1.8 5.7 1.8 8.5 0s5.7-1.8 8.5 0"/></svg>''';

const _flame =
    '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="#f4f5f7" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M12 21a6 6 0 0 0 6-6c0-3.5-2.5-5.5-3.5-8.5-1 2-2 2.8-3.2 3.4C11 7.5 10 5 10 3c-3 2.5-4 6.5-4 9.5A6 6 0 0 0 12 21z"/><path d="M12 21a2.5 2.5 0 0 1-2.5-2.5c0-1.5 1.2-2.4 2.5-4 1.3 1.6 2.5 2.5 2.5 4A2.5 2.5 0 0 1 12 21z"/></svg>''';
