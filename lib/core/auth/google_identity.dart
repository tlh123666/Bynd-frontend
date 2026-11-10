import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../config/app_config.dart';
import '../network/api_client.dart';

abstract interface class GoogleIdentity {
  bool get supported;
  Future<String?> getIdToken();
  Future<void> signOut();
}

/// Same native SDK and server audience as JCVital. Web uses email sign-in;
/// iOS is enabled only after supplying its own registered OAuth client.
class PlatformGoogleIdentity implements GoogleIdentity {
  PlatformGoogleIdentity(this.config);
  final AppConfig config;
  GoogleSignIn? _sdk;
  GoogleSignIn get sdk => _sdk ??= GoogleSignIn(
    serverClientId: config.googleWebClientId,
    clientId: defaultTargetPlatform == TargetPlatform.iOS
        ? config.googleIosClientId
        : null,
    scopes: const ['email', 'profile'],
  );
  @override
  bool get supported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          (defaultTargetPlatform == TargetPlatform.iOS &&
              config.googleIosClientId.isNotEmpty));
  @override
  Future<String?> getIdToken() async {
    if (!supported) {
      throw const ApiException(
        'Google unavailable',
        code: 'google_unavailable',
      );
    }
    try {
      final account = await sdk.signIn();
      if (account == null) return null;
      final credentials = await account.authentication;
      if (credentials.idToken == null || credentials.idToken!.isEmpty) {
        throw const ApiException(
          'No Google ID token',
          code: 'google_configuration',
        );
      }
      return credentials.idToken;
    } on PlatformException catch (error) {
      if (error.code == 'sign_in_canceled' || error.code == '12501') {
        return null;
      }
      throw const ApiException('Google sign-in failed', code: 'google_failed');
    }
  }

  @override
  Future<void> signOut() async {
    if (_sdk != null) {
      await _sdk!.signOut();
    }
  }
}
