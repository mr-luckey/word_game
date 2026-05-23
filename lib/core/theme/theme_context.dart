import 'package:flutter/material.dart';
import 'package:word_game/core/theme/app_theme_extension.dart';

extension ThemeContextX on BuildContext {
  AppThemeColors get appColors =>
      Theme.of(this).extension<AppThemeColors>() ?? AppThemeColors.light;

  ColorScheme get colorScheme => Theme.of(this).colorScheme;
}
