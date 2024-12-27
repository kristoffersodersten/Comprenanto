import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  SharedPreferences? _prefs;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<bool> setString(String key, String value) async {
    if (_prefs == null) {
      throw Exception('SharedPreferences not initialized');
    }
    return _prefs!.setString(key, value);
  }

  Future<bool> setBool(String key, bool value) async {
    if (_prefs == null) {
      throw Exception('SharedPreferences not initialized');
    }
    return _prefs!.setBool(key, value);
  }

  Future<bool> setInt(String key, int value) async {
    if (_prefs == null) {
      throw Exception('SharedPreferences not initialized');
    }
    return _prefs!.setInt(key, value);
  }

  String? getString(String key) {
    if (_prefs == null) {
      throw Exception('SharedPreferences not initialized');
    }
    return _prefs!.getString(key);
  }

  bool? getBool(String key) {
    if (_prefs == null) {
      throw Exception('SharedPreferences not initialized');
    }
    return _prefs!.getBool(key);
  }

  int? getInt(String key) {
    if (_prefs == null) {
      throw Exception('SharedPreferences not initialized');
    }
    return _prefs!.getInt(key);
  }

  Future<bool> remove(String key) async {
    if (_prefs == null) {
      throw Exception('SharedPreferences not initialized');
    }
    return _prefs!.remove(key);
  }

  Future<bool> clear() async {
    if (_prefs == null) {
      throw Exception('SharedPreferences not initialized');
    }
    return _prefs!.clear();
  }

  bool containsKey(String key) {
    if (_prefs == null) {
      throw Exception('SharedPreferences not initialized');
    }
    return _prefs!.containsKey(key);
  }
} 