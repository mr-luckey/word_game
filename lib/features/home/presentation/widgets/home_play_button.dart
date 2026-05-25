import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:word_game/core/theme/theme_context.dart';

class HomePlayButton extends StatelessWidget {
  const HomePlayButton({
    super.key,
    required this.onPressed,
    this.height = 56,
  });

  final VoidCallback? onPressed;
  final double height;

  @override
  Widget build(BuildContext context) {
    final preset = context.themePreset;
    final spec = preset.homeSpec;
    final colors = context.appColors;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(30),
          child: Ink(
            height: height,
            decoration: BoxDecoration(
              gradient: spec.playButtonGradient,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: spec.playWoodAccent
                    ? const Color(0xFF2E7D32)
                    : spec.playButtonGlow.withValues(alpha: 0.85),
                width: spec.playWoodAccent ? 2 : 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: spec.playButtonGlow.withValues(alpha: 0.55),
                  blurRadius: preset.useNeonGlow ? 22 : 18,
                  spreadRadius: preset.useNeonGlow ? 1 : 0,
                  offset: const Offset(0, 5),
                ),
                if (spec.playWoodAccent)
                  BoxShadow(
                    color: colors.success.withValues(alpha: 0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
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
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'PLAY NOW',
                      maxLines: 1,
                      style: GoogleFonts.cinzel(
                        fontSize: height < 52 ? 16 : 19,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2.5,
                        color: spec.playButtonTextColor,
                      ),
                    ),
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
