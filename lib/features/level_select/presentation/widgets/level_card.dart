import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:word_game/core/theme/theme_context.dart';

class LevelCard extends StatelessWidget {
  const LevelCard({
    super.key,
    required this.levelNumber,
    required this.stars,
    required this.locked,
    this.isActive = false,
    this.onTap,
  });

  final int levelNumber;
  final int stars;
  final bool locked;
  final bool isActive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final spec = context.themePreset.homeSpec;
    final completed = !locked && stars > 0;

    // Active tile gets accent gradient, completed gets gold, locked gets dark
    BoxDecoration decoration;
    if (locked) {
      decoration = BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.levelLockedStart, colors.levelLockedEnd],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: colors.glassBorder.withValues(alpha: 0.2),
          width: 1,
        ),
      );
    } else if (isActive) {
      decoration = BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            spec.playButtonGlow.withValues(alpha: 0.9),
            spec.playButtonGlow,
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: colors.onScenic.withValues(alpha: 0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: spec.playButtonGlow.withValues(alpha: 0.5),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      );
    } else if (completed) {
      decoration = BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.levelCompleteStart, colors.levelCompleteEnd],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: colors.gold.withValues(alpha: 0.5),
          width: 1,
        ),
      );
    } else {
      decoration = BoxDecoration(
        color: colors.surface.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: colors.glassBorder.withValues(alpha: 0.4),
          width: 1,
        ),
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          decoration: decoration,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (locked)
                  Icon(
                    Icons.lock_rounded,
                    color: colors.locked.withValues(alpha: 0.6),
                    size: 24,
                  )
                else
                  Text(
                    '$levelNumber',
                    style: GoogleFonts.cinzel(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: isActive
                          ? const Color(0xFF001021)
                          : colors.onScenic,
                    ),
                  ),
                const SizedBox(height: 5),
                // Stars row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (i) {
                    final filled = !locked && i < stars;
                    return Icon(
                      filled
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      size: 10,
                      color: locked
                          ? colors.locked.withValues(alpha: 0.35)
                          : filled
                              ? (isActive
                                  ? const Color(0xFF001021)
                                  : colors.gold)
                              : colors.gold.withValues(
                                  alpha: isActive ? 0.5 : 0.35),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 280.ms).scale(
          begin: const Offset(0.9, 0.9),
          end: const Offset(1, 1),
          curve: Curves.easeOutBack,
        );
  }
}
