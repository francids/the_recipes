import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TheRecipeAppTheme {
  static ColorScheme colorScheme = ColorScheme.fromSwatch(
    primarySwatch: Colors.deepOrange,
  );

  static TextTheme textTheme = GoogleFonts.openSansTextTheme(
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
