import 'package:flutter/foundation.dart';
import 'package:word_game/core/config/ads_config.dart';
import 'package:word_game/core/constants/admob_ids.dart';
import 'package:word_game/core/constants/game_config.dart';

/// Production unit IDs from AdMob console (see [AdMobIds]). Debug builds use
/// Google test IDs via [AdsConfig.testMode]. iOS production lists are empty
/// until real iOS units are supplied.
AdsConfig createAppAdsConfig() {
  if (kIsWeb) {
    return const AdsConfig(isEnabled: false);
  }

  final android = defaultTargetPlatform == TargetPlatform.android;
  return AdsConfig(
    isEnabled: true,
    testMode: kDebugMode,
    bannerEnabled: true,
    interstitialEnabled: true,
    rewardedEnabled: true,
    bannerAdUnits: android ? AdMobIds.bannerAndroid : AdMobIds.bannerIos,
    interstitialAdUnits:
        android ? AdMobIds.interstitialAndroid : AdMobIds.interstitialIos,
    rewardedAdUnits: android ? AdMobIds.rewardedAndroid : AdMobIds.rewardedIos,
    bannerPlacements: const {
      'level_select': 0,
      'game': 1,
      'home': 2,
      'result': 3,
      'shop': 4,
    },
    interstitialPlacements: const {
      'after_level_group': 0,
      'after_session': 1,
    },
    rewardedPlacements: const {
      'extra_coins': 0,
      'double_coins': 1,
      'double_xp': 2,
    },
    minimumInterstitialInterval: const Duration(minutes: 2),
    maxRetries: 2,
    retryBackoff: const Duration(seconds: 30),
    requestTimeout: const Duration(seconds: 10),
  );
}

abstract final class AdPlacements {
  static const bannerLevelSelect = 'level_select';
  static const bannerGame = 'game';
  static const interstitialAfterLevelGroup = 'after_level_group';
  static const rewardedExtraCoins = 'extra_coins';
  static const rewardedDoubleCoins = 'double_coins';
  static const rewardedDoubleXp = 'double_xp';

  static const interstitialEveryNLevels = GameConfig.interstitialEveryNLevels;
}
