import 'package:word_game/core/utils/word_placer.dart';
import 'package:word_game/features/game/presentation/bloc/game_state.dart';

/// Grid index helpers shared by rotate / shuffle / highlight logic.
class GameCellUtils {
  GameCellUtils._();

  static int toIndex(int row, int col, int gridSize) => row * gridSize + col;

  static int rowOf(int index, int gridSize) => index ~/ gridSize;

  static int colOf(int index, int gridSize) => index % gridSize;

  /// Maps a linear cell index after 90° clockwise board rotation.
  static int rotateIndex(int index, int gridSize) {
    final row = rowOf(index, gridSize);
    final col = colOf(index, gridSize);
    final newRow = col;
    final newCol = gridSize - 1 - row;
    return toIndex(newRow, newCol, gridSize);
  }

  static Set<int> rotateIndexSet(Set<int> indices, int gridSize) =>
      indices.map((i) => rotateIndex(i, gridSize)).toSet();

  static Map<int, int> rotateColorMap(Map<int, int> map, int gridSize) => {
        for (final e in map.entries) rotateIndex(e.key, gridSize): e.value,
      };

  static String coordKey(int row, int col) => '$row,$col';

  /// Cells that must keep their letters during shuffle (found + unfound words).
  static Set<String> lockedCoordKeys(
    GameInProgress state,
    List<WordPlacement> placements,
  ) {
    final n = state.grid.length;
    final locked = <String>{};
    final foundTexts = state.foundWords.map((w) => w.text).toSet();

    for (final idx in state.foundCells) {
      locked.add(coordKey(rowOf(idx, n), colOf(idx, n)));
    }

    for (final p in placements) {
      if (foundTexts.contains(p.word)) continue;
      for (final cell in p.cells) {
        locked.add(coordKey(cell.row, cell.col));
      }
    }
    return locked;
  }

  /// Remap hint / reveal sets after board rotation.
  static Set<int> remapHintCells(Set<int> hintCells, int gridSize) =>
      rotateIndexSet(hintCells, gridSize);

  static Set<int> remapRevealedCells(Set<int> revealedCells, int gridSize) =>
      rotateIndexSet(revealedCells, gridSize);
}
