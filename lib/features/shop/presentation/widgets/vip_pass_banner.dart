import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:word_game/core/constants/shop_products.dart';
import 'package:word_game/core/theme/app_sizes.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/core/widgets/journey_theme_kit.dart';

class VipPassBanner extends StatelessWidget {
  const VipPassBanner({
    super.key,
    required this.price,
    required this.isActive,
    required this.onGetVip,
  });

  final String price;
  final bool isActive;
  final VoidCallback onGetVip;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final spec = context.themePreset.homeSpec;
    final glow = spec.playButtonGlow;
    final cardFill = spec.cardFill;
    final onCard = JourneyThemeKit.readableOn(
      cardFill,
      colors.onScenic,
      colors.onSurface,
    );
    final width = MediaQuery.sizeOf(context).width;
    final compact = width < 380;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMd),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            cardFill.withValues(alpha: 0.98),
            colors.scrim.withValues(alpha: 0.92),
          ],
        ),
        border: Border.all(color: colors.gold.withValues(alpha: 0.7), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: colors.gold.withValues(alpha: 0.22),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              top: -16,
              child: Icon(
                Icons.workspace_premium_rounded,
                size: compact ? 100 : 120,
                color: colors.gold.withValues(alpha: 0.1),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 14, 16, compact ? 14 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      _Badge(
                        label: 'RECOMMENDED',
                        background: colors.warning,
                      ),
                      const Spacer(),
                      if (isActive)
                        _Badge(
                          label: 'ACTIVE',
                          background: colors.success,
                          outline: true,
                        ),
                    ],
                  ),
                  SizedBox(height: compact ? 10 : 12),
                  Row(
                    children: [
                      Container(
                        width: compact ? 48 : 52,
                        height: compact ? 48 : 52,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [colors.gold, glow],
                          ),
                        ),
                        child: Icon(
                          Icons.workspace_premium_rounded,
                          color: Colors.white,
                          size: compact ? 26 : 30,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'VIP PASS',
                              style: AppTextStyles.gameTitle(context).copyWith(
                                fontSize: compact ? 22 : 24,
                                height: 1,
                                color: onCard,
                                shadows: JourneyThemeKit.textGlow(context),
                              ),
                            ),
                            Text(
                              'Monthly subscription · Unlock the full journey',
                              style: AppTextStyles.bodyMuted(context).copyWith(
                                fontSize: 11,
                                color: onCard.withValues(alpha: 0.85),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: compact ? 10 : 12),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final twoCol = constraints.maxWidth > 300;
                      if (twoCol) {
                        return GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          mainAxisSpacing: 6,
                          crossAxisSpacing: 8,
                          childAspectRatio: compact ? 3.8 : 3.4,
                          children: ShopProducts.vipFeatureLines
                              .map((line) => _FeatureRow(line: line, onCard: onCard))
                              .toList(),
                        );
                      }
                      return Column(
                        children: ShopProducts.vipFeatureLines
                            .map(
                              (line) => Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: _FeatureRow(line: line, onCard: onCard),
                              ),
                            )
                            .toList(),
                      );
                    },
                  ),
                  SizedBox(height: compact ? 12 : 14),
                  SizedBox(
                    height: 46,
                    child: FilledButton(
                      onPressed: isActive ? null : onGetVip,
                      style: FilledButton.styleFrom(
                        backgroundColor: isActive
                            ? colors.onScenicMuted.withValues(alpha: 0.35)
                            : colors.gold,
                        disabledBackgroundColor:
                            colors.onScenicMuted.withValues(alpha: 0.35),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: isActive ? 0 : 4,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              isActive ? 'VIP ACTIVE' : 'Get VIP Pass',
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.button(context).copyWith(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          if (!isActive) ...[
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.22),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                price,
                                style: AppTextStyles.button(context).copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 450.ms);
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
    required this.label,
    required this.background,
    this.outline = false,
  });

  final String label;
  final Color background;
  final bool outline;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: outline ? background.withValues(alpha: 0.2) : background,
        borderRadius: BorderRadius.circular(20),
        border: outline ? Border.all(color: background, width: 1) : null,
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.line, required this.onCard});

  final String line;
  final Color onCard;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check_rounded, size: 16, color: colors.gold),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            line,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.subtitle(context).copyWith(
              color: onCard,
              fontSize: 11,
              height: 1.25,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
