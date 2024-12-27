import 'package:flutter/material.dart';
import '../storage/storage_service.dart';

class ThemeService extends ChangeNotifier {
  final StorageService _storage;
  static const _themeKey = 'theme_mode';

  ThemeMode _themeMode = ThemeMode.system;

  ThemeService(this._storage);

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  Future<void> initialize() async {
    final savedTheme = _storage.getString(_themeKey);
    if (savedTheme != null) {
      _themeMode = ThemeMode.values.firstWhere(
        (mode) => mode.toString() == savedTheme,
        orElse: () => ThemeMode.system,
      );
      notifyListeners();
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    
    _themeMode = mode;
    await _storage.setString(_themeKey, mode.toString());
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    final newMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(newMode);
  }
}