import 'package:flutter/foundation.dart';

class AppLogger {
  static bool enableDebugLogging = true; // Define a static variable for enabling debug logging

  static void _log(String level, String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      final time = DateTime.now().toIso8601String();
      final errorInfo = error != null ? ' Error: $error' : '';
      final stackInfo = stackTrace != null ? ' StackTrace: $stackTrace' : '';
      print('[$time] [$level] $message$errorInfo$stackInfo');
    }
  }

  static void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    if (enableDebugLogging) {
      _log('DEBUG', message, error, stackTrace);
    }
  }

  static void info(String message, [dynamic error, StackTrace? stackTrace]) {
    _log('INFO', message, error, stackTrace);
  }

  static void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    _log('WARNING', message, error, stackTrace);
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _log('ERROR', message, error, stackTrace);
  }

  static void fatal(String message, [dynamic error, StackTrace? stackTrace]) {
    _log('FATAL', message, error, stackTrace);
  }
}