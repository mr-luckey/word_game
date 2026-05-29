import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:word_game/core/theme/theme_context.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle gameTitle(BuildContext context) => GoogleFonts.cinzel(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        color: context.appColors.onScenic,
        letterSpacing: 2,
      );

  static TextStyle gameSubtitle(BuildContext context) => GoogleFonts.montserrat(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: context.appColors.bodyMuted,
        letterSpacing: 4,
      );

  static TextStyle sectionHeading(BuildContext context) => GoogleFonts.cinzel(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: context.appColors.gold,
      );

  static TextStyle levelName(BuildContext context) => GoogleFonts.montserrat(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: context.appColors.onScenic,
        letterSpacing: 1,
      );

  static TextStyle gridLetter(BuildContext context, double gridSize) =>
      GoogleFonts.robotoMono(
        fontSize: gridSize <= 8 ? 22 : gridSize <= 10 ? 20 : 18,
        fontWeight: FontWeight.w700,
        color: context.appColors.onSurface,
      );

  static TextStyle wordList(BuildContext context) => GoogleFonts.montserrat(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: context.appColors.onScenic,
      );

  static TextStyle wordListFound(BuildContext context) => GoogleFonts.montserrat(
        fontSize: 14,
        color: context.appColors.success,
        decoration: TextDecoration.lineThrough,
      );

  static TextStyle button(BuildContext context) => GoogleFonts.montserrat(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: context.appColors.onPrimary,
        letterSpacing: 1,
      );

  static TextStyle coinsScore(BuildContext context) => GoogleFonts.orbitron(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: context.appColors.accentCoin,
      );

  static TextStyle timer(BuildContext context, {required bool danger}) =>
      GoogleFonts.orbitron(
        fontSize: danger ? 16 : 14,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
        color: danger ? Colors.white : context.appColors.onScenic,
        shadows: danger
            ? const [
                Shadow(
                  color: Color(0x99000000),
                  blurRadius: 4,
                  offset: Offset(0, 1),
                ),
              ]
            : null,
      );

  static TextStyle wordChip(BuildContext context) => GoogleFonts.montserrat(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: context.appColors.onSurface,
      );

  static TextStyle subtitle(BuildContext context) => GoogleFonts.montserrat(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: context.appColors.onScenicMuted,
      );

  static TextStyle greeting(BuildContext context) => GoogleFonts.cinzel(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: context.appColors.gold,
      );

  static TextStyle bodyMuted(BuildContext context) => GoogleFonts.montserrat(
        fontSize: 13,
        color: context.appColors.bodyMuted,
      );

  static TextStyle wordChipFound(BuildContext context) =>
      wordListFound(context);

  static TextStyle appBarTitle(BuildContext context) =>
      sectionHeading(context);
}
