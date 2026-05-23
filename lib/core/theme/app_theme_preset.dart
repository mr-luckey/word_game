import 'package:flutter/material.dart';
import 'package:word_game/core/theme/app_theme_extension.dart';

enum AppThemePreset {
  journey,
  ocean,
  sunset,
  forest,
  royal,
  midnight,
}

extension AppThemePresetX on AppThemePreset {
  String get label => switch (this) {
        AppThemePreset.journey => 'Journey (Photos)',
        AppThemePreset.ocean => 'Ocean Blue',
        AppThemePreset.sunset => 'Sunset Glow',
        AppThemePreset.forest => 'Forest Green',
        AppThemePreset.royal => 'Royal Purple',
        AppThemePreset.midnight => 'Midnight',
      };

  bool get usesScenicImages => this == AppThemePreset.journey;

  AppThemeColors colors({required bool dark}) {
    final base = switch (this) {
      AppThemePreset.journey => AppThemeColors.light,
      AppThemePreset.ocean => _ocean(dark),
      AppThemePreset.sunset => _sunset(dark),
      AppThemePreset.forest => _forest(dark),
      AppThemePreset.royal => _royal(dark),
      AppThemePreset.midnight => _midnight(dark),
    };
    if (dark && this != AppThemePreset.midnight) {
      return _darken(base);
    }
    return base;
  }

  static AppThemeColors _ocean(bool dark) => AppThemeColors(
        primary: const Color(0xFF0277BD),
        secondary: const Color(0xFF039BE5),
        tertiary: const Color(0xFF01579B),
        surface: dark ? const Color(0xFF1A2A3A) : const Color(0xFFFFFFFF),
        onSurface: dark ? const Color(0xFFE3F2FD) : const Color(0xFF01579B),
        onPrimary: Colors.white,
        onScenic: Colors.white,
        onScenicMuted: const Color(0xB3FFFFFF),
        scrim: const Color(0x8C000000),
        scrimLight: const Color(0x4D000000),
        glassSurface: dark ? const Color(0xCC1E3A5F) : const Color(0xE0FFFFFF),
        glassBorder: const Color(0xF2FFFFFF),
        navSurface: dark ? const Color(0xEB1A2A3A) : const Color(0xEBFFFFFF),
        shadow: const Color(0x1F000000),
        cream: dark ? const Color(0xFF0D2137) : const Color(0xFFE1F5FE),
        boardWhite: dark ? const Color(0xFF263238) : const Color(0xFFFAFCFF),
        cellDefault: dark ? const Color(0xFF37474F) : Colors.white,
        cellAlt: dark ? const Color(0xFF455A64) : const Color(0xFFECEFF1),
        cellSelected: const Color(0xFF4FC3F7),
        selectionLine: const Color(0xFF0288D1),
        cellWrong: const Color(0xFFEF5350),
        cellRevealed: const Color(0xFF7986CB),
        cellHint: const Color(0xFFFFF59D),
        success: const Color(0xFF26A69A),
        warning: const Color(0xFFFF7043),
        gold: const Color(0xFFFFCA28),
        goldDark: const Color(0xFFFFA000),
        goldLight: const Color(0xFFFFE082),
        locked: const Color(0xFF90A4AE),
        cellBorder: const Color(0xFFB0BEC5),
        timerDanger: const Color(0xFFFF5252),
        easy: const Color(0xFF66BB6A),
        medium: const Color(0xFF42A5F5),
        hard: const Color(0xFFFFA726),
        pro: const Color(0xFFEF5350),
        levelLockedStart: const Color(0xFFB0BEC5),
        levelLockedEnd: const Color(0xFF78909C),
        levelCompleteStart: const Color(0xFF26C6DA),
        levelCompleteEnd: const Color(0xFF0097A7),
        foundWordPalette: AppThemeColors.light.foundWordPalette,
        primaryGradient: const LinearGradient(
          colors: [Color(0xFF0288D1), Color(0xFF26C6DA)],
        ),
        playButtonGradient: AppThemeColors.light.playButtonGradient,
        overlayGradient: const LinearGradient(
          colors: [Color(0x6601579B), Color(0xCC01579B)],
        ),
        glassGradient: AppThemeColors.light.glassGradient,
        useScenicImages: false,
        solidBackground: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF01579B), Color(0xFF0288D1), Color(0xFF4FC3F7)],
        ),
      );

  static AppThemeColors _sunset(bool dark) => _solidPreset(
        dark: dark,
        primary: const Color(0xFFE65100),
        secondary: const Color(0xFFFF7043),
        tertiary: const Color(0xFFBF360C),
        bg: [const Color(0xFFBF360C), const Color(0xFFE65100), const Color(0xFFFF8A65)],
        cream: dark ? const Color(0xFF3E2723) : const Color(0xFFFFF3E0),
      );

  static AppThemeColors _forest(bool dark) => _solidPreset(
        dark: dark,
        primary: const Color(0xFF2E7D32),
        secondary: const Color(0xFF43A047),
        tertiary: const Color(0xFF1B5E20),
        bg: [const Color(0xFF1B5E20), const Color(0xFF388E3C), const Color(0xFF81C784)],
        cream: dark ? const Color(0xFF1B2E1B) : const Color(0xFFE8F5E9),
      );

  static AppThemeColors _royal(bool dark) => _solidPreset(
        dark: dark,
        primary: const Color(0xFF6A1B9A),
        secondary: const Color(0xFF8E24AA),
        tertiary: const Color(0xFF4A148C),
        bg: [const Color(0xFF4A148C), const Color(0xFF7B1FA2), const Color(0xFFBA68C8)],
        cream: dark ? const Color(0xFF2A1A3A) : const Color(0xFFF3E5F5),
      );

  static AppThemeColors _midnight(bool dark) => _solidPreset(
        dark: true,
        primary: const Color(0xFF3949AB),
        secondary: const Color(0xFF5C6BC0),
        tertiary: const Color(0xFF1A237E),
        bg: [const Color(0xFF0D1117), const Color(0xFF1A237E), const Color(0xFF283593)],
        cream: const Color(0xFF121212),
      );

  static AppThemeColors _solidPreset({
    required bool dark,
    required Color primary,
    required Color secondary,
    required Color tertiary,
    required List<Color> bg,
    required Color cream,
  }) {
    return AppThemeColors(
      primary: primary,
      secondary: secondary,
      tertiary: tertiary,
      surface: dark ? const Color(0xFF1E1E1E) : Colors.white,
      onSurface: dark ? const Color(0xFFECEFF1) : const Color(0xFF212121),
      onPrimary: Colors.white,
      onScenic: Colors.white,
      onScenicMuted: const Color(0xB3FFFFFF),
      scrim: const Color(0x99000000),
      scrimLight: const Color(0x59000000),
      glassSurface: dark ? const Color(0xCC2C2C2C) : const Color(0xE0FFFFFF),
      glassBorder: const Color(0x66FFFFFF),
      navSurface: dark ? const Color(0xEB1E1E1E) : const Color(0xEBFFFFFF),
      shadow: const Color(0x3F000000),
      cream: cream,
      boardWhite: dark ? const Color(0xFF2C2C2C) : const Color(0xFFFAFCFF),
      cellDefault: dark ? const Color(0xFF37474F) : Colors.white,
      cellAlt: dark ? const Color(0xFF455A64) : const Color(0xFFF5F5F5),
      cellSelected: const Color(0xFFFFD54F),
      selectionLine: const Color(0xFFFFB300),
      cellWrong: const Color(0xFFEF5350),
      cellRevealed: const Color(0xFFCE93D8),
      cellHint: const Color(0xFFFFF59D),
      success: const Color(0xFF66BB6A),
      warning: const Color(0xFFFF7043),
      gold: const Color(0xFFFFB300),
      goldDark: const Color(0xFFFF8F00),
      goldLight: const Color(0xFFFFD54F),
      locked: const Color(0xFF90A4AE),
      cellBorder: const Color(0xFFBDBDBD),
      timerDanger: const Color(0xFFFF5252),
      easy: const Color(0xFF66BB6A),
      medium: const Color(0xFF42A5F5),
      hard: const Color(0xFFFFA726),
      pro: const Color(0xFFEF5350),
      levelLockedStart: const Color(0xFF78909C),
      levelLockedEnd: const Color(0xFF546E7A),
      levelCompleteStart: const Color(0xFF66BB6A),
      levelCompleteEnd: const Color(0xFF43A047),
      foundWordPalette: AppThemeColors.light.foundWordPalette,
      primaryGradient: LinearGradient(colors: [primary, secondary]),
      playButtonGradient: AppThemeColors.light.playButtonGradient,
      overlayGradient: LinearGradient(colors: [bg.first.withValues(alpha: 0.4), bg.last.withValues(alpha: 0.8)]),
      glassGradient: AppThemeColors.light.glassGradient,
      useScenicImages: false,
      solidBackground: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: bg,
      ),
    );
  }

  static AppThemeColors _darken(AppThemeColors c) => AppThemeColors(
        primary: c.primary,
        secondary: c.secondary,
        tertiary: c.tertiary,
        surface: const Color(0xFF1E1E1E),
        onSurface: const Color(0xFFECEFF1),
        onPrimary: c.onPrimary,
        onScenic: c.onScenic,
        onScenicMuted: c.onScenicMuted,
        scrim: c.scrim,
        scrimLight: c.scrimLight,
        glassSurface: const Color(0xCC2C2C2C),
        glassBorder: c.glassBorder,
        navSurface: const Color(0xEB1E1E1E),
        shadow: c.shadow,
        cream: const Color(0xFF121212),
        boardWhite: const Color(0xFF2C2C2C),
        cellDefault: const Color(0xFF37474F),
        cellAlt: const Color(0xFF455A64),
        cellSelected: c.cellSelected,
        selectionLine: c.selectionLine,
        cellWrong: c.cellWrong,
        cellRevealed: c.cellRevealed,
        cellHint: c.cellHint,
        success: c.success,
        warning: c.warning,
        gold: c.gold,
        goldDark: c.goldDark,
        goldLight: c.goldLight,
        locked: c.locked,
        cellBorder: c.cellBorder,
        timerDanger: c.timerDanger,
        easy: c.easy,
        medium: c.medium,
        hard: c.hard,
        pro: c.pro,
        levelLockedStart: c.levelLockedStart,
        levelLockedEnd: c.levelLockedEnd,
        levelCompleteStart: c.levelCompleteStart,
        levelCompleteEnd: c.levelCompleteEnd,
        foundWordPalette: c.foundWordPalette,
        primaryGradient: c.primaryGradient,
        playButtonGradient: c.playButtonGradient,
        overlayGradient: c.overlayGradient,
        glassGradient: c.glassGradient,
        useScenicImages: c.useScenicImages,
        solidBackground: c.solidBackground,
      );
}
