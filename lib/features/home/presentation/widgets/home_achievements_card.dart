import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/features/home/presentation/widgets/home_glass_card.dart';

class HomeAchievementsCard extends StatelessWidget {
  const HomeAchievementsCard({super.key, this.onTap});

  final VoidCallback? onTap;

  static const _achievements = [
    (Icons.explore_rounded, 'Word Novice', '0 / 1'),
    (Icons.public_rounded, 'Word Hunter', '0 / 50'),
    (Icons.workspace_premium_rounded, 'Word Master', '0 / 200'),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final spec = context.themePreset.homeSpec;

    return HomeGlassCard(
      onTap: onTap,
      height: 152,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Achievements',
                      style: GoogleFonts.cinzel(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: spec.achievementAccent,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      '0 / 30 Unlocked',
                      style: GoogleFonts.montserrat(
                        fontSize: 8,
                        color: colors.onScenicMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.emoji_events_rounded,
                color: spec.achievementAccent,
                size: 28,
              ),
            ],
          ),
          const Spacer(),
          // Achievement badges row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _achievements.map((a) {
              final (icon, label, progress) = a;
              return Column(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colors.gold.withValues(alpha: 0.08),
                      border: Border.all(
                        color: colors.glassBorder.withValues(alpha: 0.5),
                        width: 1.5,
                      ),
                    ),
                    child: Icon(icon, color: colors.gold, size: 17),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    label.split(' ').last,
                    style: GoogleFonts.montserrat(
                      fontSize: 7,
                      color: colors.onScenicMuted,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    ).animate(delay: 220.ms).fadeIn().slideY(begin: 0.06, end: 0);
  }
}
