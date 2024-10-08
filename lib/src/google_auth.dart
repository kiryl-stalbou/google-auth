import 'dart:io';

import 'assets/web_pages.dart';

import 'models/google_auth_session.dart';

import 'utils/crypto_utils.dart';
import 'utils/url_utils.dart';

import 'exceptions/google_auth_failed_exception.dart.dart';
import 'exceptions/google_auth_aborted_exception.dart.dart';
import 'exceptions/google_auth_timeout_exception.dart.dart';

class GoogleAuth {
  static const Duration _signInTimeoutDuration = Duration(seconds: 100);

  final String clientId;

  HttpServer? _server;

  GoogleAuth({
    required this.clientId,
  });

  Future<GoogleAuthSession> signInWithTimeout({
    Duration? timeout,
  }) async {
    return signIn().timeout(
      timeout ?? _signInTimeoutDuration,
      onTimeout: () async {
        await _closeServer();

        throw const GoogleAuthTimeoutException();
      },
    );
  }

  Future<GoogleAuthSession> signIn() async {
    try {
      await _closeServer();

      _server = await HttpServer.bind('localhost', 0);

      final String clientState = generateSecureRandomString();

      await launchAuthUrl(
        clientId: clientId,
        clientState: clientState,
        redirectUrl: Uri.http(
          <String>[
            _server!.address.host,
            _server!.port.toString(),
          ].join(':'),
        ),
      );

      await for (final HttpRequest request in _server!) {
        try {
          switch (request.requestedUri.path) {
            case '/response':
              return _handleResponseRequest(request, clientState);

            default:
              _handleAnyRequest(request);
          }
        } finally {
          await request.response.flush();
          await request.response.close();
        }
      }

      throw const GoogleAuthAbortedException();
    } finally {
      await _closeServer();
    }
  }

  Future<void> _closeServer() async {
    await _server?.close();
    _server = null;
  }

  GoogleAuthSession _handleResponseRequest(
    HttpRequest request,
    String clientState,
  ) {
    final Map<String, String> queryParameters =
        request.requestedUri.queryParameters;

    final String? serverState = queryParameters['state'];
    final String? accessToken = queryParameters['access_token'];

    if (clientState != serverState || accessToken == null) {
      _handleResponse(request, authFailedWebPageHtml);

      throw GoogleAuthFailedException(
        message: <String>[
          'Failed to process Google Auth Response (state mismatch or accessToken not found)',
          request.requestedUri.toString(),
        ].join(' '),
      );
    }

    _handleResponse(request, authSuccessWebPageHtml);

    return GoogleAuthSession(
      accessToken: accessToken,
    );
  }

  void _handleAnyRequest(
    HttpRequest request,
  ) {
    return _handleResponse(
      request,
      authLoadingWebPageHtml,
    );
  }

  void _handleResponse(
    HttpRequest request,
    Object data, {
    ContentType? contentType,
  }) {
    request.response
      ..statusCode = HttpStatus.ok
      ..headers.contentType = contentType ?? ContentType.html
      ..write(data);
  }
}
