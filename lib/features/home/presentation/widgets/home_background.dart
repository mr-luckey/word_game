import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:word_game/core/constants/asset_paths.dart';
import 'package:word_game/core/theme/theme_context.dart';

/// Full-screen themed background — splash + grid overlay + vignette.
class HomeBackground extends StatelessWidget {
  const HomeBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final preset = context.themePreset;
    final colors = context.appColors;

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
