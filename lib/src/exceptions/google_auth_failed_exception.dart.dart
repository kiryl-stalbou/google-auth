class GoogleAuthFailedException implements Exception {
  final String message;

  const GoogleAuthFailedException({
    required this.message,
  });
}
