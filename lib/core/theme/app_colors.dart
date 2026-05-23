import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Journey-style palette (warm travel / word puzzle)
  static const Color primaryBlue = Color(0xFF1A6BB5);
  static const Color oceanBlue = Color(0xFF2E9FD4);
  static const Color darkNavy = Color(0xFF0D3B66);
  static const Color lightBlueBg = Color(0xFFE8F4FC);
  static const Color cream = Color(0xFFFFF8F0);
  static const Color boardWhite = Color(0xFFFAFCFF);

  static const Color cellDefault = Color(0xFFFFFFFF);
  static const Color cellAlt = Color(0xFFF3F7FB);
  static const Color cellSelected = Color(0xFFFFD54F);
  static const Color selectionLine = Color(0xFFFFB300);
  static const Color cellWrong = Color(0xFFFF8A80);
  static const Color cellRevealed = Color(0xFFCE93D8);
  static const Color cellHint = Color(0xFFFFF59D);

  static const Color success = Color(0xFF43A047);
  static const Color warning = Color(0xFFE65100);
  static const Color gold = Color(0xFFFFB300);
  static const Color goldDark = Color(0xFFFF8F00);
  static const Color darkText = Color(0xFF1A237E);
  static const Color lockedGray = Color(0xFF90A4AE);
  static const Color cellBorder = Color(0xFFE0E7EF);
  static const Color timerDanger = Color(0xFFFF5252);

  static const Color easy = Color(0xFF66BB6A);
  static const Color medium = Color(0xFF42A5F5);
  static const Color hard = Color(0xFFFFA726);
  static const Color pro = Color(0xFFEF5350);

  /// Per-word highlight colors (like Word Search Journey).
  static const List<Color> foundWordPalette = [
    Color(0xFF81C784),
    Color(0xFF4FC3F7),
    Color(0xFFFFB74D),
    Color(0xFFBA68C8),
    Color(0xFF4DB6AC),
    Color(0xFFF06292),
    Color(0xFFAED581),
    Color(0xFF7986CB),
  ];

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF1E88E5), Color(0xFF26C6DA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient playButtonGradient = LinearGradient(
    colors: [Color(0xFFFFB300), Color(0xFFFF8F00)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient overlayGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0x660D3B66),
      Color(0x331A6BB5),
      Color(0xCC0D3B66),
    ],
  );

  static const LinearGradient glassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xE6FFFFFF),
      Color(0xCCFFFFFF),
    ],
  );

  static Color foundColorForIndex(int index) =>
      foundWordPalette[index % foundWordPalette.length];
}
