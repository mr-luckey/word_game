import 'package:equatable/equatable.dart';
import 'package:word_game/features/game/data/models/grid_cell_model.dart';
import 'package:word_game/features/game/domain/entities/level_entity.dart';

enum SelectionState { idle, selecting, correct, wrong }

/// Marker emitted via [GameInProgress.feedback] to trigger coin dialog.
const kInsufficientCoinsFeedback = '__insufficient_coins__';

class FoundWordPath extends Equatable {
  const FoundWordPath({
    required this.colorIndex,
    required this.cells,
  });

  final int colorIndex;
  final List<({int row, int col})> cells;

  @override
  List<Object?> get props => [colorIndex, cells];
}

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
    required this.timeLimit,
    required this.levelId,
    required this.displayNumber,
    required this.elapsed,
    required this.isPaused,
    required this.difficulty,
    required this.selectionState,
    required this.levelTheme,
    required this.backgroundImage,
    required this.themeId,
    required this.coinsReward,
    required this.xpReward,
    required this.hintsUsed,
    required this.revealsUsed,
    required this.maxReveals,
    this.foundWordPaths = const [],
    this.revealedWordPaths = const [],
    this.feedback,
    this.isCompleting = false,
    this.isTimedOut = false,
    this.showTutorial = false,
    this.tutorialHighlightIndices = const {},
  });

  final List<List<GridCellModel>> grid;
  final List<WordModel> wordsToFind;
  final List<WordModel> foundWords;
  final List<GridCellModel> selectedCells;
  final Set<int> foundCells;
  final Set<int> hintCells;
  final Set<int> revealedCells;
  final int coins;
  final int timeLimit;
  final int levelId;
  final int displayNumber;
  final Duration elapsed;
  final bool isPaused;
  final DifficultyLevel difficulty;
  final SelectionState selectionState;
  final String levelTheme;
  final String backgroundImage;
  final int themeId;
  final int coinsReward;
  final int xpReward;
  final int hintsUsed;
  final int revealsUsed;
  final int maxReveals;
  final List<FoundWordPath> foundWordPaths;
  final List<FoundWordPath> revealedWordPaths;
  final String? feedback;
  final bool isCompleting;
  final bool isTimedOut;
  final bool showTutorial;
  final Set<int> tutorialHighlightIndices;

  int get revealsLeft => (maxReveals - revealsUsed).clamp(0, maxReveals);

  bool get allWordsFound => foundWords.length == wordsToFind.length;

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
    List<FoundWordPath>? foundWordPaths,
    List<FoundWordPath>? revealedWordPaths,
    int? coins,
    Duration? elapsed,
    bool? isPaused,
    SelectionState? selectionState,
    int? hintsUsed,
    int? revealsUsed,
    int? themeId,
    String? feedback,
    bool clearFeedback = false,
    bool? isCompleting,
    bool? isTimedOut,
    bool? showTutorial,
  }) =>
      GameInProgress(
        grid: grid ?? this.grid,
        wordsToFind: wordsToFind ?? this.wordsToFind,
        foundWords: foundWords ?? this.foundWords,
        selectedCells: selectedCells ?? this.selectedCells,
        foundCells: foundCells ?? this.foundCells,
        hintCells: hintCells ?? this.hintCells,
        revealedCells: revealedCells ?? this.revealedCells,
        foundWordPaths: foundWordPaths ?? this.foundWordPaths,
        revealedWordPaths: revealedWordPaths ?? this.revealedWordPaths,
        coins: coins ?? this.coins,
        timeLimit: timeLimit,
        levelId: levelId,
        displayNumber: displayNumber,
        elapsed: elapsed ?? this.elapsed,
        isPaused: isPaused ?? this.isPaused,
        difficulty: difficulty,
        selectionState: selectionState ?? this.selectionState,
        levelTheme: levelTheme,
        backgroundImage: backgroundImage,
        themeId: themeId ?? this.themeId,
        coinsReward: coinsReward,
        xpReward: xpReward,
        hintsUsed: hintsUsed ?? this.hintsUsed,
        revealsUsed: revealsUsed ?? this.revealsUsed,
        maxReveals: maxReveals,
        feedback: clearFeedback ? null : (feedback ?? this.feedback),
        isCompleting: isCompleting ?? this.isCompleting,
        isTimedOut: isTimedOut ?? this.isTimedOut,
        showTutorial: showTutorial ?? this.showTutorial,
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
        elapsed,
        isPaused,
        selectionState,
        hintsUsed,
        revealsUsed,
        displayNumber,
        foundWordPaths,
        revealedWordPaths,
        backgroundImage,
        themeId,
        feedback,
        isCompleting,
        isTimedOut,
        showTutorial,
        tutorialHighlightIndices,
      ];
}

class GameCompleted extends GameState {
  const GameCompleted({
    required this.stars,
    required this.coinsEarned,
    required this.xpEarned,
    required this.time,
    required this.hintsUsed,
    required this.revealsUsed,
    required this.levelId,
    required this.displayNumber,
    required this.themeId,
  });

  final int stars;
  final int coinsEarned;
  final int xpEarned;
  final Duration time;
  final int hintsUsed;
  final int revealsUsed;
  final int levelId;
  final int displayNumber;
  final int themeId;

  @override
  List<Object?> get props => [
        stars,
        coinsEarned,
        xpEarned,
        time,
        hintsUsed,
        revealsUsed,
        levelId,
        displayNumber,
        themeId,
      ];
}

class GameError extends GameState {
  const GameError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

class GameNoMoreLevels extends GameState {
  const GameNoMoreLevels({required this.themeId});

  final int themeId;

  @override
  List<Object?> get props => [themeId];
}
