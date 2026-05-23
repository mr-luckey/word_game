import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:word_game/core/theme/app_theme.dart';
import 'package:word_game/core/theme/app_theme_preset.dart';

class AppThemeState extends Equatable {
  const AppThemeState({
    required this.preset,
    required this.darkMode,
    required this.themeData,
  });

  final AppThemePreset preset;
  final bool darkMode;
  final ThemeData themeData;

  @override
  List<Object?> get props => [preset, darkMode, themeData];
}

class AppThemeCubit extends Cubit<AppThemeState> {
  AppThemeCubit(this._prefs)
      : super(
          AppThemeState(
            preset: _loadPreset(_prefs),
            darkMode: _prefs.getBool(_darkKey) ?? false,
            themeData: AppTheme.build(
              preset: _loadPreset(_prefs),
              darkMode: _prefs.getBool(_darkKey) ?? false,
            ),
          ),
        );

  static const _presetKey = 'app_theme_preset';
  static const _darkKey = 'app_dark_mode';

  final SharedPreferences _prefs;

  static AppThemePreset _loadPreset(SharedPreferences prefs) {
    final name = prefs.getString(_presetKey);
    if (name == null) return AppThemePreset.journey;
    return AppThemePreset.values.firstWhere(
      (p) => p.name == name,
      orElse: () => AppThemePreset.journey,
    );
  }

  Future<void> setPreset(AppThemePreset preset) async {
    await _prefs.setString(_presetKey, preset.name);
    if (isClosed) return;
    emit(
      AppThemeState(
        preset: preset,
        darkMode: state.darkMode,
        themeData: AppTheme.build(preset: preset, darkMode: state.darkMode),
      ),
    );
  }

  Future<void> toggleDarkMode() async {
    final next = !state.darkMode;
    await _prefs.setBool(_darkKey, next);
    if (isClosed) return;
    emit(
      AppThemeState(
        preset: state.preset,
        darkMode: next,
        themeData: AppTheme.build(preset: state.preset, darkMode: next),
      ),
    );
  }
}
