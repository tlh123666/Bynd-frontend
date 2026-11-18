import 'package:flutter/material.dart';

import '../../../design_system/design_system.dart';
import 'community_style.dart';

/// 社区成员头像：缺少可访问地址或图片加载失败时显示姓名首字母。
class CommunityAvatar extends StatelessWidget {
  const CommunityAvatar({
    required this.name,
    this.avatarUrl,
    this.size = 30,
    super.key,
  });

  final String name;
  final String? avatarUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    final initial = name.isNotEmpty ? name.characters.first.toUpperCase() : '?';
    final fallback = Text(
      initial,
      style: AppTypography.caption.copyWith(
        color: const Color(0xFF1C2026),
        fontSize: size * .37,
        fontWeight: FontWeight.w600,
      ),
    );
    final rawUrl = avatarUrl?.trim();
    final uri = rawUrl == null ? null : Uri.tryParse(rawUrl);
    // 对象存储的 key 不是图片地址，需由服务端转换为可访问的签名 URL。
    final isNetworkUrl =
        uri != null &&
        (uri.scheme == 'https' || uri.scheme == 'http') &&
        uri.host.isNotEmpty;
    final content = isNetworkUrl
        ? Image.network(
            rawUrl!,
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => fallback,
            loadingBuilder: (_, child, progress) =>
                progress == null ? child : fallback,
          )
        : fallback;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: CommunityStyle.avatarColor(name),
      ),
      child: content,
    );
  }
}
