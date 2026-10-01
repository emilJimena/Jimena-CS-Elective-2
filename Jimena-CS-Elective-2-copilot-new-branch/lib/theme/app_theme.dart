import 'package:flutter/material.dart';

// Centralized design system so colors, typography, and controls stay consistent.
class AppTheme {
  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFFDC3545),
      brightness: brightness,
    );

    return ThemeData(
      colorScheme: scheme,
      brightness: brightness,
      scaffoldBackgroundColor: isDark
          ? const Color(0xFF1D1F23)
          : const Color(0xFFF3F4F6),
      appBarTheme: AppBarTheme(
        backgroundColor: isDark
            ? const Color(0xFF161719)
            : const Color(0xFF202123),
        foregroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 42,
      ),
      cardTheme: CardThemeData(
        color: isDark ? const Color(0xFF292C31) : Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontWeight: FontWeight.w700),
        headlineSmall: TextStyle(fontWeight: FontWeight.w700),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(7)),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
    );
  }
}
