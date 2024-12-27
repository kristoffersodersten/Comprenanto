import 'package:sentry_flutter/sentry_flutter.dart'; // Corrected import
import '../config/app_config.dart';
import '../models/app_error.dart';
import '../utils/logger.dart';

class ErrorTrackingService {
  static Future<void> initialize() async {
    await SentryFlutter.init( // Corrected initialization method
      (options) {
        options.dsn = AppConfig.sentryDsn;
        options.tracesSampleRate = 1.0;
        options.environment = AppConfig.environment;
      },
    );
  }

  static Future<void> captureException(
    dynamic exception,
    StackTrace? stackTrace, {
    Map<String, dynamic>? extras,
  }) async {
    try {
      if (exception is AppError) {
        await Sentry.captureException(
          exception,
          stackTrace: stackTrace,
          withScope: (scope) {
            scope.setExtra('error_type', exception.type.toString());
            scope.setExtra('error_title', exception.title);
            if (extras != null) {
              extras.forEach((key, value) {
                scope.setExtra(key, value);
              });
            }
          },
        );
      } else {
        await Sentry.captureException(
          exception,
          stackTrace: stackTrace,
          withScope: (scope) {
            if (extras != null) {
              extras.forEach((key, value) {
                scope.setExtra(key, value);
              });
            }
          },
        );
      }
    } catch (e) {
      AppLogger.error('Failed to capture exception in Sentry', e);
    }
  }

  static Future<void> captureMessage(
    String message, {
    SentryLevel level = SentryLevel.info,
    Map<String, dynamic>? extras,
  }) async {
    try {
      await Sentry.captureMessage(
        message,
        level: level,
        withScope: (scope) {
          if (extras != null) {
            extras.forEach((key, value) {
              scope.setExtra(key, value);
            });
          }
        },
      );
    } catch (e) {
      AppLogger.error('Failed to capture message in Sentry', e);
    }
  }
} 