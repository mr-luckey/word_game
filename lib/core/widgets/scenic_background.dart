import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:word_game/core/constants/asset_paths.dart';
import 'package:word_game/core/theme/app_theme_extension.dart';
import 'package:word_game/core/theme/theme_context.dart';

class ScenicBackground extends StatelessWidget {
  const ScenicBackground({
    super.key,
    this.imageAsset,
    this.child,
    this.blurSigma = 0,
    this.darken = 0.35,
    this.colors,
  });

  final String? imageAsset;
  final Widget? child;
  final double blurSigma;
  final double darken;
  final AppThemeColors? colors;

  @override
  Widget build(BuildContext context) {
    final c = colors ?? context.appColors;
    return Stack(
      fit: StackFit.expand,
      children: [
        _BackgroundImage(
          asset: imageAsset ?? AssetPaths.splashBg,
          blurSigma: blurSigma,
          fallbackGradient: c.primaryGradient,
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                c.scrim.withValues(alpha: darken * 0.5),
                c.scrim.withValues(alpha: darken * 0.25),
                c.scrim.withValues(alpha: darken),
              ],
            ),
          ),
        ),
        if (child != null) child!,
      ],
    );
  }
}

class _BackgroundImage extends StatelessWidget {
  const _BackgroundImage({
    required this.asset,
    required this.blurSigma,
    required this.fallbackGradient,
  });

  final String asset;
  final double blurSigma;
  final Gradient fallbackGradient;

  @override
  Widget build(BuildContext context) {
    Widget image = Image.asset(
      asset,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => DecoratedBox(
        decoration: BoxDecoration(gradient: fallbackGradient),
      ),
    );
    if (blurSigma > 0) {
      image = ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: image,
      );
    }
    return image;
  }
}
