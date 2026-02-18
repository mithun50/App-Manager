import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_management/utils/constants.dart';

class SettingsProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  bool _notificationsEnabled = true;
  double _warningThreshold = AppConstants.warningThreshold;

  ThemeMode get themeMode => _themeMode;
  bool get notificationsEnabled => _notificationsEnabled;
  double get warningThreshold => _warningThreshold;

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    final themeModeIndex = prefs.getInt(AppConstants.prefThemeMode) ?? 0;
    _themeMode = ThemeMode.values[themeModeIndex];

    _notificationsEnabled =
        prefs.getBool(AppConstants.prefNotificationsEnabled) ?? true;

    _warningThreshold =
        prefs.getDouble(AppConstants.prefWarningThreshold) ?? AppConstants.warningThreshold;

    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(AppConstants.prefThemeMode, mode.index);
    notifyListeners();
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    _notificationsEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.prefNotificationsEnabled, enabled);
    notifyListeners();
  }

  Future<void> setWarningThreshold(double threshold) async {
    _warningThreshold = threshold;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(AppConstants.prefWarningThreshold, threshold);
    notifyListeners();
  }
}
