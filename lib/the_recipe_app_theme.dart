import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TheRecipeAppTheme {
  static ColorScheme colorScheme = ColorScheme.fromSwatch(
    primarySwatch: Colors.deepOrange,
  );

  static TextTheme textTheme = GoogleFonts.openSansTextTheme(
    const TextTheme(
      displayMedium: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      bodyMedium: TextStyle(
        color: Colors.black54,
        fontSize: 13,
      ),
    ),
  );
}
