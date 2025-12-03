// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData light() {
    final comicNeue = GoogleFonts.comicNeueTextTheme();

    return ThemeData(
      primaryColor: const Color(0xFF3F8CFF), // A playful blue
      scaffoldBackgroundColor: const Color(0xFFF0F8FF), // Light, clean background
      fontFamily: GoogleFonts.comicNeue().fontFamily,

      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF3F8CFF),
        elevation: 0, // Let's use gradients in pages, not here
        foregroundColor: Colors.white,
        titleTextStyle: GoogleFonts.comicNeue(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),

      // Text Theme
      textTheme: comicNeue.copyWith(
        displayLarge: comicNeue.displayLarge?.copyWith(fontSize: 48, fontWeight: FontWeight.bold, color: const Color(0xFF3F8CFF)),
        displayMedium: comicNeue.displayMedium?.copyWith(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
        bodyLarge: comicNeue.bodyLarge?.copyWith(fontSize: 18),
        bodyMedium: comicNeue.bodyMedium?.copyWith(fontSize: 16),
        labelLarge: comicNeue.labelLarge?.copyWith(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        titleLarge: comicNeue.titleLarge?.copyWith(fontSize: 22, fontWeight: FontWeight.w800, color: const Color(0xFF333333)), // For panel titles
      ),

      // Card Theme for 3D Cards
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        margin: const EdgeInsets.all(8),
      ),

      // ElevatedButton Theme for future buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFC94F), // Bright yellow
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          textStyle: GoogleFonts.comicNeue(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
