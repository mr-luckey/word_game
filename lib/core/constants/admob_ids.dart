import 'dart:io';

/// AdMob unit IDs — replace test IDs with your production IDs.
/// Add multiple IDs per format; the app tries them in order and stops after the first load.
class AdMobIds {
  AdMobIds._();

  static const String testAppId = 'ca-app-pub-3940256099942544~3347511713';

  static const List<String> interstitialAndroid = [
    'ca-app-pub-3940256099942544/1033173712',
  ];

  static const List<String> interstitialIos = [
    'ca-app-pub-3940256099942544/4411468910',
  ];

  static const List<String> rewardedAndroid = [
    'ca-app-pub-3940256099942544/5224354917',
  ];

  static const List<String> rewardedIos = [
    'ca-app-pub-3940256099942544/1712485313',
  ];

  static const List<String> bannerAndroid = [
    'ca-app-pub-3940256099942544/6300978111',
  ];

  static const List<String> bannerIos = [
    'ca-app-pub-3940256099942544/2934735716',
  ];

  static List<String> get interstitial =>
      Platform.isAndroid ? interstitialAndroid : interstitialIos;

  static List<String> get rewarded =>
      Platform.isAndroid ? rewardedAndroid : rewardedIos;

  static List<String> get banner =>
      Platform.isAndroid ? bannerAndroid : bannerIos;
}
