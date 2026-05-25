import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/features/home/presentation/widgets/home_side_action_card.dart';

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

  static const _progress = ['0 / 1', '0 / 50', '0 / 200'];

  @override
  Widget build(BuildContext context) {
    final spec = context.themePreset.homeSpec;
    final badges = spec.achievementBadges;
    final badgeSize = dense ? 32.0 : (compact ? 36.0 : 40.0);

    return HomeSideActionCard(
      onTap: onTap,
      height: height,
      title: 'ACHIEVEMENTS',
      subtitle: dense
          ? 'Keep unlocking!'
          : 'Keep playing, keep unlocking!',
      accentColor: spec.achievementAccent,
      trailing: Icon(
        Icons.emoji_events_rounded,
        color: spec.achievementAccent,
        size: dense ? 28 : 34,
        shadows: [
          Shadow(
            color: spec.playButtonGlow.withValues(alpha: 0.5),
            blurRadius: 10,
          ),
        ],
      ),
      body: Row(
        children: List.generate(badges.length, (i) {
          final badge = badges[i];
          return Expanded(
            child: _AchievementBadge(
              icon: badge.icon,
              label: badge.label,
              progress: _progress[i],
              size: badgeSize,
              accent: spec.achievementAccent,
            ),
          );
        }),
      ),
      footer: const SizedBox(height: 4),
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
  });

  final IconData icon;
  final String label;
  final String progress;
  final double size;
  final Color accent;

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
            gradient: RadialGradient(
              colors: [
                colors.tertiary.withValues(alpha: 0.95),
                colors.surface.withValues(alpha: 0.9),
              ],
            ),
            border: Border.all(color: accent.withValues(alpha: 0.85), width: 2),
            boxShadow: [
              BoxShadow(
                color: accent.withValues(alpha: 0.25),
                blurRadius: 8,
              ),
            ],
          ),
          child: Icon(icon, color: accent, size: size * 0.48),
        ),
        const SizedBox(height: 4),
        Text(
          short,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.montserrat(
            fontSize: 6.5,
            fontWeight: FontWeight.w700,
            color: colors.onScenicMuted,
          ),
        ),
        Text(
          progress,
          style: GoogleFonts.montserrat(
            fontSize: 7.5,
            fontWeight: FontWeight.w800,
            color: colors.gold,
          ),
        ),
      ],
    );
  }
}
