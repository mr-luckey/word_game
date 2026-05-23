import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:word_game/core/theme/app_colors.dart';
import 'package:word_game/core/theme/app_sizes.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryBlue,
          primary: AppColors.primaryBlue,
          secondary: AppColors.oceanBlue,
        ),
        scaffoldBackgroundColor: AppColors.lightBlueBg,
        textTheme: GoogleFonts.poppinsTextTheme(),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingLg,
              vertical: AppSizes.paddingMd,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primaryBlue,
          unselectedItemColor: AppColors.lockedGray,
          type: BottomNavigationBarType.fixed,
        ),
      );
}
