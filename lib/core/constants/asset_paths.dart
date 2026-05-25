import 'package:word_game/core/theme/app_theme_preset.dart';

class AssetPaths {
  AssetPaths._();

  static const wordLogoLottie = 'assets/animations/word_logo.json';
  static const confettiLottie = 'assets/animations/confetti.json';
  static const starBurstLottie = 'assets/animations/star_burst.json';
  static const wordFoundLottie = 'assets/animations/word_found.json';

  static const wordFoundSfx = 'audio/word_found.wav';
  static const levelCompleteSfx = 'audio/level_complete.wav';
  static const wrongSfx = 'audio/wrong.wav';
  static const bgMusic = 'audio/bg_music.wav';

  /// Legacy flat theme images (fallback).
  static String themeImage(String fileName) =>
      'assets/images/themes/$fileName';

  static String themeSplash(AppThemePreset preset) =>
      'assets/images/themes/${preset.folder}/splash.webp';

  static String themeGrid(AppThemePreset preset) =>
      'assets/images/themes/${preset.folder}/grid_full.webp';

  static String destinationImage(AppThemePreset preset, String slug) =>
      'assets/images/themes/${preset.folder}/$slug.webp';

  static String splashForPreset(AppThemePreset preset) => themeSplash(preset);

  /// World Tour splash background (design layer under title/progress).
  static const worldTourSplashBg =
      'assets/images/themes/world_tour/splash_bg.png';

  /// World Tour home journey card illustration.
  static const worldTourHomeCardBg =
      'assets/images/themes/world_tour/home_card_bg.png';
}
