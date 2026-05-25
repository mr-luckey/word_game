import 'dart:ui';

/// Candy Crush–style vertical adventure map layout (scroll up = progress).
class LevelMapLayout {
  LevelMapLayout({
    required this.count,
    required this.mapWidth,
    this.nodeSpacing = 108,
    this.topPadding = 48,
    this.bottomPadding = 56,
    this.leftXFactor = 0.22,
    this.rightXFactor = 0.78,
  });

  final int count;
  final double mapWidth;
  final double nodeSpacing;
  final double topPadding;
  final double bottomPadding;
  final double leftXFactor;
  final double rightXFactor;

  double get mapHeight {
    if (count <= 1) return topPadding + bottomPadding + nodeSpacing;
    return topPadding + bottomPadding + (count - 1) * nodeSpacing;
  }

  /// Level 1 at bottom; higher levels toward top (scroll up to advance).
  List<Offset> nodeCenters() {
    if (count <= 0) return const [];
    return List.generate(count, (i) {
      final y = mapHeight - bottomPadding - i * nodeSpacing;
      final x = mapWidth * (i.isEven ? leftXFactor : rightXFactor);
      return Offset(x, y);
    });
  }

  /// Smooth Catmull-Rom spline (no straight segments between nodes).
  static Path buildCurvedPath(List<Offset> points) {
    final n = points.length;
    if (n < 2) return Path();
    if (n == 2) {
      return Path()
        ..moveTo(points[0].dx, points[0].dy)
        ..cubicTo(
          points[0].dx,
          points[0].dy + (points[1].dy - points[0].dy) * 0.35,
          points[1].dx,
          points[1].dy - (points[1].dy - points[0].dy) * 0.35,
          points[1].dx,
          points[1].dy,
        );
    }

    final path = Path()..moveTo(points[0].dx, points[0].dy);

    for (var i = 0; i < n - 1; i++) {
      final p0 = points[i == 0 ? 0 : i - 1];
      final p1 = points[i];
      final p2 = points[i + 1];
      final p3 = points[i + 2 >= n ? n - 1 : i + 2];

      final cp1 = Offset(
        p1.dx + (p2.dx - p0.dx) / 6,
        p1.dy + (p2.dy - p0.dy) / 6,
      );
      final cp2 = Offset(
        p2.dx - (p3.dx - p1.dx) / 6,
        p2.dy - (p3.dy - p1.dy) / 6,
      );

      path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, p2.dx, p2.dy);
    }

    return path;
  }

  /// Fraction of full path length at node [nodeIndex].
  static double progressFractionAtNode(List<Offset> points, int nodeIndex) {
    if (points.length < 2) return 0;
    final full = buildCurvedPath(points);
    final metrics = full.computeMetrics().toList();
    if (metrics.isEmpty) return 0;

    final total = metrics.first.length;
    if (total <= 0) return 0;

    final idx = nodeIndex.clamp(0, points.length - 1);
    if (idx == 0) return 0;

    var partialLen = 0.0;
    for (var i = 0; i < idx; i++) {
      partialLen += (points[i] - points[i + 1]).distance * 1.15;
    }
    return (partialLen / total).clamp(0.0, 1.0);
  }

  double scrollOffsetToCenterNode({
    required int nodeIndex,
    required double viewportHeight,
  }) {
    if (count <= 0) return 0;
    final centers = nodeCenters();
    if (centers.isEmpty) return 0;
    final maxIndex = centers.length - 1;
    final idx = nodeIndex < 0
        ? 0
        : nodeIndex > maxIndex
            ? maxIndex
            : nodeIndex;
    final nodeY = centers[idx].dy;
    final target = nodeY - viewportHeight * 0.45;
    final maxScroll = (mapHeight - viewportHeight).clamp(0.0, double.infinity);
    return target.clamp(0.0, maxScroll);
  }
}
