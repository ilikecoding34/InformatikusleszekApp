import 'package:blog/config/ui_config.dart';
import 'package:blog/services/sharedpreferences_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeService extends ChangeNotifier {
  ThemeData _themeData = UIconfig.lightTheme;
  PreferencesService shared = PreferencesService();
  bool isDarkMode = true;

  getTheme() => _themeData;

  getMode() => isDarkMode;

  changeMode(bool value) async {
    isDarkMode = value;
    _themeData = isDarkMode ? UIconfig.darkTheme : UIconfig.lightTheme;
    shared.storeThemeType(isDarkMode);
    notifyListeners();
  }
}
