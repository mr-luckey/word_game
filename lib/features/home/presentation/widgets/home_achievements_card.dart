import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:word_game/core/data/game_content_registry.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/features/home/presentation/widgets/home_vertical_action_card.dart';
import 'package:word_game/injection.dart';

class HomeAchievementsCard extends StatelessWidget {
  const HomeAchievementsCard({
    super.key,
    this.onTap,
    this.height,
    this.compact = false,
    this.dense = false,
  });

  final VoidCallback? onTap;
  final double? height;
  final bool compact;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final spec = context.themePreset.homeSpec;
    final badges = getIt<GameContentRegistry>()
        .achievements
        .badgesForTheme(context.themePreset.folder);
    final iconSize = dense ? 32.0 : (compact ? 36.0 : 40.0);
    final badgeSize = dense ? 24.0 : (compact ? 28.0 : 30.0);

    return HomeVerticalActionCard(
      onTap: onTap,
      height: height,
      compact: compact,
      dense: dense,
      title: 'ACHIEVEMENTS',
      subtitle: dense ? 'Keep unlocking!' : 'Play to unlock badges',
      accentColor: spec.achievementAccent,
      hero: Container(
        width: iconSize,
        height: iconSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              spec.achievementAccent.withValues(alpha: 0.35),
              colors.primary.withValues(alpha: 0.9),
            ],
          ),
          border: Border.all(
            color: spec.achievementAccent.withValues(alpha: 0.85),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: spec.playButtonGlow.withValues(alpha: 0.35),
              blurRadius: 8,
            ),
          ],
        ),
        child: Icon(
          Icons.emoji_events_rounded,
          color: spec.achievementAccent,
          size: iconSize * 0.52,
        ),
      ),
      body: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(badges.length, (i) {
          final badge = badges[i];
          return Expanded(
            child: _AchievementBadge(
              icon: badge.icon,
              label: badge.label,
              progress: '0/${badge.progressTarget}',
              size: badgeSize,
              accent: spec.achievementAccent,
              dense: dense,
            ),
          );
        }),
      ),
      footer: Text(
        'View all',
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.montserrat(
          fontSize: dense ? 7 : 8,
          fontWeight: FontWeight.w600,
          color: colors.accentCoin,
        ),
      ),
    ).animate(delay: 220.ms).fadeIn().slideY(begin: 0.05, end: 0);
  }
}

class _AchievementBadge extends StatelessWidget {
  const _AchievementBadge({
    required this.icon,
    required this.label,
    required this.progress,
    required this.size,
    required this.accent,
    required this.dense,
  });

  final IconData icon;
  final String label;
  final String progress;
  final double size;
  final Color accent;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final short = label.replaceFirst('Word ', '');

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colors.surface.withValues(alpha: 0.85),
            border: Border.all(color: accent.withValues(alpha: 0.75), width: 1.2),
          ),
          child: Icon(icon, color: accent, size: size * 0.48),
        ),
        SizedBox(height: dense ? 2 : 3),
        Text(
          short,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.montserrat(
            fontSize: dense ? 6 : 6.5,
            fontWeight: FontWeight.w700,
            color: colors.onScenicMuted,
          ),
        ),
        Text(
          progress,
          style: GoogleFonts.montserrat(
            fontSize: dense ? 6.5 : 7,
            fontWeight: FontWeight.w800,
            color: colors.gold,
          ),
        ),
      ],
    );
  }
}
