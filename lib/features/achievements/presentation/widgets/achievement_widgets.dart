import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:word_game/core/theme/app_sizes.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/core/widgets/journey_theme_kit.dart';

class ProfileStatsRow extends StatelessWidget {
  const ProfileStatsRow({
    super.key,
    required this.completedLevels,
    required this.wordsFound,
    required this.coinsCollected,
  });

  final int completedLevels;
  final int wordsFound;
  final int coinsCollected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatTile(
          index: 0,
          label: 'Levels\nCompleted',
          value: '$completedLevels',
        ),
        const SizedBox(width: 8),
        _StatTile(
          index: 1,
          label: 'Words\nFound',
          value: '$wordsFound',
        ),
        const SizedBox(width: 8),
        _StatTile(
          index: 2,
          label: 'Coins\nCollected',
          value: '$coinsCollected',
        ),
      ],
    );
  }
}

class AchievementListTile extends StatelessWidget {
  const AchievementListTile({
    super.key,
    required this.title,
    required this.description,
    required this.coinReward,
    required this.unlocked,
  });

  final String title;
  final String description;
  final int coinReward;
  final bool unlocked;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return JourneyPanel(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMd,
        vertical: 12,
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: unlocked
                  ? colors.gold.withValues(alpha: 0.18)
                  : colors.surface.withValues(alpha: 0.6),
              border: Border.all(
                color: unlocked
                    ? colors.gold
                    : colors.locked.withValues(alpha: 0.6),
                width: 1.5,
              ),
            ),
            child: Icon(
              unlocked
                  ? Icons.emoji_events_rounded
                  : Icons.lock_outline_rounded,
              color: unlocked ? colors.gold : colors.locked,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.levelName(context).copyWith(
                    fontSize: 15,
                    color: colors.onScenic,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  description,
                  style: AppTextStyles.bodyMuted(context).copyWith(
                    fontSize: 12,
                    color: colors.accentCoin.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
          Text(
            '+$coinReward',
            style: AppTextStyles.coinsScore(context).copyWith(
              fontSize: 15,
              color: colors.gold,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.index,
    required this.label,
    required this.value,
  });

  final int index;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Expanded(
      child: JourneyPanel(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingMd),
        child: Column(
          children: [
            Text(
              value,
              style: AppTextStyles.coinsScore(context).copyWith(
                color: colors.gold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMuted(context).copyWith(
                fontSize: 11,
                color: colors.accentCoin.withValues(alpha: 0.9),
                height: 1.3,
              ),
            ),
          ],
        ),
      )
          .animate(delay: (150 + index * 80).ms)
          .fadeIn(duration: 400.ms)
          .slideY(begin: 0.12, end: 0, curve: Curves.easeOutBack),
    );
  }
}
