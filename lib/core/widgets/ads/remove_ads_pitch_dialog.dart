import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:word_game/core/constants/shop_products.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/core/widgets/journey_theme_kit.dart';

/// Pitches the Remove Ads package after a full-screen ad closes.
Future<void> showRemoveAdsPitchDialog(BuildContext context) {
  final fallback = ShopProducts.fallbackExtras
      .firstWhere((p) => p.id == ShopProducts.removeAds);
  final price = fallback.price;

  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (ctx) => _RemoveAdsPitchDialog(price: price),
  );
}

class _RemoveAdsPitchDialog extends StatelessWidget {
  const _RemoveAdsPitchDialog({required this.price});

  final String price;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final spec = context.themePreset.homeSpec;
    final cardFill = spec.cardFill.withValues(alpha: 0.98);
    final onCard = JourneyThemeKit.readableOn(
      cardFill,
      colors.onScenic,
      colors.onSurface,
    );
    final onCardMuted = onCard.withValues(alpha: 0.78);
    final width = MediaQuery.sizeOf(context).width;
    final compact = width < 360;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: compact ? 20 : 28),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: compact ? 340 : 400),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                cardFill,
                colors.scrim.withValues(alpha: 0.9),
              ],
            ),
            border: Border.all(
              color: colors.glassBorder.withValues(alpha: 0.75),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: colors.scrim.withValues(alpha: 0.45),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              compact ? 18 : 22,
              compact ? 20 : 24,
              compact ? 18 : 22,
              compact ? 18 : 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: compact ? 54 : 60,
                  height: compact ? 54 : 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [colors.gold, spec.playButtonGlow],
                    ),
                  ),
                  child: Icon(
                    Icons.block_rounded,
                    color: JourneyThemeKit.readableOn(
                      colors.gold,
                      Colors.white,
                      colors.onSurface,
                    ),
                    size: compact ? 28 : 30,
                  ),
                ),
                SizedBox(height: compact ? 14 : 16),
                Text(
                  'Remove ads?',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.gameTitle(context).copyWith(
                    fontSize: compact ? 20 : 22,
                    color: onCard,
                    height: 1.15,
                  ),
                ),
                SizedBox(height: compact ? 8 : 10),
                Text(
                  'Enjoy Word Search Journey without banners or '
                  'interstitials. One-time purchase — $price.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.subtitle(context).copyWith(
                    color: onCardMuted,
                    fontSize: compact ? 13 : 14,
                    height: 1.45,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: compact ? 18 : 22),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.pop(context);
                      context.go('/shop');
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: colors.gold,
                      foregroundColor: JourneyThemeKit.readableOn(
                        colors.gold,
                        colors.scrim,
                        colors.onSurface,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Get Remove Ads — $price',
                      style: AppTextStyles.button(context).copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Not now',
                      style: AppTextStyles.button(context).copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: onCardMuted,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
