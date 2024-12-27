class ApiException implements Exception {
  final String message;
  final int? code;

  ApiException({required this.message, this.code});

  @override
  String toString() => 'ApiException: $message (Code: $code)';
} 