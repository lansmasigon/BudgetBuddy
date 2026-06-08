import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color emerald50 = Color(0xFFecfdf5);
  static const Color emerald100 = Color(0xFFd1fae5);
  static const Color emerald500 = Color(0xFF10b981);
  static const Color emerald600 = Color(0xFF059669);
  static const Color emerald700 = Color(0xFF047857);
  static const Color emerald900 = Color(0xFF064e3b);
  
  static const Color gray200 = Color(0xFFe5e7eb);
  static const Color gray300 = Color(0xFFD1D5DB);
  static const Color gray400 = Color(0xFF9ca3af);
  static const Color gray500 = Color(0xFF6b7280);
  static const Color gray800 = Color(0xFF1f2937);
  static const Color gray900 = Color(0xFF111827);
  static const Color gray600 = Color(0xFF4B5563);
  
  static const Color darkBg = Color(0xFF121212);
  static const Color darkCard = Color(0xFF1e1e1e);
  static const Color white = Colors.white;
  
  static const Color red500 = Color(0xFFef4444);
  static const Color amber400 = Color(0xFFfbbf24);
  static const Color amber500 = Color(0xFFf59e0b);
  static const Color blue600 = Color(0xFF2563eb);
  static const Color purple600 = Color(0xFF7c3aed);
  static const Color navy500 = Color(0xFF1e3a8a);
}

class AppTheme {
  static const Color em = AppColors.emerald500;
  static const Color emDk = AppColors.emerald600;
  static const Color emLt = AppColors.emerald100;
  static const Color emXlt = AppColors.emerald50;
  static const Color navy = AppColors.navy500;
  static const Color backgroundLight = Color(0xFFf6faf8);
  static const Color textDark = AppColors.gray900;
  static const Color textMuted = AppColors.gray500;

  static const Color red = AppColors.red500;
  static const Color amber = AppColors.amber500;

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: em,
        primary: em,
        secondary: navy,
        background: backgroundLight,
        error: red,
      ),
      scaffoldBackgroundColor: backgroundLight,
      textTheme: GoogleFonts.dmSansTextTheme().apply(
        bodyColor: textDark,
        displayColor: textDark,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundLight,
        foregroundColor: textDark,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.dmSerifDisplay(
          color: textDark,
          fontSize: 24,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: Color(0x1E10B981)), // border rgba(16,185,129,0.12) roughly
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    // Basic dark theme placeholder using similar accent colors
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: em,
        brightness: Brightness.dark,
        primary: em,
        secondary: navy,
      ),
      textTheme: GoogleFonts.dmSansTextTheme(ThemeData.dark().textTheme),
    );
  }
}
