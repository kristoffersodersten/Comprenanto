import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  // Define your settings properties and methods here

  // Example property
  bool _darkMode = false;

  bool get darkMode => _darkMode;

  void toggleDarkMode() {
    _darkMode = !_darkMode;
    notifyListeners();
  }
}
