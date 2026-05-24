import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/features/home/presentation/widgets/home_glass_card.dart';

class HomeAchievementsCard extends StatelessWidget {
  const HomeAchievementsCard({super.key, this.onTap});

  final VoidCallback? onTap;

  static const _badges = [
    (Icons.explore_rounded, 'Word\nNovice', '0 / 1'),
    (Icons.public_rounded, 'Word\nHunter', '0 / 50'),
    (Icons.star_rounded, 'Word\nMaster', '0 / 200'),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final spec = context.themePreset.homeSpec;

    return HomeGlassCard(
      onTap: onTap,
      height: 148,
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ACHIEVEMENTS',
                      style: GoogleFonts.montserrat(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: spec.achievementAccent,
                        letterSpacing: 0.8,
                      ),
                    ),
                    Text(
                      'Keep playing, keep unlocking!',
                      style: GoogleFonts.montserrat(
                        fontSize: 8,
                        color: colors.onScenicMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.emoji_events_rounded,
                  color: spec.achievementAccent, size: 30),
            ],
          ),
          const Spacer(),
          Row(
            children: List.generate(_badges.length, (i) {
              final (icon, label, progress) = _badges[i];
              return Expanded(
                child: Column(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colors.gold.withValues(alpha: 0.1),
                        border: Border.all(
                          color: colors.glassBorder.withValues(alpha: 0.65),
                          width: 1.5,
                        ),
                      ),
                      child: Icon(icon, color: colors.gold, size: 18),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      label,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        fontSize: 7,
                        height: 1.15,
                        color: colors.onScenicMuted,
                      ),
                    ),
                    Text(
                      progress,
                      style: GoogleFonts.montserrat(
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                        color: colors.gold,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    ).animate(delay: 220.ms).fadeIn().slideY(begin: 0.06, end: 0);
  }
}
