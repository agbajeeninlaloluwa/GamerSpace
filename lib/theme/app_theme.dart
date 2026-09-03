
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const _primary = Color(0xFF7C4DFF);
  static const _secondary = Color(0xFF00E5FF);
  static const _bg = Color(0xFF0A0A12);
  static const _surface = Color(0xFF16162A);
  static const _card = Color(0xFF1E1E38);

  static ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: _bg,
    colorScheme: ColorScheme.dark(
      primary: _primary,
      secondary: _secondary,
      surface: _surface,
      background: _bg,
    ),
    textTheme: GoogleFonts.spaceGroteskTextTheme(ThemeData.dark().textTheme),
    cardTheme: CardThemeData(
      color: _card,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );
}
