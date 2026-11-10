import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/auth/auth_controller.dart';
import '../../../core/auth/auth_scope.dart';
import '../../../design_system/design_system.dart';
import '../../../l10n/app_locale_controller.dart';
import '../../../l10n/app_localizations_context.dart';
import '../../../l10n/language_picker_sheet.dart';
import '../application/login_controller.dart';
import 'auth_error_message.dart';
import 'auth_privacy_page.dart';
import 'email_login_sheet.dart';
import 'health_consent_sheet.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({this.controller, super.key});
  final LoginController? controller;
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static const _images = [
    'assets/images/home-canion.webp',
    'assets/images/home-manha-lago.webp',
    'assets/images/home-noite-aurora.webp',
  ];
  LoginController? _flow;
  final _pages = PageController();
  int _photo = 0;
  bool _emailOpen = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _flow ??= widget.controller ?? LoginController(AuthScope.of(context));
  }

  @override
  void dispose() {
    _pages.dispose();
    if (widget.controller == null) _flow?.dispose();
    super.dispose();
  }

  Future<void> _email() async {
    setState(() => _emailOpen = true);
    await showAppContentSheet<void>(
      context,
      (_) => EmailLoginSheet(controller: _flow!),
      glass: true,
    );
    if (mounted) {
      _flow!.clearError();
      setState(() => _emailOpen = false);
    }
  }

  Future<void> _google() async {
    final accepted = await showHealthConsent(context);
    if (!mounted || !accepted) return;
    await _flow!.googleSignIn();
  }

  Future<void> _language() async {
    final locale = AppLocaleScope.maybeOf(context);
    if (locale == null) return;
    await AppFrostedModalSheet.show<void>(
      context,
      builder: (_) => LanguagePickerSheet(
        selectedLocale: locale.locale,
        onSelected: locale.setLocale,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
    value: SystemUiOverlayStyle.light,
    child: Scaffold(
      backgroundColor: AppColors.homeCanvas,
      resizeToAvoidBottomInset: false,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppAuthStyle.maxWidth),
          child: ListenableBuilder(
            listenable: _flow!,
            builder: (context, _) {
              final flow = _flow!, s = context.l10n;
              return Stack(
                fit: StackFit.expand,
                children: [
                  PageView.builder(
                    controller: _pages,
                    itemCount: _images.length,
                    onPageChanged: (i) => setState(() => _photo = i),
                    itemBuilder: (_, i) => Image.asset(
                      _images[i],
                      fit: BoxFit.cover,
                      excludeFromSemantics: true,
                    ),
                  ),
                  const IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: AppAuthStyle.backdrop,
                      ),
                    ),
                  ),
                  SafeArea(
                    child: CustomScrollView(
                      slivers: [
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const AppSvgIcon(
                                      AppSvgAssets.logo,
                                      width: 110,
                                      height: 30,
                                      label: 'BYND',
                                    ),
                                    const Spacer(),
                                    if (AppLocaleScope.maybeOf(context) != null)
                                      IconButton(
                                        tooltip: s.authChangeLanguage,
                                        onPressed: flow.busy ? null : _language,
                                        icon: const Icon(
                                          Icons.language,
                                          size: 22,
                                        ),
                                      ),
                                  ],
                                ),
                                const Spacer(),
                                const SizedBox(height: 48),
                                if (flow.auth.exitReason ==
                                        AuthExitReason.expired ||
                                    flow.auth.exitReason ==
                                        AuthExitReason.unauthorized)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: Text(
                                      s.authSessionExpired,
                                      style: AppTypography.body.copyWith(
                                        fontSize: 14,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ),
                                Text(
                                  s.authWelcome,
                                  style: AppTypography.kicker.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Text(
                                  s.authHeadline,
                                  style: AppAuthStyle.headline,
                                ),
                                const SizedBox(height: 14),
                                Text(
                                  s.authSubtitle,
                                  style: AppTypography.body.copyWith(
                                    fontSize: 15,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    for (int i = 0; i < _images.length; i++)
                                      Semantics(
                                        selected: i == _photo,
                                        button: true,
                                        child: Tooltip(
                                          message: s.authBackground(
                                            i + 1,
                                            _images.length,
                                          ),
                                          child: InkWell(
                                            borderRadius: AppRadii.pillBorder,
                                            onTap: () {
                                              if (AppMotion.enabled(context)) {
                                                _pages.animateToPage(
                                                  i,
                                                  duration: AppMotion.page,
                                                  curve: Curves.easeOutCubic,
                                                );
                                              } else {
                                                _pages.jumpToPage(i);
                                              }
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 12,
                                                    horizontal: 4,
                                                  ),
                                              child: AnimatedContainer(
                                                duration:
                                                    AppMotion.enabled(context)
                                                    ? AppMotion.page
                                                    : Duration.zero,
                                                width: i == _photo ? 28 : 7,
                                                height: 4,
                                                decoration: BoxDecoration(
                                                  color: i == _photo
                                                      ? AppColors.textPrimary
                                                      : AppColors.textDim,
                                                  borderRadius:
                                                      AppRadii.pillBorder,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                if (flow.supportsGoogle) ...[
                                  SizedBox(
                                    width: double.infinity,
                                    height: 52,
                                    child: FilledButton(
                                      onPressed: flow.busy ? null : _google,
                                      child: flow.busy
                                          ? const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 1.5,
                                                color: AppColors.onAction,
                                              ),
                                            )
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/icons/site/google-sign-in.svg',
                                                  width: 20,
                                                  height: 20,
                                                ),
                                                const SizedBox(width: 12),
                                                Flexible(
                                                  child: Text(
                                                    s.authGoogleContinue,
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                ],
                                AppButton(
                                  key: const Key('auth-email-continue'),
                                  label: s.authEmailContinue,
                                  expanded: true,
                                  onPressed: flow.busy ? null : _email,
                                  variant: flow.supportsGoogle
                                      ? AppButtonVariant.secondary
                                      : AppButtonVariant.primary,
                                ),
                                if (flow.failure != null && !_emailOpen)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 14),
                                    child: Semantics(
                                      liveRegion: true,
                                      child: Text(
                                        loginErrorMessage(s, flow.failure!),
                                        style: AppTypography.caption.copyWith(
                                          color: AppColors.error,
                                        ),
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 18),
                                Text(
                                  s.authLegalFootnote,
                                  style: AppTypography.caption.copyWith(
                                    color: AppColors.textMuted,
                                  ),
                                ),
                                TextButton(
                                  onPressed: flow.busy
                                      ? null
                                      : () => Navigator.push(
                                          context,
                                          MaterialPageRoute<void>(
                                            builder: (_) =>
                                                const AuthPrivacyPage(),
                                          ),
                                        ),
                                  child: Text(s.authPrivacy),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    ),
  );
}
