import 'dart:math' as math;

import 'package:word_game/core/utils/word_placer.dart';

class WordValidator {
  WordValidator._();

  /// Snaps drag end to the nearest of 8 directions (fixes diagonal corner hits).
  static GridCellCoord snapEndCell(
    GridCellCoord start,
    GridCellCoord end,
    int gridSize,
  ) {
    final dr = end.row - start.row;
    final dc = end.col - start.col;
    if (dr == 0 && dc == 0) return end;

    const dirs = <(int, int)>[
      (0, 1),
      (0, -1),
      (1, 0),
      (-1, 0),
      (1, 1),
      (1, -1),
      (-1, 1),
      (-1, -1),
    ];

    var bestDot = -1.0;
    (int, int)? bestDir;
    final mag = math.sqrt(dr * dr + dc * dc);
    for (final d in dirs) {
      final dirMag = math.sqrt(d.$1 * d.$1 + d.$2 * d.$2);
      final dot = (dr * d.$1 + dc * d.$2) / (mag * dirMag);
      if (dot > bestDot) {
        bestDot = dot;
        bestDir = d;
      }
    }

    final stepR = bestDir!.$1;
    final stepC = bestDir.$2;
    final steps = stepR == 0
        ? dc.abs()
        : stepC == 0
            ? dr.abs()
            : math.min(dr.abs(), dc.abs());

    final endRow = (start.row + stepR * steps).clamp(0, gridSize - 1);
    final endCol = (start.col + stepC * steps).clamp(0, gridSize - 1);
    return GridCellCoord(row: endRow, col: endCol);
  }

  static List<GridCellCoord> buildSelectionLine(
    GridCellCoord start,
    GridCellCoord end,
    int gridSize,
  ) {
    final snapped = snapEndCell(start, end, gridSize);
    return buildLine(start, snapped, gridSize);
  }

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
