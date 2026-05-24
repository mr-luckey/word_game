import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/features/home/presentation/widgets/home_glass_card.dart';

/// Featured destination — Paris full-bleed / Safari·Tokyo split glass (mockup).
class HomeFeaturedCard extends StatelessWidget {
  const HomeFeaturedCard({
    super.key,
    required this.title,
    required this.completed,
    required this.total,
    required this.imageAsset,
    this.onTap,
  });

  final String title;
  final int completed;
  final int total;
  final String imageAsset;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final preset = context.themePreset;
    final spec = preset.homeSpec;
    final pct = total > 0 ? ((completed / total) * 100).round() : 0;
    final (line1, line2) = preset.splitDestinationTitle(title);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: spec.featuredLayout == HomeFeaturedLayout.fullBleed
          ? _FullBleedCard(
              line1: line1,
              line2: line2,
              completed: completed,
              total: total,
              pct: pct,
              imageAsset: imageAsset,
              onTap: onTap,
            )
          : _SplitGlassCard(
              line1: line1,
              line2: line2,
              completed: completed,
              total: total,
              pct: pct,
              imageAsset: imageAsset,
              onTap: onTap,
            ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.05, end: 0);
  }
}

class _FeaturedLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final spec = context.themePreset.homeSpec;
    return Row(
      children: [
        Icon(spec.featuredLabelIcon, size: 11, color: colors.gold),
        const SizedBox(width: 4),
        Text(
          'FEATURED DESTINATION',
          style: GoogleFonts.montserrat(
            fontSize: 8.5,
            fontWeight: FontWeight.w700,
            color: colors.gold,
            letterSpacing: 1.1,
          ),
        ),
      ],
    );
  }
}

class _DestinationTitle extends StatelessWidget {
  const _DestinationTitle({required this.line1, required this.line2});

  final String line1;
  final String line2;

  @override
  Widget build(BuildContext context) {
    final spec = context.themePreset.homeSpec;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          line1,
          style: GoogleFonts.cinzel(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: spec.featuredLine1Color,
            height: 1.05,
            shadows: const [Shadow(color: Colors.black54, blurRadius: 6)],
          ),
        ),
        if (line2.isNotEmpty)
          Text(
            line2,
            style: GoogleFonts.cinzel(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: spec.featuredLine2Color,
              height: 1.05,
              shadows: const [Shadow(color: Colors.black54, blurRadius: 6)],
            ),
          ),
      ],
    );
  }
}

class _StarSeparator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Icon(Icons.star_rounded, size: 12, color: context.appColors.gold);
  }
}

class _ProgressFooter extends StatelessWidget {
  const _ProgressFooter({
    required this.completed,
    required this.total,
    required this.pct,
  });

  final int completed;
  final int total;
  final int pct;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Levels Completed',
              style: GoogleFonts.montserrat(
                fontSize: 9,
                color: colors.onScenicMuted,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$completed',
                    style: GoogleFonts.cinzel(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: colors.gold,
                    ),
                  ),
                  TextSpan(
                    text: ' / $total',
                    style: GoogleFonts.cinzel(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: colors.onScenic,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: colors.scrim.withValues(alpha: 0.65),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: colors.glassBorder, width: 1),
          ),
          child: Text(
            '$pct%',
            style: GoogleFonts.montserrat(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: colors.gold,
            ),
          ),
        ),
      ],
    );
  }
}

class _StampBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colors.onScenic.withValues(alpha: 0.12),
        border: Border.all(color: colors.onScenic.withValues(alpha: 0.35)),
      ),
      child: Icon(
        Icons.verified_rounded,
        color: colors.onScenic.withValues(alpha: 0.55),
        size: 26,
      ),
    );
  }
}

class _FullBleedCard extends StatelessWidget {
  const _FullBleedCard({
    required this.line1,
    required this.line2,
    required this.completed,
    required this.total,
    required this.pct,
    required this.imageAsset,
    this.onTap,
  });

  final String line1;
  final String line2;
  final int completed;
  final int total;
  final int pct;
  final String imageAsset;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final spec = context.themePreset.homeSpec;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: colors.glassBorder,
              width: spec.cardBorderWidth,
            ),
            boxShadow: [
              BoxShadow(
                color: spec.playButtonGlow.withValues(alpha: 0.25),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(19),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(imageAsset, fit: BoxFit.cover),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        colors.scrim.withValues(alpha: 0.88),
                        colors.scrim.withValues(alpha: 0.45),
                        colors.scrim.withValues(alpha: 0.2),
                      ],
                      stops: const [0.0, 0.55, 1.0],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _FeaturedLabel(),
                      const SizedBox(height: 8),
                      _DestinationTitle(line1: line1, line2: line2),
                      const Spacer(),
                      _StarSeparator(),
                      const SizedBox(height: 8),
                      _ProgressFooter(
                        completed: completed,
                        total: total,
                        pct: pct,
                      ),
                    ],
                  ),
                ),
                Positioned(top: 10, right: 10, child: _StampBadge()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SplitGlassCard extends StatelessWidget {
  const _SplitGlassCard({
    required this.line1,
    required this.line2,
    required this.completed,
    required this.total,
    required this.pct,
    required this.imageAsset,
    this.onTap,
  });

  final String line1;
  final String line2;
  final int completed;
  final int total;
  final int pct;
  final String imageAsset;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return HomeGlassCard(
      onTap: onTap,
      radius: 18,
      height: 188,
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            flex: 12,
            child: Padding(
              padding: const EdgeInsets.only(left: 4, right: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FeaturedLabel(),
                  const SizedBox(height: 8),
                  _DestinationTitle(line1: line1, line2: line2),
                  const Spacer(),
                  _StarSeparator(),
                  const SizedBox(height: 8),
                  _ProgressFooter(
                    completed: completed,
                    total: total,
                    pct: pct,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 11,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(imageAsset, fit: BoxFit.cover),
                ),
                Positioned(top: 4, right: 4, child: _StampBadge()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
