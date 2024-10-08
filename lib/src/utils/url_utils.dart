import 'package:url_launcher/url_launcher.dart';

import 'crypto_utils.dart';

Future<void> launchAuthUrl({
  required Uri redirectUrl,
  required String clientId,
  required String clientState,
}) async {
  final Map<String, String> authQueryParameters = <String, String>{
    'client_id': clientId,
    'redirect_uri': redirectUrl.toString(),
    'response_type': 'code token id_token',
    'scope': 'openid email profile',
    'code_challenge': generateCodeChallenge(),
    'code_challenge_method': 'S256',
    'nonce': generateSecureRandomString(),
    'state': clientState,
    'include_granted_scopes': 'true',
    'prompt': 'select_account',
  };

  final Uri authUrl = Uri.https(
    'accounts.google.com',
    '/o/oauth2/v2/auth',
    authQueryParameters,
  );

  await launchUrl(authUrl);
}
