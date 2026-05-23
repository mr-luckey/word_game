import 'package:word_game/core/utils/word_placer.dart';

class WordValidator {
  WordValidator._();

  static bool isStraightLine(List<GridCellCoord> cells) {
    if (cells.length < 2) return true;
    final dr = cells[1].row - cells[0].row;
    final dc = cells[1].col - cells[0].col;
    if (dr == 0 && dc == 0) return false;
    for (var i = 2; i < cells.length; i++) {
      if (cells[i].row - cells[i - 1].row != dr ||
          cells[i].col - cells[i - 1].col != dc) {
        return false;
      }
    }
    return true;
  }

  static List<GridCellCoord> buildLine(
    GridCellCoord start,
    GridCellCoord end,
    int gridSize,
  ) {
    final dr = (end.row - start.row).sign;
    final dc = (end.col - start.col).sign;
    if (dr == 0 && dc == 0) return [start];

    final line = <GridCellCoord>[start];
    var r = start.row;
    var c = start.col;
    while (r != end.row || c != end.col) {
      r += dr;
      c += dc;
      if (r < 0 || r >= gridSize || c < 0 || c >= gridSize) break;
      line.add(GridCellCoord(row: r, col: c));
    }
    return line;
  }

  static WordPlacement? matchPlacement(
    String selectedWord,
    List<WordPlacement> placements,
  ) {
    final reversed = selectedWord.split('').reversed.join();
    for (final p in placements) {
      if (p.word == selectedWord || p.word == reversed) {
        return p;
      }
    }
    return null;
  }
}
