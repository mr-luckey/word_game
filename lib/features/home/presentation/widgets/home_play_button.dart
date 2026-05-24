import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:word_game/core/theme/theme_context.dart';

class HomePlayButton extends StatelessWidget {
  const HomePlayButton({super.key, required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final spec = context.themePreset.homeSpec;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(30),
          child: Ink(
            height: 56,
            decoration: BoxDecoration(
              gradient: spec.playButtonGradient,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: spec.playButtonGlow.withValues(alpha: 0.85),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: spec.playButtonGlow.withValues(alpha: 0.55),
                  blurRadius: 18,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  spec.playUsesCompass
                      ? Icons.explore_rounded
                      : Icons.play_arrow_rounded,
                  size: 30,
                  color: spec.playIconLight
                      ? Colors.white
                      : spec.playButtonTextColor,
                ),
                const SizedBox(width: 10),
                Text(
                  'PLAY NOW',
                  style: GoogleFonts.cinzel(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2.5,
                    color: spec.playButtonTextColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: 120.ms, duration: 450.ms)
        .scale(
          begin: const Offset(0.94, 0.94),
          end: const Offset(1, 1),
          curve: Curves.easeOutBack,
        );
  }
}
