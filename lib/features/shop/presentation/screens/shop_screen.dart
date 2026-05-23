import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:word_game/core/theme/app_sizes.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/core/widgets/coin_display.dart';
import 'package:word_game/core/widgets/gradient_button.dart';
import 'package:word_game/features/shop/presentation/cubit/shop_cubit.dart';
import 'package:word_game/features/wallet/presentation/cubit/coin_cubit.dart';
import 'package:word_game/injection.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ShopCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('SHOP'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          actions: [
            BlocBuilder<CoinCubit, CoinState>(
              builder: (context, state) => Padding(
                padding: const EdgeInsets.only(right: AppSizes.paddingMd),
                child: Center(child: CoinDisplay(coins: state.coins)),
              ),
            ),
          ],
        ),
        body: BlocBuilder<ShopCubit, ShopState>(
          builder: (context, state) {
            if (state is ShopLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ShopUnavailable) {
              return _StaticShop();
            }
            if (state is ShopLoaded) {
              return ListView(
                padding: const EdgeInsets.all(AppSizes.paddingMd),
                children: [
                  Text('COIN PACKS', style: AppTextStyles.levelName),
                  const SizedBox(height: AppSizes.paddingMd),
                  ...state.products.map(
                    (p) => Card(
                      child: ListTile(
                        title: Text(p.title),
                        subtitle: Text(p.description),
                        trailing: GradientButton(
                          label: p.price,
                          expanded: false,
                          onPressed: () =>
                              context.read<ShopCubit>().buy(p),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingLg),
                  _StaticShopExtras(),
                ],
              );
            }
            return _StaticShop();
          },
        ),
      ),
    );
  }
}

class _StaticShop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSizes.paddingMd),
      children: [
        Text('COIN PACKS', style: AppTextStyles.levelName),
        const SizedBox(height: 16),
        const _CoinPackTile(amount: 500, price: '\$0.99'),
        const _CoinPackTile(amount: 1500, price: '\$2.49', best: true),
        const _CoinPackTile(amount: 5000, price: '\$7.99'),
        const SizedBox(height: 24),
        const _StaticShopExtras(),
      ],
    );
  }
}

class _StaticShopExtras extends StatelessWidget {
  const _StaticShopExtras();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          child: ListTile(
            title: Text('REMOVE ADS', style: AppTextStyles.levelName),
            subtitle: const Text('Play without interruptions forever'),
            trailing: const Text('\$1.99'),
          ),
        ),
        Card(
          child: ListTile(
            title: Text('VIP PASS', style: AppTextStyles.levelName),
            subtitle: const Text('No Ads + 50 daily coins + 5 hints'),
            trailing: const Text('\$0.99/mo'),
          ),
        ),
        Card(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: ListTile(
            title: Text('STARTER PACK', style: AppTextStyles.levelName),
            subtitle: const Text('200 coins + 10 hints — new users only'),
            trailing: const Text('\$0.49'),
          ),
        ),
      ],
    );
  }
}

class _CoinPackTile extends StatelessWidget {
  const _CoinPackTile({
    required this.amount,
    required this.price,
    this.best = false,
  });

  final int amount;
  final String price;
  final bool best;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('$amount coins'),
        subtitle: best ? const Text('BEST VALUE') : null,
        trailing: Text(price, style: AppTextStyles.coinsScore),
      ),
    );
  }
}
