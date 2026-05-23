class Achievement {
  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    this.unlocked = false,
  });

  final String id;
  final String title;
  final String description;
  final bool unlocked;

  Achievement copyWith({bool? unlocked}) => Achievement(
        id: id,
        title: title,
        description: description,
        unlocked: unlocked ?? this.unlocked,
      );
}

const kAchievements = [
  Achievement(
    id: 'first_word',
    title: 'Word Novice',
    description: 'Find your first word',
  ),
  Achievement(
    id: 'speed_demon',
    title: 'Speed Demon',
    description: 'Complete level under 60 seconds',
  ),
  Achievement(
    id: 'hint_free',
    title: 'Hint-Free Hero',
    description: 'Complete 10 levels without hints',
  ),
  Achievement(
    id: 'world_explore',
    title: 'World Explorer',
    description: 'Complete all levels in one theme',
  ),
  Achievement(
    id: 'daily_7',
    title: 'Daily Devotee',
    description: '7-day login streak',
  ),
  Achievement(
    id: 'vocab_master',
    title: 'Vocabulary Master',
    description: 'Find 1000 total words',
  ),
];
