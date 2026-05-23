import 'package:flutter/material.dart';
import 'package:word_game/core/theme/app_colors.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/features/game/presentation/bloc/game_state.dart';

class LetterGrid extends StatelessWidget {
  const LetterGrid({
    super.key,
    required this.state,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
  });

  final GameInProgress state;
  final void Function(int row, int col) onDragStart;
  final void Function(int row, int col) onDragUpdate;
  final VoidCallback onDragEnd;

  @override
  Widget build(BuildContext context) {
    final n = state.grid.length;
    return LayoutBuilder(
      builder: (context, constraints) {
        final cellSize = constraints.maxWidth / n;
        return GestureDetector(
          onPanStart: (d) {
            final cell = _cellFromOffset(d.localPosition, cellSize, n);
            if (cell != null) onDragStart(cell.$1, cell.$2);
          },
          onPanUpdate: (d) {
            final cell = _cellFromOffset(d.localPosition, cellSize, n);
            if (cell != null) onDragUpdate(cell.$1, cell.$2);
          },
          onPanEnd: (_) => onDragEnd(),
          child: CustomPaint(
            painter: GridPainter(
              state: state,
              cellSize: cellSize,
            ),
            size: Size.square(constraints.maxWidth),
          ),
        );
      },
    );
  }

  (int, int)? _cellFromOffset(Offset local, double cellSize, int n) {
    final col = (local.dx / cellSize).floor();
    final row = (local.dy / cellSize).floor();
    if (row < 0 || row >= n || col < 0 || col >= n) return null;
    return (row, col);
  }
}

class GridPainter extends CustomPainter {
  GridPainter({required this.state, required this.cellSize});

  final GameInProgress state;
  final double cellSize;

  @override
  void paint(Canvas canvas, Size size) {
    final n = state.grid.length;
    for (var r = 0; r < n; r++) {
      for (var c = 0; c < n; c++) {
        final idx = r * n + c;
        final rect = Rect.fromLTWH(c * cellSize, r * cellSize, cellSize, cellSize);
        Color bg = (r + c) % 2 == 0 ? AppColors.cellDefault : AppColors.cellAlt;
        if (state.foundCells.contains(idx)) {
          bg = AppColors.cellFound;
        } else if (state.revealedCells.contains(idx)) {
          bg = AppColors.cellRevealed;
        } else if (state.hintCells.contains(idx)) {
          bg = AppColors.cellHint;
        } else if (state.selectedCells.any((cell) => cell.row == r && cell.col == c)) {
          bg = state.selectionState == SelectionState.wrong
              ? AppColors.cellWrong
              : AppColors.cellSelected;
        }
        canvas.drawRect(rect, Paint()..color = bg);
        canvas.drawRect(
          rect,
          Paint()
            ..color = AppColors.cellBorder
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1,
        );
        final letter = state.grid[r][c].letter;
        final tp = TextPainter(
          text: TextSpan(
            text: letter,
            style: AppTextStyles.gridLetter(n.toDouble()),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(
          canvas,
          Offset(
            rect.left + (cellSize - tp.width) / 2,
            rect.top + (cellSize - tp.height) / 2,
          ),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant GridPainter old) =>
      old.state != state || old.cellSize != cellSize;
}
