import 'package:word_game/core/utils/word_placer.dart';

class GridRotator {
  GridRotator._();

  static List<List<String>> rotate90CW(List<List<String>> grid) {
    final n = grid.length;
    final rotated = List.generate(
      n,
      (_) => List<String>.filled(n, ''),
    );
    for (var i = 0; i < n; i++) {
      for (var j = 0; j < n; j++) {
        rotated[j][n - 1 - i] = grid[i][j];
      }
    }
    return rotated;
  }

  static List<WordPlacement> rotatePlacements(
    List<WordPlacement> placements,
    int gridSize,
  ) {
    return placements
        .map((p) {
          final newCells = p.cells
              .map(
                (cell) => GridCellCoord(
                  row: cell.col,
                  col: gridSize - 1 - cell.row,
                ),
              )
              .toList();
          return WordPlacement(
            word: p.word,
            startRow: newCells.first.row,
            startCol: newCells.first.col,
            direction: _rotateDirection(p.direction),
            cells: newCells,
          );
        })
        .toList();
  }

  static Direction _rotateDirection(Direction d) => switch (d) {
        Direction.right => Direction.down,
        Direction.down => Direction.left,
        Direction.left => Direction.up,
        Direction.up => Direction.right,
        Direction.downRight => Direction.downLeft,
        Direction.downLeft => Direction.upLeft,
        Direction.upLeft => Direction.upRight,
        Direction.upRight => Direction.downRight,
      };
}
