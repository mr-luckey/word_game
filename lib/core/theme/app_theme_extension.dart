import 'package:flutter/material.dart';

/// All app colors live here and are exposed via [ThemeData.extensions].
@immutable
class AppThemeColors extends ThemeExtension<AppThemeColors> {
  const AppThemeColors({
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.surface,
    required this.onSurface,
    required this.onPrimary,
    required this.onScenic,
    required this.onScenicMuted,
    required this.scrim,
    required this.scrimLight,
    required this.glassSurface,
    required this.glassBorder,
    required this.navSurface,
    required this.shadow,
    required this.cream,
    required this.boardWhite,
    required this.cellDefault,
    required this.cellAlt,
    required this.cellSelected,
    required this.selectionLine,
    required this.cellWrong,
    required this.cellRevealed,
    required this.cellHint,
    required this.success,
    required this.warning,
    required this.gold,
    required this.goldDark,
    required this.goldLight,
    required this.locked,
    required this.cellBorder,
    required this.timerDanger,
    required this.easy,
    required this.medium,
    required this.hard,
    required this.pro,
    required this.levelLockedStart,
    required this.levelLockedEnd,
    required this.levelCompleteStart,
    required this.levelCompleteEnd,
    required this.foundWordPalette,
    required this.primaryGradient,
    required this.playButtonGradient,
    required this.overlayGradient,
    required this.glassGradient,
    this.useScenicImages = true,
    this.solidBackground,
  });

  final Color primary;
  final Color secondary;
  final Color tertiary;
  final Color surface;
  final Color onSurface;
  final Color onPrimary;
  final Color onScenic;
  final Color onScenicMuted;
  final Color scrim;
  final Color scrimLight;
  final Color glassSurface;
  final Color glassBorder;
  final Color navSurface;
  final Color shadow;
  final Color cream;
  final Color boardWhite;
  final Color cellDefault;
  final Color cellAlt;
  final Color cellSelected;
  final Color selectionLine;
  final Color cellWrong;
  final Color cellRevealed;
  final Color cellHint;
  final Color success;
  final Color warning;
  final Color gold;
  final Color goldDark;
  final Color goldLight;
  final Color locked;
  final Color cellBorder;
  final Color timerDanger;
  final Color easy;
  final Color medium;
  final Color hard;
  final Color pro;
  final Color levelLockedStart;
  final Color levelLockedEnd;
  final Color levelCompleteStart;
  final Color levelCompleteEnd;
  final List<Color> foundWordPalette;
  final Gradient primaryGradient;
  final Gradient playButtonGradient;
  final Gradient overlayGradient;
  final Gradient glassGradient;
  final bool useScenicImages;
  final Gradient? solidBackground;

  Color foundColorForIndex(int index) =>
      foundWordPalette[index % foundWordPalette.length];

  static const AppThemeColors light = AppThemeColors(
    primary: Color(0xFF1A6BB5),
    secondary: Color(0xFF2E9FD4),
    tertiary: Color(0xFF0D3B66),
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF1A237E),
    onPrimary: Color(0xFFFFFFFF),
    onScenic: Color(0xFFFFFFFF),
    onScenicMuted: Color(0xB3FFFFFF),
    scrim: Color(0x8C000000),
    scrimLight: Color(0x4D000000),
    glassSurface: Color(0xE0FFFFFF),
    glassBorder: Color(0xF2FFFFFF),
    navSurface: Color(0xEBFFFFFF),
    shadow: Color(0x1F000000),
    cream: Color(0xFFFFF8F0),
    boardWhite: Color(0xFFFAFCFF),
    cellDefault: Color(0xFFFFFFFF),
    cellAlt: Color(0xFFF3F7FB),
    cellSelected: Color(0xFFFFD54F),
    selectionLine: Color(0xFFFFB300),
    cellWrong: Color(0xFFFF8A80),
    cellRevealed: Color(0xFFCE93D8),
    cellHint: Color(0xFFFFF59D),
    success: Color(0xFF43A047),
    warning: Color(0xFFE65100),
    gold: Color(0xFFFFB300),
    goldDark: Color(0xFFFF8F00),
    goldLight: Color(0xFFFFD54F),
    locked: Color(0xFF90A4AE),
    cellBorder: Color(0xFFE0E7EF),
    timerDanger: Color(0xFFFF5252),
    easy: Color(0xFF66BB6A),
    medium: Color(0xFF42A5F5),
    hard: Color(0xFFFFA726),
    pro: Color(0xFFEF5350),
    levelLockedStart: Color(0xFFB0BEC5),
    levelLockedEnd: Color(0xFF90A4AE),
    levelCompleteStart: Color(0xFF66BB6A),
    levelCompleteEnd: Color(0xFF43A047),
    foundWordPalette: [
      Color(0xFF81C784),
      Color(0xFF4FC3F7),
      Color(0xFFFFB74D),
      Color(0xFFBA68C8),
      Color(0xFF4DB6AC),
      Color(0xFFF06292),
      Color(0xFFAED581),
      Color(0xFF7986CB),
    ],
    primaryGradient: LinearGradient(
      colors: [Color(0xFF1E88E5), Color(0xFF26C6DA)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    playButtonGradient: LinearGradient(
      colors: [Color(0xFFFFB300), Color(0xFFFF8F00)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
    overlayGradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0x660D3B66),
        Color(0x331A6BB5),
        Color(0xCC0D3B66),
      ],
    ),
    glassGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xE6FFFFFF), Color(0xCCFFFFFF)],
    ),
    useScenicImages: true,
    solidBackground: null,
  );

  @override
  AppThemeColors copyWith({
    Color? primary,
    Color? secondary,
    Color? tertiary,
    Color? surface,
    Color? onSurface,
    Color? onPrimary,
    Color? onScenic,
    Color? onScenicMuted,
    Color? scrim,
    Color? scrimLight,
    Color? glassSurface,
    Color? glassBorder,
    Color? navSurface,
    Color? shadow,
    Color? cream,
    Color? boardWhite,
    Color? cellDefault,
    Color? cellAlt,
    Color? cellSelected,
    Color? selectionLine,
    Color? cellWrong,
    Color? cellRevealed,
    Color? cellHint,
    Color? success,
    Color? warning,
    Color? gold,
    Color? goldDark,
    Color? goldLight,
    Color? locked,
    Color? cellBorder,
    Color? timerDanger,
    Color? easy,
    Color? medium,
    Color? hard,
    Color? pro,
    Color? levelLockedStart,
    Color? levelLockedEnd,
    Color? levelCompleteStart,
    Color? levelCompleteEnd,
    List<Color>? foundWordPalette,
    Gradient? primaryGradient,
    Gradient? playButtonGradient,
    Gradient? overlayGradient,
    Gradient? glassGradient,
    bool? useScenicImages,
    Gradient? solidBackground,
  }) {
    return AppThemeColors(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      tertiary: tertiary ?? this.tertiary,
      surface: surface ?? this.surface,
      onSurface: onSurface ?? this.onSurface,
      onPrimary: onPrimary ?? this.onPrimary,
      onScenic: onScenic ?? this.onScenic,
      onScenicMuted: onScenicMuted ?? this.onScenicMuted,
      scrim: scrim ?? this.scrim,
      scrimLight: scrimLight ?? this.scrimLight,
      glassSurface: glassSurface ?? this.glassSurface,
      glassBorder: glassBorder ?? this.glassBorder,
      navSurface: navSurface ?? this.navSurface,
      shadow: shadow ?? this.shadow,
      cream: cream ?? this.cream,
      boardWhite: boardWhite ?? this.boardWhite,
      cellDefault: cellDefault ?? this.cellDefault,
      cellAlt: cellAlt ?? this.cellAlt,
      cellSelected: cellSelected ?? this.cellSelected,
      selectionLine: selectionLine ?? this.selectionLine,
      cellWrong: cellWrong ?? this.cellWrong,
      cellRevealed: cellRevealed ?? this.cellRevealed,
      cellHint: cellHint ?? this.cellHint,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      gold: gold ?? this.gold,
      goldDark: goldDark ?? this.goldDark,
      goldLight: goldLight ?? this.goldLight,
      locked: locked ?? this.locked,
      cellBorder: cellBorder ?? this.cellBorder,
      timerDanger: timerDanger ?? this.timerDanger,
      easy: easy ?? this.easy,
      medium: medium ?? this.medium,
      hard: hard ?? this.hard,
      pro: pro ?? this.pro,
      levelLockedStart: levelLockedStart ?? this.levelLockedStart,
      levelLockedEnd: levelLockedEnd ?? this.levelLockedEnd,
      levelCompleteStart: levelCompleteStart ?? this.levelCompleteStart,
      levelCompleteEnd: levelCompleteEnd ?? this.levelCompleteEnd,
      foundWordPalette: foundWordPalette ?? this.foundWordPalette,
      primaryGradient: primaryGradient ?? this.primaryGradient,
      playButtonGradient: playButtonGradient ?? this.playButtonGradient,
      overlayGradient: overlayGradient ?? this.overlayGradient,
        glassGradient: glassGradient ?? this.glassGradient,
        useScenicImages: useScenicImages ?? this.useScenicImages,
        solidBackground: solidBackground ?? this.solidBackground,
      );
  }

  @override
  AppThemeColors lerp(ThemeExtension<AppThemeColors>? other, double t) {
    if (other is! AppThemeColors) return this;
    return t < 0.5 ? this : other;
  }
}
