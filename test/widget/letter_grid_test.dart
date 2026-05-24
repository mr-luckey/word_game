import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:word_game/core/theme/app_theme.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/features/game/data/models/grid_cell_model.dart';
import 'package:word_game/features/game/domain/entities/level_entity.dart';
import 'package:word_game/features/game/presentation/bloc/game_state.dart';
import 'package:word_game/features/game/presentation/widgets/letter_grid.dart';

void main() {
  GameInProgress buildState({int size = 3}) {
    final grid = List.generate(
      size,
      (r) => List.generate(
        size,
        (c) => GridCellModel(row: r, col: c, letter: 'A'),
      ),
    );
    return GameInProgress(
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
      backgroundImage: 'paris_bg.jpg',
      themeId: 1,
      coinsReward: 10,
      hintsUsed: 0,
    );
  }

  Widget buildHarness(GameInProgress state, {required Size boxSize}) {
    return MaterialApp(
      theme: AppTheme.light,
      home: Builder(
        builder: (context) {
          return Scaffold(
            body: SizedBox(
              width: boxSize.width,
              height: boxSize.height,
              child: LetterGrid(
                state: state,
                colors: context.appColors,
                onDragStart: (_, __) {},
                onDragUpdate: (_, __) {},
                onDragEnd: () {},
              ),
            ),
          );
        },
      ),
    );
  }

  testWidgets('LetterGrid renders grid cells', (tester) async {
    await tester.pumpWidget(
      buildHarness(buildState(), boxSize: const Size(300, 300)),
    );
    expect(find.byType(LetterGrid), findsOneWidget);
  });

  testWidgets('LetterGrid stays square when height is constrained',
      (tester) async {
    await tester.pumpWidget(
      buildHarness(buildState(size: 8), boxSize: const Size(320, 180)),
    );

    final paintSize = tester.getSize(
      find.descendant(
        of: find.byType(LetterGrid),
        matching: find.byType(CustomPaint),
      ),
    );
    expect(paintSize.width, closeTo(paintSize.height, 0.001));
    expect(paintSize.height, lessThanOrEqualTo(180));
  });
}
