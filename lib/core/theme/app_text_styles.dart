import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:word_game/core/theme/theme_context.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle gameTitle(BuildContext context) => GoogleFonts.montserrat(
        fontSize: 36,
        fontWeight: FontWeight.w900,
        color: context.appColors.onScenic,
      );

  static TextStyle levelName(BuildContext context) => GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: context.appColors.onSurface,
      );

  static TextStyle gridLetter(BuildContext context, double gridSize) =>
      GoogleFonts.robotoMono(
        fontSize: gridSize <= 8 ? 22 : gridSize <= 10 ? 20 : 18,
        fontWeight: FontWeight.w700,
        color: context.appColors.onSurface,
      );

  static TextStyle wordList(BuildContext context) => GoogleFonts.poppins(
        fontSize: 16,
        color: context.appColors.onSurface,
      );

  static TextStyle wordListFound(BuildContext context) => GoogleFonts.poppins(
        fontSize: 16,
        color: context.appColors.success,
        decoration: TextDecoration.lineThrough,
      );

  static TextStyle button(BuildContext context) => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: context.appColors.onPrimary,
      );

  static TextStyle coinsScore(BuildContext context) => GoogleFonts.orbitron(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: context.appColors.gold,
      );

  static TextStyle timer(BuildContext context, {required bool danger}) =>
      GoogleFonts.orbitron(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: danger ? context.appColors.timerDanger : context.appColors.onScenic,
      );

  static TextStyle wordChip(BuildContext context) => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: context.appColors.onSurface,
      );

  static TextStyle wordChipFound(BuildContext context) => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: context.appColors.success,
        decoration: TextDecoration.lineThrough,
      );

  static TextStyle subtitle(BuildContext context) => GoogleFonts.poppins(
        fontSize: 14,
        color: context.appColors.onScenicMuted,
      );

  static TextStyle appBarTitle(BuildContext context) => GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: context.appColors.onScenic,
      );
}
