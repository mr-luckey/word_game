import 'dart:math' as math;

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
        const gap = AppSizes.gridGap;
        const borderWidth = 2.0;
        final innerRadius = AppSizes.radiusLg - borderWidth;
        final maxW = constraints.maxWidth;
        final maxH = constraints.maxHeight;
        final cellFromWidth = (maxW - gap * 2) / n;
        final cellFromHeight =
            maxH.isFinite ? (maxH - gap * 2) / n : cellFromWidth;
        final cellSize = math.min(cellFromWidth, cellFromHeight);
        final gridExtent = cellSize * n;
        final totalSize = gridExtent + gap * 2;

        return Center(
          child: Container(
            width: totalSize,
            height: totalSize,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: colors.boardWhite,
              borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              border: Border.all(
                color: colors.glassBorder.withValues(alpha: 0.45),
                width: borderWidth,
              ),
              boxShadow: [
                BoxShadow(
                  color: colors.shadow,
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            padding: const EdgeInsets.all(gap),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(innerRadius),
              child: SizedBox(
                width: gridExtent,
                height: gridExtent,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
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
                      colors: colors,
                      cellSize: cellSize,
                      letterStyle:
                          AppTextStyles.gridLetter(context, n.toDouble()),
                    ),
                    size: Size.square(gridExtent),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Nearest cell center — reliable for diagonal drags across tile corners.
  (int, int)? _cellFromOffset(Offset local, double cellSize, int n) {
    if (local.dx < 0 || local.dy < 0) return null;
    final extent = cellSize * n;
    if (local.dx > extent || local.dy > extent) return null;

    var bestRow = 0;
    var bestCol = 0;
    var bestDist = double.infinity;

    for (var r = 0; r < n; r++) {
      for (var c = 0; c < n; c++) {
        final cx = c * cellSize + cellSize / 2;
        final cy = r * cellSize + cellSize / 2;
        final d = (local - Offset(cx, cy)).distanceSquared;
        if (d < bestDist) {
          bestDist = d;
          bestRow = r;
          bestCol = c;
        }
      }
    }
    return (bestRow, bestCol);
  }
}

class GridPainter extends CustomPainter {
  GridPainter({
    required this.state,
    required this.colors,
    required this.cellSize,
    required this.letterStyle,
  });

  final GameInProgress state;
  final AppThemeColors colors;
  final double cellSize;
  final TextStyle letterStyle;

  static const _borderInset = 0.5;

  Color _contrastLetterColor(Color cellBackground) {
    final lightTile = cellBackground.computeLuminance() > 0.45;
    if (lightTile) {
      for (final c in [colors.primary, colors.tertiary, colors.cream]) {
        if (c.computeLuminance() < 0.42) return c;
      }
      return const Color(0xFF1A2744);
    }
    for (final c in [colors.onSurface, colors.onScenic]) {
      if (c.computeLuminance() > 0.58) return c;
    }
    return const Color(0xFFFFFFFF);
  }

  Offset _cellCenter(int row, int col) {
    return Offset(
      col * cellSize + cellSize / 2,
      row * cellSize + cellSize / 2,
    );
  }

  Rect _cellRect(int row, int col) {
    return Rect.fromLTWH(
      col * cellSize + _borderInset,
      row * cellSize + _borderInset,
      cellSize - _borderInset * 2,
      cellSize - _borderInset * 2,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final n = state.grid.length;

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
          ..strokeWidth = cellSize * 0.38
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
    }

    for (var r = 0; r < n; r++) {
      for (var c = 0; c < n; c++) {
        final idx = r * n + c;
        final rect = _cellRect(r, c);

        Color bg = (r + c) % 2 == 0 ? colors.cellDefault : colors.cellAlt;
        if (state.foundCellColors.containsKey(idx)) {
          bg = colors.foundColorForIndex(state.foundCellColors[idx]!);
        } else if (state.revealedCells.contains(idx)) {
          bg = colors.cellRevealed;
        } else if (state.hintCells.contains(idx)) {
          bg = colors.cellHint;
        } else if (state.selectedCells
            .any((cell) => cell.row == r && cell.col == c)) {
          bg = state.selectionState == SelectionState.wrong
              ? colors.cellWrong
              : colors.cellSelected;
        }

        canvas.drawRect(rect, Paint()..color = bg);
        canvas.drawRect(
          rect,
          Paint()
            ..color = colors.cellBorder.withValues(alpha: 0.55)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1,
        );

        final isSelected =
            state.selectedCells.any((cell) => cell.row == r && cell.col == c);
        if (isSelected && state.selectionState != SelectionState.wrong) {
          canvas.drawRect(
            rect,
            Paint()
              ..color = colors.gold.withValues(alpha: 0.35)
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2,
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
            rect.left + (rect.width - tp.width) / 2,
            rect.top + (rect.height - tp.height) / 2,
          ),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant GridPainter old) =>
      old.state != state || old.cellSize != cellSize || old.colors != colors;
}
