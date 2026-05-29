import 'package:word_game/core/data/game_content_registry.dart';
import 'package:word_game/core/theme/app_theme_bloc.dart';
import 'package:word_game/core/theme/app_theme_preset.dart';
import 'package:word_game/features/game/domain/entities/level_entity.dart';
import 'package:word_game/features/game/domain/repositories/level_repository.dart';
import 'package:word_game/injection.dart';

class LevelRepositoryImpl implements LevelRepository {
  LevelRepositoryImpl(this._content);

  final GameContentRegistry _content;

  AppThemePreset get _preset => getIt<AppThemeBloc>().state.activePreset;

  @override
  Future<List<ThemeCategoryEntity>> loadThemes() async =>
      _content.themesForPreset(_preset);

  @override
  Future<List<ThemeCategoryEntity>> loadThemesForPreset(
    AppThemePreset preset,
  ) async =>
      _content.themesForPreset(preset);

  @override
  Future<LevelEntity?> getLevelById(int levelId) async {
    if (levelId == _content.dailyChallenge.levelId) return null;
    final destId = getIt<AppThemeBloc>().state.activeDestinationId;
    return _content.levelById(
      levelId,
      preset: _preset,
      slotId: destId ?? 1,
    );
  }

  @override
  Future<LevelEntity?> getNextLevel(int currentLevelId) async {
    final levels = _content.sharedLevels;
    final idx = levels.indexWhere((l) => l.id == currentLevelId);
    if (idx < 0 || idx >= levels.length - 1) return null;
    final next = levels[idx + 1];
    final destId = getIt<AppThemeBloc>().state.activeDestinationId ?? 1;
    return _content.levelById(next.id, preset: _preset, slotId: destId);
  }
}
