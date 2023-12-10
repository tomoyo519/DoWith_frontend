// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class AppTheme {
  static final AppTheme _inst = AppTheme._internal();
  AppTheme._internal();

  static String FONT_FAMILY = 'NanumSquareRound';

  static Color PRI_COLOR = Colors.orange;
  static Color SEC_COLOR = Color.fromARGB(255, 133, 39, 176);
  static Color TER_COLOR = Color.fromARGB(255, 65, 204, 229);

  static ThemeData getapptheme() {
    return ThemeData(
      useMaterial3: true,
      fontFamily: FONT_FAMILY,
      scaffoldBackgroundColor: Colors.white,
      textTheme: TextTheme(
        bodySmall: TextStyle(fontSize: 14, color: Colors.black87),
        bodyMedium: TextStyle(fontSize: 14, color: Colors.black87),
        bodyLarge: TextStyle(fontSize: 14, color: Colors.black87),
      ),
      appBarTheme: AppBarTheme(
        titleTextStyle: TextStyle(
          fontFamily: FONT_FAMILY,
          color: Colors.black,
          fontSize: 25,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
