import 'package:flutter/material.dart';
import 'package:word_game/core/theme/theme_context.dart';

/// Responsive sizes — tuned for split featured cards (Neon / Winter Alps).
class HomeLayoutMetrics {
  HomeLayoutMetrics({
    required this.featuredHeight,
    required this.sideCardHeight,
    required this.playButtonHeight,
    required this.sectionGap,
    required this.compact,
    required this.dense,
    required this.splitFeatured,
  });

  final double featuredHeight;
  final double sideCardHeight;
  final double playButtonHeight;
  final double sectionGap;
  final bool compact;
  final bool dense;
  final bool splitFeatured;

  factory HomeLayoutMetrics.of(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final height = size.height;
    final width = size.width;
    final splitFeatured = context.themePreset.homeSpec.featuredLayout ==
        HomeFeaturedLayout.splitGlass;
    final compact = height < 720 || width < 380;
    final dense = compact || splitFeatured || width < 400;

    double featuredHeight;
    double sideCardHeight;
    double playButtonHeight;
    double sectionGap;

    if (height < 640) {
      featuredHeight = splitFeatured ? 172 : 148;
      sideCardHeight = dense ? 156 : 144;
      playButtonHeight = 46;
      sectionGap = 8;
    } else if (height < 720) {
      featuredHeight = splitFeatured ? 188 : 164;
      sideCardHeight = dense ? 164 : 152;
      playButtonHeight = 50;
      sectionGap = 10;
    } else if (height < 800) {
      featuredHeight = splitFeatured ? 200 : 178;
      sideCardHeight = dense ? 172 : 160;
      playButtonHeight = 52;
      sectionGap = 11;
    } else {
      featuredHeight = splitFeatured ? 212 : 192;
      sideCardHeight = dense ? 180 : 168;
      playButtonHeight = 54;
      sectionGap = 12;
    }

    if (width < 340) {
      featuredHeight -= 8;
      sideCardHeight -= 6;
    }

    return HomeLayoutMetrics(
      featuredHeight: featuredHeight,
      sideCardHeight: sideCardHeight,
      playButtonHeight: playButtonHeight,
      sectionGap: sectionGap,
      compact: compact,
      dense: dense,
      splitFeatured: splitFeatured,
    );
  }
}
