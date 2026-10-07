import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Deep OLED Dark Palette
  static const Color background = Color(0xFF09090B);
  static const Color surface = Color(0xFF141416);
  static const Color card = Color(0xFF1C1C1E);
  static const Color cardHover = Color(0xFF26262A);
  static const Color border = Color(0x1FFFFFFF);
  static const Color borderLight = Color(0x33FFFFFF);

  // Amber Accent Palette
  static const Color primaryOrange = Color(0xFFFF9500);
  static const Color primaryOrangeHover = Color(0xFFE08300);
  static const Color orangeSoft = Color(0x26FF9500);

  // Semantics & Status
  static const Color green = Color(0xFF34C759);
  static const Color blue = Color(0xFF0A84FF);
  static const Color red = Color(0xFFFF453A);
  static const Color textPrimary = Color(0xFFF4F4F5);
  static const Color textSecondary = Color(0xFFA1A1AA);
  static const Color textMuted = Color(0xFF71717A);
}

class AppTheme {
  // Color Aliases for convenient access
  static const Color bgOled = AppColors.background;
  static const Color cardOled = AppColors.card;
  static const Color amberOrange = AppColors.primaryOrange;
  static const Color borderSubtle = AppColors.border;
  static const Color textPrimary = AppColors.textPrimary;
  static const Color textSecondary = AppColors.textSecondary;
  static const Color textMuted = AppColors.textMuted;

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primaryOrange,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryOrange,
        surface: AppColors.card,
        onPrimary: Colors.black,
        onSurface: AppColors.textPrimary,
      ),
      textTheme: TextTheme(
        headlineLarge: GoogleFonts.instrumentSerif(
          fontSize: 38,
          fontWeight: FontWeight.normal,
          color: AppColors.textPrimary,
        ),
        headlineMedium: GoogleFonts.plusJakartaSans(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        titleMedium: GoogleFonts.plusJakartaSans(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        bodyLarge: GoogleFonts.plusJakartaSans(
          fontSize: 15,
          color: AppColors.textPrimary,
        ),
        bodyMedium: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          color: AppColors.textSecondary,
        ),
        labelLarge: GoogleFonts.plusJakartaSans(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
