import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF2F4156);       // Teal
  static const Color secondary = Color(0xFFF5EFE8);     // Beige
  static const Color background = Color(0xFFC8D9E6);    // Sky Blue
  static const Color accentIcon = Color(0xFF6C8EBF);    // Example blue shade for icons
  static const Color chartDivider = Color(0xFFB0BEC5);  // Light grey for chart dividers
}

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    hintColor: AppColors.primary,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
    ),
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      background: AppColors.background,
    ),
    // Add more theming as needed
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: Colors.black,
    hintColor: AppColors.secondary,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
    ),
    colorScheme: ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      background: Colors.black,
    ),
    // Add more theming as needed
  );
}
