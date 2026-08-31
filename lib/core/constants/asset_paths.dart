import 'package:word_game/core/theme/app_theme_preset.dart';

class AssetPaths {
  AssetPaths._();

  static const starBurstLottie = 'assets/animations/star_burst.json';
  static const treasureChestImage = 'assets/images/ui/treasure_chest.png';
  /// Same artwork as the platform launcher icon (`ic_launcher`).
  static const appLogo = 'assets/images/ui/app_logo.png';

  static const wordFoundSfx = 'audio/word_found.wav';
  static const levelCompleteSfx = 'audio/level_complete.wav';
  static const wrongSfx = 'audio/wrong.wav';
  static const timerTickSfx = 'audio/timer_tick.wav';
  static const bgMusic = 'audio/bg_music.wav';

  /// Legacy flat theme images (fallback).
  static String themeImage(String fileName) =>
      'assets/images/themes/$fileName';

  static String themeSplash(AppThemePreset preset) =>
      'assets/images/themes/${preset.folder}/splash.webp';

  static String themeGridFile(AppThemePreset preset) =>
      preset == AppThemePreset.classicTravel ? 'grid_full.png' : 'grid_full.webp';

  /// Relative to `assets/images/themes/` (e.g. `classic_travel/grid_full.png`).
  static String themeGridRelative(AppThemePreset preset) =>
      '${preset.folder}/${themeGridFile(preset)}';

  static String themeGrid(AppThemePreset preset) =>
      'assets/images/themes/${themeGridRelative(preset)}';

  /// Full-screen HD scenic background (same asset as treasure / daily rewards).
  static String themeHdBackground(AppThemePreset preset) => themeGrid(preset);

  static String destinationImage(AppThemePreset preset, String slug) =>
      'assets/images/themes/${preset.folder}/$slug.webp';

  static String splashForPreset(AppThemePreset preset) => themeSplash(preset);
}
