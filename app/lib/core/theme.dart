import 'package:flutter/material.dart';

// Brand palette (kept in sync with web/app/globals.css).
const kBrand = Color(0xFF0B6B3A); // deep green
const kBrandInk = Color(0xFF08512C);
const kAmber = Color(0xFFF4A300); // hazard amber
const kBg = Color(0xFFF6F7F9);
const kLine = Color(0xFFE3E8EE);

ThemeData joharTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: kBrand,
    primary: kBrand,
    secondary: kAmber,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: kBg,
    appBarTheme: const AppBarTheme(
      backgroundColor: kBrand,
      foregroundColor: Colors.white,
      centerTitle: false,
      elevation: 0,
    ),
    // Large touch targets + big type for accessibility / low-literacy users.
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: kBrand,
        minimumSize: const Size.fromHeight(54),
        textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(50),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
  );
}
