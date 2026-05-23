import 'dart:math';

enum Direction {
  right,
  left,
  down,
  up,
  downRight,
  downLeft,
  upRight,
  upLeft,
}

class GridCellCoord {
  const GridCellCoord({required this.row, required this.col});
  final int row;
  final int col;
}

class WordPlacement {
  const WordPlacement({
    required this.word,
    required this.startRow,
    required this.startCol,
    required this.direction,
    required this.cells,
  });

  final String word;
  final int startRow;
  final int startCol;
  final Direction direction;
  final List<GridCellCoord> cells;
}

class PlacementResult {
  const PlacementResult({
    required this.grid,
    required this.placements,
  });

  final List<List<String>> grid;
  final List<WordPlacement> placements;
}

class WordPlacer {
  WordPlacer({required this.gridSize, int? seed})
      : _random = Random(seed);

  final int gridSize;
  final Random _random;

  static const Map<Direction, List<int>> _dirs = {
    Direction.right: [0, 1],
    Direction.left: [0, -1],
    Direction.down: [1, 0],
    Direction.up: [-1, 0],
    Direction.downRight: [1, 1],
    Direction.downLeft: [1, -1],
    Direction.upRight: [-1, 1],
    Direction.upLeft: [-1, -1],
  };

  PlacementResult placeWords(List<String> words) {
    final grid =
        List.generate(gridSize, (_) => List<String>.filled(gridSize, ''));
    final placements = <WordPlacement>[];
    final sorted = [...words]..sort((a, b) => b.length.compareTo(a.length));

    for (final word in sorted) {
      final upper = word.toUpperCase();
      final placement = _tryPlaceWord(grid, upper);
      if (placement == null) {
        return placeWords(words);
      }
      _applyPlacement(grid, placement);
      placements.add(placement);
    }
    _fillRandom(grid);
    return PlacementResult(grid: grid, placements: placements);
  }

  WordPlacement? _tryPlaceWord(List<List<String>> grid, String word) {
    final dirs = Direction.values.toList()..shuffle(_random);
    for (var attempt = 0; attempt < 100; attempt++) {
      final dir = dirs[attempt % dirs.length];
      final delta = _dirs[dir]!;
      final row = _random.nextInt(gridSize);
      final col = _random.nextInt(gridSize);
      if (_canPlace(grid, word, row, col, delta)) {
        final cells = List.generate(
          word.length,
          (i) => GridCellCoord(
            row: row + delta[0] * i,
            col: col + delta[1] * i,
          ),
        );
        return WordPlacement(
          word: word,
          startRow: row,
          startCol: col,
          direction: dir,
          cells: cells,
        );
      }
    }
    return null;
  }

  bool _canPlace(
    List<List<String>> grid,
    String word,
    int r,
    int c,
    List<int> d,
  ) {
    for (var i = 0; i < word.length; i++) {
      final nr = r + d[0] * i;
      final nc = c + d[1] * i;
      if (nr < 0 || nr >= gridSize || nc < 0 || nc >= gridSize) {
        return false;
      }
      if (grid[nr][nc].isNotEmpty && grid[nr][nc] != word[i]) {
        return false;
      }
    }
    return true;
  }

  void _applyPlacement(List<List<String>> grid, WordPlacement placement) {
    for (var i = 0; i < placement.word.length; i++) {
      final cell = placement.cells[i];
      grid[cell.row][cell.col] = placement.word[i];
    }
  }

  void _fillRandom(List<List<String>> grid) {
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    for (var r = 0; r < gridSize; r++) {
      for (var c = 0; c < gridSize; c++) {
        if (grid[r][c].isEmpty) {
          grid[r][c] = letters[_random.nextInt(26)];
        }
      }
    }
  }
}
