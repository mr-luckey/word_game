class Achievement {
  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.coinReward,
    this.unlocked = false,
  });

  final String id;
  final String title;
  final String description;
  final int coinReward;
  final bool unlocked;

  Achievement copyWith({bool? unlocked}) => Achievement(
        id: id,
        title: title,
        description: description,
        coinReward: coinReward,
        unlocked: unlocked ?? this.unlocked,
      );
}

class AchievementUnlock {
  const AchievementUnlock({required this.achievement, required this.coinsAwarded});

  final Achievement achievement;
  final int coinsAwarded;
}

const kAchievements = [
  Achievement(
    id: 'first_word',
    title: 'Word Novice',
    description: 'Find your first word',
    coinReward: 25,
  ),
  Achievement(
    id: 'word_50',
    title: 'Word Hunter',
    description: 'Find 50 words total',
    coinReward: 50,
  ),
  Achievement(
    id: 'word_200',
    title: 'Word Master',
    description: 'Find 200 words total',
    coinReward: 100,
  ),
  Achievement(
    id: 'first_level',
    title: 'First Steps',
    description: 'Complete your first level',
    coinReward: 30,
  ),
  Achievement(
    id: 'levels_10',
    title: 'Dedicated Player',
    description: 'Complete 10 levels',
    coinReward: 75,
  ),
  Achievement(
    id: 'levels_25',
    title: 'Puzzle Pro',
    description: 'Complete 25 levels',
    coinReward: 150,
  ),
  Achievement(
    id: 'speed_demon',
    title: 'Speed Demon',
    description: 'Finish a level under 60 seconds',
    coinReward: 40,
  ),
  Achievement(
    id: 'three_stars',
    title: 'Perfectionist',
    description: 'Earn 3 stars on a level',
    coinReward: 50,
  ),
  Achievement(
    id: 'hint_free',
    title: 'Hint-Free Hero',
    description: 'Complete 5 levels without hints',
    coinReward: 80,
  ),
  Achievement(
    id: 'rotate_master',
    title: 'Rotate Master',
    description: 'Use rotate 20 times',
    coinReward: 35,
  ),
  Achievement(
    id: 'daily_bonus',
    title: 'Daily Devotee',
    description: 'Complete the daily challenge',
    coinReward: 60,
  ),
  Achievement(
    id: 'coin_collector',
    title: 'Coin Collector',
    description: 'Hold 1000 coins at once',
    coinReward: 100,
  ),
];
