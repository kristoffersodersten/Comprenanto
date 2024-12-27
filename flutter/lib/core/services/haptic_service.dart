import 'package:flutter/services.dart';

class HapticService {
  static void light() {
    HapticFeedback.lightImpact();
  }

  static void medium() {
    HapticFeedback.mediumImpact();
  }

  static void heavy() {
    HapticFeedback.heavyImpact();
  }

  static void success() {
    HapticFeedback.mediumImpact();
  }

  static void error() {
    HapticFeedback.vibrate();
  }

  static void buttonPress() {
    HapticFeedback.selectionClick();
  }
} 