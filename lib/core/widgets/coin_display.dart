import 'package:flutter/material.dart';
import 'package:word_game/core/theme/app_sizes.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/core/theme/theme_context.dart';

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
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingSm + 2,
        vertical: AppSizes.paddingXs + 2,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: light
              ? [
                  colors.onScenic.withValues(alpha: 0.25),
                  colors.onScenic.withValues(alpha: 0.15),
                ]
              : [
                  colors.gold.withValues(alpha: 0.2),
                  colors.gold.withValues(alpha: 0.08),
                ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: light
              ? colors.onScenic.withValues(alpha: 0.5)
              : colors.gold.withValues(alpha: 0.6),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.monetization_on_rounded,
            color: light ? colors.gold : colors.goldDark,
            size: AppSizes.coinIconSize,
          ),
          const SizedBox(width: AppSizes.paddingXs),
          Text(
            '$coins',
            style: AppTextStyles.coinsScore(context).copyWith(
              color: light ? colors.onScenic : colors.goldDark,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
