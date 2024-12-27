import 'package:flutter/material.dart';
import '../models/app_error.dart';
import '../services/error_tracking_service.dart';
import '../utils/logger.dart';

class ErrorBoundary extends StatefulWidget {
  final Widget child;
  final Widget Function(BuildContext, AppError)? errorBuilder;

  const ErrorBoundary({
    super.key,
    required this.child,
    this.errorBuilder,
  });

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  AppError? _error;

  @override
  void initState() {
    super.initState();
    ErrorWidget.builder = (FlutterErrorDetails details) {
      _handleError(details.exception, details.stack);
      return _buildErrorWidget(
        AppError(
          title: 'Error',
          message: 'An unexpected error occurred.',
          type: ErrorType.unknown,
          originalError: details.exception,
          stackTrace: details.stack,
        ),
      );
    };
  }

  void _handleError(dynamic error, StackTrace? stackTrace) {
    AppLogger.error('Error Boundary caught error', error, stackTrace);
    ErrorTrackingService.captureException(error, stackTrace);
  }

  Widget _buildErrorWidget(AppError error) {
    if (widget.errorBuilder != null) {
      return widget.errorBuilder!(context, error);
    }

    return Material(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                error.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                error.message,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() => _error = null);
                },
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return _buildErrorWidget(_error!);
    }

    return widget.child;
  }
} 