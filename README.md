# google_auth package

The **google_auth** package is a Dart-based solution designed to integrate Google authentication via OAuth 2.0 and OpenID Connect (OIDC) protocols. It provides a mechanism for handling user sign-in requests on all platforms, including mobile, web, and desktop. This package manages communication between the client and Google's authentication server, ensuring secure handling of authentication sessions.

Key features include:
- **OAuth 2.0 and OIDC Support**: Handles sign-in via standard protocols for secure user authentication.
- **Timeout Management**: Allows for customizable timeouts during sign-in operations.
- **Local HTTP Server**: Built on a Dart-based HTTP server to facilitate communication between the client and Google's authentication endpoints.
- **Error Handling**: Includes custom exceptions for failed, aborted, or timed-out authentication attempts.

This package is designed to be integrated into Dart-based applications requiring Google authentication, offering an efficient solution across all platforms. The code structure is optimized for simplicity, with easy-to-use methods for initiating authentication flows and handling responses.

Plans are in place to upload this package to **pub.dev** for public access and future updates.

### Usage

#### Sign In

```dart
import 'package:google_auth/google_auth.dart';

void main() async {
  final googleAuth = GoogleAuth(clientId: 'your-client-id');

  try {
    final googleAuthSession = await googleAuth.signIn();
    print('Access Token: ${googleAuthSession.accessToken}');
  } catch (e) {
    print('Sign-in failed: $e');
  }
}
```

#### Sign In with Timeout

```dart
import 'package:google_auth/google_auth.dart';

void main() async {
  final googleAuth = GoogleAuth(clientId: 'your-client-id');

  try {
    final googleAuthSession = await googleAuth.signInWithTimeout(
      timeout: Duration(seconds: 30),
    );
    print('Access Token: ${googleAuthSession.accessToken}');
  } catch (e) {
    print('Sign-in failed: $e');
  }
}
```
