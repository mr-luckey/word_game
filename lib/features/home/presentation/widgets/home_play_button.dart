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

  static const _radius = 28.0;

  @override
  Widget build(BuildContext context) {
    final preset = context.themePreset;
    final spec = preset.homeSpec;
    final colors = context.appColors;

    final shadows = <BoxShadow>[
      BoxShadow(
        color: spec.playButtonGlow.withValues(alpha: 0.55),
        blurRadius: preset.useNeonGlow ? 20 : 16,
        spreadRadius: preset.useNeonGlow ? 0.5 : 0,
        offset: const Offset(0, 4),
      ),
      if (spec.playWoodAccent)
        BoxShadow(
          color: colors.success.withValues(alpha: 0.35),
          blurRadius: 10,
          offset: const Offset(0, 3),
        ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_radius),
          boxShadow: shadows,
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(_radius),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onPressed,
            child: Ink(
              height: height,
              decoration: BoxDecoration(
                gradient: spec.playButtonGradient,
                borderRadius: BorderRadius.circular(_radius),
                border: Border.all(
                  color: spec.playWoodAccent
                      ? const Color(0xFF2E7D32)
                      : spec.playButtonGlow.withValues(alpha: 0.85),
                  width: spec.playWoodAccent ? 2 : 1.5,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    spec.playUsesCompass
                        ? Icons.explore_rounded
                        : Icons.play_arrow_rounded,
                    size: 28,
                    color: spec.playIconLight
                        ? Colors.white
                        : spec.playButtonTextColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'PLAY NOW',
                    maxLines: 1,
                    style: GoogleFonts.cinzel(
                      fontSize: height < 52 ? 15 : 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.8,
                      color: spec.playButtonTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: 120.ms, duration: 450.ms);
  }
}
