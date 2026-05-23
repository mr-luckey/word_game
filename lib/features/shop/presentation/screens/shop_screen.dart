import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:word_game/core/constants/shop_products.dart';
import 'package:word_game/core/theme/app_sizes.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/core/widgets/glass_panel.dart';
import 'package:word_game/core/widgets/gradient_button.dart';
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
            (p) => _ProductTile(product: p),
          )
        else
          ...fallbackPacks.map(
            (p) => _FallbackTile(pack: p),
          ),
        const SizedBox(height: AppSizes.paddingLg),
        Text('EXTRAS', style: AppTextStyles.levelName(context)),
        const SizedBox(height: AppSizes.paddingSm),
        ...extras.map((p) => _FallbackTile(pack: p)),
      ],
    );
  }
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({required this.product});

  final ProductDetails product;

  @override
  Widget build(BuildContext context) {
    final coins = ShopProducts.coinRewards[product.id];
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.paddingSm),
      child: GlassPanel(
        child: ListTile(
          title: Text(product.title),
          subtitle: Text(
            coins != null && coins > 0
                ? '$coins coins'
                : product.description,
          ),
          trailing: GradientButton(
            label: product.price,
            expanded: false,
            onPressed: () => context.read<ShopCubit>().buy(product),
          ),
        ),
      ),
    );
  }
}

class _FallbackTile extends StatelessWidget {
  const _FallbackTile({required this.pack});

  final ShopPackFallback pack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.paddingSm),
      child: GlassPanel(
        child: ListTile(
          title: Text(pack.title),
          subtitle: pack.coins > 0
              ? Text(
                  pack.bestValue ? '${pack.coins} coins · BEST VALUE' : '${pack.coins} coins',
                )
              : null,
          trailing: GradientButton(
            label: pack.price,
            expanded: false,
            onPressed: () => context.read<ShopCubit>().buyFallback(pack),
          ),
        ),
      ),
    );
  }
}
