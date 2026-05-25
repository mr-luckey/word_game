import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/core/widgets/journey_theme_kit.dart';

/// Centered WORD SEARCH / JOURNEY + plane + tagline — [deisgn/home] mockup.
class HomeBrandTitle extends StatelessWidget {
  const HomeBrandTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final spec = context.themePreset.homeSpec;
    final colors = context.appColors;
    final width = MediaQuery.sizeOf(context).width;
    final compact = width < 360;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 2, 16, compact ? 4 : 6),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'WORD SEARCH',
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: GoogleFonts.cinzel(
                          fontSize: compact ? 22 : 25,
                          fontWeight: FontWeight.w700,
                          color: spec.searchWordColor,
                          letterSpacing: 3,
                          height: 1.1,
                          shadows: JourneyThemeKit.textGlow(context),
                        ),
                      ),
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'JOURNEY',
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: GoogleFonts.cinzel(
                          fontSize: compact ? 29 : 34,
                          fontWeight: FontWeight.w800,
                          color: spec.journeyWordColor,
                          letterSpacing: 5,
                          height: 1.05,
                          shadows:
                              JourneyThemeKit.textGlow(context, strength: 1.2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 4,
                top: compact ? 20 : 26,
                child: Icon(
                  Icons.flight_rounded,
                  size: compact ? 18 : 22,
                  color: spec.journeyWordColor.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
          SizedBox(height: compact ? 6 : 8),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 1,
                  color: colors.glassBorder.withValues(alpha: 0.45),
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.public_rounded,
                        size: compact ? 11 : 12,
                        color: spec.taglineColor,
                      ),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          'Travel the world with words',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            fontSize: compact ? 9 : 10,
                            fontWeight: FontWeight.w600,
                            color: spec.taglineColor,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ],
                  ),
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
