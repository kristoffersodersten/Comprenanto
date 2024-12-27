import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  Future<String?> getString(String key) async {
    return _prefs.getString(key);
  }

  Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }
} 