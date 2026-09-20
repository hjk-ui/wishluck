import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // WishLuck Brand Colors
  static const Color primaryBlue = Color(0xFF007AFF); // Electric Royal Blue
  static const Color primaryDarkBlue = Color(0xFF0056B3);
  static const Color primaryLightBlue = Color(0xFFEBF5FF);

  static const Color accentYellow = Color(0xFFFED716); // Sunshine Yellow
  static const Color accentOrange = Color(0xFFFF9F00); // Warm Amber
  static const Color saleRed = Color(0xFFFF3B30); // Vibrant Discount Red
  static const Color freshGreen = Color(
    0xFF10B981,
  ); // Free delivery & savings green
  static const Color pastelCyan = Color(0xFFD9F9FA); // Soft pastel banner cyan

  static const Color background = Color(
    0xFFF8FAFC,
  ); // Ultra clean light grey-white
  static const Color surface = Color(0xFFFFFFFF); // Pure Card White
  static const Color textPrimary = Color(0xFF0F172A); // Slate 900
  static const Color textSecondary = Color(0xFF64748B); // Slate 500
  static const Color textLight = Color(0xFF94A3B8); // Slate 400
  static const Color borderSubtle = Color(0xFFE2E8F0); // Slate 200

  // Gokwik Brand Green / Blue for checkout
  static const Color gokwikBlue = Color(0xFF007AFF);
  static const Color gokwikGreen = Color(0xFF059669);

  // Box Shadows
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.04),
      offset: const Offset(0, 4),
      blurRadius: 12,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.02),
      offset: const Offset(0, 1),
      blurRadius: 4,
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> elevatedShadow = [
    BoxShadow(
      color: primaryBlue.withValues(alpha: 0.25),
      offset: const Offset(0, 6),
      blurRadius: 16,
      spreadRadius: 0,
    ),
  ];

  // Theme Data
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      primaryColor: primaryBlue,
      colorScheme: const ColorScheme.light(
        primary: primaryBlue,
        secondary: accentYellow,
        surface: surface,
        error: saleRed,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: textPrimary,
      ),
      textTheme: GoogleFonts.outfitTextTheme().apply(
        bodyColor: textPrimary,
        displayColor: textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 1,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: textPrimary),
      ),
    );
  }
}
