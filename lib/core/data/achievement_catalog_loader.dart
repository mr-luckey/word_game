import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:word_game/features/profile/domain/entities/achievement.dart';

class AchievementCatalogLoader {
  AchievementCatalogLoader._();

  static List<Achievement>? _cache;

  static Future<List<Achievement>> load() async {
    if (_cache != null) return _cache!;
    final raw = await rootBundle.loadString('assets/data/achievements_catalog.json');
    final list = jsonDecode(raw) as List<dynamic>;
    _cache = list.map((e) {
      final m = e as Map<String, dynamic>;
      return Achievement(
        id: m['id'] as String,
        title: m['title'] as String,
        description: m['description'] as String,
        category: m['category'] as String? ?? 'misc',
        target: (m['target'] as num?)?.toInt() ?? 1,
        coinReward: (m['rewardCoins'] as num?)?.toInt() ?? 0,
        xpReward: (m['rewardXp'] as num?)?.toInt() ?? 0,
        badgeIcon: m['badgeIcon'] as String? ?? 'star',
      );
    }).toList();
    return _cache!;
  }
}
