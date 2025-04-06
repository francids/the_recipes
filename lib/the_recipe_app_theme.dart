import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:google_fonts/google_fonts.dart";

class TheRecipeAppTheme {
  static ThemeData theme = getTheme(false);
  static ThemeData darkTheme = getTheme(true);

  static ThemeData getTheme(bool isDark) {
    return ThemeData(
      textTheme: _getTextTheme(isDark),
      colorScheme: isDark ? _darkColorScheme : _colorScheme,
      appBarTheme: _getAppBarTheme(isDark),
      floatingActionButtonTheme: _floatingActionButtonThemeData(isDark),
      filledButtonTheme: _filledButtonTheme,
      brightness: isDark ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      splashColor: Colors.deepOrange.withAlpha(32),
      highlightColor: Colors.deepOrange.withAlpha(32),
      useMaterial3: true,
    );
  }

  static FilledButtonThemeData _filledButtonTheme = const FilledButtonThemeData(
    style: ButtonStyle(
      textStyle: WidgetStatePropertyAll(
        TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: WidgetStatePropertyAll(Colors.deepOrange),
      foregroundColor: WidgetStatePropertyAll(Colors.white),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
      ),
    ),
  );

  static AppBarTheme _getAppBarTheme(bool isDark) {
    return AppBarTheme(
      centerTitle: true,
      systemOverlayStyle: isDark
          ? const SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.dark,
            )
          : const SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.light,
            ),
      backgroundColor: Colors.transparent,
      foregroundColor: isDark ? Colors.white : Colors.black,
      shadowColor: Colors.transparent,
      elevation: 0,
    );
  }

  static FloatingActionButtonThemeData _floatingActionButtonThemeData(
      bool isDark) {
    return FloatingActionButtonThemeData(
      backgroundColor: Colors.deepOrange,
      foregroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
    );
  }

  static ColorScheme _colorScheme = ColorScheme.fromSeed(
    seedColor: Colors.deepOrange,
    primary: Colors.deepOrange,
    secondary: Colors.deepOrange,
    surface: Colors.white,
    error: Colors.red,
    brightness: Brightness.light,
  );

  static ColorScheme _darkColorScheme = ColorScheme.fromSeed(
    seedColor: Colors.deepOrange,
    primary: Colors.deepOrange,
    secondary: Colors.deepOrange,
    surface: const Color(0xFF1E1E1E),
    error: Colors.red,
    brightness: Brightness.dark,
  );

  static TextTheme _getTextTheme(bool isDark) {
    return GoogleFonts.openSansTextTheme(
      TextTheme(
        displayLarge: TextStyle(
          color: isDark ? Colors.white : Colors.black,
          fontSize: 23,
          fontWeight: FontWeight.w600,
        ),
        displayMedium: TextStyle(
          color: isDark ? Colors.white : Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        bodyMedium: TextStyle(
          color: isDark ? Colors.white70 : Colors.black54,
          fontSize: 13,
        ),
      ),
    );
  }
}
