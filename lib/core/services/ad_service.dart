import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:word_game/core/constants/ad_unit_ids.dart';
import 'package:word_game/core/constants/game_config.dart';

class AdService {
  AdService(this._prefs);

  final SharedPreferences _prefs;
  static const _removeAdsKey = 'remove_ads';

  InterstitialAd? _interstitial;
  RewardedAd? _rewarded;
  int _levelCount = 0;

  bool get adsRemoved => _prefs.getBool(_removeAdsKey) ?? false;

  Future<void> setAdsRemoved(bool value) async {
    await _prefs.setBool(_removeAdsKey, value);
  }

  Future<void> initialize() async {
    if (kIsWeb) return;
    await MobileAds.instance.initialize();
    loadInterstitial();
    loadRewarded();
  }

  void loadInterstitial() {
    if (adsRemoved || kIsWeb) return;
    InterstitialAd.load(
      adUnitId: AdUnitIds.interstitial,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitial = ad;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitial = null;
              loadInterstitial();
            },
          );
        },
        onAdFailedToLoad: (_) => _interstitial = null,
      ),
    );
  }

  void loadRewarded() {
    if (kIsWeb) return;
    RewardedAd.load(
      adUnitId: AdUnitIds.rewarded,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) => _rewarded = ad,
        onAdFailedToLoad: (_) => _rewarded = null,
      ),
    );
  }

  void onLevelComplete() {
    if (adsRemoved || kIsWeb) return;
    _levelCount++;
    if (_levelCount % GameConfig.interstitialEveryNLevels == 0) {
      showInterstitial();
    }
  }

  Future<void> showInterstitial() async {
    await _interstitial?.show();
  }

  /// Doubles level coins: caller should add [levelCoins] again on success.
  Future<bool> showDoubleCoinsAd({
    required int levelCoins,
    required void Function() onGranted,
  }) async {
    final ad = _rewarded;
    if (ad == null) {
      loadRewarded();
      if (kDebugMode && !kIsWeb) {
        await Future<void>.delayed(const Duration(milliseconds: 400));
        onGranted();
        return true;
      }
      return false;
    }

    var granted = false;
    final completer = Completer<bool>();

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewarded = null;
        loadRewarded();
        if (!completer.isCompleted) completer.complete(granted);
      },
      onAdFailedToShowFullScreenContent: (ad, _) {
        ad.dispose();
        _rewarded = null;
        loadRewarded();
        if (!completer.isCompleted) completer.complete(false);
      },
    );

    await ad.show(
      onUserEarnedReward: (_, __) {
        granted = true;
        onGranted();
      },
    );

    return completer.future;
  }

  Future<bool> showRewardedAd({
    required void Function(int coins) onReward,
    required void Function() onFail,
  }) async {
    return showDoubleCoinsAd(
      levelCoins: GameConfig.rewardedBonusCoins,
      onGranted: () => onReward(GameConfig.rewardedBonusCoins),
    );
  }

  BannerAd? createBannerAd({required void Function(BannerAd) onLoaded}) {
    if (adsRemoved || kIsWeb) return null;
    final banner = BannerAd(
      adUnitId: AdUnitIds.banner,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) => onLoaded(ad as BannerAd),
        onAdFailedToLoad: (ad, _) => ad.dispose(),
      ),
    );
    banner.load();
    return banner;
  }
}
