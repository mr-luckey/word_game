import 'package:flutter_test/flutter_test.dart';
import 'package:word_game/core/utils/level_progress_id.dart';

void main() {
  test('resume picks first level with no stars after completed ones', () {
    final ordered = [101, 102, 103, 104];
    final stars = {101: 3, 102: 2};
    int? resume;
    for (final id in ordered) {
      if ((stars[id] ?? 0) == 0) {
        resume = id;
        break;
      }
    }
    expect(resume, 103);
  });

  test('legacy level 101 counts toward slot 1 unlock chain', () {
    expect(LevelProgressId.isLegacyStorageKey(101), isTrue);
    expect(LevelProgressId.matchesSlot(101, 1), isTrue);
    expect(LevelProgressId.matchesSlot(101, 2), isFalse);
  });
}
