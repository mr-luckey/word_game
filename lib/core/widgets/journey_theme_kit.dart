import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:word_game/core/theme/app_sizes.dart';
import 'package:word_game/core/theme/theme_context.dart';

class JourneyThemeKit {
  JourneyThemeKit._();

  static double maxContentWidth(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 700) return 520;
    return double.infinity;
  }

  static EdgeInsets pagePadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontal = width < 360 ? 12.0 : AppSizes.paddingMd;
    return EdgeInsets.symmetric(horizontal: horizontal);
  }

  static Color readableOn(Color background, Color light, Color dark) {
    return background.computeLuminance() > 0.45 ? dark : light;
  }

  static List<Shadow> textGlow(BuildContext context, {double strength = 1}) {
    final colors = context.appColors;
    final spec = context.themePreset.homeSpec;
    return [
      Shadow(
        color: colors.scrim.withValues(alpha: 0.75),
        blurRadius: 8 * strength,
      ),
      Shadow(
        color: spec.playButtonGlow.withValues(alpha: 0.28),
        blurRadius: 14 * strength,
      ),
    ];
  }
}

class JourneyContentWidth extends StatelessWidget {
  const JourneyContentWidth({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: JourneyThemeKit.maxContentWidth(context),
        ),
        child: child,
      ),
    );
  }
}

class JourneyPanel extends StatelessWidget {
  const JourneyPanel({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.radius,
    this.height,
    this.onTap,
    this.opacity = 1,
    this.borderOpacity = 0.8,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? radius;
  final double? height;
  final VoidCallback? onTap;
  final double opacity;
  final double borderOpacity;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final preset = context.themePreset;
    final spec = preset.homeSpec;
    final resolvedRadius = radius ?? preset.cardRadius;

    Widget panel = Container(
      height: height,
      padding: padding ?? const EdgeInsets.all(AppSizes.paddingMd),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(resolvedRadius),
        color: spec.cardFill.withValues(alpha: spec.cardFill.a * opacity),
        border: Border.all(
          color: colors.glassBorder.withValues(alpha: borderOpacity),
          width: spec.cardBorderWidth,
        ),
        boxShadow: [
          BoxShadow(
            color: spec.playButtonGlow.withValues(
              alpha: preset.useNeonGlow ? 0.38 : 0.16,
            ),
            blurRadius: preset.useNeonGlow ? 18 : 14,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: colors.scrim.withValues(alpha: 0.28),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );

    if (spec.useGlassCards) {
      panel = ClipRRect(
        borderRadius: BorderRadius.circular(resolvedRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: panel,
        ),
      );
    }

    final wrapped = Padding(padding: margin ?? EdgeInsets.zero, child: panel);
    if (onTap == null) return wrapped;
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(resolvedRadius),
          child: panel,
        ),
      ),
    );
  }
}

class CompassBadge extends StatelessWidget {
  const CompassBadge({
    super.key,
    this.size = 46,
    this.icon,
    this.dimmed = false,
  });

  final double size;
  final IconData? icon;
  final bool dimmed;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final spec = context.themePreset.homeSpec;
    final color =
        dimmed ? colors.onScenic.withValues(alpha: 0.55) : spec.playButtonGlow;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colors.scrim.withValues(alpha: 0.22),
        border: Border.all(color: color.withValues(alpha: 0.85), width: 1.4),
        boxShadow: [
          BoxShadow(
            color: color.withValues(
                alpha: context.themePreset.useNeonGlow ? 0.5 : 0.2),
            blurRadius: size * 0.24,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
              width: size * 0.82,
              height: 1,
              color: color.withValues(alpha: 0.65)),
          Container(
              width: 1,
              height: size * 0.82,
              color: color.withValues(alpha: 0.65)),
          Transform.rotate(
            angle: 0.78,
            child: Icon(
              icon ?? Icons.explore_rounded,
              color: color,
              size: size * 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class JourneySectionTitle extends StatelessWidget {
  const JourneySectionTitle({
    super.key,
    required this.title,
    this.subtitle,
    this.align = TextAlign.left,
  });

  final String title;
  final String? subtitle;
  final TextAlign align;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Column(
      crossAxisAlignment: align == TextAlign.center
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Text(
          title,
          textAlign: align,
          style: GoogleFonts.cinzel(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
            color: colors.onScenic,
            shadows: JourneyThemeKit.textGlow(context),
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 3),
          Text(
            subtitle!,
            textAlign: align,
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: colors.onScenicMuted,
            ),
          ),
        ],
      ],
    );
  }
}
