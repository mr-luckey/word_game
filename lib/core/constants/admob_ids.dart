/// Production Android AdMob unit IDs from the AdMob console.
/// iOS production IDs are not in this repo — lists stay empty (do not invent).
/// Multiple IDs per format are named placements, not a no-fill waterfall.
class AdMobIds {
  AdMobIds._();

  static const String androidAppId = 'ca-app-pub-6619866004331477~2679151109';

  static const List<String> interstitialAndroid = [
    'ca-app-pub-6619866004331477/6913979397',
    'ca-app-pub-6619866004331477/6996855392',
    'ca-app-pub-6619866004331477/2567540277',
    'ca-app-pub-6619866004331477/5683773725',
    'ca-app-pub-6619866004331477/9348571041',
  ];

  /// Production iOS interstitial units — missing.
  static const List<String> interstitialIos = <String>[];

  static const List<String> rewardedAndroid = [
    'ca-app-pub-6619866004331477/4370692051',
    'ca-app-pub-6619866004331477/6722407706',
    'ca-app-pub-6619866004331477/8118365372',
    'ca-app-pub-6619866004331477/5492202031',
    'ca-app-pub-6619866004331477/2866038698',
  ];

  /// Production iOS rewarded units — missing.
  static const List<String> rewardedIos = <String>[];

  static const List<String> bannerAndroid = [
    'ca-app-pub-6619866004331477/718827087',
    'ca-app-pub-6619866004331477/4562263749',
    'ca-app-pub-6619866004331477/5193703615',
    'ca-app-pub-6619866004331477/3166306075',
    'ca-app-pub-6619866004331477/9540142736',
  ];

  /// Production iOS banner units — missing.
  static const List<String> bannerIos = <String>[];
}
