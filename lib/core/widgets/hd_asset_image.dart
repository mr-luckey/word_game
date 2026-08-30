import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Full-bleed HD asset image — sharp on high-DPI phones (treasure screen quality).
class HdAssetImage extends StatelessWidget {
  const HdAssetImage({
    super.key,
    required this.asset,
    this.fit = BoxFit.cover,
    this.opacity = 1,
    this.fallback,
  });

  final String asset;
  final BoxFit fit;
  final double opacity;
  final Widget? fallback;

  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final size = MediaQuery.sizeOf(context);
    // Landscape photos covering a portrait screen need extra decode width
    // so BoxFit.cover never upscales a short edge.
    final longest = math.max(size.width, size.height);
    final cacheWidth = (longest * dpr * 16 / 9).round().clamp(1440, 4096);

    Widget image = Image.asset(
      asset,
      fit: fit,
      alignment: Alignment.center,
      filterQuality: FilterQuality.high,
      isAntiAlias: true,
      gaplessPlayback: true,
      cacheWidth: cacheWidth,
      errorBuilder: (_, __, ___) =>
          fallback ?? const ColoredBox(color: Color(0xFF1A2438)),
    );

    if (opacity < 1) {
      image = Opacity(opacity: opacity, child: image);
    }

    return image;
  }
}
