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
    primarySwatch: Colors.grey,
    primaryColor: Colors.black,
    brightness: Brightness.dark,
    backgroundColor: const Color(0xFF212121),
    secondaryHeaderColor: Colors.white,
    dividerColor: Colors.black12,
  );

  static ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.grey,
    primaryColor: Colors.white,
    brightness: Brightness.light,
    backgroundColor: const Color(0xFFE5E5E5),
    secondaryHeaderColor: Colors.black,
    dividerColor: Colors.white54,
  );
}
