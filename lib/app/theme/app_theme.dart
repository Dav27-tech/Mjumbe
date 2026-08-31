import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryNeutral = Color(0xFF1A1A1A); // Noir profond
  static const Color secondaryNeutral = Color(0xFF757575); // Gris neutre
  static const Color backgroundLight = Color(0xFFFDFDFD); // Fond très clair
  static const Color surfaceLight = Color(0xFFFFFFFF); // Blanc pur
  static const Color borderLight = Color(0xFFEEEEEE); // Bordure légère

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: backgroundLight,
      colorScheme: const ColorScheme.light(
        primary: primaryNeutral,
        secondary: secondaryNeutral,
        surface: surfaceLight,
        onSurface: primaryNeutral,
        onPrimary: surfaceLight,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundLight,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: primaryNeutral),
        titleTextStyle: TextStyle(
          color: primaryNeutral,
          fontSize: 22,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.0,
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceLight,
        elevation: 2,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: borderLight),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade50,
        hintStyle: const TextStyle(color: secondaryNeutral, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryNeutral, width: 1.5),
        ),
      ),
      textTheme: const TextTheme(
        headlineSmall: TextStyle(
          color: primaryNeutral,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(color: primaryNeutral),
        bodyMedium: TextStyle(color: secondaryNeutral),
      ),
    );
  }
}
