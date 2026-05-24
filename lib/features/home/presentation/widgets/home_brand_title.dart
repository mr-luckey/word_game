import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:word_game/core/theme/theme_context.dart';

/// "WELCOME BACK! / Ready for your next journey?" — matches design mockup.
class HomeBrandTitle extends StatelessWidget {
  const HomeBrandTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final spec = context.themePreset.homeSpec;
    final colors = context.appColors;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'WELCOME BACK!',
            style: GoogleFonts.montserrat(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: spec.taglineColor,
              letterSpacing: 1.4,
            ),
          ).animate().fadeIn(duration: 400.ms),
          const SizedBox(height: 2),
          Text(
            'Ready for your\nnext journey?',
            style: GoogleFonts.cinzel(
              fontSize: MediaQuery.sizeOf(context).width < 360 ? 22 : 26,
              fontWeight: FontWeight.w800,
              color: colors.onScenic,
              height: 1.12,
              shadows: [
                Shadow(
                  color: colors.scrim.withValues(alpha: 0.6),
                  blurRadius: 8,
                ),
                Shadow(
                  color: spec.playButtonGlow.withValues(alpha: 0.25),
                  blurRadius: 14,
                ),
              ],
            ),
          ).animate(delay: 80.ms).fadeIn(duration: 450.ms),
        ],
      ),
    );
  }
}
