import 'package:flutter_test/flutter_test.dart';
import 'package:word_game/core/utils/word_placer.dart';
import 'package:word_game/core/utils/word_validator.dart';

void main() {
  test('buildSelectionLine snaps near-diagonal drag to true diagonal', () {
    const start = GridCellCoord(row: 0, col: 0);
    const end = GridCellCoord(row: 3, col: 2);
    final line = WordValidator.buildSelectionLine(start, end, 10);
    expect(line.length, 3);
    expect(line.last.row, 2);
    expect(line.last.col, 2);
    expect(WordValidator.isStraightLine(line), isTrue);
  });

  test('buildSelectionLine keeps horizontal drag', () {
    const start = GridCellCoord(row: 2, col: 1);
    const end = GridCellCoord(row: 2, col: 5);
    final line = WordValidator.buildSelectionLine(start, end, 10);
    expect(line.length, 5);
    expect(line.every((c) => c.row == 2), isTrue);
  });
}
