final class AppFailure {
  final String message;
  final String? code;
  final Object? error;
  final StackTrace? stackTrace;

  const AppFailure({
    required this.message,
    this.code,
    this.error,
    this.stackTrace,
  });

  @override
  String toString() {
    return 'AppFailure(message: $message, code: $code)';
  }
}
