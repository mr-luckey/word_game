import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/core/widgets/journey_theme_kit.dart';

/// Centered WORD SEARCH / JOURNEY + plane + tagline — mockup layout.
class HomeBrandTitle extends StatelessWidget {
  const HomeBrandTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final spec = context.themePreset.homeSpec;
    final colors = context.appColors;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 6),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Column(
                children: [
                  Text(
                    'WORD SEARCH',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cinzel(
                      fontSize:
                          MediaQuery.sizeOf(context).width < 360 ? 22 : 25,
                      fontWeight: FontWeight.w700,
                      color: spec.searchWordColor,
                      letterSpacing: 3,
                      height: 1.1,
                      shadows: JourneyThemeKit.textGlow(context),
                    ),
                  ),
                  Text(
                    'JOURNEY',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cinzel(
                      fontSize:
                          MediaQuery.sizeOf(context).width < 360 ? 29 : 34,
                      fontWeight: FontWeight.w800,
                      color: spec.journeyWordColor,
                      letterSpacing: 5,
                      height: 1.05,
                      shadows: JourneyThemeKit.textGlow(context, strength: 1.2),
                    ),
                  ),
                ],
              ),
              Positioned(
                right: 0,
                top: 24,
                child: CompassBadge(size: 24),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 1,
                  color: colors.glassBorder.withValues(alpha: 0.45),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('— ',
                        style:
                            TextStyle(color: spec.taglineColor, fontSize: 10)),
                    Icon(Icons.public_rounded,
                        size: 13, color: spec.taglineColor),
                    const SizedBox(width: 5),
                    Text(
                      '${context.themePreset.label.toUpperCase()} THEME',
                      style: GoogleFonts.montserrat(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: spec.taglineColor,
                        letterSpacing: 1.9,
                      ),
                    ),
                    Text(' —',
                        style:
                            TextStyle(color: spec.taglineColor, fontSize: 10)),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  height: 1,
                  color: colors.glassBorder.withValues(alpha: 0.45),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
