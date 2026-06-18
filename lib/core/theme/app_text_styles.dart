import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:word_game/core/theme/theme_context.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle gameTitle(BuildContext context) => GoogleFonts.poppins(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        color: context.appColors.onScenic,
        letterSpacing: 1,
      );

  static TextStyle gameSubtitle(BuildContext context) => GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: context.appColors.bodyMuted,
        letterSpacing: 2,
      );

  static TextStyle sectionHeading(BuildContext context) => GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: context.appColors.gold,
      );

  static TextStyle levelName(BuildContext context) => GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: context.appColors.onScenic,
      );

  static TextStyle gridLetter(BuildContext context, double gridSize) =>
      GoogleFonts.poppins(
        fontSize: gridSize <= 8 ? 22 : gridSize <= 10 ? 20 : 18,
        fontWeight: FontWeight.w700,
        color: context.appColors.onSurface,
      );

  static TextStyle wordList(BuildContext context) => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: context.appColors.onScenic,
      );

  static TextStyle wordListFound(BuildContext context) => GoogleFonts.poppins(
        fontSize: 14,
        color: context.appColors.success,
        decoration: TextDecoration.lineThrough,
      );

  static TextStyle button(BuildContext context) => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: context.appColors.onPrimary,
      );

  static TextStyle coinsScore(BuildContext context) => GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: context.appColors.accentCoin,
      );

  static TextStyle timer(BuildContext context, {required bool danger}) =>
      GoogleFonts.poppins(
        fontSize: danger ? 16 : 14,
        fontWeight: FontWeight.w700,
        color: danger ? Colors.white : context.appColors.onScenic,
      );

  static TextStyle wordChip(BuildContext context) => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: context.appColors.onSurface,
      );

  static TextStyle subtitle(BuildContext context) => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: context.appColors.onScenicMuted,
      );

  static TextStyle greeting(BuildContext context) => GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: context.appColors.gold,
      );

  static TextStyle bodyMuted(BuildContext context) => GoogleFonts.poppins(
        fontSize: 13,
        color: context.appColors.bodyMuted,
      );

  static TextStyle wordChipFound(BuildContext context) =>
      wordListFound(context);

  static TextStyle appBarTitle(BuildContext context) =>
      sectionHeading(context);
}
