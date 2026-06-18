import 'package:word_game/core/theme/app_theme_preset.dart';
import 'package:word_game/core/theme/home_screen_styles.dart';

/// Shared HD background settings (matches daily treasure / rewards screen).
class ScenicBackgroundStyle {
  ScenicBackgroundStyle._();

  static const double hdDarken = 0.35;
  static const double hdBlur = 0;

  static String hdAssetFor(AppThemePreset preset) => preset.homeBackgroundAsset;
}
