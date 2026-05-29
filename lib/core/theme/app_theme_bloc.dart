import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:word_game/core/theme/app_theme.dart';
import 'package:word_game/core/theme/app_theme_preset.dart';

// ---------------------------------------------------------------------------
// Events
// ---------------------------------------------------------------------------

sealed class AppThemeEvent extends Equatable {
  const AppThemeEvent();
  @override
  List<Object?> get props => [];
}

class AppThemeStarted extends AppThemeEvent {
  const AppThemeStarted();
}

class AppThemeFixedPresetSet extends AppThemeEvent {
  const AppThemeFixedPresetSet(this.preset);
  final AppThemePreset preset;
  @override
  List<Object?> get props => [preset];
}

class AppThemeAutoModeSet extends AppThemeEvent {
  const AppThemeAutoModeSet();
}

class AppThemeDestinationContextSet extends AppThemeEvent {
  const AppThemeDestinationContextSet(this.destinationId);
  final int destinationId;
  @override
  List<Object?> get props => [destinationId];
}

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

class AppThemeState extends Equatable {
  const AppThemeState({
    required this.mode,
    required this.fixedPreset,
    required this.activePreset,
    required this.activeDestinationId,
    required this.themeData,
  });

  final ThemeSelectionMode mode;
  final AppThemePreset fixedPreset;
  final AppThemePreset activePreset;
  final int? activeDestinationId;
  final ThemeData themeData;

  @override
  List<Object?> get props =>
      [mode, fixedPreset, activePreset, activeDestinationId, themeData];
}

// ---------------------------------------------------------------------------
// Bloc
// ---------------------------------------------------------------------------

class AppThemeBloc extends Bloc<AppThemeEvent, AppThemeState> {
  AppThemeBloc(this._prefs) : super(_initial(_prefs)) {
    on<AppThemeStarted>(_onStarted);
    on<AppThemeFixedPresetSet>(_onFixedPreset);
    on<AppThemeAutoModeSet>(_onAutoMode);
    on<AppThemeDestinationContextSet>(_onDestinationContext);
  }

  static const _modeKey = 'app_theme_mode';
  static const _presetKey = 'app_theme_preset';
  static const _destKey = 'app_active_destination';

  final SharedPreferences _prefs;

  static AppThemeState _initial(SharedPreferences prefs) {
    final modeName = prefs.getString(_modeKey);
    final mode = modeName == 'fixed'
        ? ThemeSelectionMode.fixed
        : ThemeSelectionMode.autoDestination;
    final fixed = AppThemePresetX.fromLegacyName(prefs.getString(_presetKey));
    final destId = prefs.getInt(_destKey);
    final active = _resolve(mode, fixed, destId);
    return AppThemeState(
      mode: mode,
      fixedPreset: fixed,
      activePreset: active,
      activeDestinationId: destId,
      themeData: AppTheme.build(preset: active),
    );
  }

  static AppThemePreset _resolve(
    ThemeSelectionMode mode,
    AppThemePreset fixed,
    int? destinationId,
  ) {
    if (mode == ThemeSelectionMode.fixed) return fixed;
    // Explore slot ids are per visual preset; auto mode uses the saved preset.
    return fixed;
  }

  AppThemeState _emitResolved({
    ThemeSelectionMode? mode,
    AppThemePreset? fixedPreset,
    int? activeDestinationId,
    bool clearDestination = false,
  }) {
    final nextMode = mode ?? state.mode;
    final nextFixed = fixedPreset ?? state.fixedPreset;
    final nextDest =
        clearDestination ? null : (activeDestinationId ?? state.activeDestinationId);
    final active = _resolve(nextMode, nextFixed, nextDest);
    return AppThemeState(
      mode: nextMode,
      fixedPreset: nextFixed,
      activePreset: active,
      activeDestinationId: nextDest,
      themeData: AppTheme.build(preset: active),
    );
  }

  Future<void> _onStarted(
    AppThemeStarted event,
    Emitter<AppThemeState> emit,
  ) async {
    // State already loaded in constructor.
  }

  Future<void> _onFixedPreset(
    AppThemeFixedPresetSet event,
    Emitter<AppThemeState> emit,
  ) async {
    await _prefs.setString(_modeKey, 'fixed');
    await _prefs.setString(_presetKey, event.preset.name);
    emit(_emitResolved(mode: ThemeSelectionMode.fixed, fixedPreset: event.preset));
  }

  Future<void> _onAutoMode(
    AppThemeAutoModeSet event,
    Emitter<AppThemeState> emit,
  ) async {
    await _prefs.setString(_modeKey, 'auto');
    emit(_emitResolved(mode: ThemeSelectionMode.autoDestination));
  }

  Future<void> _onDestinationContext(
    AppThemeDestinationContextSet event,
    Emitter<AppThemeState> emit,
  ) async {
    await _prefs.setInt(_destKey, event.destinationId);
    if (state.mode == ThemeSelectionMode.autoDestination) {
      emit(_emitResolved(activeDestinationId: event.destinationId));
    } else {
      emit(
        AppThemeState(
          mode: state.mode,
          fixedPreset: state.fixedPreset,
          activePreset: state.activePreset,
          activeDestinationId: event.destinationId,
          themeData: state.themeData,
        ),
      );
    }
  }
}

/// Backward-compatible alias used across the codebase.
typedef AppThemeCubit = AppThemeBloc;

extension AppThemeBlocCompat on AppThemeBloc {
  AppThemePreset get preset => state.activePreset;

  Future<void> setPreset(AppThemePreset preset) async {
    add(AppThemeFixedPresetSet(preset));
  }

  Future<void> setAutoMode() async {
    add(AppThemeAutoModeSet());
  }

  Future<void> setDestinationContext(int destinationId) async {
    add(AppThemeDestinationContextSet(destinationId));
  }

  Future<void> toggleDarkMode() async {
    // Themes have fixed aesthetics — no-op for compatibility.
  }
}
