import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:word_game/core/constants/asset_paths.dart';
import 'package:word_game/core/theme/theme_context.dart';

/// Themed treasure chest artwork (PNG) used on home & daily rewards.
class TreasureChestImage extends StatelessWidget {
  const TreasureChestImage({
    super.key,
    required this.size,
    this.animate = false,
    this.glowColor,
  });

  final double size;
  final bool animate;
  final Color? glowColor;

  @override
  Widget build(BuildContext context) {
    final spec = context.themePreset.homeSpec;
    final glow = glowColor ?? spec.dailyBonusAccent;

    Widget chest = Image.asset(
      AssetPaths.treasureChestImage,
      width: size,
      height: size,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      errorBuilder: (_, __, ___) => Icon(
        Icons.inventory_2_rounded,
        size: size * 0.85,
        color: glow,
      ),
    );

    chest = DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: glow.withValues(alpha: animate ? 0.55 : 0.35),
            blurRadius: size * 0.22,
            spreadRadius: size * 0.02,
          ),
        ],
      ),
      child: chest,
    );

    if (animate) {
      chest = chest
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .scale(
            begin: const Offset(1, 1),
            end: const Offset(1.07, 1.07),
            duration: 1100.ms,
            curve: Curves.easeInOut,
          )
          .shimmer(
            duration: 2000.ms,
            color: glow.withValues(alpha: 0.4),
          );
    }

    return chest;
  }
}
