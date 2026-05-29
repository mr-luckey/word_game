/// One daily puzzle variant (pick one per calendar day from [DailyChallengeConfig.games]).
class DailyGameConfig {
  const DailyGameConfig({
    required this.id,
    required this.words,
    this.gridSize,
    this.timeLimit,
    this.hintsAllowed,
    this.difficultyIndex,
  });

  final int id;
  final List<String> words;
  final int? gridSize;
  final int? timeLimit;
  final int? hintsAllowed;
  final int? difficultyIndex;

  factory DailyGameConfig.fromJson(Map<String, dynamic> json) {
    return DailyGameConfig(
      id: json['id'] as int? ?? 0,
      words: (json['words'] as List<dynamic>).map((e) => e as String).toList(),
      gridSize: json['gridSize'] as int?,
      timeLimit: json['timeLimit'] as int?,
      hintsAllowed: json['hintsAllowed'] as int?,
      difficultyIndex: json['difficultyIndex'] as int?,
    );
  }
}
