import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Centralized theme configuration for the application.
///
/// Currently exposes a single dark theme via [dark].
class AppTheme {
  /// Private constructor to prevent instantiation.
  AppTheme._();

  static const Color _primary = Color(0xFF64F6FF);
  static const Color _bg = Color(0xFF090E15);
  static const Color _text = Color(0xFFF8FAFC);
  static const Color _muted = Color(0xFF94A3B8);
  static const Color _inputFill = Color(0xFF1E293B);

  /// Returns the dark [ThemeData] used by the app.
  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: _primary,
      scaffoldBackgroundColor: _bg,
      appBarTheme: const AppBarTheme(
        backgroundColor: _bg,
        foregroundColor: _text,
        elevation: 0,
        centerTitle: true,
      ),

      textTheme: TextTheme(
        headlineLarge: GoogleFonts.jetBrainsMono(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          color: _text,
        ),
        titleMedium: GoogleFonts.jetBrainsMono(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: _primary,
        ),
        bodyMedium: GoogleFonts.robotoMono(fontSize: 14, color: _muted),
        bodySmall: GoogleFonts.roboto(
          fontSize: 12,
          color: _muted,
          letterSpacing: 1.6,
        ),
      ),

      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: _inputFill,
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: _primary),
        ),
        labelStyle: TextStyle(color: _primary),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primary,
          foregroundColor: _bg,
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
