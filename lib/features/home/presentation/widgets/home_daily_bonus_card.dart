import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/features/home/presentation/widgets/home_glass_card.dart';

class HomeDailyBonusCard extends StatelessWidget {
  const HomeDailyBonusCard({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final spec = context.themePreset.homeSpec;

    return HomeGlassCard(
      onTap: onTap,
      height: 164,
      padding: const EdgeInsets.all(9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    colors: [
                      colors.primary.withValues(alpha: 0.7),
                      colors.primary,
                    ],
                  ),
                ),
                child: Icon(Icons.card_giftcard_rounded,
                    color: spec.dailyBonusAccent, size: 24),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DAILY BONUS',
                      style: GoogleFonts.montserrat(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: spec.dailyBonusAccent,
                        letterSpacing: 0.8,
                      ),
                    ),
                    Text(
                      'Come back every day to claim rewards!',
                      style: GoogleFonts.montserrat(
                        fontSize: 8,
                        height: 1.25,
                        color: colors.onScenicMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
            decoration: BoxDecoration(
              color: colors.tertiary.withValues(alpha: 0.75),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colors.glassBorder.withValues(alpha: 0.35),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.monetization_on_rounded,
                    color: colors.gold, size: 18),
                Text(
                  ' 50 ',
                  style: GoogleFonts.montserrat(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: colors.onScenic,
                  ),
                ),
                Container(
                  width: 1,
                  height: 16,
                  color: colors.glassBorder.withValues(alpha: 0.5),
                ),
                Icon(Icons.diamond_rounded, color: colors.accentCoin, size: 16),
                Text(
                  ' 1',
                  style: GoogleFonts.montserrat(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: colors.onScenic,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Icon(Icons.access_time_rounded,
                  size: 12, color: colors.accentCoin),
              const SizedBox(width: 4),
              Text(
                '23h 45m left',
                style: GoogleFonts.montserrat(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: colors.accentCoin,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate(delay: 180.ms).fadeIn().slideY(begin: 0.06, end: 0);
  }
}
