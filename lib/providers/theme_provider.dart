import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const _prefKey = 'theme_mode';
  ThemeMode _mode = ThemeMode.system;

  ThemeProvider() {
    _loadTheme();
  }

  ThemeMode get mode => _mode;

  void toggle() {
    _mode = _mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    _saveTheme(_mode);
    notifyListeners();
  }

  void toggleTheme() => toggle();

  void setDark(bool isDark) {
    _mode = isDark ? ThemeMode.dark : ThemeMode.light;
    _saveTheme(_mode);
    notifyListeners();
  }

  void setMode(ThemeMode mode) {
    _mode = mode;
    _saveTheme(mode);
    notifyListeners();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefKey);

    if (saved == 'dark') {
      _mode = ThemeMode.dark;
    } else if (saved == 'light') {
      _mode = ThemeMode.light;
    } else {
      _mode = ThemeMode.system;
    }
    notifyListeners();
  }

  Future<void> _saveTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    switch (mode) {
      case ThemeMode.dark:
        await prefs.setString(_prefKey, 'dark');
        break;
      case ThemeMode.light:
        await prefs.setString(_prefKey, 'light');
        break;
      case ThemeMode.system:
        await prefs.setString(_prefKey, 'system');
        break;
    }
  }
}
