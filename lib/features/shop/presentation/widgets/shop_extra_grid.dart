import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:word_game/core/constants/shop_products.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/core/widgets/journey_theme_kit.dart';

class ShopExtraPackData {
  const ShopExtraPackData({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.icon,
    required this.onBuy,
  });

  final String id;
  final String title;
  final String subtitle;
  final String price;
  final IconData icon;
  final VoidCallback onBuy;
}

class ShopExtraGrid extends StatelessWidget {
  const ShopExtraGrid({super.key, required this.packs});

  final List<ShopExtraPackData> packs;

  static IconData iconForId(String id) {
    return switch (id) {
      ShopProducts.starterPack => Icons.card_giftcard_rounded,
      ShopProducts.removeAds => Icons.block_rounded,
      _ => Icons.shopping_bag_rounded,
    };
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 10.0;
        final cardHeight = (constraints.maxWidth * 0.42).clamp(128.0, 148.0);

        return SizedBox(
          height: cardHeight,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < packs.length; i++) ...[
                if (i > 0) const SizedBox(width: gap),
                Expanded(
                  child: _ExtraPackCard(
                    pack: packs[i],
                    index: i,
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

class _ExtraPackCard extends StatelessWidget {
  const _ExtraPackCard({required this.pack, required this.index});

  final ShopExtraPackData pack;
  final int index;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final spec = context.themePreset.homeSpec;
    final cardFill = spec.cardFill.withValues(alpha: 0.94);
    final onCard = JourneyThemeKit.readableOn(
      cardFill,
      colors.onScenic,
      colors.onSurface,
    );
    final onCardMuted = onCard.withValues(alpha: 0.72);
    final accent = pack.id == ShopProducts.starterPack
        ? colors.primary
        : colors.shopPriceButton;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: pack.onBuy,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          decoration: BoxDecoration(
            color: cardFill,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: accent.withValues(alpha: 0.45)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.22),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(pack.icon, color: accent, size: 20),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        pack.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.levelName(context).copyWith(
                          fontSize: 13,
                          color: onCard,
                          height: 1.1,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Expanded(
                  child: Text(
                    pack.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyMuted(context).copyWith(
                      fontSize: 10,
                      height: 1.2,
                      color: onCardMuted,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  decoration: BoxDecoration(
                    color: colors.shopPriceButton,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    pack.price,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.button(context).copyWith(
                      fontSize: 12,
                      color: JourneyThemeKit.readableOn(
                        colors.shopPriceButton,
                        Colors.white,
                        colors.onSurface,
                      ),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate(delay: (280 + index * 90).ms)
        .fadeIn(duration: 400.ms);
  }
}
