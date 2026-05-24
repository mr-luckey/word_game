import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:word_game/features/game/domain/entities/level_entity.dart';
import 'package:word_game/features/game/domain/repositories/level_repository.dart';

class LevelRepositoryImpl implements LevelRepository {
  List<ThemeCategoryEntity>? _cache;

  @override
  Future<List<ThemeCategoryEntity>> loadThemes() async {
    if (_cache != null) return _cache!;
    final packs = await Future.wait([
      rootBundle.loadString('assets/data/levels_pack_1.json'),
      rootBundle.loadString('assets/data/levels_pack_2.json'),
      rootBundle.loadString('assets/data/levels_pack_3.json'),
    ]);
    final categories = <ThemeCategoryEntity>[];
    for (final pack in packs) {
      final data = jsonDecode(pack) as Map<String, dynamic>;
      final cats = data['categories'] as List<dynamic>;
      for (final c in cats) {
        final map = c as Map<String, dynamic>;
        categories.add(
          ThemeCategoryEntity(
            id: map['id'] as int,
            name: map['name'] as String,
            theme: map['theme'] as String? ?? 'default',
            backgroundImage: map['backgroundImage'] as String? ?? '',
            levels: (map['levels'] as List<dynamic>)
                .map((l) => LevelJson.fromJson(l as Map<String, dynamic>))
                .toList(),
          ),
        );
      }
    }
    _cache = categories;
    return categories;
  }

  @override
  Future<LevelEntity?> getLevelById(int levelId) async {
    final themes = await loadThemes();
    for (final theme in themes) {
      for (final level in theme.levels) {
        if (level.id == levelId) {
          return _toEntity(theme, level);
        }
      }
    }
    return null;
  }

  @override
  Future<LevelEntity?> getNextLevel(int currentLevelId) async {
    final themes = await loadThemes();
    final all = <LevelEntity>[];
    for (final theme in themes) {
      for (final level in theme.levels) {
        all.add(_toEntity(theme, level));
      }
    }
    all.sort((a, b) => a.id.compareTo(b.id));
    final idx = all.indexWhere((l) => l.id == currentLevelId);
    if (idx < 0 || idx >= all.length - 1) return null;
    return all[idx + 1];
  }

  LevelEntity _toEntity(ThemeCategoryEntity theme, LevelJson level) =>
      LevelEntity(
        id: level.id,
        themeId: theme.id,
        themeName: theme.name,
        backgroundImage: theme.backgroundImage,
        difficultyIndex: level.difficultyIndex,
        gridSize: level.gridSize,
        timeLimit: level.timeLimit,
        hintsAllowed: level.hintsAllowed,
        coinsReward: level.coinsReward,
        words: level.words,
      );
}
