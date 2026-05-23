import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:word_game/core/theme/app_sizes.dart';
import 'package:word_game/core/theme/app_theme_preset.dart';

class AppTheme {
  AppTheme._();

  static ThemeData build({
    required AppThemePreset preset,
    required bool darkMode,
  }) {
    final c = preset.colors(dark: darkMode);
    final brightness = darkMode ? Brightness.dark : Brightness.light;

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: c.primary,
      onPrimary: c.onPrimary,
      secondary: c.secondary,
      onSecondary: c.onPrimary,
      tertiary: c.tertiary,
      onTertiary: c.onPrimary,
      error: c.timerDanger,
      onError: c.onPrimary,
      surface: c.surface,
      onSurface: c.onSurface,
    );

    final textTheme = GoogleFonts.poppinsTextTheme().apply(
      bodyColor: c.onSurface,
      displayColor: c.onSurface,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      extensions: [c],
      scaffoldBackgroundColor: c.cream,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: c.primary,
        foregroundColor: c.onPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        color: c.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: c.primary,
          foregroundColor: c.onPrimary,
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: c.gold),
      snackBarTheme: SnackBarThemeData(backgroundColor: c.tertiary),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: c.navSurface,
        selectedItemColor: c.goldDark,
        unselectedItemColor: c.locked,
      ),
    );
  }

  /// Legacy accessor — prefer [AppThemeCubit].
  static ThemeData get light => build(
        preset: AppThemePreset.journey,
        darkMode: false,
      );
}
