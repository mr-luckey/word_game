import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/features/home/presentation/widgets/home_side_action_card.dart';

class HomeDailyBonusCard extends StatelessWidget {
  const HomeDailyBonusCard({
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
    final iconSize = dense ? 38.0 : (compact ? 42.0 : 46.0);

    return HomeSideActionCard(
      onTap: onTap,
      height: height,
      title: 'DAILY BONUS',
      subtitle: dense
          ? 'Claim daily rewards!'
          : 'Come back every day to claim rewards!',
      accentColor: spec.dailyBonusAccent,
      leading: HomeSideIconBadge(
        icon: Icons.card_giftcard_rounded,
        accentColor: spec.dailyBonusAccent,
        size: iconSize,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _RewardChip(
            icon: Icons.monetization_on_rounded,
            value: '50',
            iconColor: colors.gold,
          ),
          Container(
            width: 1,
            height: 22,
            margin: const EdgeInsets.symmetric(horizontal: 12),
            color: colors.glassBorder.withValues(alpha: 0.45),
          ),
          _RewardChip(
            icon: Icons.diamond_rounded,
            value: '1',
            iconColor: colors.accentCoin,
          ),
        ],
      ),
      footer: Row(
        children: [
          Icon(Icons.schedule_rounded, size: 13, color: colors.accentCoin),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              '23h 45m left',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.montserrat(
                fontSize: dense ? 8 : 9,
                fontWeight: FontWeight.w600,
                color: colors.accentCoin,
              ),
            ),
          ),
        ],
      ),
    ).animate(delay: 180.ms).fadeIn().slideY(begin: 0.05, end: 0);
  }
}

class _RewardChip extends StatelessWidget {
  const _RewardChip({
    required this.icon,
    required this.value,
    required this.iconColor,
  });

  final IconData icon;
  final String value;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: iconColor, size: 20),
        const SizedBox(width: 4),
        Text(
          value,
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: colors.onScenic,
          ),
        ),
      ],
    );
  }
}
