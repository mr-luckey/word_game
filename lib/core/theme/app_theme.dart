import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:word_game/core/theme/app_theme_preset.dart';
import 'package:word_game/core/theme/theme_context.dart';

class AppTheme {
  AppTheme._();

  static ThemeData build({
    required AppThemePreset preset,
    bool darkMode = true,
  }) {
    final c = preset.colors(dark: darkMode);
    final textTheme = GoogleFonts.montserratTextTheme(
      ThemeData.dark().textTheme,
    ).apply(bodyColor: c.onSurface, displayColor: c.onSurface);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: c.primary,
        onPrimary: c.onPrimary,
        secondary: c.secondary,
        surface: c.surface,
        onSurface: c.onSurface,
        error: c.timerDanger,
      ),
      extensions: [c, ThemePresetMarker(preset: preset)],
      scaffoldBackgroundColor: c.cream,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: c.onScenic,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: c.glassSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(preset.cardRadius),
          side: BorderSide(color: c.glassBorder, width: 1),
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
        selectedItemColor: c.gold,
        unselectedItemColor: c.locked,
      ),
    );
  }

  static ThemeData get light => build(preset: AppThemePreset.classicTravel);
}
