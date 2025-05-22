import 'package:flutter/material.dart';

class AppTheme {
  // Color constants - now used in both light and dark themes
  static const Color primaryBackground = Color(0xFFF7F4ED); // Light background
  static const Color primaryColor = Color(0xFF5D7A6C); // Sage green
  static const Color secondaryColor = Color(0xFFA3B899); // Muted green
  static const Color accentColor = Color(0xFFE57A44); // Warm peach/orange
  static const Color textColor = Color(0xFF333333); // Dark gray text

  // Dark mode colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkTextColor = Color(0xFFEAEAEA);

  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: primaryBackground,
    primaryColor: primaryColor,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: accentColor,
      surface: Colors.white,
      background: primaryBackground,
      onBackground: textColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      secondaryContainer: Color(0xFFFCC42A),
      surfaceVariant: Colors.grey.shade200,
      tertiaryContainer: Colors.orangeAccent,
      primaryContainer: primaryColor.withOpacity(0.8),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    textTheme: TextTheme(
      bodyMedium: TextStyle(fontSize: 16, color: textColor),
      bodyLarge: TextStyle(fontSize: 18, color: textColor),
      titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBackground,
    primaryColor: primaryColor,
    colorScheme: ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: accentColor,
      surface: Color(0xFF1E1E1E),
      background: darkBackground,
      onBackground: darkTextColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      secondaryContainer: Color(0xFF6C4C0F),
      surfaceVariant: Colors.grey.shade800,
      tertiaryContainer: Colors.deepOrange,
      primaryContainer: primaryColor.withOpacity(0.7),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: darkTextColor),
      iconTheme: IconThemeData(color: darkTextColor),
    ),
    textTheme: TextTheme(
      bodyMedium: TextStyle(fontSize: 16, color: darkTextColor),
      bodyLarge: TextStyle(fontSize: 18, color: darkTextColor),
      titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: darkTextColor),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),
  );
}