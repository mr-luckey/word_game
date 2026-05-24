import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:word_game/core/theme/theme_context.dart';

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
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: spec.searchWordColor,
                      letterSpacing: 3,
                      height: 1.1,
                      shadows: [
                        Shadow(
                          color: colors.scrim.withValues(alpha: 0.6),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'JOURNEY',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cinzel(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: spec.journeyWordColor,
                      letterSpacing: 5,
                      height: 1.05,
                      shadows: [
                        Shadow(
                          color: spec.playButtonGlow.withValues(alpha: 0.55),
                          blurRadius: 14,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                right: 4,
                top: 28,
                child: Icon(
                  Icons.flight_takeoff_rounded,
                  color: spec.journeyWordColor,
                  size: 20,
                ),
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
                    Text('— ', style: TextStyle(color: spec.taglineColor, fontSize: 10)),
                    Icon(Icons.public_rounded, size: 13, color: spec.taglineColor),
                    const SizedBox(width: 5),
                    Text(
                      'Travel the world with words',
                      style: GoogleFonts.montserrat(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: spec.taglineColor,
                        letterSpacing: 0.3,
                      ),
                    ),
                    Text(' —', style: TextStyle(color: spec.taglineColor, fontSize: 10)),
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
