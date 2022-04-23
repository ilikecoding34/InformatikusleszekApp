import 'package:flutter/material.dart';

class UIconfig {
  static const double mySize = 20.0;
  static const Color myColor = Colors.blue;
  static const Icon myIcon = Icon(
    Icons.search,
    color: Colors.red,
  );
  static const TextStyle myStyle =
      TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.green);

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
  );

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
  );
}
