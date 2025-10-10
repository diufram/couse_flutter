import 'package:flutter/material.dart';
import '../storage/prefs_service.dart';

class ThemeProvider extends ChangeNotifier {
  final PrefsService _prefs;

  ThemeMode _mode = ThemeMode.system;
  double _fontScale = 1.0;
  String? _fontFamily;

  ThemeProvider(this._prefs) {
    // Cargar estado persistido
    final modeStr = _prefs.themeMode();
    _mode = switch (modeStr) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
    _fontScale = _prefs.fontScale();
    _fontFamily = _prefs.fontFamily();
  }

  ThemeMode get mode => _mode;
  double get fontScale => _fontScale;
  String? get fontFamily => _fontFamily;

  Future<void> setMode(ThemeMode m) async {
    _mode = m;
    await _prefs.setThemeMode(switch (m) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      _ => 'system',
    });
    notifyListeners();
  }

  Future<void> toggleMode() async {
    await setMode(_mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
  }

  Future<void> setFontScale(double s) async {
    _fontScale = s.clamp(0.8, 1.4);
    await _prefs.setFontScale(_fontScale);
    notifyListeners();
  }

  Future<void> setFontFamily(String? f) async {
    _fontFamily = f;
    await _prefs.setFontFamily(f);
    notifyListeners();
  }
}
