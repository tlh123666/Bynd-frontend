import '../../../vitality/presentation/widgets/vitality_entries.dart';
import '../home_signal_destination.dart';
import 'dart:async';
import 'dart:ui' show ImageFilter;
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../design_system/design_system.dart';
import '../../../../l10n/app_localizations_context.dart';
import '../../../../shared/widgets/day_strip.dart';
import '../../application/home_controller.dart';
import '../../home_sky_background.dart';
import '../pages/home_signals_page.dart';
import '../pages/home_diary_page.dart';
import 'home_direction_hero.dart';
import 'home_direction_sheet.dart';
import 'home_signals_section.dart';
import 'home_customize_sheet.dart';
import 'home_explore_section.dart';
import 'home_account_guard.dart';

class HomeContent extends StatelessWidget {
  HomeContent({
    required this.controller,
    required this.onMenu,
    required this.onProfile,
    required this.onDevice,
    required this.onMapa,
    this.onDestinationSelected,
    super.key,
  });
  final HomeController controller;
  final ValueChanged<int>? onDestinationSelected;
  final VoidCallback onMenu, onProfile, onDevice, onMapa;
  // .sn-cab：吸顶头部（首页的 logo 头部滚出视口后，玻璃吸顶条浮现，
  // 内容从下面滚过被模糊化）。阈值 110 ≈ 状态栏 + 头部高度。
  final ValueNotifier<bool> _scrolled = ValueNotifier(false);
  Future<void> _photo(BuildContext context) async {
    try {
      await controller.nextPhoto();
    } catch (_) {
      if (context.mounted) {
        AppNotice.show(
          context,
          kind: AppNoticeKind.error,
          message: context.l10n.homePreferenceFailed,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: controller,
    builder: (context, _) {
      final s = context.l10n;
      final snapshot = controller.snapshot;
      final viewport = MediaQuery.sizeOf(context);
      // Browser metrics can briefly be 1×1 while the engine initializes.
      if (viewport.width < 120 || viewport.height < 120) {
        return const ColoredBox(color: AppColors.homeCanvas);
      }
      final safeTop = math.max(20.0, MediaQuery.paddingOf(context).top);
      return Stack(children: [
        ColoredBox(
        color: AppColors.homeCanvas,
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification.metrics.axis == Axis.vertical) {
              _scrolled.value = notification.metrics.pixels > 110;
            }
            return false;
          },
          child: RefreshIndicator(
          onRefresh: controller.reload,
          color: AppColors.sky,
          backgroundColor: AppColors.surface,
          child: SingleChildScrollView(
            key: const PageStorageKey('home-scroll'),
            physics: const AlwaysScrollableScrollPhysics(),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: viewport.height,
                  child: HomeSkyBackground(
                    photo: controller.photo,
                    now: controller.now,
                  ),
                ),
                Column(
                  children: [
                    SizedBox(height: safeTop + 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: AppPageHeader(
                        height: 40,
                        padding: EdgeInsets.zero,
                        leading: SizedBox.square(
                          dimension: 40,
                          child: IconButton(
                            onPressed: onMenu,
                            tooltip: s.menu,
                            padding: EdgeInsets.zero,
                            alignment: Alignment.centerLeft,
                            icon: const AppSvgIcon(AppSvgAssets.menu, size: 22),
                          ),
                        ),
                        title: const AppSvgIcon(
                          AppSvgAssets.logo,
                          label: 'BYND',
                          width: 72.5,
                          height: 15,
                        ),
                        trailing: Semantics(
                          button: true,
                          label: s.profile,
                          child: InkWell(
                            onTap: onProfile,
                            customBorder: const CircleBorder(),
                            child: Container(
                              width: 37,
                              height: 37,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.homePhotoBorder,
                                ),
                              ),
                              child: ClipOval(
                                child:
                                    snapshot?.avatarUrl?.startsWith(
                                          'https://',
                                        ) ==
                                        true
                                    ? Image.network(
                                        snapshot!.avatarUrl!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, _, _) => const Icon(
                                          Icons.person_outline,
                                          size: 22,
                                        ),
                                      )
                                    : snapshot?.userId == 'demo'
                                    ? Image.asset(
                                        'assets/images/avatar.webp',
                                        fit: BoxFit.cover,
                                      )
                                    : const Icon(
                                        Icons.person_outline,
                                        size: 22,
                                        color: AppColors.textSecondary,
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    DayStrip(
                      day: controller.day,
                      onDayChanged: controller.setDay,
                    ),
                    if (controller.loading && snapshot == null)
                      SizedBox(
                        height: math.max(180, viewport.height - 116),
                        child: const Center(child: AppLoadingIndicator()),
                      )
                    else if (snapshot == null)
                      SizedBox(
                        height: math.max(280, viewport.height - 116),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  controller.error?.code ==
                                          'authentication_required'
                                      ? s.homeSignIn
                                      : s.homeUnavailable,
                                  textAlign: TextAlign.center,
                                  style: AppTypography.section,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  s.homeSync,
                                  textAlign: TextAlign.center,
                                  style: AppTypography.body.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                AppButton(
                                  label: s.homeRetry,
                                  onPressed: controller.reload,
                                ),
                                const SizedBox(height: 10),
                                TextButton(
                                  onPressed: onDevice,
                                  child: Text(s.homeOpenDevice),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    else ...[
                      if (snapshot.partial)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(22, 22, 22, 0),
                          child: Text(
                            s.homePartial,
                            style: AppTypography.caption.copyWith(
                              color: AppColors.signalAttention,
                            ),
                          ),
                        ),
                      TweenAnimationBuilder<double>(
                        key: ValueKey(
                          'direction-${controller.day}-${controller.locale}',
                        ),
                        tween: Tween(begin: 0, end: 1),
                        duration: AppMotion.enabled(context)
                            ? AppMotion.homeEnter
                            : Duration.zero,
                        curve: AppMotion.pageCurve,
                        builder: (context, value, child) => Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 12 * (1 - value)),
                            child: child,
                          ),
                        ),
                        child: HomeDirectionHero(
                          snapshot: snapshot,
                          now: controller.now,
                          viewportHeight: viewport.height,
                          onDirection: () => showAppContentSheet<void>(
                            context,
                            (_) => HomeAccountGuard(
                              controller: controller,
                              child: HomeDirectionSheet(snapshot: snapshot),
                            ),
                          ),
                        ),
                      ),
                      VitalityEntries(
                        date: controller.date,
                        demo: controller.demoData,
                        onDestinationSelected: onDestinationSelected,
                      ),
                      HomeSignalsSection(
                        snapshot: snapshot,
                        signals: controller.signals,
                        onSignal: (signal) => Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (_) => HomeAccountGuard(
                              controller: controller,
                              child: homeSignalDestination(
                                controller,
                                signal,
                                onDestinationSelected: onDestinationSelected,
                              ),
                            ),
                          ),
                        ),
                        onCustomize: () => showAppContentSheet<void>(
                          context,
                          (_) => HomeAccountGuard(
                            controller: controller,
                            child: HomeCustomizeSheet(controller: controller),
                          ),
                        ),
                        onAll: () => Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (_) => HomeAccountGuard(
                              controller: controller,
                              child: HomeSignalsPage(
                                controller: controller,
                                onDestinationSelected: onDestinationSelected,
                              ),
                            ),
                          ),
                        ),
                      ),
                      HomeExploreSection(
                        patterns: snapshot.patterns,
                        onMapa: onMapa,
                        onDiary: () => Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (_) => HomeAccountGuard(
                              controller: controller,
                              child: HomeDiaryPage(
                                controller: controller,
                                openRecord: true,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 120),
                    ],
                  ],
                ),
                Positioned(
                  top: safeTop + 104,
                  right: 14,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => unawaited(_photo(context)),
                      borderRadius: BorderRadius.circular(999),
                      child: Semantics(
                        button: true,
                        label: s.homePhoto,
                        child: Container(
                          height: 30,
                          padding: const EdgeInsets.only(left: 9, right: 11),
                          decoration: BoxDecoration(
                            color: AppColors.homePhotoChip,
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: AppColors.homePhotoBorder,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const AppSvgIcon(
                                AppSvgAssets.photoCounter,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${controller.photo}/25',
                                style: AppTypography.caption.copyWith(
                                  height: 1,
                                ),
                              ),
                            ],
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
      ),
        ),
        ValueListenableBuilder<bool>(
          valueListenable: _scrolled,
          builder: (context, scrolled, _) => scrolled
              ? _glassHeader(context)
              : const SizedBox.shrink(),
        ),
      ]);
    },
  );
}

/// .sn-cab.rolou：玻璃吸顶条（blur 16px + 渐变纱 rgba(34,44,56,.96) 70%→0）。
Widget _glassHeader(BuildContext context) {
  return SafeArea(
    bottom: false,
    child: ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          height: 40,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0, 0.70, 1],
              colors: [
                Color(0xF5222C38),
                Color(0xF5222C38),
                Color(0x00222C38),
              ],
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Row(
            children: [
              const AppSvgIcon(AppSvgAssets.menu, size: 22),
              const Spacer(),
              const AppSvgIcon(
                AppSvgAssets.logo,
                label: 'BYND',
                width: 72.5,
                height: 15,
              ),
              const Spacer(),
              Container(
                width: 37,
                height: 37,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.homePhotoBorder),
                ),
                child: const ClipOval(
                  child: Icon(Icons.person_outline, size: 22),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
