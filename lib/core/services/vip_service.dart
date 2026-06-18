import 'package:shared_preferences/shared_preferences.dart';
import 'package:word_game/core/constants/game_config.dart';
import 'package:word_game/core/constants/product_ids.dart';

/// VIP Pass perks (active while [isVipActive]).
class VipService {
  VipService(this._prefs);

  final SharedPreferences _prefs;
  static const _vipKey = 'vip_pass_active';

  bool get isVipActive => _prefs.getBool(_vipKey) ?? false;

  Future<void> setVipActive(bool value) async {
    await _prefs.setBool(_vipKey, value);
  }

  /// +50% coins on level complete.
  int applyLevelCoinBonus(int baseCoins) {
    if (!isVipActive || baseCoins <= 0) return baseCoins;
    return (baseCoins * GameConfig.vipCoinMultiplier).round();
  }

  /// +50% XP on level complete.
  int applyLevelXpBonus(int baseXp) {
    if (!isVipActive || baseXp <= 0) return baseXp;
    return (baseXp * GameConfig.vipCoinMultiplier).round();
  }

  /// +1 free hint at level start.
  int bonusHintsForLevel() => isVipActive ? GameConfig.vipExtraHintsPerLevel : 0;

  /// +50% daily treasure chest coins shown in UI / reward.
  int applyDailyCoinBonus(int baseCoins) {
    if (!isVipActive || baseCoins <= 0) return baseCoins;
    return (baseCoins * GameConfig.vipCoinMultiplier).round();
  }

  bool get suppressesAds => isVipActive;

  static bool productGrantsVip(String productId) =>
      productId == ProductIds.vipMonthly;
}
