import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:google_fonts/google_fonts.dart";

class TheRecipeAppTheme {
  static ThemeData theme = ThemeData(
    textTheme: _textTheme,
    colorScheme: _colorScheme,
    appBarTheme: _appBarTheme,
    filledButtonTheme: _filledButtonTheme,
    useMaterial3: false,
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

  static AppBarTheme _appBarTheme = const AppBarTheme(
    centerTitle: true,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark, // Dark icons for Android
      statusBarBrightness: Brightness.light, // Dark icons for iOS
    ),
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.black,
    shadowColor: Colors.transparent,
  );

  static ColorScheme _colorScheme = ColorScheme.fromSeed(
    seedColor: Colors.deepOrange,
    primary: Colors.deepOrange,
    secondary: Colors.deepOrange,
    surface: Colors.white,
    error: Colors.red,
    brightness: Brightness.light,
  );

  static TextTheme _textTheme = GoogleFonts.openSansTextTheme(
    const TextTheme(
      displayLarge: TextStyle(
        color: Colors.black,
        fontSize: 23,
        fontWeight: FontWeight.w600,
      ),
      displayMedium: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
      bodyMedium: TextStyle(
        color: Colors.black54,
        fontSize: 13,
      ),
    ),
  );
}
