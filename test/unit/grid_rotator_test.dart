import 'package:flutter_test/flutter_test.dart';
import 'package:word_game/core/utils/grid_rotator.dart';
import 'package:word_game/core/utils/word_placer.dart';

void main() {
  test('rotate90 preserves dimensions', () {
    final grid = List.generate(3, (i) => List.generate(3, (j) => '$i$j'));
    final rotated = GridRotator.rotate90CW(grid);
    expect(rotated.length, 3);
    expect(rotated[0][2], '00');
  });

  test('rotate placements remaps cells', () {
    const placement = WordPlacement(
      word: 'AB',
      startRow: 0,
      startCol: 0,
      direction: Direction.right,
      cells: [
        GridCellCoord(row: 0, col: 0),
        GridCellCoord(row: 0, col: 1),
      ],
    );
    final rotated = GridRotator.rotatePlacements([placement], 3);
    expect(rotated.first.cells.first.row, 0);
    expect(rotated.first.cells.first.col, 2);
  });
}
