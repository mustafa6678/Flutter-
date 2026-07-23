import 'package:flutter/material.dart';

/// The black & gold palette shared by both light and dark themes. Only the
/// backgrounds/surfaces shift between modes — gold stays gold.
class AppColors {
  AppColors._();

  // Gold family
  static const Color gold = Color(0xFFD4AF37);
  static const Color goldBright = Color(0xFFF5D576);
  static const Color goldDeep = Color(0xFFA37E2C);

  // Black / near-black family
  static const Color black = Color(0xFF0A0A0A);
  static const Color charcoal = Color(0xFF1B1B1B);
  static const Color slate = Color(0xFF2A2A2A);

  // Light-mode surfaces (cream, not pure white — keeps the "premium" feel)
  static const Color cream = Color(0xFFFBF7EE);
  static const Color creamCard = Color(0xFFFFFFFF);
  static const Color creamBorder = Color(0xFFE8DFC8);

  // Status colors
  static const Color success = Color(0xFF3FA34D);
  static const Color danger = Color(0xFFD64545);

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [goldBright, gold, goldDeep],
  );

  static const LinearGradient darkBackgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF141414), black],
  );

  static const LinearGradient lightBackgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFFDF6), cream],
  );
}
