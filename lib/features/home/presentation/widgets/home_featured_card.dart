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
    required this.country,
    required this.completed,
    required this.total,
    required this.imageAsset,
    this.height = 196,
    this.compact = false,
    this.dense = false,
    this.onTap,
  });

  final String title;
  final String country;
  final int completed;
  final int total;
  final String imageAsset;
  final double height;
  final bool compact;
  final bool dense;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final preset = context.themePreset;
    final spec = preset.homeSpec;
    final pct = total > 0 ? ((completed / total) * 100).round() : 0;
    final (line1, line2) = preset.splitDestinationTitle(title);
    final width = MediaQuery.sizeOf(context).width;
    // Split layout overflows on narrow phones — use full-bleed there.
    final useFullBleed = spec.featuredLayout == HomeFeaturedLayout.fullBleed ||
        (spec.featuredLayout == HomeFeaturedLayout.splitGlass &&
            (dense || width < 420));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: useFullBleed
          ? _FullBleedCard(
              line1: line1,
              line2: line2,
              stampLine1: preset.stampLinesFor(title, country).$1,
              stampLine2: preset.stampLinesFor(title, country).$2,
              completed: completed,
              total: total,
              pct: pct,
              imageAsset: imageAsset,
              height: height,
              compact: compact,
              dense: dense,
              onTap: onTap,
            )
          : _SplitGlassCard(
              line1: line1,
              line2: line2,
              stampLine1: preset.stampLinesFor(title, country).$1,
              stampLine2: preset.stampLinesFor(title, country).$2,
              completed: completed,
              total: total,
              pct: pct,
              imageAsset: imageAsset,
              height: height,
              compact: compact,
              dense: dense,
              onTap: onTap,
            ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.05, end: 0);
  }
}

class _FeaturedLabel extends StatelessWidget {
  const _FeaturedLabel({this.dense = false});

  final bool dense;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final spec = context.themePreset.homeSpec;
    return Row(
      children: [
        Icon(spec.featuredLabelIcon, size: dense ? 9 : 11, color: colors.gold),
        const SizedBox(width: 3),
        Expanded(
          child: Text(
            dense ? 'FEATURED' : 'FEATURED DESTINATION',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.montserrat(
              fontSize: dense ? 7 : 8.5,
              fontWeight: FontWeight.w700,
              color: colors.gold,
              letterSpacing: dense ? 0.4 : 1.1,
            ),
          ),
        ),
      ],
    );
  }
}

class _DestinationTitle extends StatelessWidget {
  const _DestinationTitle({
    required this.line1,
    required this.line2,
    this.compact = false,
    this.dense = false,
  });

  final String line1;
  final String line2;
  final bool compact;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final spec = context.themePreset.homeSpec;
    final line1Size = dense ? 16.0 : (compact ? 20.0 : 24.0);
    final line2Size = dense ? 14.0 : (compact ? 17.0 : 20.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          line1,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.cinzel(
            fontSize: line1Size,
            fontWeight: FontWeight.w800,
            color: spec.featuredLine1Color,
            height: 1.05,
            shadows: const [Shadow(color: Colors.black54, blurRadius: 6)],
          ),
        ),
        if (line2.isNotEmpty)
          Text(
            line2,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.cinzel(
              fontSize: line2Size,
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
    this.compact = false,
    this.dense = false,
  });

  final int completed;
  final int total;
  final int pct;
  final bool compact;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final spec = context.themePreset.homeSpec;
    final progress = total > 0 ? completed / total : 0.0;
    final useRing = spec.progressStyle == HomeProgressStyle.ring;
    final ringSize = dense ? 34.0 : (compact ? 38.0 : 44.0);

    Widget percentWidget;
    if (useRing) {
      percentWidget = SizedBox(
        width: ringSize,
        height: ringSize,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CircularProgressIndicator(
              value: progress,
              strokeWidth: dense ? 2.5 : 3,
              backgroundColor: colors.onScenic.withValues(alpha: 0.15),
              valueColor: AlwaysStoppedAnimation(colors.gold),
            ),
            Text(
              '$pct%',
              style: GoogleFonts.montserrat(
                fontSize: dense ? 7 : (compact ? 8 : 9),
                fontWeight: FontWeight.w800,
                color: colors.gold,
              ),
            ),
          ],
        ),
      );
    } else {
      percentWidget = Container(
        padding: EdgeInsets.symmetric(
          horizontal: dense ? 8 : 12,
          vertical: dense ? 3 : 5,
        ),
        decoration: BoxDecoration(
          color: colors.scrim.withValues(alpha: 0.65),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: colors.glassBorder, width: 1),
        ),
        child: Text(
          '$pct%',
          style: GoogleFonts.montserrat(
            fontSize: dense ? 9 : 11,
            fontWeight: FontWeight.w700,
            color: colors.gold,
          ),
        ),
      );
    }

    final levelsLabel = dense ? 'Levels' : 'Levels Completed';
    final countStyle = GoogleFonts.cinzel(
      fontSize: dense ? 15 : (compact ? 18 : 22),
      fontWeight: FontWeight.w800,
      color: colors.gold,
    );
    final totalStyle = GoogleFonts.cinzel(
      fontSize: dense ? 12 : (compact ? 14 : 17),
      fontWeight: FontWeight.w600,
      color: colors.onScenic,
    );

    if (dense) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  levelsLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.montserrat(
                    fontSize: 8,
                    color: colors.onScenicMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 1),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(text: '$completed', style: countStyle),
                        TextSpan(text: ' / $total', style: totalStyle),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          percentWidget,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                levelsLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.montserrat(
                  fontSize: 9,
                  color: colors.onScenicMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text: '$completed', style: countStyle),
                      TextSpan(text: ' / $total', style: totalStyle),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 6),
        percentWidget,
      ],
    );
  }
}

class _StampBadge extends StatelessWidget {
  const _StampBadge({
    required this.line1,
    required this.line2,
    this.small = false,
  });

  final String line1;
  final String line2;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final spec = context.themePreset.homeSpec;
    final size = small ? 40.0 : 48.0;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colors.onScenic.withValues(alpha: 0.1),
        border: Border.all(
          color: colors.glassBorder.withValues(alpha: 0.7),
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(spec.stampIcon, color: colors.gold, size: 14),
          const SizedBox(height: 1),
          Text(
            line1,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.montserrat(
              fontSize: 5.5,
              fontWeight: FontWeight.w800,
              color: colors.onScenic.withValues(alpha: 0.9),
              letterSpacing: 0.3,
            ),
          ),
          Text(
            line2,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.montserrat(
              fontSize: 5,
              fontWeight: FontWeight.w600,
              color: colors.onScenicMuted,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _FullBleedCard extends StatelessWidget {
  const _FullBleedCard({
    required this.line1,
    required this.line2,
    required this.stampLine1,
    required this.stampLine2,
    required this.completed,
    required this.total,
    required this.pct,
    required this.imageAsset,
    required this.height,
    this.compact = false,
    this.dense = false,
    this.onTap,
  });

  final String line1;
  final String line2;
  final String stampLine1;
  final String stampLine2;
  final int completed;
  final int total;
  final int pct;
  final String imageAsset;
  final double height;
  final bool compact;
  final bool dense;
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
          height: height,
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
                      _FeaturedLabel(dense: dense),
                      SizedBox(height: dense ? 4 : 6),
                      _DestinationTitle(
                        line1: line1,
                        line2: line2,
                        compact: compact,
                        dense: dense,
                      ),
                      const Spacer(),
                      if (!dense) ...[
                        _StarSeparator(),
                        const SizedBox(height: 6),
                      ],
                      _ProgressFooter(
                        completed: completed,
                        total: total,
                        pct: pct,
                        compact: compact,
                        dense: dense,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: dense ? 8 : 10,
                  right: dense ? 8 : 10,
                  child: _StampBadge(
                    line1: stampLine1,
                    line2: stampLine2,
                    small: dense,
                  ),
                ),
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
    required this.stampLine1,
    required this.stampLine2,
    required this.completed,
    required this.total,
    required this.pct,
    required this.imageAsset,
    required this.height,
    this.compact = false,
    this.dense = true,
    this.onTap,
  });

  final String line1;
  final String line2;
  final String stampLine1;
  final String stampLine2;
  final int completed;
  final int total;
  final int pct;
  final String imageAsset;
  final double height;
  final bool compact;
  final bool dense;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final pad = dense ? 8.0 : 10.0;
    return HomeGlassCard(
      onTap: onTap,
      radius: 18,
      height: height,
      padding: EdgeInsets.all(pad),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 11,
            child: Padding(
              padding:
                  EdgeInsets.only(left: dense ? 2 : 4, right: dense ? 4 : 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FeaturedLabel(dense: true),
                  SizedBox(height: dense ? 4 : 6),
                  Expanded(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: _DestinationTitle(
                        line1: line1,
                        line2: line2,
                        compact: true,
                        dense: true,
                      ),
                    ),
                  ),
                  _ProgressFooter(
                    completed: completed,
                    total: total,
                    pct: pct,
                    compact: true,
                    dense: true,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 10,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(imageAsset, fit: BoxFit.cover),
                ),
                Positioned(
                  top: 2,
                  right: 2,
                  child: _StampBadge(
                    line1: stampLine1,
                    line2: stampLine2,
                    small: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
