import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../design_system/design_system.dart';
import '../../../../l10n/app_localizations_context.dart';
import '../../domain/home_models.dart';

class HomeDirectionHero extends StatefulWidget {
  const HomeDirectionHero({
    required this.snapshot,
    required this.now,
    required this.viewportHeight,
    required this.onDirection,
    super.key,
  });
  final HomeSnapshot snapshot;
  final DateTime now;
  final double viewportHeight;
  final VoidCallback onDirection;
  @override
  State<HomeDirectionHero> createState() => _HomeDirectionHeroState();
}

class _HomeDirectionHeroState extends State<HomeDirectionHero> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    final past = homeDay(widget.snapshot.date).isBefore(homeDay(widget.now));
    final greet = past
        ? strings.homePastGreeting
        : widget.now.hour < 12
        ? strings.homeMorning
        : widget.now.hour < 18
        ? strings.homeAfternoon
        : strings.homeEvening;
    final greeting = past || widget.snapshot.firstName.isEmpty
        ? greet
        : '$greet, ${widget.snapshot.firstName}';
    final english = strings.localeName.startsWith('en');
    final date = widget.snapshot.date;
    final weekdays = english
        ? const [
            'Monday',
            'Tuesday',
            'Wednesday',
            'Thursday',
            'Friday',
            'Saturday',
            'Sunday',
          ]
        : const [
            'Segunda-feira',
            'Terça-feira',
            'Quarta-feira',
            'Quinta-feira',
            'Sexta-feira',
            'Sábado',
            'Domingo',
          ];
    final months = english
        ? const [
            'Jan',
            'Feb',
            'Mar',
            'Apr',
            'May',
            'Jun',
            'Jul',
            'Aug',
            'Sep',
            'Oct',
            'Nov',
            'Dec',
          ]
        : const [
            'jan',
            'fev',
            'mar',
            'abr',
            'mai',
            'jun',
            'jul',
            'ago',
            'set',
            'out',
            'nov',
            'dez',
          ];
    final compact = widget.viewportHeight <= 760;
    final titleStyle = AppTypography.homeTitle.copyWith(
      fontSize: compact ? 32 : 36,
    );
    const greetStyle = TextStyle(
      fontFamily: AppFontFamilies.geist,
      fontSize: 17,
      fontWeight: FontWeight.w400,
      height: 1.3,
      letterSpacing: 0,
      color: AppColors.homeGreeting,
    );
    const dateStyle = TextStyle(
      fontFamily: AppFontFamilies.geist,
      fontSize: 11,
      fontWeight: FontWeight.w600,
      height: 1.27,
      letterSpacing: 1.98,
      color: AppColors.homeDate,
    );
    final title = widget.snapshot.title.isEmpty
        ? strings.homeUnknownDirection
        : widget.snapshot.title;
    final body = widget.snapshot.paragraphs.isEmpty
        ? strings.homeNoDirection
        : widget.snapshot.paragraphs.join('\n\n');
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth - 2 * AppSizes.homeGutter;
        double measure(String text, TextStyle style, {int? lines}) {
          final painter = TextPainter(
            text: TextSpan(text: text, style: style),
            textDirection: Directionality.of(context),
            textScaler: MediaQuery.textScalerOf(context),
            maxLines: lines,
          )..layout(maxWidth: width);
          return painter.height;
        }

        final short = widget.viewportHeight <= 700;
        final titleHeight = measure(title, titleStyle);
        final bodyHeight = measure(body, AppTypography.homeBody);
        final collapsedHeight = short && !_expanded
            ? math.min(bodyHeight, 105.4)
            : bodyHeight;
        final canExpand = short && bodyHeight > 105.4;
        final textHeight =
            measure(
              '${weekdays[date.weekday - 1]} · ${date.day} ${months[date.month - 1]}'
                  .toUpperCase(),
              dateStyle,
            ) +
            8 +
            measure(greeting, greetStyle) +
            14 +
            titleHeight +
            10 +
            collapsedHeight +
            (canExpand ? 40 : 0);
        final height = math.max(
          widget.viewportHeight - 210,
          textHeight + 90 + (short ? 36 : 72),
        );
        return AnimatedSize(
          duration: AppMotion.enabled(context)
              ? AppMotion.homeExpand
              : Duration.zero,
          curve: AppMotion.drawerCurve,
          alignment: Alignment.topCenter,
          child: SizedBox(
            height: height,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.homeGutter,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  Text(
                    '${weekdays[date.weekday - 1]} · ${date.day} ${months[date.month - 1]}'
                        .toUpperCase(),
                    style: dateStyle,
                  ),
                  const SizedBox(height: 8),
                  Text(greeting, style: greetStyle),
                  const SizedBox(height: 14),
                  Text(title, style: titleStyle),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: collapsedHeight,
                    child: ClipRect(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          body,
                          style: AppTypography.homeBody,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ),
                  ),
                  if (canExpand)
                    SizedBox(
                      height: 40,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          alignment: Alignment.centerLeft,
                          foregroundColor: AppColors.textPrimary,
                        ),
                        onPressed: () => setState(() => _expanded = !_expanded),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _expanded
                                  ? strings.homeShowLess
                                  : strings.homeShowMore,
                            ),
                            Icon(
                              _expanded
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(top: 24, bottom: 18),
                    child: Center(
                      child: AppGlassPill(
                        label: strings.homeDirection,
                        onPressed: widget.onDirection,
                        leading: AppSvgAssets.homeDirection,
                        trailing: const Icon(
                          Icons.chevron_right,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
