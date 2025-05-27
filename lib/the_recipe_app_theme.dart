import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:google_fonts/google_fonts.dart";

class TheRecipeAppTheme {
  static ThemeData theme = getTheme(false);
  static ThemeData darkTheme = getTheme(true);

  static ThemeData getTheme(bool isDark) {
    return ThemeData(
      textTheme: _getTextTheme(isDark),
      dividerTheme: _dividerTheme(isDark),
      colorScheme: isDark ? _darkColorScheme : _colorScheme,
      appBarTheme: _getAppBarTheme(isDark),
      floatingActionButtonTheme: _floatingActionButtonThemeData(isDark),
      filledButtonTheme: _filledButtonTheme,
      brightness: isDark ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      splashColor: Colors.deepOrange.withAlpha(32),
      highlightColor: Colors.deepOrange.withAlpha(32),
      useMaterial3: true,
      popupMenuTheme: _popupMenuTheme(isDark),
    );
  }

  static DividerThemeData _dividerTheme(bool isDark) => DividerThemeData(
        color: isDark ? Colors.white30 : Colors.black26,
        thickness: 0.5,
        space: 0.5,
      );

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
    return GoogleFonts.montserratTextTheme(
      TextTheme(
        displayLarge: TextStyle(
          color: isDark ? Colors.white : Colors.black,
          fontSize: 28,
          fontWeight: FontWeight.w600,
        ),
        displayMedium: TextStyle(
          color: isDark ? Colors.white : Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        bodyMedium: TextStyle(
          color: isDark ? Colors.white70 : Colors.black87,
          fontSize: 13,
        ),
        bodySmall: TextStyle(
          color: isDark ? Colors.white60 : Colors.black54,
          fontSize: 12,
        ),
      ),
    );
  }

  static PopupMenuThemeData _popupMenuTheme(bool isDark) {
    return PopupMenuThemeData(
      color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
      textStyle: TextStyle(
        color: isDark ? Colors.white : Colors.black87,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: isDark ? Colors.white30 : Colors.black26,
          width: 0.5,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
      ),
      elevation: 2,
    );
  }
}
