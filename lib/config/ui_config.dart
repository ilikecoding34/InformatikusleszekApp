import 'package:flutter/material.dart';

class UIconfig {
  static const double mySize = 20.0;
  static const double boxWidth = 50.0;
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

  static ButtonStyle buttonBasicStyle = ElevatedButton.styleFrom(
      primary: Colors.cyan,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      textStyle: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold));
}
