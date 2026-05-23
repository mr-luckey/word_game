import 'package:word_game/core/utils/word_placer.dart';

class GridGenerator {
  GridGenerator({required this.gridSize, this.seed});

  final int gridSize;
  final int? seed;

  PlacementResult generate(List<String> words) {
    return WordPlacer(gridSize: gridSize, seed: seed).placeWords(words);
  }
}
