import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/features/home/presentation/widgets/home_glass_card.dart';

/// Shared shell for Daily Bonus / Achievements — matches travel mockup cards.
class HomeSideActionCard extends StatelessWidget {
  const HomeSideActionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.accentColor,
    this.leading,
    this.trailing,
    required this.body,
    required this.footer,
    this.onTap,
    this.height,
  });

  final String title;
  final String subtitle;
  final Color accentColor;
  final Widget? leading;
  final Widget? trailing;
  final Widget body;
  final Widget footer;
  final VoidCallback? onTap;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final spec = context.themePreset.homeSpec;

    return HomeGlassCard(
      onTap: onTap,
      height: height,
      radius: 18,
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (leading != null) ...[leading!, const SizedBox(width: 8)],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.montserrat(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: accentColor,
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.montserrat(
                        fontSize: 8,
                        height: 1.2,
                        fontWeight: FontWeight.w500,
                        color: colors.onScenicMuted,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            decoration: BoxDecoration(
              color: colors.tertiary.withValues(alpha: 0.82),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colors.glassBorder.withValues(alpha: 0.4),
              ),
              boxShadow: [
                BoxShadow(
                  color: colors.scrim.withValues(alpha: 0.35),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: body,
          ),
          const Spacer(),
          footer,
          if (spec.useNeonCardGlow) const SizedBox(height: 2),
        ],
      ),
    );
  }
}

class HomeSideIconBadge extends StatelessWidget {
  const HomeSideIconBadge({
    super.key,
    required this.icon,
    required this.accentColor,
    this.size = 44,
  });

  final IconData icon;
  final Color accentColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.primary.withValues(alpha: 0.85),
            colors.primary,
            colors.tertiary.withValues(alpha: 0.9),
          ],
        ),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.65),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.35),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Icon(icon, color: accentColor, size: size * 0.52),
    );
  }
}
