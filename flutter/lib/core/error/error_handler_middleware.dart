import 'package:flutter/material.dart';
import '../models/app_error.dart';
import '../services/error_tracking_service.dart';
import '../utils/logger.dart';

class ErrorHandlerMiddleware extends StatelessWidget {
  final Widget child;
  final Function(BuildContext, AppError)? onError;

  const ErrorHandlerMiddleware({
    super.key,
    required this.child,
    this.onError,
  });

  @override
  Widget build(BuildContext context) {
    // Fix: Assign ErrorWidget.builder correctly and return the child widget
    ErrorWidget.builder = (FlutterErrorDetails details) {
      AppLogger.error('Flutter Error', details.exception, details.stack);
      ErrorTrackingService.captureException(
        details.exception,
        details.stack,
        extras: {'context': 'Flutter Error Widget'},
      );

      return Material(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Something went wrong',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    };

    return child; // Return the child widget
  }
}