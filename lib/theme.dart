import 'package:flutter/material.dart';

class MobiCraftTheme {
  static const Color orange = Color(0xFFF4651C);
  static const Color teal = Color(0xFF1ABEAD);
  static const Color navy = Color(0xFF0E2C38);
  static const Color cream = Color(0xFFFEFDF5);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: orange,
      secondary: teal,
      background: cream,
      surface: cream,
      onPrimary: cream,
      onSecondary: navy,
      onBackground: navy,
      onSurface: navy,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: cream,
      foregroundColor: navy,
      elevation: 0,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: orange,
      foregroundColor: cream,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: orange,
        foregroundColor: cream,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: teal,
      ),
    ),
    iconTheme: IconThemeData(
      color: navy,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.dark(
      primary: orange,
      secondary: teal,
      background: navy,
      surface: navy,
      onPrimary: cream,
      onSecondary: cream,
      onBackground: cream,
      onSurface: cream,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: navy,
      foregroundColor: cream,
      elevation: 0,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: orange,
      foregroundColor: cream,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: orange,
        foregroundColor: cream,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: teal,
      ),
    ),
    iconTheme: IconThemeData(
      color: cream,
    ),
  );
}
