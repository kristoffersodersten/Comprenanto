enum ErrorType {
  network,
  timeout,
  api,
  validation,
  auth,
  unknown,
}

class AppError implements Exception {
  final String title;
  final String message;
  final ErrorType type;
  final dynamic originalError;
  final StackTrace? stackTrace;

  AppError({
    required this.title,
    required this.message,
    this.type = ErrorType.unknown,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() => '$title: $message';

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'message': message,
      'type': type.toString(),
      'originalError': originalError?.toString(),
      'stackTrace': stackTrace?.toString(),
    };
  }
} 