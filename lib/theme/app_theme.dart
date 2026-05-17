import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const navy = Color(0xFF0B1628);
  static const navy2 = Color(0xFF121E34);
  static const navy3 = Color(0xFF182742);
  static const teal = Color(0xFF00D4AA);
  static const amber = Color(0xFFFFB930);
  static const red = Color(0xFFFF4D6D);
  static const blue = Color(0xFF4C8EFF);
  static const muted = Color(0xFF9FB3CE);
  static const text = Color(0xFFF0F4FA);
  static const text2 = Color(0xFFC8D6E5);
  static const border = Color(0xFF1E3456);
}

class AppText {
  static TextStyle dm({
    double size = 14,
    Color color = AppColors.text,
    FontWeight weight = FontWeight.w400,
  }) {
    return GoogleFonts.dmSans(
      fontSize: size,
      color: color,
      fontWeight: weight,
    );
  }

  static TextStyle syne({
    double size = 14,
    Color color = AppColors.text,
    FontWeight weight = FontWeight.w700,
  }) {
    return GoogleFonts.syne(
      fontSize: size,
      color: color,
      fontWeight: weight,
    );
  }

  static TextStyle mono({
    double size = 12,
    Color color = AppColors.text2,
    FontWeight weight = FontWeight.w400,
  }) {
    return GoogleFonts.spaceMono(
      fontSize: size,
      color: color,
      fontWeight: weight,
    );
  }
}

class AppTheme {
  static ThemeData get dark => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.navy,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.teal,
      secondary: AppColors.blue,
      surface: AppColors.navy2,
      error: AppColors.red,
    ),
    textTheme: TextTheme(
      headlineSmall: AppText.syne(size: 20),
      titleMedium: AppText.dm(size: 16, weight: FontWeight.w600),
      bodyMedium: AppText.dm(size: 14),
      bodySmall: AppText.dm(size: 12, color: AppColors.muted),
      labelSmall: AppText.mono(size: 11),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.navy,
    ),
  );
}
