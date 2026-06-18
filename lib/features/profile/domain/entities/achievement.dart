class Achievement {
  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.coinReward,
    this.category = 'misc',
    this.target = 1,
    this.xpReward = 0,
    this.badgeIcon = 'star',
    this.unlocked = false,
  });

  final String id;
  final String title;
  final String description;
  final int coinReward;
  final String category;
  final int target;
  final int xpReward;
  final String badgeIcon;
  final bool unlocked;

  Achievement copyWith({bool? unlocked}) => Achievement(
        id: id,
        title: title,
        description: description,
        coinReward: coinReward,
        category: category,
        target: target,
        xpReward: xpReward,
        badgeIcon: badgeIcon,
        unlocked: unlocked ?? this.unlocked,
      );
}

class AchievementUnlock {
  const AchievementUnlock({
    required this.achievement,
    required this.coinsAwarded,
    this.xpAwarded = 0,
  });

  final Achievement achievement;
  final int coinsAwarded;
  final int xpAwarded;
}

/// Legacy list kept for tests; runtime uses [AchievementCatalogLoader].
const kAchievements = [
  Achievement(
    id: 'first_word',
    title: 'Word Novice',
    description: 'Find your first word',
    coinReward: 25,
  ),
  Achievement(
    id: 'first_level',
    title: 'First Steps',
    description: 'Complete your first level',
    coinReward: 30,
  ),
];
