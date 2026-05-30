import 'package:flutter/material.dart';
import 'package:word_game/core/constants/asset_paths.dart';

/// App brand logo — full-bleed icon art (no white splash canvas padding).
class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    required this.size,
    this.borderRadius = 20,
    this.elevation = 8,
  });

  final double size;
  final double borderRadius;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: elevation,
      shadowColor: Colors.black.withValues(alpha: 0.45),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        AssetPaths.appLogo,
        width: size,
        height: size,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.high,
        errorBuilder: (_, __, ___) => Icon(
          Icons.image_not_supported_outlined,
          size: size * 0.5,
        ),
      ),
    );
  }
}
