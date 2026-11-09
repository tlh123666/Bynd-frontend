import 'package:flutter/material.dart';

import '../design_system/design_system.dart';
import 'app_localizations_context.dart';

/// 可复用的应用语言选择面板。
class LanguagePickerSheet extends StatelessWidget {
  const LanguagePickerSheet({
    required this.selectedLocale,
    required this.onSelected,
    super.key,
  });

  final Locale selectedLocale;
  final Future<bool> Function(Locale locale) onSelected;

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(strings.chooseLanguage, style: AppTypography.title),
            const SizedBox(height: AppSpacing.sm),
            _LanguageOption(
              locale: const Locale('pt', 'BR'),
              selectedLocale: selectedLocale,
              label: strings.languagePortugueseBrazil,
              onSelected: onSelected,
            ),
            _LanguageOption(
              locale: const Locale('en'),
              selectedLocale: selectedLocale,
              label: strings.languageEnglish,
              onSelected: onSelected,
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageOption extends StatefulWidget {
  const _LanguageOption({
    required this.locale,
    required this.selectedLocale,
    required this.label,
    required this.onSelected,
  });

  final Locale locale;
  final Locale selectedLocale;
  final String label;
  final Future<bool> Function(Locale locale) onSelected;

  @override
  State<_LanguageOption> createState() => _LanguageOptionState();
}

class _LanguageOptionState extends State<_LanguageOption> {
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    final isSelected =
        widget.locale.languageCode == widget.selectedLocale.languageCode;
    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: isSelected,
      label: widget.label,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(widget.label, style: AppTypography.listItem),
        trailing: _saving
            ? const SizedBox.square(
                dimension: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: isSelected ? AppColors.textPrimary : AppColors.textDim,
              ),
        onTap: _saving ? null : _select,
      ),
    );
  }

  Future<void> _select() async {
    setState(() => _saving = true);
    final saved = await widget.onSelected(widget.locale);
    if (!mounted) return;
    Navigator.of(context).pop();
    if (!saved) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.languagePreferenceNotSaved)),
      );
    }
  }
}
