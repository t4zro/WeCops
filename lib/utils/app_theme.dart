import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFFFF6B6B);
  static const Color secondary = Color(0xFFFF477E);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    primaryColor: primary,
    colorScheme: ColorScheme.fromSeed(seedColor: primary),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      centerTitle: true,
      elevation: 0,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primary,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.dark,
    ),
  );
}
