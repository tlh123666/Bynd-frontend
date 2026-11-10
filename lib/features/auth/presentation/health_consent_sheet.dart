import 'package:flutter/material.dart';
import '../../../design_system/design_system.dart';
import '../../../l10n/app_localizations_context.dart';
import '../../../shared/widgets/app_sheet_controls.dart';
import 'auth_privacy_page.dart';

Future<bool> showHealthConsent(BuildContext context) async =>
    await showAppContentSheet<bool>(
      context,
      (_) => const _HealthConsentSheet(),
      glass: true,
      heightFactor: .84,
    ) ??
    false;

class HealthConsentContent extends StatelessWidget {
  const HealthConsentContent({
    required this.accepted,
    required this.onChanged,
    this.enabled = true,
    super.key,
  });
  final bool accepted, enabled;
  final ValueChanged<bool> onChanged;
  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          s.authConsentTitle,
          style: AppTypography.title.copyWith(fontSize: 18),
        ),
        const SizedBox(height: 12),
        Text(
          s.authConsentBody,
          style: AppTypography.body.copyWith(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        CheckboxListTile(
          key: const Key('auth-health-consent'),
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
          value: accepted,
          onChanged: enabled ? (v) => onChanged(v ?? false) : null,
          activeColor: AppColors.textPrimary,
          checkColor: AppColors.onAction,
          title: Text(
            s.authConsentLabel,
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        TextButton(
          onPressed: enabled
              ? () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const AuthPrivacyPage(),
                  ),
                )
              : null,
          child: Text(s.authPrivacyLink),
        ),
      ],
    );
  }
}

class _HealthConsentSheet extends StatefulWidget {
  const _HealthConsentSheet();
  @override
  State<_HealthConsentSheet> createState() => _HealthConsentSheetState();
}

class _HealthConsentSheetState extends State<_HealthConsentSheet> {
  bool _accepted = false;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      AppSheetHeader(title: context.l10n.authPrivacy),
      Expanded(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: HealthConsentContent(
            accepted: _accepted,
            onChanged: (v) => setState(() => _accepted = v),
          ),
        ),
      ),
      AppSheetSaveButton(
        label: context.l10n.authConsentAccept,
        onPressed: _accepted ? () => Navigator.pop(context, true) : null,
      ),
      TextButton(
        onPressed: () => Navigator.pop(context, false),
        child: Text(context.l10n.authConsentDecline),
      ),
      const SizedBox(height: 12),
    ],
  );
}
