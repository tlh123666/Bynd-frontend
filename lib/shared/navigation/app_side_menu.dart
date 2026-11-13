import 'dart:ui';

import 'package:flutter/material.dart';

import '../../design_system/design_system.dart';
import '../../features/device/application/device_scope.dart';
import '../../features/device/presentation/widgets/device_menu_tile.dart';
import '../../l10n/app_localizations_context.dart';

/// Reusable app navigation drawer. Its contents belong to the app shell,
/// while timing and easing come from the global motion tokens.
class AppSideMenu extends StatelessWidget {
  const AppSideMenu({
    required this.visible,
    required this.onClose,
    required this.onSettings,
    required this.onLanguage,
    required this.onOtherSelected,
    this.onDevice,
    super.key,
  });

  final bool visible;
  final VoidCallback onClose;
  final VoidCallback onSettings;
  final VoidCallback onLanguage;
  final ValueChanged<String> onOtherSelected;
  final VoidCallback? onDevice;

  @override
  Widget build(BuildContext context) {
    final animate = AppMotion.enabled(context);
    final strings = context.l10n;
    return Positioned.fill(
      child: IgnorePointer(
        ignoring: !visible,
        child: ExcludeSemantics(
          excluding: !visible,
          child: Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  key: const Key('menu-backdrop'),
                  onTap: onClose,
                  child: AnimatedOpacity(
                    duration: animate ? AppMotion.veil : Duration.zero,
                    opacity: visible ? 1 : 0,
                    child: const ColoredBox(color: AppColors.menuVeil),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: 0.7,
                  heightFactor: 1,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 300),
                    child: AnimatedSlide(
                      duration: animate ? AppMotion.drawer : Duration.zero,
                      curve: AppMotion.drawerCurve,
                      offset: visible ? Offset.zero : const Offset(-1.05, 0),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(28),
                          bottomRight: Radius.circular(28),
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                          child: DecoratedBox(
                            decoration: const BoxDecoration(
                              color: AppColors.menuPanel,
                              border: Border(right: AppBorders.glass),
                            ),
                            child: SafeArea(
                              bottom: false,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  30,
                                  16,
                                  28,
                                ),
                                child: CustomScrollView(
                                  slivers: [
                                    SliverToBoxAdapter(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          DeviceMenuTile(
                                            device: DeviceScope.maybeOf(
                                              context,
                                            )?.device,
                                            loading:
                                                DeviceScope.maybeOf(
                                                  context,
                                                )?.loading ??
                                                false,
                                            onTap:
                                                onDevice ??
                                                () =>
                                                    onOtherSelected('BYND ONE'),
                                          ),
                                          const SizedBox(height: 24),
                                          _GroupTitle(strings.youGroup),
                                          const SizedBox(height: 8),
                                          _MenuGroup(
                                            children: [
                                              _MenuItem(
                                                strings.diary,
                                                AppSvgAssets.diary,
                                                onOtherSelected,
                                              ),
                                              _MenuItem(
                                                strings.menuMapa,
                                                AppSvgAssets.atlas,
                                                onOtherSelected,
                                              ),
                                              _MenuItem(
                                                strings.journey,
                                                AppSvgAssets.journey,
                                                onOtherSelected,
                                              ),
                                              _MenuItem(
                                                strings.activities,
                                                AppSvgAssets.activities,
                                                onOtherSelected,
                                              ),
                                              _MenuItem(
                                                strings.community,
                                                AppSvgAssets.menuCommunity,
                                                onOtherSelected,
                                              ),
                                              _MenuItem(
                                                strings.goals,
                                                AppSvgAssets.goals,
                                                onOtherSelected,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 22),
                                          _GroupTitle(strings.appGroup),
                                          const SizedBox(height: 8),
                                          _MenuGroup(
                                            children: [
                                              _MenuItem(
                                                strings.settings,
                                                AppSvgAssets.settings,
                                                (_) => onSettings(),
                                              ),
                                              _MenuItem(
                                                strings.languageMenu,
                                                null,
                                                (_) => onLanguage(),
                                                materialIcon: Icons.language,
                                              ),
                                              _MenuItem(
                                                strings.integrations,
                                                AppSvgAssets.integrations,
                                                onOtherSelected,
                                              ),
                                              _MenuItem(
                                                strings.privacy,
                                                AppSvgAssets.privacy,
                                                onOtherSelected,
                                              ),
                                              _MenuItem(
                                                strings.help,
                                                AppSvgAssets.help,
                                                onOtherSelected,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SliverFillRemaining(
                                      hasScrollBody: false,
                                      child: Align(
                                        alignment: Alignment.bottomLeft,
                                        child: TextButton(
                                          onPressed: () =>
                                              onOtherSelected(strings.signOut),
                                          child: Text(
                                            strings.signOut,
                                            style: AppTypography.listItem
                                                .copyWith(
                                                  color: AppColors.menuExit,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GroupTitle extends StatelessWidget {
  const _GroupTitle(this.title);
  final String title;

  @override
  Widget build(BuildContext context) => Text(
    title,
    style: AppTypography.kicker.copyWith(color: AppColors.textDim),
  );
}

class _MenuGroup extends StatelessWidget {
  const _MenuGroup({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [AppColors.glass, AppColors.glassLow],
      ),
      borderRadius: AppRadii.controlBorder,
    ),
    child: Column(
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 14),
              child: Divider(height: 1),
            ),
          children[i],
        ],
      ],
    ),
  );
}

class _MenuItem extends StatelessWidget {
  const _MenuItem(
    this.label,
    this.iconAsset,
    this.onSelected, {
    this.materialIcon,
  }) : assert(iconAsset != null || materialIcon != null);
  final String label;
  final String? iconAsset;
  final ValueChanged<String> onSelected;
  final IconData? materialIcon;

  @override
  Widget build(BuildContext context) {
    final iconData = materialIcon;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onSelected(label),
        child: SizedBox(
          height: 46,
          child: Row(
            children: [
              const SizedBox(width: 14),
              if (iconData != null)
                Icon(iconData, size: 20, color: AppColors.menuIcon)
              else
                AppSvgIcon(iconAsset!, size: 20, color: AppColors.menuIcon),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: AppTypography.listItem.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right,
                size: 16,
                color: AppColors.menuChevron,
              ),
              const SizedBox(width: 12),
            ],
          ),
        ),
      ),
    );
  }
}
