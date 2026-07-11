import 'package:flutter/material.dart';

class AppTheme {
  // Color Palette — Rose Gold Luxury
  static const Color primary = Color(0xFFB5736A); // dusty rose
  static const Color primaryDark = Color(0xFF8B4A43); // deep rose
  static const Color primaryLight = Color(0xFFE8C4BE); // blush
  static const Color accent = Color(0xFFD4AF7A); // gold
  static const Color accentLight = Color(0xFFF5E6CC); // champagne
  static const Color bg = Color(0xFFFDF8F5); // warm white
  static const Color bgCard = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF2C1810); // espresso
  static const Color textMid = Color(0xFF6B4C44);
  static const Color textLight = Color(0xFF9E7B74);
  static const Color surface = Color(0xFFF9F0EC);
  static const Color divider = Color(0xFFEDD5CE);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Georgia',
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: accent,
        surface: bgCard,
        background: bg,
        onPrimary: Colors.white,
        onSecondary: textDark,
        onSurface: textDark,
        onBackground: textDark,
      ),
      scaffoldBackgroundColor: bg,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: textDark),
        titleTextStyle: TextStyle(
          fontFamily: 'Georgia',
          color: textDark,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          textStyle: const TextStyle(
            fontFamily: 'Georgia',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: bgCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: divider, width: 1),
        ),
      ),
    );
  }
}
