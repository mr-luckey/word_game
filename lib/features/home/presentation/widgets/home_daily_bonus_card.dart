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
      height: 152,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon + label row
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      spec.dailyBonusAccent.withValues(alpha: 0.35),
                      spec.dailyBonusAccent.withValues(alpha: 0.15),
                    ],
                  ),
                  border: Border.all(
                    color: spec.dailyBonusAccent.withValues(alpha: 0.5),
                  ),
                ),
                child: Icon(
                  Icons.card_giftcard_rounded,
                  color: spec.dailyBonusAccent,
                  size: 22,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daily Bonus',
                      style: GoogleFonts.cinzel(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: spec.dailyBonusAccent,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      'Claim your reward!',
                      style: GoogleFonts.montserrat(
                        fontSize: 8,
                        color: colors.onScenicMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Coin reward pill
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: colors.tertiary.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: colors.glassBorder.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.monetization_on_rounded,
                    color: colors.gold, size: 18),
                const SizedBox(width: 4),
                Text(
                  '50',
                  style: GoogleFonts.montserrat(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: colors.onScenic,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          // Timer
          Row(
            children: [
              Icon(Icons.timer_outlined, size: 11, color: colors.accentCoin),
              const SizedBox(width: 3),
              Text(
                'Ready to claim!',
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
