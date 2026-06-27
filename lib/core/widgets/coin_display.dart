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
    this.plain = false,
    this.compact = false,
  });

  final int coins;
  final bool light;
  final bool plain;
  final bool compact;

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

    final iconSize = compact ? 16.0 : AppSizes.coinIconSize;
    final fontSize = compact ? 12.0 : 15.0;
    final fontWeight = compact ? FontWeight.w500 : FontWeight.w700;
    final hPad = compact ? 6.0 : AppSizes.paddingSm + 2;
    final vPad = compact ? 3.0 : AppSizes.paddingXs + 2;
    final radius = compact ? 14.0 : 24.0;

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.monetization_on_rounded,
          color: plain || light ? colors.gold : colors.goldDark,
          size: iconSize,
        ),
        SizedBox(width: compact ? 4 : AppSizes.paddingXs),
        Text(
          '$coins',
          style: AppTextStyles.coinsScore(context).copyWith(
            color: plain ? colors.gold : (light ? onCard : colors.goldDark),
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
        ),
      ],
    );

    if (plain) return content;

    if (compact) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: colors.scrim.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: colors.glassBorder.withValues(alpha: 0.4),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.monetization_on_rounded,
              color: colors.gold,
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              '$coins',
              style: AppTextStyles.coinsScore(context).copyWith(
                color: colors.onScenic,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
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
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: light
              ? colors.glassBorder.withValues(alpha: 0.85)
              : colors.gold.withValues(alpha: 0.6),
          width: compact ? 1 : 1.3,
        ),
        boxShadow: compact
            ? null
            : [
                BoxShadow(
                  color: spec.playButtonGlow.withValues(alpha: 0.18),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: content,
    );
  }
}
