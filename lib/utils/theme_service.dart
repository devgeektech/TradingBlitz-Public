import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  final String _key = 'themeMode';
  bool get isDark => currentThemeMode.value == ThemeMode.dark;
  bool get isLight => currentThemeMode.value == ThemeMode.light;

  final Rx<ThemeMode> currentThemeMode = ThemeMode.system.obs;

  ThemeService() {
    _loadThemeMode().then((value) {
      currentThemeMode.value = value;
      Get.changeThemeMode(value);
    });
  }

  Future<void> _saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, mode.name);
  }

  Future<ThemeMode> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final mode = prefs.getString(_key);
    switch (mode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  Future<ThemeMode> get theme async => await _loadThemeMode();

  void switchTheme(ThemeMode mode) async {
    currentThemeMode.value = mode;
    await _saveThemeMode(mode);
    Get.changeThemeMode(mode);
  }
}
