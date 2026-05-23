import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:word_game/core/theme/app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle get gameTitle => GoogleFonts.montserrat(
        fontSize: 36,
        fontWeight: FontWeight.w900,
        color: Colors.white,
      );

  static TextStyle get levelName => GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppColors.darkText,
      );

  static TextStyle gridLetter(double gridSize) => GoogleFonts.robotoMono(
        fontSize: gridSize <= 8 ? 22 : gridSize <= 10 ? 20 : 18,
        fontWeight: FontWeight.w700,
        color: AppColors.darkText,
      );

  static TextStyle get wordList => GoogleFonts.poppins(
        fontSize: 16,
        color: AppColors.darkText,
      );

  static TextStyle get wordListFound => GoogleFonts.poppins(
        fontSize: 16,
        color: AppColors.success,
        decoration: TextDecoration.lineThrough,
      );

  static TextStyle get button => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      );

  static TextStyle get coinsScore => GoogleFonts.orbitron(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.gold,
      );

  static TextStyle timer({required bool danger}) => GoogleFonts.orbitron(
        fontSize: 24,
        color: danger ? AppColors.timerDanger : Colors.white,
      );

  static TextStyle get subtitle => GoogleFonts.poppins(
        fontSize: 14,
        color: Colors.white70,
      );

  static TextStyle get appBarTitle => GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      );
}
