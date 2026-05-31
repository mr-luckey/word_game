/// In-app purchase product IDs — replace with your Play Console / App Store IDs.
/// Lists are merged into [all]; add backup IDs to a category if you use alternates.
class ProductIds {
  ProductIds._();

  static const String coins500 = 'coins_500';
  static const String coins1500 = 'coins_1500';
  static const String coins5000 = 'coins_5000';
  static const String removeAds = 'remove_ads';
  static const String vipMonthly = 'vip_monthly';
  static const String starterPack = 'starter_pack';

  static const List<String> coinPacks = [
    coins500,
    coins1500,
    coins5000,
  ];

  static const List<String> consumables = [
  ...coinPacks,
    starterPack,
  ];

  static const List<String> nonConsumables = [
    removeAds,
  ];

  static const List<String> subscriptions = [
    vipMonthly,
  ];

  static const List<String> extras = [
    removeAds,
    vipMonthly,
    starterPack,
  ];

  static Set<String> get all => {
        ...coinPacks,
        ...consumables,
        ...nonConsumables,
        ...subscriptions,
      };
}
