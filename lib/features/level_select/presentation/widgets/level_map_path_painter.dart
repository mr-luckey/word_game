import 'package:flutter/material.dart';
import 'package:word_game/features/level_select/presentation/widgets/level_map_layout.dart';

/// Curved adventure path — solid for progress, dashed ahead.
class LevelMapPathPainter extends CustomPainter {
  LevelMapPathPainter({
    required this.points,
    required this.unlockedThroughIndex,
    required this.unlockedColor,
    required this.lockedColor,
    required this.glowColor,
    this.strokeWidth = 6,
  });

  final List<Offset> points;
  final int unlockedThroughIndex;
  final Color unlockedColor;
  final Color lockedColor;
  final Color glowColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    final fullPath = LevelMapLayout.buildCurvedPath(points);
    final metrics = fullPath.computeMetrics().toList();
    if (metrics.isEmpty) return;

    final metric = metrics.first;
    final total = metric.length;
    if (total <= 0) return;

    final fraction = LevelMapLayout.progressFractionAtNode(
      points,
      unlockedThroughIndex,
    );
    final splitAt = (total * fraction).clamp(0.0, total);

    if (splitAt > 2) {
      _drawSolid(
        canvas,
        metric.extractPath(0, splitAt),
        unlockedColor,
        glow: true,
      );
    }

    if (splitAt < total - 2) {
      _drawDashed(canvas, metric.extractPath(splitAt, total), lockedColor);
    }
  }

  void _drawSolid(Canvas canvas, Path path, Color color, {bool glow = false}) {
    if (glow) {
      canvas.drawPath(
        path,
        Paint()
          ..color = glowColor.withValues(alpha: 0.45)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth + 10
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  void _drawDashed(Canvas canvas, Path path, Color color) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth - 1.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    const dash = 10.0;
    const gap = 12.0;
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final end = (distance + dash).clamp(0.0, metric.length);
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant LevelMapPathPainter old) =>
      old.points != points ||
      old.unlockedThroughIndex != unlockedThroughIndex ||
      old.unlockedColor != unlockedColor;
}
