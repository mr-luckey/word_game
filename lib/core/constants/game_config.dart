class GameConfig {
  GameConfig._();

  static const int initialCoins = 250;
  static const int hintCost = 15;
  static const int revealCost = 30;
  static const int shuffleCost = 25;
  static const int rotateCost = 0;

  static const int gridEasy = 8;
  static const int gridMedium = 10;
  static const int gridHard = 12;
  static const int gridPro = 14;

  static const int splashDelayMs = 2500;
  static const int interstitialEveryNLevels = 3;
  static const int rewardedBonusCoins = 50;

  /// VIP Pass: multiply level & daily coin rewards by this factor.
  static const double vipCoinMultiplier = 1.5;
  static const int vipExtraHintsPerLevel = 1;

  static const int defaultTimeLimitSeconds = 180;

  /// Play clock tick each second when remaining time is at or below this.
  static const int timerTickThresholdSeconds = 30;

  static int gridSizeForDifficultyIndex(int index) {
    switch (index) {
      case 0:
        return gridEasy;
      case 1:
        return gridMedium;
      case 2:
        return gridHard;
      case 3:
        return gridPro;
      default:
        return gridEasy;
    }
  }

  static int starsForTimeRatio(double ratio) {
    if (ratio < 0.5) return 3;
    if (ratio < 0.8) return 2;
    return 1;
  }
}
