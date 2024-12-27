import 'package:flutter/material.dart';
import '../models/app_error.dart';
import 'logger.dart';

class ErrorHandler {
  static AppError handle(dynamic error, StackTrace? stackTrace) {
    AppLogger.error('Error occurred', error, stackTrace);

    if (error is AppError) {
      return error;
    }

    // Network errors
    if (error.toString().contains('SocketException') ||
        error.toString().contains('NetworkException')) {
      return AppError(
        title: 'Network Error',
        message: 'Please check your internet connection and try again.',
        type: ErrorType.network,
      );
    }

    // Timeout errors
    if (error.toString().contains('TimeoutException')) {
      return AppError(
        title: 'Request Timeout',
        message: 'The operation timed out. Please try again.',
        type: ErrorType.timeout,
      );
    }

    // API errors
    if (error.toString().contains('ApiException')) {
      return AppError(
        title: 'API Error',
        message: error.toString(),
        type: ErrorType.api,
      );
    }

    // Default error
    return AppError(
      title: 'Unexpected Error',
      message: 'An unexpected error occurred. Please try again.',
      type: ErrorType.unknown,
    );
  }

  static void showErrorDialog(BuildContext context, AppError error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(error.title),
        content: Text(error.message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  static void showErrorSnackBar(BuildContext context, AppError error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error.message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
} 