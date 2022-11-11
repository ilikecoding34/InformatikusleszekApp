import 'package:blog/config/ui_config.dart';
import 'package:blog/services/sharedpreferences_service.dart';
import 'package:flutter/material.dart';

class ThemeService extends ChangeNotifier {
  ThemeData _themeData = UIconfig.lightTheme;
  PreferencesService shared = PreferencesService();
  bool _isDarkMode = true;

  getTheme() => _themeData;

  isDarkMode() => _isDarkMode;

  changeMode(bool value) async {
    _isDarkMode = value;
    _themeData = _isDarkMode ? UIconfig.darkTheme : UIconfig.lightTheme;
    shared.storeThemeType(_isDarkMode);
    notifyListeners();
  }
}
