import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  // Theme Mode..
  Future<ThemeMode> themeMode() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int _index = preferences.getInt("themeMode") ?? 0;
    if (_index <= 2 || _index >= 0) {
      return ThemeMode.values[_index];
    }
    return ThemeMode.system;
  }

  Future<void> updateThemeMode(ThemeMode theme) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt("themeMode", theme.index);
  }
  // --Theme Mode..
}
