import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

enum DailyDayStatus { collected, available, locked }

class DailyRewardDay {
  const DailyRewardDay({
    required this.day,
    required this.coins,
    required this.status,
    this.isMilestone = false,
  });

  final int day;
  final int coins;
  final DailyDayStatus status;
  final bool isMilestone;
}

class DailyChallengeService {
  DailyChallengeService(this._prefs);

  final SharedPreferences _prefs;
  static const _lastDailyKey = 'last_daily_date';
  static const _lastClaimMsKey = 'last_claim_timestamp_ms';
  static const _streakKey = 'daily_streak';
  static const _cooldown = Duration(hours: 24);

  static const coinSchedule = [50, 100, 150, 250, 500, 750, 1000];

  static int getDailySeed() {
    final now = DateTime.now();
    return now.year * 10000 + now.month * 100 + now.day;
  }

  bool canClaimNow() {
    final lastMs = _prefs.getInt(_lastClaimMsKey);
    if (lastMs == null) return true;
    final last = DateTime.fromMillisecondsSinceEpoch(lastMs);
    return DateTime.now().difference(last) >= _cooldown;
  }

  Duration? cooldownRemaining() {
    if (canClaimNow()) return null;
    final lastMs = _prefs.getInt(_lastClaimMsKey);
    if (lastMs == null) return null;
    final next =
        DateTime.fromMillisecondsSinceEpoch(lastMs).add(_cooldown);
    final left = next.difference(DateTime.now());
    return left.isNegative ? Duration.zero : left;
  }

  int get streak => _prefs.getInt(_streakKey) ?? 0;

  int get todayRewardCoins {
    final day = _nextClaimDay;
    return coinSchedule[(day - 1).clamp(0, coinSchedule.length - 1)];
  }

  int get _nextClaimDay {
    if (!canClaimNow()) return streak.clamp(1, 7);
    return (streak + 1).clamp(1, 7);
  }

  List<DailyRewardDay> buildWeekRewards() {
    return List.generate(7, (i) {
      final day = i + 1;
      final coins = coinSchedule[i];
      return DailyRewardDay(
        day: day,
        coins: coins,
        status: _statusForDay(day),
        isMilestone: day == 7,
      );
    });
  }

  DailyDayStatus _statusForDay(int day) {
    final s = streak;
    if (!canClaimNow()) {
      if (day <= s) return DailyDayStatus.collected;
      return DailyDayStatus.locked;
    }
    final next = (s + 1).clamp(1, 7);
    if (day < next) return DailyDayStatus.collected;
    if (day == next) return DailyDayStatus.available;
    return DailyDayStatus.locked;
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

  Future<void> recordSuccessfulClaim() async {
    await markCompletedToday();
    await _prefs.setInt(
      _lastClaimMsKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

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

  static String formatCountdown(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    if (h > 0) return '${h}h ${m}m';
    if (m > 0) return '${m}m ${s}s';
    return '${s}s';
  }
}
