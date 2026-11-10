import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../design_system/design_system.dart';
import '../../../l10n/app_localizations_context.dart';
import '../../../shared/widgets/app_sheet_controls.dart';
import '../application/login_controller.dart';
import 'auth_error_message.dart';
import 'health_consent_sheet.dart';

class EmailLoginSheet extends StatefulWidget {
  const EmailLoginSheet({required this.controller, super.key});
  final LoginController controller;
  @override
  State<EmailLoginSheet> createState() => _EmailLoginSheetState();
}

class _EmailLoginSheetState extends State<EmailLoginSheet> {
  late final _email = TextEditingController(text: widget.controller.email);
  final _code = TextEditingController();
  final _codeFocus = FocusNode();
  bool _consent = false;
  LoginController get flow => widget.controller;
  @override
  void dispose() {
    _email.dispose();
    _code.dispose();
    _codeFocus.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    FocusScope.of(context).unfocus();
    final sent = await flow.sendCode(_email.text);
    if (!mounted || !sent) return;
    _code.clear();
    _consent = false;
    _codeFocus.requestFocus();
    AppNotice.show(
      context,
      kind: AppNoticeKind.success,
      message: context.l10n.authCodeSent,
    );
  }

  void _verify() {
    FocusScope.of(context).unfocus();
    flow.verify(_code.text, consent: _consent);
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: flow,
    builder: (context, _) {
      final s = context.l10n;
      final verifying = flow.step == LoginStep.code;
      final message = flow.failure == null
          ? null
          : loginErrorMessage(s, flow.failure!);
      final fieldError =
          flow.failure == LoginFailure.email ||
          flow.failure == LoginFailure.code ||
          flow.failure == LoginFailure.rejected;
      return PopScope(
        canPop: !flow.busy,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: Column(
            children: [
              AppSheetHeader(title: s.authSignIn, canClose: !flow.busy),
              Expanded(
                child: AutofillGroup(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (verifying)
                          TextButton.icon(
                            onPressed: flow.busy
                                ? null
                                : () {
                                    flow.editEmail();
                                    _code.clear();
                                    _consent = false;
                                  },
                            icon: const Icon(Icons.arrow_back, size: 18),
                            label: Text(s.authEditEmail),
                          ),
                        Text(
                          verifying ? s.authCodeTitle : s.authEmailTitle,
                          style: AppAuthStyle.title,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          verifying
                              ? s.authCodeBody(flow.email)
                              : s.authEmailBody,
                          style: AppTypography.body.copyWith(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 28),
                        if (!verifying) ...[
                          AppInputField(
                            key: const Key('auth-email-field'),
                            controller: _email,
                            label: s.authEmailLabel,
                            hint: s.authEmailHint,
                            error: fieldError ? message : null,
                            enabled: !flow.busy,
                            keyboardType: TextInputType.emailAddress,
                            action: TextInputAction.send,
                            autofillHints: const [AutofillHints.email],
                            onChanged: (_) => flow.clearError(),
                            onSubmitted: (_) => _send(),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            s.authAccountHint,
                            style: AppTypography.caption.copyWith(
                              color: AppColors.textMuted,
                            ),
                          ),
                        ] else ...[
                          AppInputField(
                            key: const Key('auth-code-field'),
                            controller: _code,
                            focusNode: _codeFocus,
                            label: s.authCodeLabel,
                            hint: s.authCodeHint,
                            error: fieldError ? message : null,
                            enabled: !flow.busy,
                            keyboardType: TextInputType.number,
                            action: TextInputAction.done,
                            autofillHints: const [AutofillHints.oneTimeCode],
                            formatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(6),
                            ],
                            style: AppTypography.section.copyWith(
                              fontSize: 30,
                              letterSpacing: 10,
                            ),
                            onChanged: (_) {
                              flow.clearError();
                              setState(() {});
                            },
                            onSubmitted: (_) => _verify(),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            s.authSpamHint,
                            style: AppTypography.caption.copyWith(
                              color: AppColors.textMuted,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            key: const Key('auth-resend'),
                            onPressed: flow.busy || flow.resendSeconds > 0
                                ? null
                                : _send,
                            child: Text(
                              flow.resendSeconds > 0
                                  ? s.authResendIn(flow.resendSeconds)
                                  : s.authResend,
                            ),
                          ),
                          if (flow.newUser) ...[
                            const SizedBox(height: 18),
                            AppGradientCard(
                              child: HealthConsentContent(
                                accepted: _consent,
                                enabled: !flow.busy,
                                onChanged: (v) => setState(() => _consent = v),
                              ),
                            ),
                          ],
                        ],
                        if (message != null && !fieldError)
                          Padding(
                            padding: const EdgeInsets.only(top: 18),
                            child: Semantics(
                              liveRegion: true,
                              child: Text(
                                message,
                                style: AppTypography.caption.copyWith(
                                  color: AppColors.error,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                child: AppButton(
                  key: const Key('auth-submit'),
                  label: verifying
                      ? (flow.newUser ? s.authCreateAccount : s.authSignIn)
                      : s.authSendCode,
                  expanded: true,
                  loading: flow.busy,
                  onPressed: flow.busy
                      ? null
                      : verifying
                      ? (_code.text.length == 6 && (!flow.newUser || _consent)
                            ? _verify
                            : null)
                      : _send,
                ),
              ),
              SafeArea(
                top: false,
                minimum: const EdgeInsets.only(bottom: 20),
                child: const SizedBox(height: 8),
              ),
            ],
          ),
        ),
      );
    },
  );
}
