import 'package:flutter/material.dart';
import 'package:word_game/core/theme/app_sizes.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/core/theme/app_theme_extension.dart';
import 'package:word_game/features/game/presentation/bloc/game_state.dart';

class LetterGrid extends StatelessWidget {
  const LetterGrid({
    super.key,
    required this.state,
    required this.colors,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
  });

  final GameInProgress state;
  final AppThemeColors colors;
  final void Function(int row, int col) onDragStart;
  final void Function(int row, int col) onDragUpdate;
  final VoidCallback onDragEnd;

  @override
  Widget build(BuildContext context) {
    final n = state.grid.length;
    return LayoutBuilder(
      builder: (context, constraints) {
        final gap = AppSizes.gridGap;
        final cellSize = (constraints.maxWidth - gap * (n + 1)) / n;
        final totalSize = cellSize * n + gap * (n + 1);

        return Center(
          child: Container(
            width: totalSize,
            height: totalSize,
            decoration: BoxDecoration(
              color: colors.boardWhite,
              borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              border: Border.all(
                color: colors.glassBorder.withValues(alpha: 0.45),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: colors.shadow,
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            padding: EdgeInsets.all(gap),
            child: GestureDetector(
              onPanStart: (d) {
                final cell = _cellFromOffset(d.localPosition, cellSize, gap, n);
                if (cell != null) onDragStart(cell.$1, cell.$2);
              },
              onPanUpdate: (d) {
                final cell = _cellFromOffset(d.localPosition, cellSize, gap, n);
                if (cell != null) onDragUpdate(cell.$1, cell.$2);
              },
              onPanEnd: (_) => onDragEnd(),
              child: CustomPaint(
                painter: GridPainter(
                  state: state,
                  colors: colors,
                  cellSize: cellSize,
                  gap: gap,
                  letterStyle: AppTextStyles.gridLetter(context, n.toDouble()),
                ),
                size: Size.square(cellSize * n + gap * (n - 1)),
              ),
            ),
          ),
        );
      },
    );
  }

  (int, int)? _cellFromOffset(
    Offset local,
    double cellSize,
    double gap,
    int n,
  ) {
    final stride = cellSize + gap;
    final col = (local.dx / stride).floor();
    final row = (local.dy / stride).floor();
    if (row < 0 || row >= n || col < 0 || col >= n) return null;
    final cx = local.dx - col * stride;
    final cy = local.dy - row * stride;
    if (cx > cellSize || cy > cellSize) return null;
    return (row, col);
  }
}

class GridPainter extends CustomPainter {
  GridPainter({
    required this.state,
    required this.colors,
    required this.cellSize,
    required this.gap,
    required this.letterStyle,
  });

  final GameInProgress state;
  final AppThemeColors colors;
  final double cellSize;
  final double gap;
  final TextStyle letterStyle;

  /// Dark letters on light tiles, light letters on dark tiles (all themes).
  Color _contrastLetterColor(Color cellBackground) {
    return cellBackground.computeLuminance() > 0.45
        ? colors.onPrimary
        : colors.onSurface;
  }

  Offset _cellCenter(int row, int col) {
    final stride = cellSize + gap;
    return Offset(
      col * stride + cellSize / 2,
      row * stride + cellSize / 2,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final n = state.grid.length;
    final stride = cellSize + gap;
    final radius = Radius.circular(AppSizes.radiusSm);

    if (state.selectedCells.length >= 2 &&
        state.selectionState != SelectionState.wrong) {
      final path = Path();
      final first = state.selectedCells.first;
      path.moveTo(_cellCenter(first.row, first.col).dx,
          _cellCenter(first.row, first.col).dy);
      for (var i = 1; i < state.selectedCells.length; i++) {
        final c = state.selectedCells[i];
        path.lineTo(_cellCenter(c.row, c.col).dx, _cellCenter(c.row, c.col).dy);
      }
      canvas.drawPath(
        path,
        Paint()
          ..color = colors.selectionLine.withValues(alpha: 0.85)
          ..strokeWidth = cellSize * 0.42
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
    }

    for (var r = 0; r < n; r++) {
      for (var c = 0; c < n; c++) {
        final idx = r * n + c;
        final rect = RRect.fromRectAndRadius(
          Rect.fromLTWH(c * stride, r * stride, cellSize, cellSize),
          radius,
        );

        Color bg = (r + c) % 2 == 0 ? colors.cellDefault : colors.cellAlt;
        if (state.foundCellColors.containsKey(idx)) {
          bg = colors.foundColorForIndex(state.foundCellColors[idx]!);
        } else if (state.revealedCells.contains(idx)) {
          bg = colors.cellRevealed;
        } else if (state.hintCells.contains(idx)) {
          bg = colors.cellHint;
        } else if (state.selectedCells.any((cell) => cell.row == r && cell.col == c)) {
          bg = state.selectionState == SelectionState.wrong
              ? colors.cellWrong
              : colors.cellSelected;
        }

        canvas.drawRRect(rect, Paint()..color = bg);
        canvas.drawRRect(
          rect,
          Paint()
            ..color = colors.cellBorder.withValues(alpha: 0.55)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1,
        );

        final isSelected =
            state.selectedCells.any((cell) => cell.row == r && cell.col == c);
        if (isSelected && state.selectionState != SelectionState.wrong) {
          canvas.drawRRect(
            rect,
            Paint()
              ..color = colors.gold.withValues(alpha: 0.35)
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2.5,
          );
        }

        final letter = state.grid[r][c].letter;
        final letterColor = _contrastLetterColor(bg);
        final tp = TextPainter(
          text: TextSpan(
            text: letter,
            style: letterStyle.copyWith(
              color: letterColor,
              fontWeight: FontWeight.w800,
            ),
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
      old.state != state || old.cellSize != cellSize || old.colors != colors;
}
