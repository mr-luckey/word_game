import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:word_game/core/theme/app_theme_extension.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/core/theme/theme_context.dart';

class ShopCoinPackData {
  const ShopCoinPackData({
    required this.coins,
    required this.price,
    required this.onBuy,
    this.bestValue = false,
  });

  final int coins;
  final String price;
  final VoidCallback onBuy;
  final bool bestValue;
}

/// Responsive row of coin packs — height derived from width (no grid overflow).
class ShopCoinGrid extends StatelessWidget {
  const ShopCoinGrid({super.key, required this.packs});

  final List<ShopCoinPackData> packs;

  static double _cardHeight(double cardWidth) {
    return (cardWidth * 1.12).clamp(118.0, 138.0);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 10.0;
        final count = packs.length.clamp(1, 3);
        final cardWidth =
            (constraints.maxWidth - gap * (count - 1)) / count;
        final cardHeight = _cardHeight(cardWidth);

        return SizedBox(
          height: cardHeight,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < packs.length; i++) ...[
                if (i > 0) const SizedBox(width: gap),
                Expanded(
                  child: _CoinPackCard(
                    pack: packs[i],
                    index: i,
                    cardHeight: cardHeight,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _CoinPackCard extends StatelessWidget {
  const _CoinPackCard({
    required this.pack,
    required this.index,
    required this.cardHeight,
  });

  final ShopCoinPackData pack;
  final int index;
  final double cardHeight;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final iconSize = (cardHeight * 0.26).clamp(24.0, 30.0);
    final topInset = pack.bestValue ? 18.0 : 8.0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: pack.onBuy,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          decoration: BoxDecoration(
            color: colors.glassSurface.withValues(alpha: 0.94),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: pack.bestValue
                  ? colors.gold.withValues(alpha: 0.9)
                  : colors.glassBorder.withValues(alpha: 0.45),
              width: pack.bestValue ? 1.5 : 1,
            ),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              if (pack.bestValue)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    decoration: BoxDecoration(
                      color: colors.warning,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(13),
                      ),
                    ),
                    child: Text(
                      'BEST',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                ),
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(6, topInset, 6, 6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.monetization_on_rounded,
                            size: iconSize,
                            color: colors.gold,
                          ),
                          const SizedBox(height: 2),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              '${pack.coins}',
                              style: AppTextStyles.levelName(context).copyWith(
                                fontSize: 15,
                                color: colors.onScenic,
                                height: 1,
                              ),
                            ),
                          ),
                          Text(
                            'Coins',
                            style: AppTextStyles.bodyMuted(context).copyWith(
                              fontSize: 9,
                              color: colors.onScenicMuted,
                              height: 1.1,
                            ),
                          ),
                        ],
                      ),
                      _PriceChip(price: pack.price, colors: colors),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate(delay: (140 + index * 70).ms)
        .fadeIn(duration: 380.ms)
        .scale(
          begin: const Offset(0.96, 0.96),
          end: const Offset(1, 1),
          curve: Curves.easeOut,
        );
  }
}

class _PriceChip extends StatelessWidget {
  const _PriceChip({required this.price, required this.colors});

  final String price;
  final AppThemeColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: colors.shopPriceButton,
        borderRadius: BorderRadius.circular(8),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            price,
            style: AppTextStyles.button(context).copyWith(
              fontSize: 11,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
