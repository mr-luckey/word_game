import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:word_game/core/theme/theme_context.dart';

/// Hint / Reveal / Shuffle buttons — matches design mockup exactly.
class ToolCircleButton extends StatelessWidget {
  const ToolCircleButton({
    super.key,
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final String subtitle;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final spec = context.themePreset.homeSpec;

    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colors.surface.withValues(alpha: 0.95),
                  colors.surface.withValues(alpha: 0.75),
                ],
              ),
              border: Border.all(
                color: spec.playButtonGlow.withValues(alpha: 0.45),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: spec.playButtonGlow.withValues(alpha: 0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: colors.scrim.withValues(alpha: 0.25),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(icon, color: spec.playButtonGlow, size: 26),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: colors.onScenic,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.monetization_on_rounded,
                  color: colors.gold, size: 11),
              const SizedBox(width: 2),
              Text(
                subtitle,
                style: GoogleFonts.montserrat(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: colors.gold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
