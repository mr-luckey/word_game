import 'package:flutter/material.dart';
import 'package:word_game/core/theme/app_sizes.dart';
import 'package:word_game/core/theme/app_text_styles.dart';

class CoinDisplay extends StatelessWidget {
  const CoinDisplay({super.key, required this.coins});

  final int coins;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.monetization_on,
          color: AppTextStyles.coinsScore.color,
          size: AppSizes.coinIconSize,
        ),
        const SizedBox(width: AppSizes.paddingXs),
        Text('$coins', style: AppTextStyles.coinsScore),
      ],
    );
  }
}
