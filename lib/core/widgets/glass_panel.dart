import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:word_game/core/theme/app_sizes.dart';
import 'package:word_game/core/theme/theme_context.dart';

class GlassPanel extends StatelessWidget {
  const GlassPanel({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.margin,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final radius = borderRadius ?? BorderRadius.circular(AppSizes.radiusLg);
    final panel = ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: radius,
            color: colors.glassSurface,
            border: Border.all(color: colors.glassBorder, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: colors.shadow,
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(AppSizes.paddingMd),
            child: child,
          ),
        ),
      ),
    );

    if (onTap == null) {
      return Padding(padding: margin ?? EdgeInsets.zero, child: panel);
    }
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: panel,
        ),
      ),
    );
  }
}
