class AppError implements Exception {
  /// {@macro api_client_error}
  AppError(
    this.cause, {
    this.stackTrace,
  });

  /// Error cause.
  final dynamic cause;

  /// The stack trace of the error.
  final StackTrace? stackTrace;

  @override
  String toString() {
    return '''
cause: $cause
stackTrace: $stackTrace
''';
  }
}
