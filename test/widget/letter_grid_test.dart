import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:word_game/features/game/data/models/grid_cell_model.dart';
import 'package:word_game/features/game/domain/entities/level_entity.dart';
import 'package:word_game/features/game/presentation/bloc/game_state.dart';
import 'package:word_game/features/game/presentation/widgets/letter_grid.dart';

void main() {
  testWidgets('LetterGrid renders grid cells', (tester) async {
    final grid = List.generate(
      3,
      (r) => List.generate(
        3,
        (c) => GridCellModel(row: r, col: c, letter: 'A'),
      ),
    );
    final state = GameInProgress(
      grid: grid,
      wordsToFind: const [WordModel(text: 'AAA')],
      foundWords: const [],
      selectedCells: const [],
      foundCells: {},
      hintCells: {},
      revealedCells: {},
      coins: 100,
      hintsLeft: 3,
      timeLimit: 60,
      levelId: 1,
      elapsed: Duration.zero,
      isPaused: false,
      difficulty: DifficultyLevel.easy,
      selectionState: SelectionState.idle,
      levelTheme: 'Test',
      coinsReward: 10,
      hintsUsed: 0,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 300,
            height: 300,
            child: LetterGrid(
              state: state,
              onDragStart: (_, __) {},
              onDragUpdate: (_, __) {},
              onDragEnd: () {},
            ),
          ),
        ),
      ),
    );
    expect(find.byType(LetterGrid), findsOneWidget);
  });
}
