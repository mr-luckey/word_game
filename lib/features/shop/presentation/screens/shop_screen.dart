import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:word_game/core/constants/asset_paths.dart';
import 'package:word_game/core/theme/app_sizes.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/core/widgets/glass_panel.dart';
import 'package:word_game/core/widgets/gradient_button.dart';
import 'package:word_game/core/widgets/scenic_background.dart';
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
        extendBodyBehindAppBar: true,
        body: ScenicBackground(
          imageAsset: AssetPaths.splashBg,
          darken: 0.38,
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingSm,
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 48),
                      Expanded(
                        child: Text(
                          'SHOP',
                          style: AppTextStyles.appBarTitle(context)
                              .copyWith(fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      BlocBuilder<CoinCubit, CoinState>(
                        builder: (context, state) => Padding(
                          padding: const EdgeInsets.only(
                            right: AppSizes.paddingSm,
                          ),
                          child: Text(
                            '${state.coins}',
                            style: AppTextStyles.coinsScore(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
                      if (state is ShopLoaded) {
                        return ListView(
                          padding: const EdgeInsets.all(AppSizes.paddingMd),
                          children: [
                            Text(
                              'COIN PACKS',
                              style: AppTextStyles.levelName(context),
                            ),
                            const SizedBox(height: AppSizes.paddingMd),
                            ...state.products.map(
                              (p) => Padding(
                                padding: const EdgeInsets.only(
                                  bottom: AppSizes.paddingSm,
                                ),
                                child: GlassPanel(
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
                            ),
                            const _StaticShopExtras(),
                          ],
                        );
                      }
                      return const _StaticShop();
                    },
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

class _StaticShop extends StatelessWidget {
  const _StaticShop();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSizes.paddingMd),
      children: [
        Text('COIN PACKS', style: AppTextStyles.levelName(context)),
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
        GlassPanel(
          child: ListTile(
            title: Text('REMOVE ADS', style: AppTextStyles.levelName(context)),
            subtitle: const Text('Play without interruptions forever'),
            trailing: Text('\$1.99', style: AppTextStyles.coinsScore(context)),
          ),
        ),
        const SizedBox(height: AppSizes.paddingSm),
        GlassPanel(
          child: ListTile(
            title: Text('VIP PASS', style: AppTextStyles.levelName(context)),
            subtitle: const Text('No Ads + 50 daily coins + 5 hints'),
            trailing: Text('\$0.99/mo', style: AppTextStyles.coinsScore(context)),
          ),
        ),
        const SizedBox(height: AppSizes.paddingSm),
        GlassPanel(
          child: ListTile(
            title: Text('STARTER PACK', style: AppTextStyles.levelName(context)),
            subtitle: const Text('200 coins + 10 hints — new users only'),
            trailing: Text('\$0.49', style: AppTextStyles.coinsScore(context)),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.paddingSm),
      child: GlassPanel(
        child: ListTile(
          title: Text('$amount coins'),
          subtitle: best ? const Text('BEST VALUE') : null,
          trailing: Text(price, style: AppTextStyles.coinsScore(context)),
        ),
      ),
    );
  }
}
