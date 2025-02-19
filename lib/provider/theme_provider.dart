import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  ThemeProvider() {
    // _loadThemeMode();
  }

  void toggleTheme() {
    themeMode = themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    // _saveThemeMode();
    notifyListeners();
  }

  // void _loadThemeMode() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   if (prefs.getBool('isDark') != null) {
  //     themeMode =
  //         (prefs.getBool('isDark') ?? false) ? ThemeMode.dark : ThemeMode.light;
  //   }
  //   notifyListeners();
  // }

  // void _saveThemeMode() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.setBool('isDark', themeMode == ThemeMode.dark);
  // }

  bool isTablet(context) {
    return MediaQuery.of(context).size.width > 600;
  }
}
