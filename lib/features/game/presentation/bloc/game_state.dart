import 'package:equatable/equatable.dart';
import 'package:word_game/features/game/data/models/grid_cell_model.dart';
import 'package:word_game/features/game/domain/entities/level_entity.dart';

enum SelectionState { idle, selecting, correct, wrong }

abstract class GameState extends Equatable {
  const GameState();

  @override
  List<Object?> get props => [];
}

class GameInitial extends GameState {
  const GameInitial();
}

class GameLoading extends GameState {
  const GameLoading();
}

class GameInProgress extends GameState {
  const GameInProgress({
    required this.grid,
    required this.wordsToFind,
    required this.foundWords,
    required this.selectedCells,
    required this.foundCells,
    required this.hintCells,
    required this.revealedCells,
    required this.coins,
    required this.hintsLeft,
    required this.timeLimit,
    required this.levelId,
    required this.elapsed,
    required this.isPaused,
    required this.difficulty,
    required this.selectionState,
    required this.levelTheme,
    required this.backgroundImage,
    required this.coinsReward,
    required this.hintsUsed,
    this.foundCellColors = const {},
  });

  final List<List<GridCellModel>> grid;
  final List<WordModel> wordsToFind;
  final List<WordModel> foundWords;
  final List<GridCellModel> selectedCells;
  final Set<int> foundCells;
  final Set<int> hintCells;
  final Set<int> revealedCells;
  final int coins;
  final int hintsLeft;
  final int timeLimit;
  final int levelId;
  final Duration elapsed;
  final bool isPaused;
  final DifficultyLevel difficulty;
  final SelectionState selectionState;
  final String levelTheme;
  final String backgroundImage;
  final int coinsReward;
  final int hintsUsed;
  final Map<int, int> foundCellColors;

  bool get allWordsFound =>
      foundWords.length == wordsToFind.length;

  int get remainingSeconds => timeLimit > 0
      ? (timeLimit - elapsed.inSeconds).clamp(0, 9999)
      : 0;

  bool get timerDanger => remainingSeconds > 0 && remainingSeconds < 30;

  GameInProgress copyWith({
    List<List<GridCellModel>>? grid,
    List<WordModel>? wordsToFind,
    List<WordModel>? foundWords,
    List<GridCellModel>? selectedCells,
    Set<int>? foundCells,
    Set<int>? hintCells,
    Set<int>? revealedCells,
    Map<int, int>? foundCellColors,
    int? coins,
    int? hintsLeft,
    Duration? elapsed,
    bool? isPaused,
    SelectionState? selectionState,
    int? hintsUsed,
  }) =>
      GameInProgress(
        grid: grid ?? this.grid,
        wordsToFind: wordsToFind ?? this.wordsToFind,
        foundWords: foundWords ?? this.foundWords,
        selectedCells: selectedCells ?? this.selectedCells,
        foundCells: foundCells ?? this.foundCells,
        hintCells: hintCells ?? this.hintCells,
        revealedCells: revealedCells ?? this.revealedCells,
        foundCellColors: foundCellColors ?? this.foundCellColors,
        coins: coins ?? this.coins,
        hintsLeft: hintsLeft ?? this.hintsLeft,
        timeLimit: timeLimit,
        levelId: levelId,
        elapsed: elapsed ?? this.elapsed,
        isPaused: isPaused ?? this.isPaused,
        difficulty: difficulty,
        selectionState: selectionState ?? this.selectionState,
        levelTheme: levelTheme,
        backgroundImage: backgroundImage,
        coinsReward: coinsReward,
        hintsUsed: hintsUsed ?? this.hintsUsed,
      );

  @override
  List<Object?> get props => [
        grid,
        wordsToFind,
        foundWords,
        selectedCells,
        foundCells,
        hintCells,
        revealedCells,
        coins,
        hintsLeft,
        elapsed,
        isPaused,
        selectionState,
        hintsUsed,
        foundCellColors,
        backgroundImage,
      ];
}

class GameCompleted extends GameState {
  const GameCompleted({
    required this.stars,
    required this.coinsEarned,
    required this.time,
    required this.hintsUsed,
    required this.levelId,
  });

  final int stars;
  final int coinsEarned;
  final Duration time;
  final int hintsUsed;
  final int levelId;

  @override
  List<Object?> get props => [stars, coinsEarned, time, hintsUsed, levelId];
}

class GameError extends GameState {
  const GameError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
