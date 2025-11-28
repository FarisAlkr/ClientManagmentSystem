import 'package:flutter/material.dart';

class AppTheme {
  // Two-Color System: Blue as primary, Neutral as secondary
  // Primary Blue Palette
  static const Color primaryBlue = Color(0xFF2563EB);      // Main blue
  static const Color primaryBlueLight = Color(0xFF3B82F6); // Light blue
  static const Color primaryBlueLighter = Color(0xFF60A5FA); // Lighter blue
  static const Color primaryBlueDark = Color(0xFF1D4ED8);   // Dark blue
  static const Color primaryBlueDarker = Color(0xFF1E40AF); // Darker blue

  // Secondary Neutral Palette (blue-tinted grays)
  static const Color neutralLight = Color(0xFFF8FAFC);      // Very light blue-gray
  static const Color neutral = Color(0xFF64748B);           // Medium blue-gray
  static const Color neutralDark = Color(0xFF475569);       // Dark blue-gray
  static const Color neutralDarker = Color(0xFF334155);     // Darker blue-gray

  // Functional colors (blue-based)
  static const Color success = Color(0xFF059669);          // Blue-green
  static const Color warning = Color(0xFF0891B2);          // Blue-cyan
  static const Color error = Color(0xFFDC2626);            // Keep red for errors
  static const Color info = primaryBlueLight;              // Use our light blue

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: primaryBlue,
        primaryContainer: Color(0xFFDBEAFE),
        secondary: neutral,
        secondaryContainer: neutralLight,
        surface: Colors.white,
        background: neutralLight,
        error: error,
        onPrimary: Colors.white,
        onPrimaryContainer: primaryBlueDarker,
        onSecondary: Colors.white,
        onSecondaryContainer: neutralDarker,
        onSurface: neutralDarker,
        onBackground: neutralDarker,
        onError: Colors.white,
        outline: Color(0xFFCBD5E1),
        surfaceVariant: Color(0xFFF1F5F9),
        onSurfaceVariant: neutral,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: neutralDarker,
        titleTextStyle: TextStyle(
          color: neutralDarker,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: neutralDarker),
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        color: Colors.white,
        shadowColor: primaryBlue.withOpacity(0.1),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xFFE2E8F0),
          disabledForegroundColor: neutral,
          elevation: 1,
          shadowColor: primaryBlue.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryBlue,
          disabledForegroundColor: neutral,
          side: const BorderSide(color: primaryBlue),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryBlue,
          disabledForegroundColor: neutral,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: neutralLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryBlue, width: 2),
        ),
        labelStyle: const TextStyle(color: neutral),
        hintStyle: const TextStyle(color: neutral),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return primaryBlue;
          }
          return Colors.transparent;
        }),
        checkColor: MaterialStateProperty.all(Colors.white),
        side: const BorderSide(color: Color(0xFFCBD5E1), width: 2),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return primaryBlue;
          }
          return neutral;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return primaryBlueLight;
          }
          return const Color(0xFFE2E8F0);
        }),
      ),
    );
  }

  // Accent colors
  static const Color accentBlue = Color(0xFF60A5FA);  // For highlights in dark mode
  static const Color lightBackground = Colors.white;

  // Dark mode colors
  static const Color darkPrimaryBlue = Color(0xFF60A5FA);     // Lighter blue for dark backgrounds
  static const Color darkPrimaryBlueLight = Color(0xFF93C5FD); // Even lighter
  static const Color darkPrimaryBlueDark = Color(0xFF3B82F6);  // Medium blue
  static const Color darkBackground = Color(0xFF0F172A);       // Very dark blue-gray
  static const Color darkSurface = Color(0xFF1E293B);         // Dark blue-gray
  static const Color darkCard = Color(0xFF334155);            // Medium dark blue-gray
  static const Color darkBorder = Color(0xFF475569);          // Border blue-gray
  static const Color darkText = Color(0xFFF1F5F9);            // Light blue-tinted text
  static const Color darkTextSecondary = Color(0xFF94A3B8);   // Secondary text

  // Dark Theme - same two-color blue system adapted for dark mode
  static ThemeData get darkTheme {

    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        primary: darkPrimaryBlue,
        primaryContainer: Color(0xFF1E40AF),
        secondary: darkTextSecondary,
        secondaryContainer: darkCard,
        surface: darkSurface,
        background: darkBackground,
        error: Color(0xFFEF4444),
        onPrimary: Color(0xFF0F172A),
        onPrimaryContainer: darkPrimaryBlueLight,
        onSecondary: darkBackground,
        onSecondaryContainer: darkText,
        onSurface: darkText,
        onBackground: darkText,
        onError: Colors.white,
        outline: darkBorder,
        surfaceVariant: darkCard,
        onSurfaceVariant: darkTextSecondary,
      ),
      scaffoldBackgroundColor: darkBackground,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: darkSurface,
        foregroundColor: darkText,
        titleTextStyle: TextStyle(
          color: darkText,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: darkText),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        color: darkSurface,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkPrimaryBlue,
          foregroundColor: darkBackground,
          disabledBackgroundColor: darkCard,
          disabledForegroundColor: darkTextSecondary,
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: darkPrimaryBlue,
          disabledForegroundColor: darkTextSecondary,
          side: const BorderSide(color: darkPrimaryBlue),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: darkPrimaryBlue,
          disabledForegroundColor: darkTextSecondary,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: darkText,
          disabledForegroundColor: darkTextSecondary,
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(color: darkText, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: darkText, fontWeight: FontWeight.w600),
        headlineSmall: TextStyle(color: darkText),
        titleLarge: TextStyle(color: darkText, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(color: darkText),
        titleSmall: TextStyle(color: darkText),
        bodyLarge: TextStyle(color: darkText),
        bodyMedium: TextStyle(color: darkText),
        bodySmall: TextStyle(color: darkTextSecondary),
        labelLarge: TextStyle(color: darkText),
        labelMedium: TextStyle(color: darkTextSecondary),
        labelSmall: TextStyle(color: darkTextSecondary),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: darkPrimaryBlue,
        foregroundColor: darkBackground,
        elevation: 4,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: darkPrimaryBlue, width: 2),
        ),
        labelStyle: const TextStyle(color: darkTextSecondary),
        hintStyle: const TextStyle(color: darkTextSecondary),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: darkSurface,
        modalBackgroundColor: darkSurface,
        elevation: 8,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: darkSurface,
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        titleTextStyle: const TextStyle(
          color: darkText,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: const TextStyle(
          color: darkTextSecondary,
          fontSize: 16,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: darkCard,
        contentTextStyle: const TextStyle(color: darkText),
        actionTextColor: darkPrimaryBlue,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return darkPrimaryBlue;
          }
          return Colors.transparent;
        }),
        checkColor: MaterialStateProperty.all(darkBackground),
        side: const BorderSide(color: darkBorder, width: 2),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return darkPrimaryBlue;
          }
          return darkTextSecondary;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return darkPrimaryBlueDark;
          }
          return darkCard;
        }),
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: darkPrimaryBlue,
        unselectedLabelColor: darkTextSecondary,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: darkPrimaryBlue, width: 2),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: darkBorder,
        thickness: 1,
      ),
      listTileTheme: const ListTileThemeData(
        textColor: darkText,
        iconColor: darkTextSecondary,
        selectedColor: darkPrimaryBlue,
        selectedTileColor: Color(0xFF1E40AF),
      ),
    );
  }

  // Status colors using our blue system
  static const Color notDoneColor = neutral;           // Use our neutral gray
  static const Color notDoneSecondaryColor = error;    // Keep red for errors
  static const Color doneColor = success;              // Use our blue-green success

  // Helper method to get theme-appropriate colors
  static Color getSuccessColor(bool isDark) => isDark ? success : success;
  static Color getWarningColor(bool isDark) => isDark ? warning : warning;
  static Color getErrorColor(bool isDark) => isDark ? error : error;
  static Color getInfoColor(bool isDark) => isDark ? primaryBlueLighter : primaryBlue;
}