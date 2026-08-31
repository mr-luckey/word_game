import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:word_game/core/config/ads_config.dart';
import 'package:word_game/core/config/app_ads_config.dart';
import 'package:word_game/core/constants/game_config.dart';
import 'package:word_game/core/services/analytics_service.dart';
import 'package:word_game/core/services/network_guard.dart';
import 'package:word_game/core/services/vip_service.dart';

enum RewardedAdOutcome { earned, skipped, unavailable }

enum FullScreenAdKind { interstitial, rewarded }

enum InterstitialSource { scheduled, userAction }

typedef FullScreenAdDismissed = void Function(FullScreenAdKind kind);

/// Central AdMob manager. Placement-based IDs. No waterfall. Offline = idle.
class AdService {
  AdService(
    this._prefs,
    this._vip, {
    AdsConfig? config,
    NetworkGuard? network,
    AnalyticsService? analytics,
  })  : _config = config ?? createAppAdsConfig(),
        _network = network ?? NetworkGuard(),
        _analytics = analytics;

  final SharedPreferences _prefs;
  final VipService _vip;
  final AdsConfig _config;
  final NetworkGuard _network;
  final AnalyticsService? _analytics;

  static const _removeAdsKey = 'remove_ads';

  bool _sdkInitialized = false;
  bool _initializing = false;
  bool _fullScreenShowing = false;
  bool _gameplayActive = false;
  bool _interstitialShowInProgress = false;
  DateTime? _lastFullScreenAt;
  DateTime? _userInterstitialPriorityUntil;

  InterstitialAd? _interstitial;
  String? _interstitialPlacement;
  RewardedAd? _rewarded;
  String? _rewardedPlacement;

  int _interstitialAttempts = 0;
  int _rewardedAttempts = 0;
  Timer? _interstitialRetry;
  Timer? _rewardedRetry;
  Timer? _periodicInterstitialTimer;

  final List<VoidCallback> _readyListeners = [];
  final List<FullScreenAdDismissed> _dismissListeners = [];

  bool get adsRemoved =>
      (_prefs.getBool(_removeAdsKey) ?? false) || _vip.suppressesAds;

  bool get isReady => _sdkInitialized;
  bool get isOnline => _network.isOnline;
  bool get isFullScreenShowing => _fullScreenShowing;
  bool get isGameplayActive => _gameplayActive;
  bool get hasRewardedAd => _rewarded != null;

  /// True while the player is actively finding words — blocks interstitials.
  void setGameplayActive(bool active) {
    _gameplayActive = active;
  }

  void addOnFullScreenAdDismissed(FullScreenAdDismissed listener) =>
      _dismissListeners.add(listener);

  void removeOnFullScreenAdDismissed(FullScreenAdDismissed listener) =>
      _dismissListeners.remove(listener);

  Future<void> setAdsRemoved(bool value) async {
    await _prefs.setBool(_removeAdsKey, value);
    if (value) {
      _stopPeriodicInterstitials();
    } else if (_network.isOnline) {
      _startPeriodicInterstitials();
    }
  }

  void addOnAdsReady(VoidCallback listener) => _readyListeners.add(listener);

  void removeOnAdsReady(VoidCallback listener) =>
      _readyListeners.remove(listener);

  /// SDK init once. Does not load every placement.
  Future<void> initialize() => start();

  Future<void> start() async {
    if (kIsWeb) return;
    await _network.start(onOnline: _onNetworkRestored);
    if (_network.isOnline && !adsRemoved) {
      await _ensureSdk();
      if (_sdkInitialized) {
        unawaited(
          preloadInterstitial(placement: AdPlacements.interstitialAfterSession),
        );
        unawaited(preloadRewarded(placement: AdPlacements.rewardedExtraCoins));
        _startPeriodicInterstitials();
      }
    }
  }

  Future<void> dispose() async {
    _stopPeriodicInterstitials();
    _interstitialRetry?.cancel();
    _rewardedRetry?.cancel();
    _interstitial?.dispose();
    _rewarded?.dispose();
    _interstitial = null;
    _rewarded = null;
    _readyListeners.clear();
    await _network.dispose();
  }

  /// Load a banner for one visible placement. Caller owns dispose.
  Future<BannerAd?> loadBanner({
    required String placement,
    required AdSize size,
  }) async {
    if (adsRemoved || kIsWeb) return null;
    final unitId = _config.bannerUnitId(placement);
    if (unitId == null) return null;
    if (!await _canUseAds()) return null;
    try {
      final completer = Completer<BannerAd?>();
      final ad = BannerAd(
        adUnitId: unitId,
        size: size,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            if (!completer.isCompleted) completer.complete(ad as BannerAd);
          },
          onAdFailedToLoad: (ad, error) {
            debugPrint('Banner no-fill/fail [$placement]: $error');
            ad.dispose();
            if (!completer.isCompleted) completer.complete(null);
          },
        ),
      );
      await ad.load();
      return completer.future.timeout(
        _config.requestTimeout,
        onTimeout: () {
          ad.dispose();
          return null;
        },
      );
    } catch (error, stack) {
      debugPrint('loadBanner failed: $error\n$stack');
      return null;
    }
  }

  Future<void> preloadInterstitial({
    String placement = AdPlacements.interstitialAfterSession,
  }) async {
    if (adsRemoved || kIsWeb) return;
    if (_fullScreenShowing || _interstitialShowInProgress) return;
    if (_interstitial != null && _interstitialPlacement == placement) return;
    final unitId = _config.interstitialUnitId(placement);
    if (unitId == null) return;
    if (!await _canUseAds()) return;
    if (_interstitialAttempts > _config.maxRetries) return;

    try {
      _interstitialRetry?.cancel();
      _interstitial?.dispose();
      _interstitial = null;
      _interstitialPlacement = null;
      final completer = Completer<InterstitialAd?>();
      await InterstitialAd.load(
        adUnitId: unitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: completer.complete,
          onAdFailedToLoad: (error) {
            debugPrint('Interstitial no-fill/fail [$placement]: $error');
            if (!completer.isCompleted) completer.complete(null);
          },
        ),
      );
      final ad = await completer.future.timeout(
        _config.requestTimeout,
        onTimeout: () => null,
      );
      if (ad == null) {
        _interstitialAttempts++;
        _scheduleInterstitialRetry(placement);
        return;
      }
      _interstitialAttempts = 0;
      _interstitialPlacement = placement;
      ad.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (_) => _fullScreenShowing = true,
        onAdDismissedFullScreenContent: (ad) {
          _fullScreenShowing = false;
          _lastFullScreenAt = DateTime.now();
          ad.dispose();
          _interstitial = null;
          _interstitialPlacement = null;
          _notifyFullScreenDismissed(FullScreenAdKind.interstitial);
          unawaited(preloadInterstitial(placement: placement));
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          debugPrint('Interstitial show failed: $error');
          _fullScreenShowing = false;
          ad.dispose();
          _interstitial = null;
          _interstitialPlacement = null;
        },
      );
      _interstitial = ad;
    } catch (error, stack) {
      debugPrint('preloadInterstitial failed: $error\n$stack');
    }
  }

  void onLevelComplete() {
    if (adsRemoved || kIsWeb) return;
    unawaited(
      showInterstitial(
        placement: AdPlacements.interstitialAfterLevelGroup,
        source: InterstitialSource.userAction,
      ),
    );
  }

  /// Natural break when leaving a game session (back to map/home).
  void onGameSessionEnded() {
    if (adsRemoved || kIsWeb) return;
    setGameplayActive(false);
    unawaited(
      showInterstitial(
        placement: AdPlacements.interstitialAfterSession,
        source: InterstitialSource.userAction,
      ),
    );
  }

  /// Button / navigation triggered interstitial — beats scheduled ads.
  Future<bool> showInterstitialForUserAction({
    String placement = AdPlacements.interstitialAfterLevelGroup,
  }) {
    return showInterstitial(placement: placement, source: InterstitialSource.userAction);
  }

  Future<bool> showInterstitial({
    String placement = AdPlacements.interstitialAfterLevelGroup,
    InterstitialSource source = InterstitialSource.userAction,
  }) async {
    if (adsRemoved || kIsWeb) return false;
    if (_gameplayActive) return false;
    if (_fullScreenShowing || _interstitialShowInProgress) return false;
    if (source == InterstitialSource.scheduled &&
        _userInterstitialPriorityUntil != null &&
        DateTime.now().isBefore(_userInterstitialPriorityUntil!)) {
      return false;
    }
    if (!_frequencyAllowsInterstitial()) return false;

    if (source == InterstitialSource.userAction) {
      _userInterstitialPriorityUntil = DateTime.now().add(
        _config.minimumInterstitialInterval,
      );
    }

    _interstitialShowInProgress = true;
    try {
      if (_interstitial == null || _interstitialPlacement != placement) {
        await preloadInterstitial(placement: placement);
      }
      final ad = _interstitial;
      if (ad == null) return false;
      await ad.show();
      return true;
    } catch (error, stack) {
      debugPrint('showInterstitial failed: $error\n$stack');
      _interstitial?.dispose();
      _interstitial = null;
      _interstitialPlacement = null;
      return false;
    } finally {
      _interstitialShowInProgress = false;
    }
  }

  Future<void> preloadRewarded({
    String placement = AdPlacements.rewardedExtraCoins,
  }) async {
    if (kIsWeb) return;
    if (_rewarded != null && _rewardedPlacement == placement) return;
    final unitId = _config.rewardedUnitId(placement);
    if (unitId == null) return;
    if (!await _canUseAds()) return;
    if (_rewardedAttempts > _config.maxRetries) return;

    try {
      _rewardedRetry?.cancel();
      _rewarded?.dispose();
      _rewarded = null;
      final completer = Completer<RewardedAd?>();
      await RewardedAd.load(
        adUnitId: unitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: completer.complete,
          onAdFailedToLoad: (error) {
            debugPrint('Rewarded no-fill/fail [$placement]: $error');
            if (!completer.isCompleted) completer.complete(null);
          },
        ),
      );
      final ad = await completer.future.timeout(
        _config.requestTimeout,
        onTimeout: () => null,
      );
      if (ad == null) {
        _rewardedAttempts++;
        _scheduleRewardedRetry(placement);
        return;
      }
      _rewardedAttempts = 0;
      _rewardedPlacement = placement;
      _rewarded = ad;
    } catch (error, stack) {
      debugPrint('preloadRewarded failed: $error\n$stack');
    }
  }

  /// User-initiated only. Grant a reward only when [RewardedAdOutcome.earned].
  Future<RewardedAdOutcome> showRewarded({
    String placement = AdPlacements.rewardedExtraCoins,
  }) async {
    if (kIsWeb) return RewardedAdOutcome.unavailable;
    if (_fullScreenShowing) return RewardedAdOutcome.unavailable;
    if (_rewarded == null || _rewardedPlacement != placement) {
      await preloadRewarded(placement: placement);
    }
    final ad = _rewarded;
    if (ad == null) return RewardedAdOutcome.unavailable;

    final completer = Completer<RewardedAdOutcome>();
    var earned = false;
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (_) => _fullScreenShowing = true,
      onAdDismissedFullScreenContent: (ad) {
        _fullScreenShowing = false;
        _lastFullScreenAt = DateTime.now();
        ad.dispose();
        _rewarded = null;
        if (!completer.isCompleted) {
          completer.complete(
            earned ? RewardedAdOutcome.earned : RewardedAdOutcome.skipped,
          );
        }
        _notifyFullScreenDismissed(FullScreenAdKind.rewarded);
        unawaited(preloadRewarded(placement: placement));
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('Rewarded show failed: $error');
        _fullScreenShowing = false;
        ad.dispose();
        _rewarded = null;
        if (!completer.isCompleted) {
          completer.complete(RewardedAdOutcome.unavailable);
        }
      },
    );

    try {
      await ad.show(
        onUserEarnedReward: (_, __) {
          earned = true;
        },
      );
      return completer.future;
    } catch (error, stack) {
      debugPrint('showRewarded failed: $error\n$stack');
      ad.dispose();
      _rewarded = null;
      return RewardedAdOutcome.unavailable;
    }
  }

  /// Doubles level coins: caller should add [levelCoins] again on success.
  Future<bool> showDoubleCoinsAd({
    required int levelCoins,
    required void Function() onGranted,
  }) {
    return _showRewardedLegacy(
      placement: AdPlacements.rewardedDoubleCoins,
      onGranted: onGranted,
    );
  }

  /// Doubles level XP: caller should add [xpAmount] again on success.
  Future<bool> showDoubleXpAd({
    required int xpAmount,
    required void Function() onGranted,
  }) {
    return _showRewardedLegacy(
      placement: AdPlacements.rewardedDoubleXp,
      onGranted: onGranted,
    );
  }

  Future<bool> showRewardedAd({
    required void Function(int coins) onReward,
    required void Function() onFail,
  }) async {
    final ok = await _showRewardedLegacy(
      placement: AdPlacements.rewardedExtraCoins,
      onGranted: () => onReward(GameConfig.rewardedBonusCoins),
    );
    if (!ok) onFail();
    return ok;
  }

  Future<bool> _showRewardedLegacy({
    required String placement,
    required void Function() onGranted,
  }) async {
    final outcome = await showRewarded(placement: placement);
    if (outcome != RewardedAdOutcome.earned) return false;
    onGranted();
    unawaited(
      _analytics?.logRewardedAdCompleted(placement: placement, source: 'admob'),
    );
    unawaited(
      _analytics?.logRewardClaimed(rewardType: placement, source: 'rewarded_ad'),
    );
    return true;
  }

  void _onNetworkRestored() {
    if (adsRemoved) return;
    _interstitialAttempts = 0;
    _rewardedAttempts = 0;
    unawaited(() async {
      final ok = await _ensureSdk();
      if (!ok) return;
      unawaited(
        preloadInterstitial(placement: AdPlacements.interstitialAfterSession),
      );
      _startPeriodicInterstitials();
      for (final listener in List<VoidCallback>.from(_readyListeners)) {
        listener();
      }
    }());
  }

  Future<bool> _canUseAds() async {
    if (!_config.isEnabled) return false;
    if (adsRemoved) return false;
    if (!_network.isOnline) return false;
    return _ensureSdk();
  }

  Future<bool> _ensureSdk() async {
    if (kIsWeb) return false;
    if (_sdkInitialized) return true;
    if (!_network.isOnline || !_config.isEnabled || adsRemoved) return false;
    if (_initializing) return _sdkInitialized;
    _initializing = true;
    try {
      await MobileAds.instance.initialize();
      _sdkInitialized = true;
    } catch (error, stack) {
      debugPrint('MobileAds.initialize failed: $error\n$stack');
      _sdkInitialized = false;
    } finally {
      _initializing = false;
    }
    return _sdkInitialized;
  }

  bool _frequencyAllowsInterstitial() {
    final last = _lastFullScreenAt;
    if (last == null) return true;
    return DateTime.now().difference(last) >=
        _config.minimumInterstitialInterval;
  }

  void _startPeriodicInterstitials() {
    _stopPeriodicInterstitials();
    if (adsRemoved || kIsWeb) return;
    _periodicInterstitialTimer = Timer.periodic(
      Duration(seconds: GameConfig.scheduledInterstitialIntervalSeconds),
      (_) => unawaited(_tickScheduledInterstitial()),
    );
  }

  void _stopPeriodicInterstitials() {
    _periodicInterstitialTimer?.cancel();
    _periodicInterstitialTimer = null;
  }

  Future<void> _tickScheduledInterstitial() async {
    if (adsRemoved || kIsWeb) return;
    if (_gameplayActive) return;
    if (_fullScreenShowing || _interstitialShowInProgress) return;
    await showInterstitial(
      placement: AdPlacements.interstitialAfterSession,
      source: InterstitialSource.scheduled,
    );
  }

  void _scheduleInterstitialRetry(String placement) {
    if (!_network.isOnline) return;
    if (_interstitialAttempts > _config.maxRetries) return;
    _interstitialRetry?.cancel();
    final delay = _config.retryBackoff * _interstitialAttempts;
    _interstitialRetry = Timer(delay, () {
      unawaited(preloadInterstitial(placement: placement));
    });
  }

  void _scheduleRewardedRetry(String placement) {
    if (!_network.isOnline) return;
    if (_rewardedAttempts > _config.maxRetries) return;
    _rewardedRetry?.cancel();
    final delay = _config.retryBackoff * _rewardedAttempts;
    _rewardedRetry = Timer(delay, () {
      unawaited(preloadRewarded(placement: placement));
    });
  }

  void _notifyFullScreenDismissed(FullScreenAdKind kind) {
    for (final listener in List<FullScreenAdDismissed>.from(_dismissListeners)) {
      listener(kind);
    }
  }
}
