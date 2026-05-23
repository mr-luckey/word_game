import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:word_game/core/theme/app_sizes.dart';
import 'package:word_game/core/theme/app_theme_extension.dart';

class AppTheme {
  AppTheme._();

  static const AppThemeColors _c = AppThemeColors.light;

  static ThemeData get light {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: _c.primary,
      onPrimary: _c.onPrimary,
      secondary: _c.secondary,
      onSecondary: _c.onPrimary,
      tertiary: _c.tertiary,
      onTertiary: _c.onPrimary,
      error: _c.timerDanger,
      onError: _c.onPrimary,
      surface: _c.surface,
      onSurface: _c.onSurface,
    );

    final textTheme = GoogleFonts.poppinsTextTheme().apply(
      bodyColor: _c.onSurface,
      displayColor: _c.onSurface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      extensions: const [AppThemeColors.light],
      scaffoldBackgroundColor: _c.cream,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: _c.primary,
        foregroundColor: _c.onPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: _c.onPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        color: _c.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _c.primary,
          foregroundColor: _c.onPrimary,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.paddingLg,
            vertical: AppSizes.paddingMd,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _c.primary,
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: _c.gold,
        linearTrackColor: _c.onScenicMuted,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: _c.tertiary,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: _c.onScenic),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: _c.navSurface,
        selectedItemColor: _c.goldDark,
        unselectedItemColor: _c.locked,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
