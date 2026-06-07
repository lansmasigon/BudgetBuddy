import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color em = Color(0xFF10b981);
  static const Color emDk = Color(0xFF059669);
  static const Color emLt = Color(0xFFd1fae5);
  static const Color emXlt = Color(0xFFecfdf5);
  static const Color navy = Color(0xFF1e3a5f);
  static const Color backgroundLight = Color(0xFFf6faf8);
  static const Color textDark = Color(0xFF111827);
  static const Color textMuted = Color(0xFF6b7280);

  static const Color red = Color(0xFFef4444);
  static const Color amber = Color(0xFFf59e0b);

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
