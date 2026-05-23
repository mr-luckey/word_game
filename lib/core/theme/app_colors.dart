import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primaryBlue = Color(0xFF1565C0);
  static const Color oceanBlue = Color(0xFF0288D1);
  static const Color darkNavy = Color(0xFF01579B);
  static const Color lightBlueBg = Color(0xFFE3F2FD);

  static const Color cellDefault = Color(0xFFFFFFFF);
  static const Color cellAlt = Color(0xFFF0F4F8);
  static const Color cellSelected = Color(0xFFB3E5FC);
  static const Color cellFound = Color(0xFFA5D6A7);
  static const Color cellWrong = Color(0xFFEF9A9A);
  static const Color cellRevealed = Color(0xFFCE93D8);
  static const Color cellHint = Color(0xFFFFF59D);

  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFE65100);
  static const Color gold = Color(0xFFFFA000);
  static const Color darkText = Color(0xFF212121);
  static const Color lockedGray = Color(0xFF9E9E9E);
  static const Color cellBorder = Color(0xFFCCCCCC);
  static const Color timerDanger = Color(0xFFC62828);

  static const Color easy = Color(0xFF4CAF50);
  static const Color medium = Color(0xFF2196F3);
  static const Color hard = Color(0xFFFF9800);
  static const Color pro = Color(0xFFF44336);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryBlue, oceanBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
