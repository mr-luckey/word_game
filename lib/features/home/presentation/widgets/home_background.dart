import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:word_game/core/constants/scenic_background_style.dart';
import 'package:word_game/core/theme/app_theme_preset.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/core/widgets/hd_asset_image.dart';
import 'package:word_game/core/widgets/journey_theme_kit.dart';

/// Full-screen themed HD background — splash + grid overlay + vignette.
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
        HdAssetImage(
          asset: ScenicBackgroundStyle.hdAssetFor(preset),
          fallback: DecoratedBox(
            decoration: BoxDecoration(gradient: colors.primaryGradient),
          ),
        ),
        if (preset != AppThemePreset.classicTravel)
          Opacity(
            opacity: 0.22,
            child: HdAssetImage(
              asset: 'assets/images/themes/${preset.folder}/splash.webp',
              fallback: const SizedBox.shrink(),
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
