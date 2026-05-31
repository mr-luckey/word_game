import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:word_game/core/constants/shop_products.dart';
import 'package:word_game/core/services/vip_service.dart';
import 'package:word_game/core/utils/shop_purchase_gate.dart';
import 'package:word_game/core/theme/app_sizes.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/core/widgets/coin_display.dart';
import 'package:word_game/core/widgets/app_logo.dart';
import 'package:word_game/core/widgets/journey_theme_kit.dart';
import 'package:word_game/core/widgets/scenic_background.dart';
import 'package:word_game/core/widgets/shell_nav_metrics.dart';
import 'package:word_game/core/constants/asset_paths.dart';
import 'package:word_game/features/shop/presentation/cubit/shop_cubit.dart';
import 'package:word_game/features/shop/presentation/widgets/shop_catalog.dart';
import 'package:word_game/features/shop/presentation/widgets/shop_section_header.dart';
import 'package:word_game/features/shop/presentation/widgets/shop_coin_grid.dart';
import 'package:word_game/features/shop/presentation/widgets/shop_extra_grid.dart';
import 'package:word_game/features/shop/presentation/widgets/vip_pass_banner.dart';
import 'package:word_game/features/wallet/presentation/cubit/coin_cubit.dart';
import 'package:word_game/injection.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  bool _vipActive = getIt<VipService>().isVipActive;

  void _refreshVipFlag() {
    final active = getIt<VipService>().isVipActive;
    if (active != _vipActive) {
      setState(() => _vipActive = active);
    }
  }

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
            _refreshVipFlag();
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
            darken: 0.5,
            child: SafeArea(
              bottom: false,
              child: JourneyContentWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSizes.paddingMd,
                        AppSizes.paddingSm,
                        AppSizes.paddingMd,
                        4,
                      ),
                      child: Row(
                        children: [
                          AppLogo(size: 44, borderRadius: 12, elevation: 3),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'SHOP',
                                  style: AppTextStyles.gameTitle(context)
                                      .copyWith(
                                    fontSize: 24,
                                    height: 1,
                                    shadows: JourneyThemeKit.textGlow(context),
                                  ),
                                ),
                                Text(
                                  'Power up your journey',
                                  style: AppTextStyles.bodyMuted(context)
                                      .copyWith(
                                    fontSize: 12,
                                    color: context.appColors.onScenicMuted,
                                  ),
                                ),
                              ],
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
                    ).animate().fadeIn(duration: 350.ms),
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

                          final products = state is ShopLoaded
                              ? state.products
                              : <ProductDetails>[];
                          final useStore = state is ShopLoaded && products.isNotEmpty;
                          final coinFallbacks = state is ShopLoaded
                              ? state.fallbackPacks
                              : ShopProducts.fallbackPacks;

                          return _ShopScrollBody(
                            products: products,
                            coinFallbacks: coinFallbacks,
                            useStore: useStore,
                            vipActive: _vipActive,
                            onPurchased: _refreshVipFlag,
                          );
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

class _ShopScrollBody extends StatelessWidget {
  const _ShopScrollBody({
    required this.products,
    required this.coinFallbacks,
    required this.useStore,
    required this.vipActive,
    required this.onPurchased,
  });

  final List<ProductDetails> products;
  final List<ShopPackFallback> coinFallbacks;
  final bool useStore;
  final bool vipActive;
  final VoidCallback onPurchased;

  String get _vipPrice {
    final store = shopFindProduct(products, ShopProducts.vipMonthly);
    return store?.price ?? ShopProducts.vipFallback.price;
  }

  List<ShopCoinPackData> _coinPacks(BuildContext context) {
    if (useStore) {
      return shopCoinProducts(products).map((p) {
        final coins = ShopProducts.coinRewards[p.id] ?? 0;
        return ShopCoinPackData(
          coins: coins,
          price: p.price,
          bestValue: p.id == ShopProducts.coins1500,
          onBuy: () => _purchase(
            context,
            () => context.read<ShopCubit>().buy(p),
          ),
        );
      }).toList();
    }
    return coinFallbacks.map((p) {
      return ShopCoinPackData(
        coins: p.coins,
        price: p.price,
        bestValue: p.bestValue,
        onBuy: () => _purchase(
          context,
          () => context.read<ShopCubit>().buyFallback(p),
        ),
      );
    }).toList();
  }

  List<ShopExtraPackData> _extraPacks(BuildContext context) {
    if (useStore) {
      final storeExtras = shopExtraProducts(products);
      if (storeExtras.isNotEmpty) {
        return storeExtras.map((p) {
          final fallback = ShopProducts.fallbackExtras
              .firstWhere((f) => f.id == p.id, orElse: () => ShopPackFallback(
                    id: p.id,
                    title: p.title,
                    coins: ShopProducts.coinRewards[p.id] ?? 0,
                    price: p.price,
                  ));
          return ShopExtraPackData(
            id: p.id,
            title: fallback.title,
            subtitle: fallback.subtitle ?? p.description,
            price: p.price,
            icon: ShopExtraGrid.iconForId(p.id),
            onBuy: () => _purchase(
              context,
              () => context.read<ShopCubit>().buy(p),
            ),
          );
        }).toList();
      }
    }
    return ShopProducts.fallbackExtras.map((p) {
      return ShopExtraPackData(
        id: p.id,
        title: p.title,
        subtitle: p.subtitle ?? '',
        price: p.price,
        icon: ShopExtraGrid.iconForId(p.id),
        onBuy: () => _purchase(
          context,
          () => context.read<ShopCubit>().buyFallback(p),
        ),
      );
    }).toList();
  }

  Future<void> _purchase(
    BuildContext context,
    Future<void> Function() buy,
  ) async {
    if (!await ensureSignedInForPurchase(context)) return;
    if (!context.mounted) return;
    await buy();
    onPurchased();
  }

  Future<void> _buyVip(BuildContext context) async {
    if (vipActive) return;
    final vipProduct = shopFindProduct(products, ShopProducts.vipMonthly);
    if (useStore && vipProduct != null) {
      await _purchase(context, () => context.read<ShopCubit>().buy(vipProduct));
    } else {
      await _purchase(
        context,
        () => context.read<ShopCubit>().buyFallback(ShopProducts.vipFallback),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final coinPacks = _coinPacks(context);
    final extraPacks = _extraPacks(context);

    return ListView(
      padding: EdgeInsets.only(
        top: 8,
        bottom: ShellNavMetrics.listBottomPadding(context),
      ),
      children: [
        VipPassBanner(
          price: _vipPrice,
          isActive: vipActive,
          onGetVip: () => _buyVip(context),
        ),
        const SizedBox(height: 20),
        const ShopSectionHeader(title: 'COINS'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMd),
          child: ShopCoinGrid(packs: coinPacks),
        ),
        const SizedBox(height: 20),
        const ShopSectionHeader(title: 'EXTRAS'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMd),
          child: ShopExtraGrid(packs: extraPacks),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
