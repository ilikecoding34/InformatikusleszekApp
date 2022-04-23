import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeService extends ChangeNotifier {
  ThemeData _themeData;
  bool isDarkMode = false;

  ThemeService(this._themeData);

  getTheme() => _themeData;

  getMode() => isDarkMode;

  setTheme(ThemeData themeData) async {
    _themeData = themeData;
    notifyListeners();
  }

  setMode(bool value) async {
    isDarkMode = value;
    notifyListeners();
  }
}
