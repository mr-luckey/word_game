import 'package:flutter_test/flutter_test.dart';
import 'package:word_game/core/utils/word_placer.dart';

void main() {
  test('places all words on grid', () {
    final placer = WordPlacer(gridSize: 8, seed: 42);
    final result = placer.placeWords(['CAT', 'DOG', 'BIRD']);
    expect(result.placements.length, 3);
    expect(result.grid.length, 8);
    for (final row in result.grid) {
      expect(row.length, 8);
      for (final cell in row) {
        expect(cell, isNotEmpty);
      }
    }
  });
}
