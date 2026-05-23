import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:word_game/core/constants/asset_paths.dart';
import 'package:word_game/core/theme/app_colors.dart';

/// Full-screen scenic photo with soft blur and gradient (Word Search Journey style).
class ScenicBackground extends StatelessWidget {
  const ScenicBackground({
    super.key,
    this.imageAsset,
    this.child,
    this.blurSigma = 0,
    this.darken = 0.35,
  });

  final String? imageAsset;
  final Widget? child;
  final double blurSigma;
  final double darken;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _BackgroundImage(
          asset: imageAsset ?? AssetPaths.splashBg,
          blurSigma: blurSigma,
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: darken * 0.5),
                Colors.black.withValues(alpha: darken * 0.25),
                Colors.black.withValues(alpha: darken),
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
  const _BackgroundImage({required this.asset, required this.blurSigma});

  final String asset;
  final double blurSigma;

  @override
  Widget build(BuildContext context) {
    Widget image = Image.asset(
      asset,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
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
