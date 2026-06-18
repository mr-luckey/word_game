import 'dart:convert';
import 'dart:io';

/// Generates assets/data/achievements_catalog.json with 500+ achievements.
void main() {
  final achievements = <Map<String, dynamic>>[];

  void add({
    required String id,
    required String category,
    required String title,
    required String description,
    required int target,
    int rewardCoins = 10,
    int rewardXp = 0,
    String badgeIcon = 'star',
  }) {
    achievements.add({
      'id': id,
      'category': category,
      'title': title,
      'description': description,
      'target': target,
      'rewardCoins': rewardCoins,
      'rewardXp': rewardXp,
      'badgeIcon': badgeIcon,
    });
  }

  const levelMilestones = [5, 10, 25, 50, 75, 100, 150, 200, 250, 300, 400, 500, 750, 1000];
  for (final n in levelMilestones) {
    add(
      id: 'level_$n',
      category: 'levels',
      title: 'Level $n',
      description: 'Complete level $n',
      target: n,
      rewardCoins: n >= 100 ? 50 : 25,
      rewardXp: n * 10,
    );
  }

  const wordMilestones = [10, 25, 50, 100, 250, 500, 1000, 2500, 5000, 10000];
  for (final n in wordMilestones) {
    add(
      id: 'words_$n',
      category: 'words',
      title: 'Word Hunter $n',
      description: 'Find $n words',
      target: n,
      rewardCoins: n ~/ 20,
    );
  }

  const streakDays = [3, 7, 15, 30, 60, 100];
  for (final n in streakDays) {
    add(
      id: 'streak_$n',
      category: 'streak',
      title: '${n}-Day Streak',
      description: 'Play $n days in a row',
      target: n,
      rewardCoins: n * 5,
    );
  }

  for (var n = 1; n <= 100; n++) {
    add(
      id: 'no_hint_$n',
      category: 'no_hint',
      title: 'Pure Mind $n',
      description: 'Complete $n levels without hints',
      target: n,
      rewardCoins: n >= 50 ? 150 : 10,
    );
  }

  for (var n = 1; n <= 50; n++) {
    add(
      id: 'fast_$n',
      category: 'fast',
      title: 'Speed Runner $n',
      description: 'Complete $n levels under 60 seconds',
      target: n,
      rewardCoins: 15,
    );
  }

  for (var n = 1; n <= 100; n++) {
    add(
      id: 'no_reveal_$n',
      category: 'no_reveal',
      title: 'Reveal Free $n',
      description: 'Complete $n levels without reveal',
      target: n,
      rewardCoins: 12,
    );
  }

  const worlds = [
    'maldives', 'santorini', 'bali', 'tokyo', 'paris', 'dubai',
    'dark_luxury', 'neon_city', 'forest_quest', 'winter_alps',
  ];
  for (final w in worlds) {
    add(
      id: 'world_$w',
      category: 'world',
      title: 'Explore ${w.replaceAll('_', ' ').toUpperCase()}',
      description: 'Complete the $w world',
      target: 1,
      rewardCoins: 100,
      rewardXp: 500,
    );
  }

  for (var n = 1; n <= 100; n++) {
    add(
      id: 'daily_$n',
      category: 'daily',
      title: 'Daily Hero $n',
      description: 'Complete $n daily challenges',
      target: n,
      rewardCoins: 20,
    );
  }

  const xpMilestones = [100, 500, 1000, 2500, 5000, 10000, 25000, 50000, 100000, 500000, 1000000];
  for (final n in xpMilestones) {
    add(
      id: 'xp_$n',
      category: 'xp',
      title: '${_formatNum(n)} XP',
      description: 'Reach $n total XP',
      target: n,
      rewardCoins: n ~/ 100,
      rewardXp: n ~/ 10,
    );
  }

  for (var i = 1; i <= 50; i++) {
    add(
      id: 'rotate_$i',
      category: 'misc',
      title: 'Spinner $i',
      description: 'Rotate the board $i times',
      target: i * 2,
      rewardCoins: 5,
    );
  }

  for (var i = 1; i <= 60; i++) {
    add(
      id: 'bonus_$i',
      category: 'misc',
      title: 'Explorer $i',
      description: 'Reach bonus milestone $i',
      target: i * 10,
      rewardCoins: 8,
    );
  }

  final file = File('assets/data/achievements_catalog.json');
  file.parent.createSync(recursive: true);
  file.writeAsStringSync(
    const JsonEncoder.withIndent('  ').convert(achievements),
  );
  stdout.writeln('Generated ${achievements.length} achievements');
}

String _formatNum(int n) {
  if (n >= 1000000) return '${n ~/ 1000000}M';
  if (n >= 1000) return '${n ~/ 1000}K';
  return '$n';
}
