import 'package:flutter_test/flutter_test.dart';
import 'package:word_game/core/utils/destination_unlock.dart';
import 'package:word_game/features/game/domain/entities/level_entity.dart';

void main() {
  final slot1 = ThemeCategoryEntity(
    id: 1,
    name: 'Paris',
    theme: 'classic_travel',
    backgroundImage: 'a.webp',
    levels: [
      const LevelJson(
        id: 1,
        difficultyIndex: 0,
        gridSize: 10,
        timeLimit: 180,
        hintsAllowed: 3,
        coinsReward: 30,
        words: ['A'],
      ),
      const LevelJson(
        id: 2,
        difficultyIndex: 0,
        gridSize: 10,
        timeLimit: 180,
        hintsAllowed: 3,
        coinsReward: 30,
        words: ['B'],
      ),
    ],
  );
  final slot2 = ThemeCategoryEntity(
    id: 2,
    name: 'London',
    theme: 'classic_travel',
    backgroundImage: 'b.webp',
    levels: [
      const LevelJson(
        id: 101,
        difficultyIndex: 0,
        gridSize: 10,
        timeLimit: 180,
        hintsAllowed: 3,
        coinsReward: 30,
        words: ['C'],
      ),
    ],
  );

  test('slot 1 is always unlocked', () {
    expect(
      DestinationUnlock.isUnlocked(
        slotId: 1,
        sortedThemes: [slot1, slot2],
        starsBySlot: const {},
      ),
      isTrue,
    );
  });

  test('slot 2 locked until slot 1 last level has stars', () {
    expect(
      DestinationUnlock.isUnlocked(
        slotId: 2,
        sortedThemes: [slot1, slot2],
        starsBySlot: {1: {1: 3}},
      ),
      isFalse,
    );
    expect(
      DestinationUnlock.isUnlocked(
        slotId: 2,
        sortedThemes: [slot1, slot2],
        starsBySlot: {1: {2: 2}},
      ),
      isTrue,
    );
  });

  test('lastLevelId picks highest id', () {
    expect(DestinationUnlock.lastLevelId(slot1.levels), 2);
    expect(DestinationUnlock.lastLevelId(slot2.levels), 101);
  });
}
