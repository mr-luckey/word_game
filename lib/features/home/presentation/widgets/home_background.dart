import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:word_game/core/constants/asset_paths.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/core/widgets/journey_theme_kit.dart';

/// Full-screen themed background — splash + grid overlay + vignette.
class HomeBackground extends StatelessWidget {
  const HomeBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final preset = context.themePreset;
    final colors = context.appColors;
    final spec = preset.homeSpec;

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          AssetPaths.themeSplash(preset),
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => DecoratedBox(
            decoration: BoxDecoration(gradient: colors.primaryGradient),
          ),
        ),
        Opacity(
          opacity: 0.32,
          child: Image.asset(
            preset.homeBackgroundAsset,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                colors.scrim.withValues(alpha: 0.2),
                colors.scrim.withValues(alpha: 0.42),
                colors.scrim.withValues(alpha: 0.62),
              ],
            ),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topCenter,
              radius: 1.1,
              colors: [
                spec.playButtonGlow.withValues(alpha: 0.16),
                Colors.transparent,
              ],
            ),
          ),
        ),
        Positioned(
          top: 74,
          left: 0,
          right: 0,
          child: IgnorePointer(
            child: Opacity(
              opacity: 0.15,
              child: Center(child: CompassBadge(size: 96, dimmed: true)),
            ),
          ),
        ),
        if (preset.useGlassmorphism)
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
            child: const SizedBox.expand(),
          ),
        child,
      ],
    );
  }
}
