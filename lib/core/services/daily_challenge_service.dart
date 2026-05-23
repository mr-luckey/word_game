import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

class DailyChallengeService {
  DailyChallengeService(this._prefs);

  final SharedPreferences _prefs;
  static const _lastDailyKey = 'last_daily_date';
  static const _streakKey = 'daily_streak';

  static int getDailySeed() {
    final now = DateTime.now();
    return now.year * 10000 + now.month * 100 + now.day;
  }

  bool hasCompletedToday() {
    final last = _prefs.getString(_lastDailyKey) ?? '';
    return last == _todayString();
  }

  Future<void> markCompletedToday() async {
    final last = _prefs.getString(_lastDailyKey) ?? '';
    final today = _todayString();
    if (last != today) {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final yStr =
          '${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}';
      final streak = last == yStr ? (_prefs.getInt(_streakKey) ?? 0) + 1 : 1;
      await _prefs.setInt(_streakKey, streak);
      await _prefs.setString(_lastDailyKey, today);
    }
  }

  int get streak => _prefs.getInt(_streakKey) ?? 0;

  static List<String> getDailyWords() {
    final r = Random(getDailySeed());
    const allWords = [
      'OCEAN',
      'BEACH',
      'CORAL',
      'WAVE',
      'SHELL',
      'FISH',
      'SAND',
      'TIDE',
      'REEF',
      'CRAB',
      'SAIL',
      'PORT',
    ];
    final picked = <String>{};
    while (picked.length < 6) {
      picked.add(allWords[r.nextInt(allWords.length)]);
    }
    return picked.toList();
  }

  String _todayString() {
    final n = DateTime.now();
    return '${n.year}-${n.month.toString().padLeft(2, '0')}-${n.day.toString().padLeft(2, '0')}';
  }
}
