import 'package:flutter/material.dart';
export 'package:word_game/core/theme/app_decorations.dart';
export 'package:word_game/core/theme/app_theme_preset.dart';
export 'package:word_game/core/theme/home_screen_styles.dart';
import 'package:word_game/core/theme/app_theme_extension.dart';
import 'package:word_game/core/theme/app_theme_preset.dart';

extension ThemeContextX on BuildContext {
  AppThemeColors get appColors =>
      Theme.of(this).extension<AppThemeColors>() ?? AppThemeColors.light;

  AppThemePreset get themePreset {
    final name = Theme.of(this).extension<_ThemePresetMarker>()?.preset;
    return name ?? AppThemePreset.worldTour;
  }

  ColorScheme get colorScheme => Theme.of(this).colorScheme;
}

/// Internal marker so widgets can read active preset from ThemeData.
class ThemePresetMarker extends ThemeExtension<ThemePresetMarker> {
  const ThemePresetMarker({required this.preset});

  final AppThemePreset preset;

  @override
  ThemePresetMarker copyWith({AppThemePreset? preset}) =>
      ThemePresetMarker(preset: preset ?? this.preset);

  @override
  ThemePresetMarker lerp(ThemeExtension<ThemePresetMarker>? other, double t) {
    if (other is! ThemePresetMarker) return this;
    return t < 0.5 ? this : other;
  }
}

// Private alias for shorter access in extension above.
typedef _ThemePresetMarker = ThemePresetMarker;
