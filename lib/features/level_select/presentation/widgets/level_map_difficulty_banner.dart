import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Section label on the adventure map (Easy / Medium / Hard / Pro).
class LevelMapDifficultyBanner extends StatelessWidget {
  const LevelMapDifficultyBanner({
    super.key,
    required this.label,
    required this.color,
    this.compact = false,
  });

  final String label;
  final Color color;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 10 : 14,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.95),
            color.withValues(alpha: 0.72),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.55), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.45),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _iconForLabel(label),
            size: compact ? 14 : 16,
            color: Colors.white,
          ),
          const SizedBox(width: 6),
          Text(
            label.toUpperCase(),
            style: GoogleFonts.montserrat(
              fontSize: compact ? 10 : 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconForLabel(String label) {
    return switch (label.toLowerCase()) {
      'easy' => Icons.terrain_rounded,
      'medium' => Icons.hiking_rounded,
      'hard' => Icons.landscape_rounded,
      'pro' => Icons.emoji_events_rounded,
      _ => Icons.flag_rounded,
    };
  }
}
