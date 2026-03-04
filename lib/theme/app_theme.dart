import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors
  static const Color primaryColor = Color(0xFF6C63FF);
  static const Color secondaryColor = Color(0xFF03DAC6);
  static const Color accentOrange = Color(0xFFFF6B35);
  static const Color accentGreen = Color(0xFF4CAF50);
  static const Color accentBlue = Color(0xFF2196F3);

  // Dark Theme Colors
  static const Color darkBg = Color(0xFF0A0A0F);
  static const Color darkSurface = Color(0xFF13131A);
  static const Color darkCard = Color(0xFF1C1C27);
  static const Color darkBorder = Color(0xFF2A2A3A);

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: darkSurface,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Colors.white,
    ),
    scaffoldBackgroundColor: darkBg,
    fontFamily: 'SF Pro Display',
    appBarTheme: const AppBarTheme(
      backgroundColor: darkBg,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    cardTheme: CardThemeData(
      color: darkCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: darkBorder, width: 1),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: darkSurface,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.white38,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        elevation: 0,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkCard,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: darkBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: darkBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      labelStyle: const TextStyle(color: Colors.white60),
      hintStyle: const TextStyle(color: Colors.white30),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: darkCard,
      selectedColor: primaryColor.withOpacity(0.3),
      labelStyle: const TextStyle(color: Colors.white70),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    dividerTheme: const DividerThemeData(color: darkBorder, space: 1),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
      displayMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
      headlineLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
      headlineMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      headlineSmall: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(color: Colors.white70, fontWeight: FontWeight.w500),
      titleSmall: TextStyle(color: Colors.white60, fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(color: Colors.white70),
      bodyMedium: TextStyle(color: Colors.white60),
      bodySmall: TextStyle(color: Colors.white38),
      labelLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
    ),
  );

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
    ),
    scaffoldBackgroundColor: const Color(0xFFF6F6FF),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Color(0xFF0A0A1A),
      elevation: 0,
      centerTitle: true,
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFEEEEFF), width: 1),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        elevation: 0,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.black38,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
  );

  // Gradient helpers
  static LinearGradient get primaryGradient => const LinearGradient(
        colors: [Color(0xFF6C63FF), Color(0xFF8B80F9)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient get darkGradient => const LinearGradient(
        colors: [Color(0xFF0A0A1A), Color(0xFF13133A)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );

  static LinearGradient cardGradient(Color color) => LinearGradient(
        colors: [color.withOpacity(0.8), color.withOpacity(0.4)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  // Condition color helper
  static Color conditionColor(String condition) {
    switch (condition.toLowerCase()) {
      case 'excellent':
        return accentGreen;
      case 'good':
        return accentBlue;
      case 'fair':
        return accentOrange;
      case 'poor':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Status color helper
  static Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return accentGreen;
      case 'pending':
        return accentOrange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Difficulty color helper
  static Color difficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return accentGreen;
      case 'intermediate':
        return accentOrange;
      case 'advanced':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
