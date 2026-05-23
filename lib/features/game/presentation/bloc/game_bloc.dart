import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:word_game/core/constants/game_config.dart';
import 'package:word_game/core/services/analytics_service.dart';
import 'package:word_game/core/services/audio_service.dart';
import 'package:word_game/core/services/daily_challenge_service.dart';
import 'package:word_game/features/game/domain/entities/level_entity.dart';
import 'package:word_game/core/utils/game_cell_utils.dart';
import 'package:word_game/core/utils/grid_generator.dart';
import 'package:word_game/core/utils/grid_rotator.dart';
import 'package:word_game/core/utils/word_placer.dart';
import 'package:word_game/core/utils/word_validator.dart';
import 'package:word_game/features/game/data/models/grid_cell_model.dart';
import 'package:word_game/features/game/domain/repositories/level_repository.dart';
import 'package:word_game/features/game/domain/usecases/load_level_usecase.dart';
import 'package:word_game/features/game/presentation/bloc/game_event.dart';
import 'package:word_game/features/game/presentation/bloc/game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc({
    required LoadLevelUseCase loadLevel,
    required GetNextLevelUseCase getNextLevel,
    required SaveProgressUseCase saveProgress,
    required SpendCoinsUseCase spendCoins,
    required AddCoinsUseCase addCoins,
    required WalletRepository wallet,
    required AudioService audio,
    required AnalyticsService analytics,
  })  : _loadLevel = loadLevel,
        _getNextLevel = getNextLevel,
        _saveProgress = saveProgress,
        _spendCoins = spendCoins,
        _addCoins = addCoins,
        _wallet = wallet,
        _audio = audio,
        _analytics = analytics,
        super(const GameInitial()) {
    on<LoadLevel>(_onLoadLevel);
    on<LoadNextLevel>(_onLoadNextLevel);
    on<CellDragStarted>(_onDragStart);
    on<CellDragUpdated>(_onDragUpdate);
    on<CellDragEnded>(_onDragEnd);
    on<HintRequested>(_onHint);
    on<RevealRequested>(_onReveal);
    on<BoardRotated>(_onRotate);
    on<ShuffleRequested>(_onShuffle);
    on<GamePaused>(_onPause);
    on<GameResumed>(_onResume);
    on<GameTick>(_onTick);
    on<ClearGameFeedback>(_onClearFeedback);
  }

  final LoadLevelUseCase _loadLevel;
  final GetNextLevelUseCase _getNextLevel;
  final SaveProgressUseCase _saveProgress;
  final SpendCoinsUseCase _spendCoins;
  final AddCoinsUseCase _addCoins;
  final WalletRepository _wallet;
  final AudioService _audio;
  final AnalyticsService _analytics;

  Timer? _timer;
  List<WordPlacement> _placements = [];
  GridCellCoord? _dragStart;

  Future<void> _onLoadLevel(LoadLevel event, Emitter<GameState> emit) async {
    emit(const GameLoading());
    _timer?.cancel();
    LevelEntity? level = await _loadLevel(event.levelId);
    if (level == null && event.levelId == 9999) {
      level = LevelEntity(
        id: 9999,
        themeId: 0,
        themeName: 'Daily Challenge',
        backgroundImage: 'paris_bg.jpg',
        difficultyIndex: 1,
        gridSize: GameConfig.gridMedium,
        timeLimit: 300,
        hintsAllowed: 2,
        coinsReward: 75,
        words: DailyChallengeService.getDailyWords(),
      );
    }
    if (level == null) {
      emit(const GameError('Level not found'));
      return;
    }
    final result =
        GridGenerator(gridSize: level.gridSize).generate(level.words);
    _placements = result.placements;
    final coins = await _wallet.getCoins();
    await _analytics.logLevelStart(level.id);
  final grid = _buildGridModels(result.grid);
    emit(
      GameInProgress(
        grid: grid,
        wordsToFind:
            level.words.map((w) => WordModel(text: w.toUpperCase())).toList(),
        foundWords: const [],
        selectedCells: const [],
        foundCells: {},
        hintCells: {},
        revealedCells: {},
        coins: coins,
        hintsLeft: level.hintsAllowed,
        timeLimit: level.timeLimit,
        levelId: level.id,
        elapsed: Duration.zero,
        isPaused: false,
        difficulty: level.difficulty,
        selectionState: SelectionState.idle,
        levelTheme: level.themeName,
        backgroundImage: level.backgroundImage,
        themeId: level.themeId,
        coinsReward: level.coinsReward,
        hintsUsed: 0,
      ),
    );
    _startTimer();
  }

  Future<void> _onLoadNextLevel(
    LoadNextLevel event,
    Emitter<GameState> emit,
  ) async {
    final currentId = switch (state) {
      GameCompleted s => s.levelId,
      GameInProgress s => s.levelId,
      _ => null,
    };
    if (currentId == null) return;

    final next = await _getNextLevel(currentId);
    if (next == null) {
      emit(GameNoMoreLevels(
        themeId: switch (state) {
          GameCompleted s => s.themeId,
          GameInProgress s => s.themeId,
          _ => 1,
        },
      ));
      return;
    }
    add(LoadLevel(next.id));
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      add(const GameTick());
    });
  }

  void _onTick(GameTick event, Emitter<GameState> emit) {
    final s = state;
    if (s is! GameInProgress || s.isPaused) return;
    final next = s.elapsed + const Duration(seconds: 1);
    if (s.timeLimit > 0 && next.inSeconds >= s.timeLimit) {
      emit(s.copyWith(elapsed: Duration(seconds: s.timeLimit)));
      _completeGame(s.copyWith(elapsed: Duration(seconds: s.timeLimit)), emit);
      return;
    }
    emit(s.copyWith(elapsed: next));
  }

  void _onClearFeedback(ClearGameFeedback event, Emitter<GameState> emit) {
    final s = state;
    if (s is! GameInProgress) return;
    emit(s.copyWith(clearFeedback: true));
  }

  void _onDragStart(CellDragStarted event, Emitter<GameState> emit) {
    final s = state;
    if (s is! GameInProgress || s.isPaused) return;
    _dragStart = GridCellCoord(row: event.row, col: event.col);
    final cell = s.grid[event.row][event.col];
    emit(
      s.copyWith(
        selectedCells: [cell],
        selectionState: SelectionState.selecting,
        clearFeedback: true,
      ),
    );
  }

  void _onDragUpdate(CellDragUpdated event, Emitter<GameState> emit) {
    final s = state;
    if (s is! GameInProgress || _dragStart == null) return;
    final end = GridCellCoord(row: event.row, col: event.col);
    final line = WordValidator.buildLine(
      _dragStart!,
      end,
      s.grid.length,
    );
    if (!WordValidator.isStraightLine(line)) return;
    final cells = line
        .map((c) => s.grid[c.row][c.col])
        .toList();
    emit(s.copyWith(selectedCells: cells));
  }

  void _onDragEnd(CellDragEnded event, Emitter<GameState> emit) async {
    final s = state;
    if (s is! GameInProgress) return;
    _dragStart = null;
    final word = s.selectedCells.map((c) => c.letter).join();
    if (word.length < 2) {
      emit(s.copyWith(selectedCells: [], selectionState: SelectionState.idle));
      return;
    }
    final placement = WordValidator.matchPlacement(word, _placements);
    final alreadyFound = s.foundWords.any((w) => w.text == placement?.word);
    if (placement != null && !alreadyFound) {
      await _audio.playWordFound();
      final n = s.grid.length;
      final colorIndex = s.foundWords.length;
      final newFoundCellColors = Map<int, int>.from(s.foundCellColors);
      for (final c in placement.cells) {
        newFoundCellColors[c.row * n + c.col] = colorIndex;
      }
      final newFoundCells = {
        ...s.foundCells,
        ...placement.cells.map((c) => c.row * n + c.col),
      };
      final newFoundWords = [
        ...s.foundWords,
        WordModel(text: placement.word, isFound: true),
      ];
      var newState = s.copyWith(
        foundWords: newFoundWords,
        foundCells: newFoundCells,
        foundCellColors: newFoundCellColors,
        selectedCells: [],
        selectionState: SelectionState.correct,
      );
      if (newState.allWordsFound) {
        await _completeGame(newState, emit);
      } else {
        emit(newState);
      }
    } else {
      await _audio.playWrong();
      emit(s.copyWith(selectionState: SelectionState.wrong));
      await Future<void>.delayed(const Duration(milliseconds: 500));
      final current = state;
      if (current is GameInProgress) {
        emit(
          current.copyWith(
            selectedCells: [],
            selectionState: SelectionState.idle,
          ),
        );
      }
    }
  }

  Future<void> _onHint(HintRequested event, Emitter<GameState> emit) async {
    final s = state;
    if (s is! GameInProgress || s.isPaused) return;

    final unfound = s.wordsToFind
        .where((w) => !s.foundWords.any((f) => f.text == w.text))
        .toList();
    if (unfound.isEmpty) {
      emit(s.copyWith(feedback: 'All words already found!'));
      return;
    }

    var working = s.copyWith(clearFeedback: true, selectedCells: []);
    if (s.hintsLeft <= 0) {
      final ok = await _spendCoins(GameConfig.hintCost);
      if (!ok) {
        emit(s.copyWith(feedback: 'Not enough coins for a hint.'));
        return;
      }
      final coins = await _wallet.getCoins();
      working = working.copyWith(coins: coins, hintsUsed: s.hintsUsed + 1);
    } else {
      working = working.copyWith(
        hintsLeft: s.hintsLeft - 1,
        hintsUsed: s.hintsUsed + 1,
      );
    }

    final n = working.grid.length;
    final foundTexts = working.foundWords.map((w) => w.text).toSet();

    WordPlacement? targetPlacement;
    for (final word in unfound) {
      final placement = _placements.firstWhere((p) => p.word == word.text);
      final startIdx = GameCellUtils.toIndex(
        placement.cells.first.row,
        placement.cells.first.col,
        n,
      );
      if (!working.hintCells.contains(startIdx)) {
        targetPlacement = placement;
        break;
      }
    }
    targetPlacement ??= _placements.firstWhere(
      (p) => p.word == unfound.first.text && !foundTexts.contains(p.word),
    );

    final start = targetPlacement.cells.first;
    final idx = GameCellUtils.toIndex(start.row, start.col, n);

    emit(
      working.copyWith(
        hintCells: {...working.hintCells, idx},
        feedback: 'Hint: first letter of "${targetPlacement.word}"',
      ),
    );
  }

  Future<void> _onReveal(RevealRequested event, Emitter<GameState> emit) async {
    final s = state;
    if (s is! GameInProgress || s.isPaused) return;

    final unfound = s.wordsToFind
        .where((w) => !s.foundWords.any((f) => f.text == w.text))
        .toList();
    if (unfound.isEmpty) {
      emit(s.copyWith(feedback: 'All words already found!'));
      return;
    }

    final ok = await _spendCoins(GameConfig.revealCost);
    if (!ok) {
      emit(s.copyWith(feedback: 'Not enough coins to reveal a word.'));
      return;
    }
    final coins = await _wallet.getCoins();

    final withoutReveal = unfound.where((w) {
      final p = _placements.firstWhere((pl) => pl.word == w.text);
      final n = s.grid.length;
      return !p.cells.every(
        (c) => s.revealedCells.contains(GameCellUtils.toIndex(c.row, c.col, n)),
      );
    }).toList();

    final targetWord = withoutReveal.isNotEmpty ? withoutReveal.first : unfound.first;
    final placement = _placements.firstWhere((p) => p.word == targetWord.text);
    final n = s.grid.length;
    final indices = placement.cells
        .map((c) => GameCellUtils.toIndex(c.row, c.col, n))
        .toSet();

    emit(
      s.copyWith(
        coins: coins,
        revealedCells: {...s.revealedCells, ...indices},
        hintsUsed: s.hintsUsed + 1,
        selectedCells: [],
        clearFeedback: true,
        feedback: 'Revealed "${placement.word}" on the board',
      ),
    );
  }

  void _onRotate(BoardRotated event, Emitter<GameState> emit) {
    final s = state;
    if (s is! GameInProgress || s.isPaused) return;
    final n = s.grid.length;
    final letters = s.grid.map((row) => row.map((c) => c.letter).toList()).toList();
    final rotated = GridRotator.rotate90CW(letters);
    _placements = GridRotator.rotatePlacements(_placements, n);

    emit(
      s.copyWith(
        grid: _buildGridModels(rotated),
        selectedCells: [],
        selectionState: SelectionState.idle,
        foundCells: GameCellUtils.rotateIndexSet(s.foundCells, n),
        hintCells: GameCellUtils.remapHintCells(s.hintCells, n),
        revealedCells: GameCellUtils.remapRevealedCells(s.revealedCells, n),
        foundCellColors: GameCellUtils.rotateColorMap(s.foundCellColors, n),
        clearFeedback: true,
        feedback: 'Board rotated',
      ),
    );
  }

  Future<void> _onShuffle(ShuffleRequested event, Emitter<GameState> emit) async {
    final s = state;
    if (s is! GameInProgress || s.isPaused) return;

    final ok = await _spendCoins(GameConfig.shuffleCost);
    if (!ok) {
      emit(s.copyWith(feedback: 'Not enough coins to shuffle.'));
      return;
    }
    final coins = await _wallet.getCoins();
    final random = Random();
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final locked = GameCellUtils.lockedCoordKeys(s, _placements);

    final newGrid = s.grid.map((row) => row.map((c) => c).toList()).toList();
    var shuffledCount = 0;
    for (var r = 0; r < newGrid.length; r++) {
      for (var c = 0; c < newGrid[r].length; c++) {
        if (locked.contains(GameCellUtils.coordKey(r, c))) continue;
        newGrid[r][c] = newGrid[r][c].copyWith(
          letter: letters[random.nextInt(26)],
        );
        shuffledCount++;
      }
    }

    emit(
      s.copyWith(
        grid: newGrid,
        coins: coins,
        selectedCells: [],
        selectionState: SelectionState.idle,
        clearFeedback: true,
        feedback: shuffledCount > 0
            ? 'Filler letters shuffled — found words unchanged'
            : 'Nothing to shuffle',
      ),
    );
  }

  void _onPause(GamePaused event, Emitter<GameState> emit) {
    final s = state;
    if (s is! GameInProgress) return;
    emit(s.copyWith(isPaused: true));
  }

  void _onResume(GameResumed event, Emitter<GameState> emit) {
    final s = state;
    if (s is! GameInProgress) return;
    emit(s.copyWith(isPaused: false));
  }

  Future<void> _completeGame(
    GameInProgress s,
    Emitter<GameState> emit,
  ) async {
    _timer?.cancel();
    final ratio = s.timeLimit > 0
        ? s.elapsed.inSeconds / s.timeLimit
        : 0.5;
    final stars = GameConfig.starsForTimeRatio(ratio);
    await _addCoins(s.coinsReward);
    await _saveProgress(
      levelId: s.levelId,
      stars: stars,
      timeSeconds: s.elapsed.inSeconds,
    );
    await _analytics.logLevelComplete(levelId: s.levelId, stars: stars);
    await _audio.playLevelComplete();
    emit(
      GameCompleted(
        stars: stars,
        coinsEarned: s.coinsReward,
        time: s.elapsed,
        hintsUsed: s.hintsUsed,
        levelId: s.levelId,
        themeId: s.themeId,
      ),
    );
  }

  List<List<GridCellModel>> _buildGridModels(List<List<String>> grid) {
    return List.generate(
      grid.length,
      (r) => List.generate(
        grid[r].length,
        (c) => GridCellModel(row: r, col: c, letter: grid[r][c]),
      ),
    );
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
