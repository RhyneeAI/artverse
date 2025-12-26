import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // 🎨 COLORS
  static const Color primary = Color(0xFF0DA7ED);
  static const Color background = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1C1C1E);
  static const Color textSecondary = Color(0xFF6E6E73);
  static const Color border = Color(0xFFE5E5EA);
  static const Color iconInactive = Color(0xFFB0B0B5);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: background,
    primaryColor: primary,

    colorScheme: const ColorScheme.light(
      primary: primary,
      background: background,
      surface: background,
    ),

    // 📝 TEXT THEME — GOOGLE FONTS POPPINS
    textTheme: GoogleFonts.poppinsTextTheme(
      const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        labelLarge: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: primary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textPrimary,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: textSecondary,
        ),
      ),
    ),

    // 🔍 SEARCH BAR
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primary),
      ),
      hintStyle: GoogleFonts.poppins(
        fontSize: 14,
        color: textSecondary,
      ),
    ),

    // 🧭 BOTTOM NAV
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: primary,
      unselectedItemColor: iconInactive,
      selectedLabelStyle: GoogleFonts.poppins(
        fontSize: 11,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: GoogleFonts.poppins(
        fontSize: 11,
        fontWeight: FontWeight.w500,
      ),
      type: BottomNavigationBarType.fixed,
    ),
  );
}
