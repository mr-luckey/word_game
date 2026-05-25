import 'package:flutter/material.dart';
import 'package:word_game/core/theme/app_theme_extension.dart';

enum AppThemePreset {
  classicTravel,
  forestQuest,
  neonCity,
  sunsetSafari,
  winterAlps,
  darkLuxury,
  oceanEscape,
}

enum ThemeSelectionMode { autoDestination, fixed }

enum PlayButtonStyle { goldSolid, woodTexture, neonGradient, icyBlue, tealSolid }

extension AppThemePresetX on AppThemePreset {
  String get label => switch (this) {
        AppThemePreset.classicTravel => 'Classic Travel',
        AppThemePreset.forestQuest => 'Forest Quest',
        AppThemePreset.neonCity => 'Neon City',
        AppThemePreset.sunsetSafari => 'Sunset Safari',
        AppThemePreset.winterAlps => 'Winter Alps',
        AppThemePreset.darkLuxury => 'Dark Luxury',
        AppThemePreset.oceanEscape => 'Ocean Escape',
      };

  String get folder => switch (this) {
        AppThemePreset.classicTravel => 'classic_travel',
        AppThemePreset.forestQuest => 'forest_quest',
        AppThemePreset.neonCity => 'neon_city',
        AppThemePreset.sunsetSafari => 'sunset_safari',
        AppThemePreset.winterAlps => 'winter_alps',
        AppThemePreset.darkLuxury => 'dark_luxury',
        AppThemePreset.oceanEscape => 'ocean_escape',
      };

  String get subtitle => label.toUpperCase();

  String get splashTagline => switch (this) {
        AppThemePreset.classicTravel => 'Exploring new places...',
        AppThemePreset.forestQuest => 'Every path hides a word.',
        AppThemePreset.neonCity => 'Exploring neon cities...',
        AppThemePreset.sunsetSafari => 'Exploring new horizons...',
        AppThemePreset.winterAlps => 'Charting your next adventure...',
        AppThemePreset.darkLuxury => 'Crafted journeys. Timeless discovery.',
        AppThemePreset.oceanEscape =>
            'Set sail for stunning places and inspiring word adventures.',
      };

  String get profilePersona => switch (this) {
        AppThemePreset.forestQuest => 'Forest Explorer',
        AppThemePreset.winterAlps => 'Alpine Voyager',
        AppThemePreset.oceanEscape => 'Voyager',
        _ => 'Voyager',
      };

  String get exploreSubtitle => switch (this) {
        AppThemePreset.forestQuest =>
          'Discover forest paths and new word adventures.',
        AppThemePreset.neonCity =>
          'Explore neon cities and unlock new word packs.',
        AppThemePreset.sunsetSafari =>
          'Discover iconic places and new word adventures.',
        AppThemePreset.winterAlps =>
          'Chart snowy peaks and unlock alpine word packs.',
        AppThemePreset.darkLuxury =>
          'Discover luxury destinations and word adventures.',
        AppThemePreset.oceanEscape =>
          'Sail to tropical shores and new word adventures.',
        _ => 'Discover iconic places and new word adventures.',
      };

  bool get useGlassmorphism => this == AppThemePreset.winterAlps ||
      this == AppThemePreset.oceanEscape;

  bool get useNeonGlow => this == AppThemePreset.neonCity;

  PlayButtonStyle get playButtonStyle => switch (this) {
        AppThemePreset.forestQuest => PlayButtonStyle.woodTexture,
        AppThemePreset.neonCity => PlayButtonStyle.neonGradient,
        AppThemePreset.winterAlps => PlayButtonStyle.icyBlue,
        AppThemePreset.oceanEscape => PlayButtonStyle.tealSolid,
        _ => PlayButtonStyle.goldSolid,
      };

  double get cardRadius => switch (this) {
        AppThemePreset.winterAlps => 16,
        AppThemePreset.oceanEscape => 18,
        _ => 14,
      };

  bool get usesScenicImages => true;

  AppThemeColors colors({required bool dark}) {
    return switch (this) {
      AppThemePreset.classicTravel => _classicTravel(),
      AppThemePreset.forestQuest => _forestQuest(),
      AppThemePreset.neonCity => _neonCity(),
      AppThemePreset.sunsetSafari => _sunsetSafari(),
      AppThemePreset.winterAlps => _winterAlps(),
      AppThemePreset.darkLuxury => _darkLuxury(),
      AppThemePreset.oceanEscape => _oceanEscape(),
    };
  }

  static AppThemeColors _classicTravel() => AppThemeColors(
        primary: const Color(0xFF1A6BB5),
        secondary: const Color(0xFFD4AF37),
        tertiary: const Color(0xFF050A18),
        surface: const Color(0xFF101D33),
        onSurface: const Color(0xFFFFFFFF),
        onPrimary: const Color(0xFF050A18),
        onScenic: const Color(0xFFFFFFFF),
        onScenicMuted: const Color(0xB3FFFFFF),
        scrim: const Color(0x99000000),
        scrimLight: const Color(0x59000000),
        glassSurface: const Color(0xCC101D33),
        glassBorder: const Color(0xFFD4AF37),
        navSurface: const Color(0xF0050A18),
        shadow: const Color(0x66000000),
        cream: const Color(0xFF050A18),
        boardWhite: const Color(0xFFF5F5F0),
        cellDefault: const Color(0xFFFFFFFF),
        cellAlt: const Color(0xFFF0F0EA),
        cellSelected: const Color(0xFFD4AF37),
        selectionLine: const Color(0xFFFFD700),
        cellWrong: const Color(0xFFEF5350),
        cellRevealed: const Color(0xFF7986CB),
        cellHint: const Color(0xFFFFF59D),
        success: const Color(0xFF66BB6A),
        warning: const Color(0xFFFF7043),
        gold: const Color(0xFFD4AF37),
        goldDark: const Color(0xFFB8860B),
        goldLight: const Color(0xFFFFD700),
        accentCoin: const Color(0xFF4FC3F7),
        bodyMuted: const Color(0xFFA0A0A0),
        locked: const Color(0xFF78909C),
        cellBorder: const Color(0xFFE0E0E0),
        timerDanger: const Color(0xFFFF5252),
        easy: const Color(0xFF66BB6A),
        medium: const Color(0xFF42A5F5),
        hard: const Color(0xFFFFA726),
        pro: const Color(0xFFEF5350),
        levelLockedStart: const Color(0xFF37474F),
        levelLockedEnd: const Color(0xFF263238),
        levelCompleteStart: const Color(0xFFD4AF37),
        levelCompleteEnd: const Color(0xFFB8860B),
        shopPriceButton: const Color(0xFF4FC3F7),
        foundWordPalette: _goldFoundPalette,
        primaryGradient: const LinearGradient(
          colors: [Color(0xFF0B101B), Color(0xFF161D2F)],
        ),
        playButtonGradient: const LinearGradient(
          colors: [Color(0xFFFFD700), Color(0xFFD4AF37)],
        ),
        overlayGradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x660B101B), Color(0xCC0B101B)],
        ),
        glassGradient: const LinearGradient(
          colors: [Color(0xCC161D2F), Color(0x99161D2F)],
        ),
        useScenicImages: true,
        solidBackground: const LinearGradient(
          colors: [Color(0xFF0B101B), Color(0xFF161D2F)],
        ),
      );

  static AppThemeColors _forestQuest() => AppThemeColors(
        primary: const Color(0xFF2E7D32),
        secondary: const Color(0xFFC5A059),
        tertiary: const Color(0xFF051A05),
        surface: const Color(0xFF0C2B0C),
        onSurface: const Color(0xFFE8F5E9),
        onPrimary: const Color(0xFF051A05),
        onScenic: const Color(0xFFFFFFFF),
        onScenicMuted: const Color(0xB3FFFFFF),
        scrim: const Color(0x99000000),
        scrimLight: const Color(0x59000000),
        glassSurface: const Color(0xCC0C2B0C),
        glassBorder: const Color(0xFFC5A059),
        navSurface: const Color(0xEB051A05),
        shadow: const Color(0x66000000),
        cream: const Color(0xFF051A05),
        boardWhite: const Color(0xFFF5F0E1),
        cellDefault: const Color(0xFFFFF8E7),
        cellAlt: const Color(0xFFF0E8D0),
        cellSelected: const Color(0xFF81C784),
        selectionLine: const Color(0xFF43A047),
        cellWrong: const Color(0xFFEF5350),
        cellRevealed: const Color(0xFFCE93D8),
        cellHint: const Color(0xFFFFF59D),
        success: const Color(0xFF66BB6A),
        warning: const Color(0xFFFF7043),
        gold: const Color(0xFFC5A059),
        goldDark: const Color(0xFF8D6E3A),
        goldLight: const Color(0xFFE6C875),
        accentCoin: const Color(0xFFC5A059),
        bodyMuted: const Color(0xFFA5D6A7),
        locked: const Color(0xFF78909C),
        cellBorder: const Color(0xFFBCAAA4),
        timerDanger: const Color(0xFFFF5252),
        easy: const Color(0xFF66BB6A),
        medium: const Color(0xFF43A047),
        hard: const Color(0xFFFFA726),
        pro: const Color(0xFFEF5350),
        levelLockedStart: const Color(0xFF37474F),
        levelLockedEnd: const Color(0xFF263238),
        levelCompleteStart: const Color(0xFF66BB6A),
        levelCompleteEnd: const Color(0xFF43A047),
        shopPriceButton: const Color(0xFF43A047),
        foundWordPalette: _greenFoundPalette,
        primaryGradient: const LinearGradient(
          colors: [Color(0xFF051A05), Color(0xFF0C2B0C)],
        ),
        playButtonGradient: const LinearGradient(
          colors: [Color(0xFF8D6E3A), Color(0xFFC5A059)],
        ),
        overlayGradient: const LinearGradient(
          colors: [Color(0x66051A05), Color(0xCC0C2B0C)],
        ),
        glassGradient: const LinearGradient(
          colors: [Color(0xCC0C2B0C), Color(0x990C2B0C)],
        ),
        useScenicImages: true,
        solidBackground: const LinearGradient(
          colors: [Color(0xFF051A05), Color(0xFF0C2B0C), Color(0xFF1B5E20)],
        ),
      );

  static AppThemeColors _neonCity() => AppThemeColors(
        primary: const Color(0xFFEA00FF),
        secondary: const Color(0xFF9D00FF),
        tertiary: const Color(0xFF050510),
        surface: const Color(0xFF0A0A1A),
        onSurface: const Color(0xFFFFFFFF),
        onPrimary: const Color(0xFFFFFFFF),
        onScenic: const Color(0xFFFFFFFF),
        onScenicMuted: const Color(0xB3B0B0C0),
        scrim: const Color(0xCC000000),
        scrimLight: const Color(0x66000000),
        glassSurface: const Color(0xCC0A0A1A),
        glassBorder: const Color(0xFF9D00FF),
        navSurface: const Color(0xEB050510),
        shadow: const Color(0x80EA00FF),
        cream: const Color(0xFF050510),
        boardWhite: const Color(0xFF12122A),
        cellDefault: const Color(0xFF1A1A3A),
        cellAlt: const Color(0xFF22224A),
        cellSelected: const Color(0xFFEA00FF),
        selectionLine: const Color(0xFFFF00FF),
        cellWrong: const Color(0xFFFF5252),
        cellRevealed: const Color(0xFFCE93D8),
        cellHint: const Color(0xFFFFF59D),
        success: const Color(0xFF69F0AE),
        warning: const Color(0xFFFF7043),
        gold: const Color(0xFFFFD700),
        goldDark: const Color(0xFFFFA000),
        goldLight: const Color(0xFFFFE082),
        accentCoin: const Color(0xFFFFD700),
        bodyMuted: const Color(0xFFB0B0C0),
        locked: const Color(0xFF616161),
        cellBorder: const Color(0xFF9D00FF),
        timerDanger: const Color(0xFFFF5252),
        easy: const Color(0xFFEA00FF),
        medium: const Color(0xFF9D00FF),
        hard: const Color(0xFFFF4081),
        pro: const Color(0xFFFF1744),
        levelLockedStart: const Color(0xFF37474F),
        levelLockedEnd: const Color(0xFF263238),
        levelCompleteStart: const Color(0xFFEA00FF),
        levelCompleteEnd: const Color(0xFF9D00FF),
        shopPriceButton: const Color(0xFFEA00FF),
        foundWordPalette: _neonFoundPalette,
        primaryGradient: const LinearGradient(
          colors: [Color(0xFFEA00FF), Color(0xFF9D00FF)],
        ),
        playButtonGradient: const LinearGradient(
          colors: [Color(0xFFFF00FF), Color(0xFF9D00FF)],
        ),
        overlayGradient: const LinearGradient(
          colors: [Color(0x99050510), Color(0xCC050510)],
        ),
        glassGradient: const LinearGradient(
          colors: [Color(0xCC0A0A1A), Color(0x990A0A1A)],
        ),
        useScenicImages: true,
        solidBackground: const LinearGradient(
          colors: [Color(0xFF050510), Color(0xFF1A0A2E)],
        ),
      );

  static AppThemeColors _sunsetSafari() => AppThemeColors(
        primary: const Color(0xFFE65100),
        secondary: const Color(0xFFFFB300),
        tertiary: const Color(0xFF3E2723),
        surface: const Color(0xFF4E342E),
        onSurface: const Color(0xFFFFF8E1),
        onPrimary: const Color(0xFF3E2723),
        onScenic: const Color(0xFFFFFFFF),
        onScenicMuted: const Color(0xB3FFFFFF),
        scrim: const Color(0x99000000),
        scrimLight: const Color(0x59000000),
        glassSurface: const Color(0xCC4E342E),
        glassBorder: const Color(0xFFFFB300),
        navSurface: const Color(0xEB3E2723),
        shadow: const Color(0x66000000),
        cream: const Color(0xFF3E2723),
        boardWhite: const Color(0xFFFFF3E0),
        cellDefault: const Color(0xFFFFF8E1),
        cellAlt: const Color(0xFFFFE0B2),
        cellSelected: const Color(0xFFFF9800),
        selectionLine: const Color(0xFFE65100),
        cellWrong: const Color(0xFFEF5350),
        cellRevealed: const Color(0xFFCE93D8),
        cellHint: const Color(0xFFFFF59D),
        success: const Color(0xFF66BB6A),
        warning: const Color(0xFFFF7043),
        gold: const Color(0xFFFFB300),
        goldDark: const Color(0xFFFF8F00),
        goldLight: const Color(0xFFFFD54F),
        accentCoin: const Color(0xFFFFB300),
        bodyMuted: const Color(0xFFBCAAA4),
        locked: const Color(0xFF78909C),
        cellBorder: const Color(0xFFFFCC80),
        timerDanger: const Color(0xFFFF5252),
        easy: const Color(0xFF66BB6A),
        medium: const Color(0xFFFF9800),
        hard: const Color(0xFFFF5722),
        pro: const Color(0xFFD84315),
        levelLockedStart: const Color(0xFF37474F),
        levelLockedEnd: const Color(0xFF263238),
        levelCompleteStart: const Color(0xFFFFB300),
        levelCompleteEnd: const Color(0xFFE65100),
        shopPriceButton: const Color(0xFFE65100),
        foundWordPalette: _goldFoundPalette,
        primaryGradient: const LinearGradient(
          colors: [Color(0xFFBF360C), Color(0xFFE65100), Color(0xFFFF8A65)],
        ),
        playButtonGradient: const LinearGradient(
          colors: [Color(0xFFFFD54F), Color(0xFFFF8F00)],
        ),
        overlayGradient: const LinearGradient(
          colors: [Color(0x663E2723), Color(0xCC3E2723)],
        ),
        glassGradient: const LinearGradient(
          colors: [Color(0xCC4E342E), Color(0x994E342E)],
        ),
        useScenicImages: true,
        solidBackground: const LinearGradient(
          colors: [Color(0xFF3E2723), Color(0xFFBF360C), Color(0xFFE65100)],
        ),
      );

  static AppThemeColors _winterAlps() => AppThemeColors(
        primary: const Color(0xFF1E3A5F),
        secondary: const Color(0xFFA5C9E1),
        tertiary: const Color(0xFF0D2137),
        surface: const Color(0xCCFFFFFF),
        onSurface: const Color(0xFF1E3A5F),
        onPrimary: const Color(0xFF0D2137),
        onScenic: const Color(0xFFFFFFFF),
        onScenicMuted: const Color(0xB3FFFFFF),
        scrim: const Color(0x80000000),
        scrimLight: const Color(0x40000000),
        glassSurface: const Color(0x99FFFFFF),
        glassBorder: const Color(0xFFFFFFFF),
        navSurface: const Color(0xEB1E3A5F),
        shadow: const Color(0x33000000),
        cream: const Color(0xFF0D2137),
        boardWhite: const Color(0xFFF0F8FF),
        cellDefault: const Color(0xFFFFFFFF),
        cellAlt: const Color(0xFFE8F4FC),
        cellSelected: const Color(0xFFA5C9E1),
        selectionLine: const Color(0xFF1E88E5),
        cellWrong: const Color(0xFFEF5350),
        cellRevealed: const Color(0xFFCE93D8),
        cellHint: const Color(0xFFFFF59D),
        success: const Color(0xFF66BB6A),
        warning: const Color(0xFFFF7043),
        gold: const Color(0xFFFFD700),
        goldDark: const Color(0xFFFFA000),
        goldLight: const Color(0xFFFFE082),
        accentCoin: const Color(0xFFFFD700),
        bodyMuted: const Color(0xFF90A4AE),
        locked: const Color(0xFF78909C),
        cellBorder: const Color(0xFFB0BEC5),
        timerDanger: const Color(0xFFFF5252),
        easy: const Color(0xFF66BB6A),
        medium: const Color(0xFF42A5F5),
        hard: const Color(0xFFFFA726),
        pro: const Color(0xFFEF5350),
        levelLockedStart: const Color(0xFF78909C),
        levelLockedEnd: const Color(0xFF546E7A),
        levelCompleteStart: const Color(0xFFA5C9E1),
        levelCompleteEnd: const Color(0xFF1E3A5F),
        shopPriceButton: const Color(0xFF1E88E5),
        foundWordPalette: _blueFoundPalette,
        primaryGradient: const LinearGradient(
          colors: [Color(0xFF0D2137), Color(0xFF1E3A5F)],
        ),
        playButtonGradient: const LinearGradient(
          colors: [Color(0xFF42A5F5), Color(0xFF1E88E5)],
        ),
        overlayGradient: const LinearGradient(
          colors: [Color(0x660D2137), Color(0x991E3A5F)],
        ),
        glassGradient: const LinearGradient(
          colors: [Color(0xCCFFFFFF), Color(0x99FFFFFF)],
        ),
        useScenicImages: true,
        solidBackground: const LinearGradient(
          colors: [Color(0xFF0D2137), Color(0xFF1E3A5F), Color(0xFFA5C9E1)],
        ),
      );

  static AppThemeColors _darkLuxury() => AppThemeColors(
        primary: const Color(0xFFD4AF37),
        secondary: const Color(0xFFB8860B),
        tertiary: const Color(0xFF000000),
        surface: const Color(0xFF121212),
        onSurface: const Color(0xFFECEFF1),
        onPrimary: const Color(0xFF000000),
        onScenic: const Color(0xFFFFFFFF),
        onScenicMuted: const Color(0xB3FFFFFF),
        scrim: const Color(0xCC000000),
        scrimLight: const Color(0x66000000),
        glassSurface: const Color(0xCC121212),
        glassBorder: const Color(0xFFD4AF37),
        navSurface: const Color(0xEB000000),
        shadow: const Color(0x66D4AF37),
        cream: const Color(0xFF000000),
        boardWhite: const Color(0xFF1E1E1E),
        cellDefault: const Color(0xFF2C2C2C),
        cellAlt: const Color(0xFF383838),
        cellSelected: const Color(0xFFD4AF37),
        selectionLine: const Color(0xFFFFD700),
        cellWrong: const Color(0xFFEF5350),
        cellRevealed: const Color(0xFFCE93D8),
        cellHint: const Color(0xFFFFF59D),
        success: const Color(0xFF66BB6A),
        warning: const Color(0xFFFF7043),
        gold: const Color(0xFFD4AF37),
        goldDark: const Color(0xFFB8860B),
        goldLight: const Color(0xFFFFE082),
        accentCoin: const Color(0xFFD4AF37),
        bodyMuted: const Color(0xFF9E9E9E),
        locked: const Color(0xFF616161),
        cellBorder: const Color(0xFFD4AF37),
        timerDanger: const Color(0xFFFF5252),
        easy: const Color(0xFF66BB6A),
        medium: const Color(0xFF42A5F5),
        hard: const Color(0xFFFFA726),
        pro: const Color(0xFFEF5350),
        levelLockedStart: const Color(0xFF424242),
        levelLockedEnd: const Color(0xFF212121),
        levelCompleteStart: const Color(0xFFD4AF37),
        levelCompleteEnd: const Color(0xFFB8860B),
        shopPriceButton: const Color(0xFFD4AF37),
        foundWordPalette: _goldFoundPalette,
        primaryGradient: const LinearGradient(
          colors: [Color(0xFF000000), Color(0xFF121212)],
        ),
        playButtonGradient: const LinearGradient(
          colors: [Color(0xFFFFE082), Color(0xFFD4AF37)],
        ),
        overlayGradient: const LinearGradient(
          colors: [Color(0xCC000000), Color(0x99000000)],
        ),
        glassGradient: const LinearGradient(
          colors: [Color(0xCC121212), Color(0x99121212)],
        ),
        useScenicImages: true,
        solidBackground: const LinearGradient(
          colors: [Color(0xFF000000), Color(0xFF121212)],
        ),
      );

  static AppThemeColors _oceanEscape() => AppThemeColors(
        primary: const Color(0xFF004B70),
        secondary: const Color(0xFF26C6DA),
        tertiary: const Color(0xFF002B49),
        surface: const Color(0xCC002B49),
        onSurface: const Color(0xFFE0F7FA),
        onPrimary: const Color(0xFF002B49),
        onScenic: const Color(0xFFFFFFFF),
        onScenicMuted: const Color(0xB3FFFFFF),
        scrim: const Color(0x99000000),
        scrimLight: const Color(0x59000000),
        glassSurface: const Color(0xCC004B70),
        glassBorder: const Color(0xFF26C6DA),
        navSurface: const Color(0xEB002B49),
        shadow: const Color(0x6626C6DA),
        cream: const Color(0xFF002B49),
        boardWhite: const Color(0xFFE0F7FA),
        cellDefault: const Color(0xFFFFFFFF),
        cellAlt: const Color(0xFFB2EBF2),
        cellSelected: const Color(0xFF26C6DA),
        selectionLine: const Color(0xFF00BCD4),
        cellWrong: const Color(0xFFEF5350),
        cellRevealed: const Color(0xFFCE93D8),
        cellHint: const Color(0xFFFFF59D),
        success: const Color(0xFF26A69A),
        warning: const Color(0xFFFF7043),
        gold: const Color(0xFFFFD700),
        goldDark: const Color(0xFFFFA000),
        goldLight: const Color(0xFFFFE082),
        accentCoin: const Color(0xFFFFD700),
        bodyMuted: const Color(0xFF80DEEA),
        locked: const Color(0xFF78909C),
        cellBorder: const Color(0xFF4DD0E1),
        timerDanger: const Color(0xFFFF5252),
        easy: const Color(0xFF26C6DA),
        medium: const Color(0xFF00ACC1),
        hard: const Color(0xFF00838F),
        pro: const Color(0xFF006064),
        levelLockedStart: const Color(0xFF37474F),
        levelLockedEnd: const Color(0xFF263238),
        levelCompleteStart: const Color(0xFF26C6DA),
        levelCompleteEnd: const Color(0xFF004B70),
        shopPriceButton: const Color(0xFF26C6DA),
        foundWordPalette: _blueFoundPalette,
        primaryGradient: const LinearGradient(
          colors: [Color(0xFF002B49), Color(0xFF004B70)],
        ),
        playButtonGradient: const LinearGradient(
          colors: [Color(0xFF26C6DA), Color(0xFF004B70)],
        ),
        overlayGradient: const LinearGradient(
          colors: [Color(0x66002B49), Color(0xCC004B70)],
        ),
        glassGradient: const LinearGradient(
          colors: [Color(0xCC004B70), Color(0x99002B49)],
        ),
        useScenicImages: true,
        solidBackground: const LinearGradient(
          colors: [Color(0xFF002B49), Color(0xFF004B70), Color(0xFF26C6DA)],
        ),
      );

  static const _goldFoundPalette = [
    Color(0xFFD4AF37),
    Color(0xFF4FC3F7),
    Color(0xFFFFB74D),
    Color(0xFFBA68C8),
    Color(0xFF4DB6AC),
    Color(0xFFF06292),
  ];

  static const _greenFoundPalette = [
    Color(0xFF81C784),
    Color(0xFF43A047),
    Color(0xFFAED581),
    Color(0xFF4DB6AC),
    Color(0xFF66BB6A),
    Color(0xFF2E7D32),
  ];

  static const _neonFoundPalette = [
    Color(0xFFEA00FF),
    Color(0xFF9D00FF),
    Color(0xFFFF4081),
    Color(0xFF00E5FF),
    Color(0xFFFFD740),
    Color(0xFF69F0AE),
  ];

  static const _blueFoundPalette = [
    Color(0xFF4FC3F7),
    Color(0xFF26C6DA),
    Color(0xFF7986CB),
    Color(0xFFA5C9E1),
    Color(0xFF4DB6AC),
    Color(0xFF81D4FA),
  ];

  /// Migrate legacy preset names from SharedPreferences.
  static AppThemePreset fromLegacyName(String? name) {
    if (name == null) return AppThemePreset.classicTravel;
    return switch (name) {
      'journey' => AppThemePreset.classicTravel,
      'ocean' => AppThemePreset.oceanEscape,
      'sunset' => AppThemePreset.sunsetSafari,
      'forest' => AppThemePreset.forestQuest,
      'royal' => AppThemePreset.neonCity,
      'midnight' => AppThemePreset.darkLuxury,
      _ => AppThemePreset.values.firstWhere(
          (p) => p.name == name,
          orElse: () => AppThemePreset.classicTravel,
        ),
    };
  }
}
