import 'package:flutter_test/flutter_test.dart';
import 'package:word_game/core/utils/word_placer.dart';
import 'package:word_game/core/utils/word_validator.dart';

void main() {
  test('detects straight line', () {
    const cells = [
      GridCellCoord(row: 0, col: 0),
      GridCellCoord(row: 0, col: 1),
      GridCellCoord(row: 0, col: 2),
    ];
    expect(WordValidator.isStraightLine(cells), isTrue);
  });

  test('buildLine connects start and end', () {
    const start = GridCellCoord(row: 0, col: 0);
    const end = GridCellCoord(row: 0, col: 2);
    final line = WordValidator.buildLine(start, end, 5);
    expect(line.length, 3);
  });
}
