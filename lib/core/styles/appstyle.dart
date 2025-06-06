import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppStyle {
  static const Color mainColor = Colors.white;
  static const Color mainBackground = Color(0xFF0B0B0E);

  static ThemeData theme = ThemeData.dark().copyWith(
    primaryColor: Colors.greenAccent,
    scaffoldBackgroundColor: const Color(0xFF121212),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.greenAccent,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    ),
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
  );
}
