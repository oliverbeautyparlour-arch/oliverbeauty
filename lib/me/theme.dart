import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFFE91E63);
  static const softPink = Color(0xFFF8BBD0);
  static const lightBlush = Color(0xFFFDE4EC);

  static const accent = Color(0xFFD81B60);
  static const button = Color(0xFFC2185B);
  static const highlight = Color(0xFFFF4081);

  static const white = Colors.white;
  static const textDark = Color(0xFF333333);
  static const textLight = Color(0xFF777777);
  static const border = Color(0xFFE0E0E0);
  static const back = Color(0xFFEBC2C5);
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.white,
    fontFamily: 'Poppins',

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      elevation: 0,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.button,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.border),
      ),
    ),
  );
}
