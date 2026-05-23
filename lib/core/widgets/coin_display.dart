import 'package:flutter/material.dart';
import 'package:word_game/core/theme/app_colors.dart';
import 'package:word_game/core/theme/app_sizes.dart';
import 'package:word_game/core/theme/app_text_styles.dart';

class CoinDisplay extends StatelessWidget {
  const CoinDisplay({
    super.key,
    required this.coins,
    this.light = false,
  });

  final int coins;
  final bool light;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingSm + 2,
        vertical: AppSizes.paddingXs + 2,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: light
              ? [
                  Colors.white.withValues(alpha: 0.25),
                  Colors.white.withValues(alpha: 0.15),
                ]
              : [
                  AppColors.gold.withValues(alpha: 0.2),
                  AppColors.gold.withValues(alpha: 0.08),
                ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: light
              ? Colors.white.withValues(alpha: 0.5)
              : AppColors.gold.withValues(alpha: 0.6),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.monetization_on_rounded,
            color: light ? AppColors.gold : AppColors.goldDark,
            size: AppSizes.coinIconSize,
          ),
          const SizedBox(width: AppSizes.paddingXs),
          Text(
            '$coins',
            style: AppTextStyles.coinsScore.copyWith(
              color: light ? Colors.white : AppColors.goldDark,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
