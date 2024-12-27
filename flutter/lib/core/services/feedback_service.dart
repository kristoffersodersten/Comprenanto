import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/logger.dart';

class FeedbackService {
  static final GlobalKey<ScaffoldMessengerState> messengerKey = 
      GlobalKey<ScaffoldMessengerState>();

  // Success feedback
  static Future<void> success({String? message}) async {
    try {
      if (_enableHapticFeedback()) {
        await HapticFeedback.mediumImpact();
      }
      
      if (message != null) {
        _showSnackBar(
          message: message,
          backgroundColor: Colors.green[700],
          duration: _snackBarDuration(),
        );
      }
    } catch (e) {
      AppLogger.warning('Failed to provide success feedback', e);
    }
  }

  // Error feedback
  static Future<void> error({
    required String message,
    bool showSnackBar = true,
  }) async {
    try {
      if (_enableHapticFeedback()) {
        await HapticFeedback.heavyImpact();
      }
      
      if (showSnackBar) {
        _showSnackBar(
          message: message,
          backgroundColor: Colors.red[700],
          duration: _errorSnackBarDuration(),
        );
      }
    } catch (e) {
      AppLogger.error('Failed to provide error feedback', e);
    }
  }

  // Light feedback for UI interactions
  static Future<void> light() async {
    try {
      if (_enableHapticFeedback()) {
        await HapticFeedback.lightImpact();
      }
    } catch (e) {
      AppLogger.warning('Failed to provide light feedback', e);
    }
  }

  // Show snackbar with consistent styling
  static void _showSnackBar({
    required String message,
    Color? backgroundColor,
    Duration? duration,
  }) {
    final messenger = messengerKey.currentState;
    if (messenger == null) return;

    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: backgroundColor,
        duration: duration ?? _snackBarDuration(),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  // Placeholder methods for missing AppConfig properties
  static bool _enableHapticFeedback() {
    // Implement logic to determine if haptic feedback is enabled
    return true; // Default to true for demonstration
  }

  static Duration _snackBarDuration() {
    // Implement logic to get the default snack bar duration
    return Duration(seconds: 3); // Default to 3 seconds for demonstration
  }

  static Duration _errorSnackBarDuration() {
    // Implement logic to get the error snack bar duration
    return Duration(seconds: 5); // Default to 5 seconds for demonstration
  }
} 