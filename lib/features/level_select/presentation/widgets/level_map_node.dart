import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:word_game/core/theme/theme_context.dart';

/// Level pin on Candy Crush–style adventure map.
class LevelMapNode extends StatelessWidget {
  const LevelMapNode({
    super.key,
    required this.levelNumber,
    required this.stars,
    required this.locked,
    required this.isActive,
    required this.isCompleted,
    this.onTap,
    this.size = 58,
    this.showPulse = true,
  });

  final int levelNumber;
  final int stars;
  final bool locked;
  final bool isActive;
  final bool isCompleted;
  final VoidCallback? onTap;
  final double size;
  final bool showPulse;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final spec = context.themePreset.homeSpec;
    final nodeSize = isActive ? size + 6 : size;

    Color fill;
    Color border;
    List<BoxShadow> shadows;
    Widget centerChild;

    if (locked) {
      fill = colors.surface.withValues(alpha: 0.9);
      border = colors.locked.withValues(alpha: 0.55);
      shadows = [
        BoxShadow(
          color: colors.scrim.withValues(alpha: 0.3),
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ];
      centerChild = Icon(
        Icons.lock_rounded,
        color: colors.locked,
        size: nodeSize * 0.36,
      );
    } else if (isActive) {
      fill = colors.gold;
      border = colors.goldLight;
      shadows = [
        BoxShadow(
          color: spec.playButtonGlow.withValues(alpha: 0.75),
          blurRadius: 16,
          spreadRadius: 1,
        ),
      ];
      centerChild = Text(
        '$levelNumber',
        style: GoogleFonts.cinzel(
          fontSize: nodeSize * 0.42,
          fontWeight: FontWeight.w900,
          color: colors.onPrimary,
        ),
      );
    } else if (isCompleted) {
      fill = colors.onScenic;
      border = colors.success;
      shadows = [
        BoxShadow(
          color: colors.success.withValues(alpha: 0.35),
          blurRadius: 8,
        ),
      ];
      centerChild = Stack(
        alignment: Alignment.center,
        children: [
          Text(
            '$levelNumber',
            style: GoogleFonts.cinzel(
              fontSize: nodeSize * 0.34,
              fontWeight: FontWeight.w800,
              color: colors.primary.withValues(alpha: 0.35),
            ),
          ),
          Icon(
            Icons.check_circle_rounded,
            color: colors.success,
            size: nodeSize * 0.44,
          ),
        ],
      );
    } else {
      fill = colors.onScenic;
      border = colors.primary.withValues(alpha: 0.5);
      shadows = [
        BoxShadow(
          color: colors.scrim.withValues(alpha: 0.28),
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ];
      centerChild = Text(
        '$levelNumber',
        style: GoogleFonts.cinzel(
          fontSize: nodeSize * 0.38,
          fontWeight: FontWeight.w800,
          color: colors.primary,
        ),
      );
    }

    Widget circle = SizedBox(
      width: nodeSize,
      height: nodeSize,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: fill,
          border: Border.all(
            color: border,
            width: isActive ? 3.5 : 2.5,
          ),
          boxShadow: shadows,
        ),
        child: Center(child: centerChild),
      ),
    );

    final column = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        circle,
        if (!locked && !isActive && stars > 0) ...[
          const SizedBox(height: 3),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(3, (i) {
              final filled = i < stars;
              return Icon(
                filled ? Icons.star_rounded : Icons.star_outline_rounded,
                size: 11,
                color: filled ? colors.gold : colors.onScenicMuted,
              );
            }),
          ),
        ],
      ],
    );

    if (onTap == null) return column;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: column,
      ),
    );
  }
}
