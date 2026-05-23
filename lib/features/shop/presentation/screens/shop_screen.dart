import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:word_game/core/constants/shop_products.dart';
import 'package:word_game/core/theme/app_sizes.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/core/widgets/glass_panel.dart';
import 'package:word_game/core/widgets/scenic_page.dart';
import 'package:word_game/features/shop/presentation/cubit/shop_cubit.dart';
import 'package:word_game/features/wallet/presentation/cubit/coin_cubit.dart';
import 'package:word_game/injection.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
        child: ScenicPage(
          title: 'SHOP',
          showBack: false,
          child: BlocBuilder<ShopCubit, ShopState>(
            builder: (context, state) {
              if (state is ShopLoading) {
                return Center(
                  child: CircularProgressIndicator(color: context.appColors.gold),
                );
              }
              if (state is ShopLoaded && state.products.isNotEmpty) {
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
    return ListView(
      padding: const EdgeInsets.all(AppSizes.paddingMd),
      children: [
        if (!useStore)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.paddingSm),
            child: Text(
              'Store preview — replace product IDs in shop_products.dart',
              style: AppTextStyles.wordList(context).copyWith(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
        Text('COIN PACKS', style: AppTextStyles.levelName(context)),
        const SizedBox(height: AppSizes.paddingMd),
        if (useStore)
          ...products.map(
            (p) {
              final coins = ShopProducts.coinRewards[p.id];
              return _ShopPackTile(
                title: p.title,
                subtitle: coins != null && coins > 0
                    ? '$coins coins'
                    : p.description,
                price: p.price,
                onBuy: () => context.read<ShopCubit>().buy(p),
              );
            },
          )
        else
          ...fallbackPacks.map(
            (p) => _ShopPackTile(
              title: p.title,
              subtitle: p.coins > 0
                  ? (p.bestValue
                      ? '${p.coins} coins · BEST VALUE'
                      : '${p.coins} coins')
                  : null,
              price: p.price,
              onBuy: () => context.read<ShopCubit>().buyFallback(p),
            ),
          ),
        const SizedBox(height: AppSizes.paddingLg),
        Text('EXTRAS', style: AppTextStyles.levelName(context)),
        const SizedBox(height: AppSizes.paddingSm),
        ...extras.map(
          (p) => _ShopPackTile(
            title: p.title,
            subtitle: p.coins > 0 ? '${p.coins} coins' : null,
            price: p.price,
            onBuy: () => context.read<ShopCubit>().buyFallback(p),
          ),
        ),
      ],
    );
  }
}

class _ShopPackTile extends StatelessWidget {
  const _ShopPackTile({
    required this.title,
    this.subtitle,
    required this.price,
    required this.onBuy,
  });

  final String title;
  final String? subtitle;
  final String price;
  final VoidCallback onBuy;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.paddingSm),
      child: GlassPanel(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingMd,
          vertical: AppSizes.paddingSm + 2,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.levelName(context).copyWith(fontSize: 16),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: AppTextStyles.wordList(context).copyWith(
                        fontSize: 13,
                        color: colors.locked,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            _ShopPriceButton(price: price, onPressed: onBuy),
          ],
        ),
      ),
    );
  }
}

/// Compact buy button — no outer shadow so GlassPanel clip does not cut it.
class _ShopPriceButton extends StatelessWidget {
  const _ShopPriceButton({
    required this.price,
    required this.onPressed,
  });

  final String price;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          decoration: BoxDecoration(
            gradient: colors.primaryGradient,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colors.goldLight.withValues(alpha: 0.5),
              width: 1,
            ),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 72),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Text(
                price,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.visible,
                softWrap: false,
                style: AppTextStyles.button(context).copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
