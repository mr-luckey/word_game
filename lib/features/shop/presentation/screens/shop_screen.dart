import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:word_game/core/constants/asset_paths.dart';
import 'package:word_game/core/constants/shop_products.dart';
import 'package:word_game/core/utils/shop_purchase_gate.dart';
import 'package:word_game/core/theme/app_sizes.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/core/widgets/coin_display.dart';
import 'package:word_game/core/widgets/app_logo.dart';
import 'package:word_game/core/widgets/journey_theme_kit.dart';
import 'package:word_game/core/widgets/scenic_background.dart';
import 'package:word_game/core/widgets/shell_nav_metrics.dart';
import 'package:word_game/features/shop/presentation/cubit/shop_cubit.dart';
import 'package:word_game/features/wallet/presentation/cubit/coin_cubit.dart';
import 'package:word_game/injection.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final preset = context.themePreset;
    return BlocProvider(
      create: (_) => getIt<ShopCubit>(),
      child: BlocListener<ShopCubit, ShopState>(
        listenWhen: (p, c) =>
            c is ShopPurchaseSuccess || c is ShopPurchaseError,
        listener: (context, state) {
          if (state is ShopPurchaseSuccess) {
            context.read<CoinCubit>().refresh();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is ShopPurchaseError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Scaffold(
          extendBodyBehindAppBar: true,
          body: ScenicBackground(
            imageAsset: AssetPaths.themeSplash(preset),
            darken: 0.45,
            child: SafeArea(
              bottom: false,
              child: JourneyContentWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.paddingMd,
                        vertical: AppSizes.paddingSm,
                      ),
                      child: JourneyPanel(
                        padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
                        radius: 20,
                        child: Row(
                          children: [
                            AppLogo(size: 52, borderRadius: 14, elevation: 4),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: JourneySectionTitle(
                                title: 'SHOP',
                                subtitle: 'Enhance your adventure',
                              ),
                            ),
                            BlocBuilder<CoinCubit, CoinState>(
                              builder: (context, state) => CoinDisplay(
                                coins: state.coins,
                                light: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 400.ms)
                        .slideY(begin: -0.1, end: 0),
                    Expanded(
                      child: BlocBuilder<ShopCubit, ShopState>(
                        builder: (context, state) {
                          if (state is ShopLoading) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: context.appColors.gold,
                              ),
                            );
                          }
                          if (state is ShopLoaded &&
                              state.products.isNotEmpty) {
                            return _ShopList(
                              products: state.products,
                              extras: ShopProducts.fallbackExtras,
                              useStore: true,
                            );
                          }
                          if (state is ShopUnavailable ||
                              (state is ShopLoaded && state.products.isEmpty)) {
                            final packs = state is ShopLoaded
                                ? state.fallbackPacks
                                : ShopProducts.fallbackPacks;
                            return _ShopList(
                              products: const [],
                              fallbackPacks: packs,
                              extras: ShopProducts.fallbackExtras,
                              useStore: false,
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ShopList extends StatelessWidget {
  const _ShopList({
    required this.products,
    this.fallbackPacks = const [],
    required this.extras,
    required this.useStore,
  });

  final List<ProductDetails> products;
  final List<ShopPackFallback> fallbackPacks;
  final List<ShopPackFallback> extras;
  final bool useStore;

  @override
  Widget build(BuildContext context) {
    final packWidgets = useStore
        ? products.asMap().entries.map((e) {
            final p = e.value;
            final coins = ShopProducts.coinRewards[p.id];
            return _animatedTile(
              e.key,
              _ShopPackTile(
                title: p.title,
                subtitle: coins != null ? '$coins Coins' : p.description,
                price: p.price,
                onBuy: () => _purchase(context, () => context.read<ShopCubit>().buy(p)),
              ),
            );
          }).toList()
        : fallbackPacks.asMap().entries.map((e) {
            final p = e.value;
            return _animatedTile(
              e.key,
              _ShopPackTile(
                title: '${p.coins} Coins',
                subtitle: p.title,
                price: p.price,
                bestValue: p.bestValue,
                onBuy: () => _purchase(
                  context,
                  () => context.read<ShopCubit>().buyFallback(p),
                ),
              ),
            );
          }).toList();

    final extraWidgets = extras.asMap().entries.map((e) {
      final p = e.value;
      return _animatedTile(
        packWidgets.length + e.key,
        _ShopPackTile(
          title: p.title,
          subtitle: p.subtitle ??
              (p.coins > 0 ? '${p.coins} bonus coins' : null),
          price: p.price,
          icon: _extraIcon(p.id),
          onBuy: () => _purchase(
            context,
            () => context.read<ShopCubit>().buyFallback(p),
          ),
        ),
      );
    }).toList();

    return ListView(
      padding: EdgeInsets.fromLTRB(
        AppSizes.paddingMd,
        AppSizes.paddingMd,
        AppSizes.paddingMd,
        ShellNavMetrics.listBottomPadding(context),
      ),
      children: [
        Text(
          'COIN PACKS',
          style: AppTextStyles.sectionHeading(context).copyWith(fontSize: 18),
        ).animate().fadeIn(delay: 100.ms),
        const SizedBox(height: AppSizes.paddingMd),
        ...packWidgets,
        const SizedBox(height: AppSizes.paddingLg),
        Text(
          'EXTRAS',
          style: AppTextStyles.sectionHeading(context).copyWith(fontSize: 18),
        ).animate().fadeIn(delay: 200.ms),
        const SizedBox(height: AppSizes.paddingSm),
        ...extraWidgets,
      ],
    );
  }

  Future<void> _purchase(BuildContext context, Future<void> Function() buy) async {
    if (!await ensureSignedInForPurchase(context)) return;
    if (!context.mounted) return;
    await buy();
  }

  Widget _animatedTile(int index, Widget tile) {
    return tile
        .animate(delay: (120 + index * 70).ms)
        .fadeIn(duration: 420.ms, curve: Curves.easeOut)
        .slideX(begin: 0.12, end: 0, curve: Curves.easeOutCubic)
        .scale(
          begin: const Offset(0.96, 0.96),
          end: const Offset(1, 1),
          duration: 420.ms,
          curve: Curves.easeOutBack,
        );
  }

  IconData _extraIcon(String id) {
    return switch (id) {
      ShopProducts.removeAds => Icons.block_rounded,
      ShopProducts.vipMonthly => Icons.workspace_premium_rounded,
      ShopProducts.starterPack => Icons.card_giftcard_rounded,
      _ => Icons.shopping_bag_rounded,
    };
  }
}

class _ShopPackTile extends StatelessWidget {
  const _ShopPackTile({
    required this.title,
    this.subtitle,
    required this.price,
    required this.onBuy,
    this.bestValue = false,
    this.icon,
  });

  final String title;
  final String? subtitle;
  final String price;
  final VoidCallback onBuy;
  final bool bestValue;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.paddingSm),
      child: JourneyPanel(
        radius: 16,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingMd,
          vertical: AppSizes.paddingMd,
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: colors.gold.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(color: colors.gold.withValues(alpha: 0.4)),
              ),
              child: Icon(
                icon ?? Icons.monetization_on_rounded,
                color: colors.gold,
                size: 28,
              ),
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .shimmer(
                  duration: bestValue ? 2.seconds : 3.seconds,
                  color: colors.gold.withValues(alpha: 0.25),
                )
                .then()
                .scale(
                  begin: const Offset(1, 1),
                  end: const Offset(1.06, 1.06),
                  duration: 1.5.seconds,
                  curve: Curves.easeInOut,
                ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          style: AppTextStyles.levelName(context)
                              .copyWith(fontSize: 16, color: colors.onScenic),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (bestValue) ...[
                        const SizedBox(width: 8),
                        JourneyDecorations.bestValueBadge(context)
                            .animate(onPlay: (c) => c.repeat(reverse: true))
                            .scale(
                              begin: const Offset(1, 1),
                              end: const Offset(1.08, 1.08),
                              duration: 900.ms,
                            ),
                      ],
                    ],
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: AppTextStyles.bodyMuted(context),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            JourneyDecorations.shopPriceButton(
              context,
              price: price,
              onPressed: onBuy,
            ),
          ],
        ),
      ),
    );
  }
}
