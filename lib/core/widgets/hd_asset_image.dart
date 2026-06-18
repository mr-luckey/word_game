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
    final width = MediaQuery.sizeOf(context).width;
    final cacheWidth = (width * dpr).round().clamp(720, 4096);

    Widget image = Image.asset(
      asset,
      fit: fit,
      filterQuality: FilterQuality.high,
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
