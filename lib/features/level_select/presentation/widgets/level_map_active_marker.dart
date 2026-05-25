import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/features/level_select/presentation/widgets/level_map_node.dart';

/// Wraps the current level node with ring + "Play" label (Candy Crush style).
class LevelMapActiveMarker extends StatelessWidget {
  const LevelMapActiveMarker({
    super.key,
    required this.levelNumber,
    required this.stars,
    required this.onTap,
    this.size = 58,
  });

  final int levelNumber;
  final int stars;
  final VoidCallback? onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final spec = context.themePreset.homeSpec;
    final outer = size + 28;

    return SizedBox(
      width: outer + 20,
      height: outer + 36,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                gradient: spec.playButtonGradient,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: colors.goldLight, width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: spec.playButtonGlow.withValues(alpha: 0.55),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.play_arrow_rounded,
                      size: 14, color: spec.playButtonTextColor),
                  const SizedBox(width: 2),
                  Text(
                    'PLAY',
                    style: GoogleFonts.montserrat(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.8,
                      color: spec.playButtonTextColor,
                    ),
                  ),
                ],
              ),
            ),
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .moveY(begin: 0, end: -3, duration: 800.ms),
          Center(
            child: SizedBox(
              width: outer,
              height: outer,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: outer,
                    height: outer,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: spec.playButtonGlow.withValues(alpha: 0.55),
                        width: 3,
                      ),
                    ),
                  )
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .scale(
                        begin: const Offset(0.92, 0.92),
                        end: const Offset(1.05, 1.05),
                        duration: 1200.ms,
                      ),
                  Container(
                    width: outer - 10,
                    height: outer - 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: spec.playButtonGlow.withValues(alpha: 0.2),
                    ),
                  ),
                  LevelMapNode(
                    levelNumber: levelNumber,
                    stars: stars,
                    locked: false,
                    isActive: true,
                    isCompleted: false,
                    onTap: onTap,
                    size: size,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
