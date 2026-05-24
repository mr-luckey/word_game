import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:word_game/core/theme/theme_context.dart';

/// Glass / dark panel used on home cards — mockup borders + blur.
class HomeGlassCard extends StatelessWidget {
  const HomeGlassCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.radius = 16,
    this.height,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final double radius;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final spec = context.themePreset.homeSpec;

    Widget panel = Container(
      height: height,
      padding: padding ?? const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: spec.cardFill,
        border: Border.all(
          color: colors.glassBorder,
          width: spec.cardBorderWidth,
        ),
        boxShadow: spec.useNeonCardGlow
            ? [
                BoxShadow(
                  color: spec.playButtonGlow.withValues(alpha: 0.4),
                  blurRadius: 12,
                  spreadRadius: 0.5,
                ),
              ]
            : [
                BoxShadow(
                  color: colors.gold.withValues(alpha: 0.12),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: child,
    );

    if (spec.useGlassCards) {
      panel = ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: panel,
        ),
      );
    }

    if (onTap == null) return panel;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: panel,
      ),
    );
  }
}
