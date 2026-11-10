import '../domain/diary_media.dart';
import 'package:flutter/material.dart';
import '../../../design_system/design_system.dart';
import '../../../design_system/tokens/app_diary_style.dart';
import '../domain/diary_models.dart';
import '../../../shared/widgets/app_sheet_controls.dart';

String diaryText(BuildContext c, String pt, String en) =>
    Localizations.localeOf(c).languageCode == 'en' ? en : pt;

class DiaryIcon extends StatelessWidget {
  const DiaryIcon(
    this.name, {
    this.size = 20,
    this.color = AppColors.textSecondary,
    super.key,
  });
  final String name;
  final double size;
  final Color color;
  @override
  Widget build(BuildContext context) => AppSvgIcon(
    'assets/icons/site/diary-${DiaryMedia.icons.contains(name) ? name : 'nota'}.svg',
    size: size,
    color: color,
  );
}

class DiarySection extends StatelessWidget {
  const DiarySection(this.title, {this.icon, this.trailing, super.key});
  final String title;
  final String? icon;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 36, bottom: 14),
    child: Row(
      children: [
        if (icon != null) ...[
          DiaryIcon(icon!, size: 18),
          const SizedBox(width: 10),
        ],
        Expanded(child: Text(title, style: AppDiaryStyle.section)),
        ?trailing,
      ],
    ),
  );
}

class DiaryRecordRow extends StatelessWidget {
  const DiaryRecordRow({
    required this.title,
    required this.icon,
    this.subtitle,
    this.value,
    this.selected = false,
    this.onTap,
    this.onToggle,
    this.showIcon = true,
    super.key,
  });
  final String title, icon;
  final String? subtitle, value;
  final bool selected;
  final bool showIcon;
  final VoidCallback? onTap, onToggle;
  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      borderRadius: AppDiaryStyle.radius,
      child: Container(
        constraints: const BoxConstraints(minHeight: 72),
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppDiaryStyle.line)),
        ),
        child: Row(
          children: [
            if (showIcon) ...[DiaryIcon(icon), const SizedBox(width: 14)],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppDiaryStyle.label),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(subtitle!, style: AppDiaryStyle.caption),
                  ],
                ],
              ),
            ),
            if (value != null)
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  value!,
                  style: AppDiaryStyle.section.copyWith(fontSize: 17),
                ),
              ),
            if (onToggle != null)
              IconButton(
                onPressed: onToggle,
                tooltip: diaryText(context, 'Marcar $title', 'Toggle $title'),
                icon: Icon(
                  selected ? Icons.check_circle : Icons.radio_button_unchecked,
                  size: 22,
                  color: selected ? AppColors.textPrimary : AppDiaryStyle.faint,
                ),
              ),
          ],
        ),
      ),
    ),
  );
}

class DiarySurface extends StatelessWidget {
  const DiarySurface({required this.child, super.key});
  final Widget child;
  @override
  Widget build(BuildContext context) => Container(
    clipBehavior: Clip.antiAlias,
    decoration: const BoxDecoration(
      color: AppDiaryStyle.surface,
      borderRadius: AppDiaryStyle.radius,
    ),
    child: child,
  );
}

class DiaryCapturePanel extends StatelessWidget {
  const DiaryCapturePanel({
    required this.onWrite,
    required this.onSpeak,
    super.key,
  });
  final VoidCallback onWrite, onSpeak;
  @override
  Widget build(BuildContext context) => DiarySurface(
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const DiaryIcon('estrela', size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  diaryText(context, 'Registrar com a IA', 'Record with AI'),
                  style: AppDiaryStyle.label,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            diaryText(
              context,
              'Conte como foi. Ela marca tudo aqui para você.',
              'Tell us about your day. Review before saving.',
            ),
            style: AppDiaryStyle.caption,
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: AppSheetActionButton(
                  label: diaryText(context, 'Escrever', 'Write'),
                  iconAsset: 'assets/icons/site/diary-nota.svg',
                  onPressed: onWrite,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppSheetActionButton(
                  label: diaryText(context, 'Falar', 'Speak'),
                  iconAsset: 'assets/icons/site/diary-mic.svg',
                  onPressed: onSpeak,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class DiaryTimelineTile extends StatelessWidget {
  const DiaryTimelineTile({required this.moment, this.onTap, super.key});
  final DiaryMoment moment;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => IntrinsicHeight(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: 18,
          child: Column(
            children: [
              DiaryIcon(moment.icon, size: 18, color: AppColors.textMuted),
              const SizedBox(height: 6),
              Expanded(child: Container(width: 1, color: AppDiaryStyle.line)),
              const SizedBox(height: 6),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    moment.timeLabel,
                    style: AppDiaryStyle.caption.copyWith(
                      fontSize: 12,
                      color: AppDiaryStyle.faint,
                    ),
                  ),
                ),
                const SizedBox(height: 7),
                DiarySurface(
                  child: InkWell(
                    onTap: onTap,
                    borderRadius: AppDiaryStyle.radius,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 13,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              if (moment.automatic) ...[
                                Image.asset(
                                  'assets/images/diary-band.png',
                                  width: 14,
                                  height: 16,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(width: 6),
                              ],
                              Expanded(
                                child: Text(
                                  moment.label,
                                  style: AppDiaryStyle.label,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 12,
                            runSpacing: 5,
                            children: [
                              Text(
                                moment.valueLabel,
                                style: AppDiaryStyle.caption,
                              ),
                              if (moment.kind == 'meal' &&
                                  moment.details['protein'] != null)
                                Text(
                                  'P ${moment.details['protein']} g \u00b7 C ${moment.details['carbs']} g \u00b7 G ${moment.details['fat']} g',
                                  style: AppDiaryStyle.caption,
                                ),
                            ],
                          ),
                          if (moment.note.isNotEmpty &&
                              !moment.automatic &&
                              moment.kind != 'meal' &&
                              moment.kind != 'boolean')
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                moment.note,
                                style: AppDiaryStyle.caption,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
