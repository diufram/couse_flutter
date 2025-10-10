import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  static const _kThemeMode = 'theme_mode'; // 'system' | 'light' | 'dark'
  static const _kFontScale = 'font_scale'; // double
  static const _kFontFamily = 'font_family'; // String?

  static const _kToken = 'auth_token'; // String
  static const _kUserJson = 'auth_user_json'; // String (json)

  final SharedPreferences _prefs;
  PrefsService(this._prefs);

  // ---- THEME ----
  Future<void> setThemeMode(String mode) => _prefs.setString(_kThemeMode, mode);
  String themeMode() => _prefs.getString(_kThemeMode) ?? 'system';

  Future<void> setFontScale(double v) => _prefs.setDouble(_kFontScale, v);
  double fontScale() => _prefs.getDouble(_kFontScale) ?? 1.0;

  Future<void> setFontFamily(String? f) async {
    if (f == null) {
      await _prefs.remove(_kFontFamily);
    } else {
      await _prefs.setString(_kFontFamily, f);
    }
  }

  String? fontFamily() => _prefs.getString(_kFontFamily);

  // ---- AUTH ----
  Future<void> setToken(String token) => _prefs.setString(_kToken, token);
  String? token() => _prefs.getString(_kToken);

  Future<void> clearToken() => _prefs.remove(_kToken);

  Future<void> setUserJson(String json) => _prefs.setString(_kUserJson, json);
  String? userJson() => _prefs.getString(_kUserJson);
  Future<void> clearUser() => _prefs.remove(_kUserJson);

  Future<void> clearSession() async {
    await _prefs.remove(_kToken);
    await _prefs.remove(_kUserJson);
  }
}
