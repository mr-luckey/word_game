import 'package:word_game/core/constants/product_ids.dart';

/// Shop display metadata and IAP helpers (IDs live in [ProductIds]).
class ShopProducts {
  ShopProducts._();

  static const coins500 = ProductIds.coins500;
  static const coins1500 = ProductIds.coins1500;
  static const coins5000 = ProductIds.coins5000;
  static const removeAds = ProductIds.removeAds;
  static const vipMonthly = ProductIds.vipMonthly;
  static const starterPack = ProductIds.starterPack;

  static final allIds = ProductIds.all;

  static final consumableIds = ProductIds.consumables.toSet();

  static final nonConsumableIds = ProductIds.nonConsumables.toSet();

  static const coinRewards = {
    coins500: 500,
    coins1500: 1500,
    coins5000: 5000,
    starterPack: 200,
  };

  /// Fallback UI when store is unavailable (dev / no Play account).
  static const fallbackPacks = [
    ShopPackFallback(id: coins500, title: '500 Coins', coins: 500, price: '\$0.99'),
    ShopPackFallback(
      id: coins1500,
      title: '1500 Coins',
      coins: 1500,
      price: '\$2.49',
      bestValue: true,
    ),
    ShopPackFallback(id: coins5000, title: '5000 Coins', coins: 5000, price: '\$7.99'),
  ];

  static const fallbackExtras = [
    ShopPackFallback(
      id: removeAds,
      title: 'Remove Ads',
      coins: 0,
      price: '\$1.99',
      subtitle: 'No banners or interstitials',
    ),
    ShopPackFallback(
      id: vipMonthly,
      title: 'VIP Pass',
      coins: 0,
      price: '\$0.99/mo',
      subtitle: '+50% level coins, +1 hint/level, no ads',
    ),
    ShopPackFallback(id: starterPack, title: 'Starter Pack', coins: 200, price: '\$0.49'),
  ];
}

class ShopPackFallback {
  const ShopPackFallback({
    required this.id,
    required this.title,
    required this.coins,
    required this.price,
    this.bestValue = false,
    this.subtitle,
  });

  final String id;
  final String title;
  final int coins;
  final String price;
  final bool bestValue;
  final String? subtitle;
}
