import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

const String _chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';

String generateSecureRandomString([int length = 32]) {
  final Random random = Random.secure();

  return List<String>.generate(
    length,
    (_) => _chars[random.nextInt(_chars.length)],
  ).join('');
}

String generateCodeChallenge() {
  final String code = generateSecureRandomString();

  return base64Url
      .encode(sha256.convert(ascii.encode(code)).bytes)
      .replaceAll('=', '');
}
