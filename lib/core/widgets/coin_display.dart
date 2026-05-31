import 'package:flutter/material.dart';
import 'package:word_game/core/theme/app_sizes.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/core/widgets/journey_theme_kit.dart';

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
    final spec = context.themePreset.homeSpec;
    final cardFill = light
        ? spec.cardFill.withValues(alpha: 0.92)
        : colors.gold.withValues(alpha: 0.14);
    final onCard = JourneyThemeKit.readableOn(
      cardFill,
      colors.onScenic,
      colors.onSurface,
    );
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingSm + 2,
        vertical: AppSizes.paddingXs + 2,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: light
              ? [
                  spec.cardFill.withValues(alpha: 0.92),
                  colors.surface.withValues(alpha: 0.74),
                ]
              : [
                  colors.gold.withValues(alpha: 0.2),
                  colors.gold.withValues(alpha: 0.08),
                ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: light
              ? colors.glassBorder.withValues(alpha: 0.85)
              : colors.gold.withValues(alpha: 0.6),
          width: 1.3,
        ),
        boxShadow: [
          BoxShadow(
            color: spec.playButtonGlow.withValues(alpha: 0.18),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
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
              color: light ? onCard : colors.goldDark,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
