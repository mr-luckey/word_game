import 'package:equatable/equatable.dart';

enum DifficultyLevel { easy, medium, hard, pro }

class LevelEntity extends Equatable {
  const LevelEntity({
    required this.id,
    required this.themeId,
    required this.themeName,
    required this.backgroundImage,
    required this.difficultyIndex,
    required this.gridSize,
    required this.timeLimit,
    required this.hintsAllowed,
    required this.coinsReward,
    required this.words,
  });

  final int id;
  final int themeId;
  final String themeName;
  final String backgroundImage;
  final int difficultyIndex;
  final int gridSize;
  final int timeLimit;
  final int hintsAllowed;
  final int coinsReward;
  final List<String> words;

  DifficultyLevel get difficulty => DifficultyLevel.values[difficultyIndex.clamp(0, 3)];

  @override
  List<Object?> get props => [id];
}

class ThemeEntity extends Equatable {
  const ThemeEntity({
    required this.id,
    required this.name,
    required this.themeKey,
    required this.backgroundImage,
    required this.levels,
    this.completedLevels = 0,
  });

  final int id;
  final String name;
  final String themeKey;
  final String backgroundImage;
  final List<LevelEntity> levels;
  final int completedLevels;

  @override
  List<Object?> get props => [id];
}

class ThemeCategoryEntity extends Equatable {
  const ThemeCategoryEntity({
    required this.id,
    required this.name,
    required this.theme,
    required this.backgroundImage,
    required this.levels,
  });

  final int id;
  final String name;
  final String theme;
  final String backgroundImage;
  final List<LevelJson> levels;

  @override
  List<Object?> get props => [id];
}

class LevelJson extends Equatable {
  const LevelJson({
    required this.id,
    required this.difficultyIndex,
    required this.gridSize,
    required this.timeLimit,
    required this.hintsAllowed,
    required this.coinsReward,
    required this.words,
  });

  final int id;
  final int difficultyIndex;
  final int gridSize;
  final int timeLimit;
  final int hintsAllowed;
  final int coinsReward;
  final List<String> words;

  factory LevelJson.fromJson(Map<String, dynamic> json) => LevelJson(
        id: json['id'] as int,
        difficultyIndex: json['difficultyIndex'] as int? ?? 0,
        gridSize: json['gridSize'] as int? ?? 8,
        timeLimit: json['timeLimit'] as int? ?? 180,
        hintsAllowed: json['hintsAllowed'] as int? ?? 3,
        coinsReward: json['coinsReward'] as int? ?? 30,
        words: (json['words'] as List<dynamic>).map((e) => e as String).toList(),
      );

  @override
  List<Object?> get props => [id];
}
