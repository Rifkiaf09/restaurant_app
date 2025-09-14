import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

class SettingsProvider extends ChangeNotifier {
  static const _keyIsDark = 'is_dark';
  static const _keyDailyReminder = 'daily_reminder';

  bool _isDark = false;
  bool _dailyReminder = false;

  bool get isDark => _isDark;
  bool get dailyReminder => _dailyReminder;

  SettingsProvider() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _isDark = prefs.getBool(_keyIsDark) ?? false;
    _dailyReminder = prefs.getBool(_keyDailyReminder) ?? false;

    if (_dailyReminder) {
      await scheduleDaily();
    }

    notifyListeners();
  }

  Future<void> setDark(bool value) async {
    _isDark = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsDark, value);
    notifyListeners();
  }

  Future<void> toggleTheme() async => setDark(!_isDark);

  Future<void> setDailyReminder(bool enabled) async {
    _dailyReminder = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyDailyReminder, enabled);

    if (enabled) {
      await scheduleDaily();
    } else {
      await cancelDaily();
    }

    notifyListeners();
  }

  Future<void> scheduleDaily() async {
    await Workmanager().registerPeriodicTask(
      'daily-reminder',
      'fetchBackground',
      frequency: const Duration(hours: 24),
      initialDelay: _computeInitialDelayTo11AM(),
      existingWorkPolicy: ExistingWorkPolicy.replace,
    );
  }

  Future<void> cancelDaily() async {
    await Workmanager().cancelByUniqueName('daily-reminder');
  }

  /// Hitung delay supaya notifikasi muncul tepat jam 11:00 siang
  Duration _computeInitialDelayTo11AM() {
    final now = DateTime.now();
    var target = DateTime(now.year, now.month, now.day, 11, 0);
    if (now.isAfter(target)) {
      target = target.add(const Duration(days: 1));
    }
    return target.difference(now);
  }
}
