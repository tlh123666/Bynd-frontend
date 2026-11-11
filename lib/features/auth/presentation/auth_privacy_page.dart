import 'package:flutter/material.dart';
import '../../../design_system/design_system.dart';
import '../../../l10n/app_localizations_context.dart';

class AuthPrivacyPage extends StatelessWidget {
  const AuthPrivacyPage({super.key});
  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    return Scaffold(
      backgroundColor: AppColors.homeCanvas,
      body: AppDetailBackground(
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppAuthStyle.maxWidth,
              ),
              child: Column(
                children: [
                  AppDetailHeader(
                    title: s.authPrivacy,
                    onClose: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(24),
                      children: [
                        Text(s.authPrivacyTitle, style: AppAuthStyle.title),
                        const SizedBox(height: 28),
                        for (final entry in [
                          (s.authPrivacyPurposeTitle, s.authPrivacyPurpose),
                          (s.authPrivacyChoiceTitle, s.authPrivacyChoice),
                          (s.authPrivacyAccessTitle, s.authPrivacyAccess),
                        ])
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: AppGradientCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    entry.$1,
                                    style: AppTypography.title.copyWith(
                                      fontSize: 17,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    entry.$2,
                                    style: AppTypography.body.copyWith(
                                      fontSize: 14,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
