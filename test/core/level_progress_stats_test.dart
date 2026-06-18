import 'package:flutter_test/flutter_test.dart';
import 'package:word_game/core/utils/level_progress_stats.dart';

void main() {
  group('LevelProgressStats', () {
    test('maps legacy slot-1 ids 101+ onto pack ids 1+', () {
      final pack = List.generate(80, (i) => i + 1);
      final raw = {101: 3, 102: 2};
      final normalized = LevelProgressStats.normalizeStars(raw, pack);

      expect(normalized[1], 3);
      expect(normalized[2], 2);
      expect(LevelProgressStats.completedCount(normalized, pack), 2);
    });

    test('resume picks next level after normalized completions', () async {
      final pack = [1, 2, 3, 4];
      final raw = {101: 3, 102: 1};
      final stars = LevelProgressStats.normalizeStars(raw, pack);

      final resume = await LevelProgressStats.pickResumeSharedId(
        normalizedStars: stars,
        orderedPackIds: pack,
        isUnlocked: (_, __) async => true,
        orderedStorageIds: const [10001, 10002, 10003, 10004],
      );

      expect(resume, 3);
      expect(LevelProgressStats.displayNumberFor(pack, resume), 3);
    });

    test('ignores orphan legacy stars outside the active pack', () {
      final pack = [1, 2, 3];
      final raw = {1: 2, 101: 3, 999: 1};
      final normalized = LevelProgressStats.normalizeStars(raw, pack);

      expect(normalized.length, 1);
      expect(normalized[1], 3);
      expect(LevelProgressStats.completedCount(normalized, pack), 1);
    });
  });
}
