import '../../../l10n/generated/app_localizations.dart';
import '../application/login_controller.dart';

String loginErrorMessage(AppLocalizations s, LoginFailure failure) =>
    switch (failure) {
      LoginFailure.email => s.authInvalidEmail,
      LoginFailure.code => s.authInvalidCode,
      LoginFailure.expired => s.authCodeExpired,
      LoginFailure.rejected => s.authCodeRejected,
      LoginFailure.consent => s.authConsentRequired,
      LoginFailure.connection => s.authNetworkError,
      LoginFailure.rateLimited => s.authRateLimited,
      LoginFailure.storage => s.authStorageError,
      LoginFailure.google => s.authGoogleError,
      LoginFailure.server => s.authServerError,
    };
