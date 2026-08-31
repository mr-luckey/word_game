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
    this.embedded = false,
    this.darkBoard = false,
    this.gridBoundsKey,
  });

  final GameInProgress state;
  final AppThemeColors colors;
  final void Function(int row, int col) onDragStart;
  final void Function(int row, int col) onDragUpdate;
  final VoidCallback onDragEnd;
  final bool embedded;
  final bool darkBoard;
  final GlobalKey? gridBoundsKey;

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
        final cellFromWidth = maxW / n;
        final cellFromHeight = maxH.isFinite ? maxH / n : cellFromWidth;
        final cellSize = embedded
            ? cellFromWidth
            : math.min(cellFromWidth, cellFromHeight);
        final gridExtent = cellSize * n;
        final totalSize = gridExtent + gap * 2;
        final letterStyle = embedded
            ? AppTextStyles.gridLetter(context, n.toDouble()).copyWith(
                fontSize: cellSize * 0.46,
              )
            : AppTextStyles.gridLetter(context, n.toDouble());

        final gridContent = ClipRRect(
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
                  letterStyle: letterStyle,
                  darkBoard: darkBoard,
                ),
                size: Size.square(gridExtent),
              ),
            ),
          ),
        );

        if (embedded) {
          final grid = gridBoundsKey == null
              ? gridContent
              : KeyedSubtree(key: gridBoundsKey, child: gridContent);
          return grid;
        }

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
            child: gridContent,
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
    this.darkBoard = false,
  });

  final GameInProgress state;
  final AppThemeColors colors;
  final double cellSize;
  final TextStyle letterStyle;
  final bool darkBoard;

  Color get _hintFillColor => colors.cellHint.withValues(alpha: 0.78);

  Color get _revealFillColor => colors.cellRevealed.withValues(alpha: 0.78);

  bool _isSelected(int row, int col) =>
      state.selectedCells.any((cell) => cell.row == row && cell.col == col);

  Color get _selectionFillColor => state.selectionState == SelectionState.wrong
      ? colors.cellWrong.withValues(alpha: 0.92)
      : colors.selectionLine.withValues(alpha: 0.9);

  double get _selectionStrokeWidth => cellSize * 0.62;

  static const _fallbackLetterPalette = [
    Color(0xFFFFE082),
    Color(0xFF80DEEA),
    Color(0xFFFF8A80),
    Color(0xFF69F0AE),
    Color(0xFFFFB74D),
    Color(0xFFCE93D8),
    Color(0xFF4FC3F7),
    Color(0xFFFFF59D),
  ];

  List<Color> get _letterPalette {
    if (colors.foundWordPalette.isNotEmpty) {
      return colors.foundWordPalette;
    }
    return _fallbackLetterPalette;
  }

  /// Bright per-cell color — saturated enough to read on dark and light boards.
  Color _idleLetterColor(int idx) {
    final base = _letterPalette[idx % _letterPalette.length];
    final hsl = HSLColor.fromColor(base);
    final lightness = darkBoard
        ? hsl.lightness.clamp(0.68, 0.92)
        : hsl.lightness.clamp(0.38, 0.52);
    return hsl
        .withLightness(lightness)
        .withSaturation((hsl.saturation * 1.08).clamp(0.55, 1.0))
        .toColor();
  }

  Color _foundLetterColor() => const Color(0xFFFFFFFF);

  FontWeight _letterWeight({required bool isSelected, required bool isFound}) {
    if (isSelected || isFound) return FontWeight.w800;
    return FontWeight.w700;
  }

  Offset _cellCenter(int row, int col) {
    return Offset(
      col * cellSize + cellSize / 2,
      row * cellSize + cellSize / 2,
    );
  }

  Rect _cellRect(int row, int col) {
    return Rect.fromLTWH(
      col * cellSize,
      row * cellSize,
      cellSize,
      cellSize,
    );
  }

  int? _foundColorIndexAt(int row, int col) {
    var latest = -1;
    for (final path in state.foundWordPaths) {
      if (path.cells.any((cell) => cell.row == row && cell.col == col)) {
        latest = path.colorIndex;
      }
    }
    return latest >= 0 ? latest : null;
  }

  bool _isRevealed(int row, int col) =>
      state.revealedWordPaths.any(
        (path) => path.cells.any((cell) => cell.row == row && cell.col == col),
      );

  bool _isHint(int idx) => state.hintCells.contains(idx);

  void _sortCellsInLine(List<({int row, int col})> cells) {
    if (cells.length <= 1) return;

    var anchor = cells.first;
    var farthest = cells.first;
    var maxDistSq = 0.0;
    for (final a in cells) {
      for (final b in cells) {
        final dx = (a.col - b.col).toDouble();
        final dy = (a.row - b.row).toDouble();
        final distSq = dx * dx + dy * dy;
        if (distSq > maxDistSq) {
          maxDistSq = distSq;
          anchor = a;
          farthest = b;
        }
      }
    }

    final dirRow = farthest.row - anchor.row;
    final dirCol = farthest.col - anchor.col;
    cells.sort((a, b) {
      final projA =
          (a.row - anchor.row) * dirRow + (a.col - anchor.col) * dirCol;
      final projB =
          (b.row - anchor.row) * dirRow + (b.col - anchor.col) * dirCol;
      return projA.compareTo(projB);
    });
  }

  void _drawRoundedPath(
    Canvas canvas,
    List<({int row, int col})> cells,
    Color color, {
    double? strokeWidth,
    double opacity = 1,
  }) {
    if (cells.isEmpty) return;
    final paintColor = color.withValues(alpha: color.a * opacity);
    final width = strokeWidth ?? _selectionStrokeWidth;

    if (cells.length == 1) {
      final cell = cells.first;
      canvas.drawCircle(
        _cellCenter(cell.row, cell.col),
        width / 2,
        Paint()
          ..color = paintColor
          ..style = PaintingStyle.fill,
      );
      return;
    }

    final path = Path();
    final first = cells.first;
    path.moveTo(
      _cellCenter(first.row, first.col).dx,
      _cellCenter(first.row, first.col).dy,
    );
    for (var i = 1; i < cells.length; i++) {
      final cell = cells[i];
      path.lineTo(
        _cellCenter(cell.row, cell.col).dx,
        _cellCenter(cell.row, cell.col).dy,
      );
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = paintColor
        ..strokeWidth = width
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  void _drawRoundedPathWithGlow(
    Canvas canvas,
    List<({int row, int col})> cells,
    Color color,
  ) {
    _drawRoundedPath(
      canvas,
      cells,
      color,
      strokeWidth: _selectionStrokeWidth * 1.45,
      opacity: 0.32,
    );
    _drawRoundedPath(canvas, cells, color);
  }

  void _drawFoundWords(Canvas canvas) {
    for (final path in state.foundWordPaths) {
      final cells = List<({int row, int col})>.from(path.cells);
      _sortCellsInLine(cells);
      final color = colors.foundColorForIndex(path.colorIndex);
      _drawRoundedPathWithGlow(canvas, cells, color.withValues(alpha: 0.88));
    }
  }

  void _drawRevealedWords(Canvas canvas) {
    for (final path in state.revealedWordPaths) {
      final cells = List<({int row, int col})>.from(path.cells);
      _sortCellsInLine(cells);
      _drawRoundedPathWithGlow(canvas, cells, _revealFillColor);
    }
  }

  void _drawHintMarkers(Canvas canvas, int n) {
    for (final idx in state.hintCells) {
      final row = idx ~/ n;
      final col = idx % n;
      _drawRoundedPathWithGlow(
        canvas,
        [(row: row, col: col)],
        _hintFillColor,
      );
    }
  }

  void _drawRoundedSelection(Canvas canvas) {
    if (state.selectedCells.isEmpty) return;

    final cells = state.selectedCells
        .map((cell) => (row: cell.row, col: cell.col))
        .toList();
    _drawRoundedPathWithGlow(canvas, cells, _selectionFillColor);
  }

  Color _letterColor({
    required int idx,
    required bool isSelected,
    required bool isFound,
    required bool isRevealed,
    required bool isHint,
    required bool isWrong,
  }) {
    if (isWrong || isSelected || isFound || isRevealed) {
      return _foundLetterColor();
    }
    if (isHint) {
      return _idleLetterColor(idx);
    }
    return _idleLetterColor(idx);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final n = state.grid.length;

    _drawFoundWords(canvas);
    _drawRevealedWords(canvas);
    _drawHintMarkers(canvas, n);

    if (state.selectedCells.isNotEmpty) {
      _drawRoundedSelection(canvas);
    }

    final isWrong = state.selectionState == SelectionState.wrong;

    for (var r = 0; r < n; r++) {
      for (var c = 0; c < n; c++) {
        final rect = _cellRect(r, c);
        final idx = r * n + c;
        final isSelected = _isSelected(r, c);
        final foundColorIndex = _foundColorIndexAt(r, c);
        final isFound = foundColorIndex != null;
        final isRevealed = _isRevealed(r, c);
        final isHint = _isHint(idx);

        final letterColor = _letterColor(
          idx: idx,
          isSelected: isSelected,
          isFound: isFound,
          isRevealed: isRevealed,
          isHint: isHint,
          isWrong: isWrong && isSelected,
        );

        final letter = state.grid[r][c].letter;
        final tp = TextPainter(
          text: TextSpan(
            text: letter,
            style: letterStyle.copyWith(
              color: letterColor,
              fontWeight: _letterWeight(
                isSelected: isSelected,
                isFound: isFound || isRevealed,
              ),
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
      old.state != state ||
      old.cellSize != cellSize ||
      old.colors != colors ||
      old.darkBoard != darkBoard;
}
