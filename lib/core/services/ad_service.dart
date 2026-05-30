import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:word_game/core/constants/admob_ids.dart';
import 'package:word_game/core/constants/game_config.dart';
import 'package:word_game/core/services/vip_service.dart';

class AdService {
  AdService(this._prefs, this._vip);

  final SharedPreferences _prefs;
  final VipService _vip;
  static const _removeAdsKey = 'remove_ads';

  InterstitialAd? _interstitial;
  RewardedAd? _rewarded;
  int _levelCount = 0;

  bool get adsRemoved =>
      (_prefs.getBool(_removeAdsKey) ?? false) || _vip.suppressesAds;

  Future<void> setAdsRemoved(bool value) async {
    await _prefs.setBool(_removeAdsKey, value);
  }

  Future<void> initialize() async {
    if (kIsWeb) return;
    await MobileAds.instance.initialize();
    loadInterstitial();
    loadRewarded();
  }

  void loadInterstitial({int index = 0}) {
    if (adsRemoved || kIsWeb) return;
    final ids = AdMobIds.interstitial;
    if (index >= ids.length) return;

    InterstitialAd.load(
      adUnitId: ids[index],
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
        onAdFailedToLoad: (_) {
          if (index + 1 < ids.length) {
            loadInterstitial(index: index + 1);
          } else {
            _interstitial = null;
          }
        },
      ),
    );
  }

  void loadRewarded({int index = 0}) {
    if (kIsWeb) return;
    final ids = AdMobIds.rewarded;
    if (index >= ids.length) return;

    RewardedAd.load(
      adUnitId: ids[index],
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) => _rewarded = ad,
        onAdFailedToLoad: (_) {
          if (index + 1 < ids.length) {
            loadRewarded(index: index + 1);
          } else {
            _rewarded = null;
          }
        },
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
    final ok = await showDoubleCoinsAd(
      levelCoins: GameConfig.rewardedBonusCoins,
      onGranted: () => onReward(GameConfig.rewardedBonusCoins),
    );
    if (!ok) onFail();
    return ok;
  }

  BannerAd? createBannerAd({
    required void Function(BannerAd) onLoaded,
    int index = 0,
  }) {
    if (adsRemoved || kIsWeb) return null;
    final ids = AdMobIds.banner;
    if (index >= ids.length) return null;

    final banner = BannerAd(
      adUnitId: ids[index],
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) => onLoaded(ad as BannerAd),
        onAdFailedToLoad: (ad, _) {
          ad.dispose();
          if (index + 1 < ids.length) {
            createBannerAd(onLoaded: onLoaded, index: index + 1);
          }
        },
      ),
    );
    banner.load();
    return banner;
  }
}
