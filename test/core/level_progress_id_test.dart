import 'package:flutter_test/flutter_test.dart';
import 'package:word_game/core/utils/level_progress_id.dart';

void main() {
  test('encode isolates progress per explore slot', () {
    final paris = LevelProgressId.encode(slotId: 1, sharedLevelId: 101);
    final london = LevelProgressId.encode(slotId: 2, sharedLevelId: 101);
    expect(paris, isNot(london));
    expect(LevelProgressId.matchesSlot(paris, 1), isTrue);
    expect(LevelProgressId.matchesSlot(paris, 2), isFalse);
    expect(LevelProgressId.matchesSlot(london, 2), isTrue);
  });

  test('legacy keys count only for slot 1', () {
    expect(LevelProgressId.matchesSlot(101, 1), isTrue);
    expect(LevelProgressId.matchesSlot(101, 2), isFalse);
  });
}
