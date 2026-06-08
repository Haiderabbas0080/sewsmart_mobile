import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Background
  static const bg       = Color(0xFF0A0812);
  static const surface  = Color(0xFF120F22);
  static const card     = Color(0xFF1C1535);
  static const cardAlt  = Color(0xFF241D42);
  static const divider  = Color(0xFF2D2550);
  // Brand
  static const primary      = Color(0xFF7C3AED);
  static const primaryLight = Color(0xFF9D5CF6);
  static const teal         = Color(0xFF0D9488);
  static const tealLight    = Color(0xFF14B8A6);
  static const secondary    = Color(0xFFBE185D);
  static const gold         = Color(0xFFEAB308);
  // Role colours
  static const customerColor = Color(0xFF7C3AED);
  static const tailorColor   = Color(0xFF0D9488);
  static const riderColor    = Color(0xFFEA580C);
  // Status
  static const success = Color(0xFF22C55E);
  static const warning = Color(0xFFF59E0B);
  static const error   = Color(0xFFEF4444);
  static const info    = Color(0xFF3B82F6);
  // Text
  static const textPrimary   = Color(0xFFF8F7FF);
  static const textSecondary = Color(0xFFB0A8CC);
  static const textMuted     = Color(0xFF6B6088);
  // Orbs
  static const purpleOrb = Color(0x886B21A8);
  static const pinkOrb   = Color(0x88831843);
  static const tealOrb   = Color(0x880F766E);
  static const orangeOrb = Color(0x88923408);
}

class AppTheme {
  static ThemeData get dark => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.bg,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary, secondary: AppColors.teal,
      surface: AppColors.surface, error: AppColors.error,
    ),
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme).copyWith(
      headlineLarge: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 26),
      headlineMedium: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 20),
      titleLarge: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 17),
      titleMedium: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.w500, fontSize: 15),
      bodyLarge: GoogleFonts.poppins(color: AppColors.textPrimary, fontSize: 14),
      bodyMedium: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 13),
      bodySmall: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 11),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent, elevation: 0,
      titleTextStyle: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 18),
      iconTheme: const IconThemeData(color: AppColors.textPrimary),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true, fillColor: AppColors.card,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.divider)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
      hintStyle: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 13),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary, foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(vertical: 14),
      textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14),
    )),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.surface, selectedItemColor: AppColors.primaryLight,
      unselectedItemColor: AppColors.textMuted, type: BottomNavigationBarType.fixed, elevation: 0,
    ),
  );
}
