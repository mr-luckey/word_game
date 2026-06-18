import 'dart:io';

/// AdMob unit IDs — replace test IDs with your production IDs.
/// Add multiple IDs per format; the app tries them in order and stops after the first load.
class AdMobIds {
  AdMobIds._();

  static const String testAppId = 'ca-app-pub-3940256099942544~3347511713';

  static const List<String> interstitialAndroid = [
    'ca-app-pub-5561438827097019/6060325087',
    'ca-app-pub-5561438827097019/7812390450',
    'ca-app-pub-5561438827097019/7425377646',
    'ca-app-pub-5561438827097019/8149296799',
    'ca-app-pub-5561438827097019/7429247074',
  ];

  static const List<String> interstitialIos = [
    'ca-app-pub-3940256099942544/4411468910',
  ];

  static const List<String> rewardedAndroid = [
    'ca-app-pub-5561438827097019/3415844860',
    'ca-app-pub-5561438827097019/7564102737',
    'ca-app-pub-5561438827097019/9789681524',
    'ca-app-pub-5561438827097019/4018480093',
    'ca-app-pub-5561438827097019/8476599854',
  ];

  static const List<String> rewardedIos = [
    'ca-app-pub-3940256099942544/1712485313',
  ];

  static const List<String> bannerAndroid = [
    'ca-app-pub-5561438827097019/9639601737',
    'ca-app-pub-5561438827097019/7780600865',
    'ca-app-pub-5561438827097019/3443765025',
    'ca-app-pub-5561438827097019/5960252736',
    'ca-app-pub-5561438827097019/6821866706',
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
