class DailyChallengeConfig {
  const DailyChallengeConfig({
    required this.levelId,
    required this.name,
    required this.difficultyIndex,
    required this.gridSize,
    required this.timeLimit,
    required this.hintsAllowed,
    required this.backgroundImageTemplate,
    required this.coinSchedule,
    required this.wordPool,
    required this.wordsPerDay,
  });

  final int levelId;
  final String name;
  final int difficultyIndex;
  final int gridSize;
  final int timeLimit;
  final int hintsAllowed;
  final String backgroundImageTemplate;
  final List<int> coinSchedule;
  final List<String> wordPool;
  final int wordsPerDay;

  factory DailyChallengeConfig.fromJson(Map<String, dynamic> json) {
    final level = json['level'] as Map<String, dynamic>;
    return DailyChallengeConfig(
      levelId: level['id'] as int,
      name: level['name'] as String,
      difficultyIndex: level['difficultyIndex'] as int? ?? 1,
      gridSize: level['gridSize'] as int? ?? 10,
      timeLimit: level['timeLimit'] as int? ?? 300,
      hintsAllowed: level['hintsAllowed'] as int? ?? 2,
      backgroundImageTemplate:
          level['backgroundImage'] as String? ?? '{themeFolder}/grid_full.webp',
      coinSchedule: (json['coinSchedule'] as List<dynamic>)
          .map((e) => e as int)
          .toList(),
      wordPool: (json['wordPool'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      wordsPerDay: json['wordsPerDay'] as int? ?? 6,
    );
  }
}
