import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    final base = ThemeData.dark(useMaterial3: true);
    final textTheme = GoogleFonts.poppinsTextTheme(base.textTheme).apply(
      bodyColor: AppColors.goldBright,
      displayColor: AppColors.goldBright,
    );

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.black,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.gold,
        brightness: Brightness.dark,
      ).copyWith(
        primary: AppColors.gold,
        secondary: AppColors.goldDeep,
        surface: AppColors.charcoal,
      ),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.gold,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: 1.1,
          color: AppColors.gold,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.charcoal,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.goldDeep, width: 1),
        ),
      ),
      dividerColor: AppColors.slate,
      iconTheme: const IconThemeData(color: AppColors.gold),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.gold,
          foregroundColor: AppColors.black,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  static ThemeData get lightTheme {
    final base = ThemeData.light(useMaterial3: true);
    final textTheme = GoogleFonts.poppinsTextTheme(base.textTheme).apply(
      bodyColor: AppColors.black,
      displayColor: AppColors.black,
    );

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.cream,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.gold,
        brightness: Brightness.light,
      ).copyWith(
        primary: AppColors.goldDeep,
        secondary: AppColors.gold,
        surface: AppColors.creamCard,
      ),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.black,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: 1.1,
          color: AppColors.black,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.creamCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.creamBorder, width: 1),
        ),
      ),
      dividerColor: AppColors.creamBorder,
      iconTheme: const IconThemeData(color: AppColors.goldDeep),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.black,
          foregroundColor: AppColors.gold,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
