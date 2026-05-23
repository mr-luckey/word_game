/// Replace these IDs with your Google Play / App Store product IDs.
class ShopProducts {
  ShopProducts._();

  static const coins500 = 'coins_500';
  static const coins1500 = 'coins_1500';
  static const coins5000 = 'coins_5000';
  static const removeAds = 'remove_ads';
  static const vipMonthly = 'vip_monthly';
  static const starterPack = 'starter_pack';

  static const allIds = {
    coins500,
    coins1500,
    coins5000,
    removeAds,
    vipMonthly,
    starterPack,
  };

  static const consumableIds = {coins500, coins1500, coins5000, starterPack};

  static const nonConsumableIds = {removeAds, vipMonthly};

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
    ShopPackFallback(id: removeAds, title: 'Remove Ads', coins: 0, price: '\$1.99'),
    ShopPackFallback(id: vipMonthly, title: 'VIP Pass', coins: 0, price: '\$0.99/mo'),
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
  });

  final String id;
  final String title;
  final int coins;
  final String price;
  final bool bestValue;
}
