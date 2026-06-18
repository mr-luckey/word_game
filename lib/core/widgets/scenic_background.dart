import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:word_game/core/constants/asset_paths.dart';
import 'package:word_game/core/constants/scenic_background_style.dart';
import 'package:word_game/core/theme/app_theme_extension.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/core/widgets/hd_asset_image.dart';
import 'package:word_game/core/widgets/journey_theme_kit.dart';

class ScenicBackground extends StatelessWidget {
  const ScenicBackground({
    super.key,
    this.imageAsset,
    this.child,
    this.blurSigma = ScenicBackgroundStyle.hdBlur,
    this.darken = ScenicBackgroundStyle.hdDarken,
    this.colors,
    this.showBackgroundImage = true,
    this.useHdDefaults = true,
  });

  /// Full-screen scenic background with HD defaults (treasure screen quality).
  factory ScenicBackground.hd({
    Key? key,
    String? imageAsset,
    Widget? child,
    double darken = ScenicBackgroundStyle.hdDarken,
    AppThemeColors? colors,
  }) {
    return ScenicBackground(
      key: key,
      imageAsset: imageAsset,
      blurSigma: ScenicBackgroundStyle.hdBlur,
      darken: darken,
      colors: colors,
      useHdDefaults: true,
      child: child,
    );
  }

  final String? imageAsset;
  final Widget? child;
  final double blurSigma;
  final double darken;
  final AppThemeColors? colors;
  final bool showBackgroundImage;
  final bool useHdDefaults;

  @override
  Widget build(BuildContext context) {
    final c = colors ?? context.appColors;
    final preset = context.themePreset;
    final spec = preset.homeSpec;
    final asset = imageAsset ??
        (useHdDefaults
            ? ScenicBackgroundStyle.hdAssetFor(preset)
            : AssetPaths.themeSplash(preset));

    return Stack(
      fit: StackFit.expand,
      children: [
        if (showBackgroundImage && c.useScenicImages)
          _BackgroundImage(
            asset: asset,
            blurSigma: blurSigma,
            fallbackGradient: c.primaryGradient,
          )
        else
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: c.solidBackground ?? c.primaryGradient,
            ),
          ),
        if (showBackgroundImage)
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
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topCenter,
              radius: 1.2,
              colors: [
                spec.playButtonGlow.withValues(alpha: 0.13),
                Colors.transparent,
              ],
            ),
          ),
        ),
        Positioned(
          top: 54,
          left: 0,
          right: 0,
          child: IgnorePointer(
            child: Center(
              child: Opacity(
                opacity: 0.16,
                child: CompassBadge(size: 78, dimmed: true),
              ),
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
    Widget image = HdAssetImage(
      asset: asset,
      fallback: DecoratedBox(
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
