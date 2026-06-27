import 'package:flutter/material.dart';

/// Responsive scale for [GameScreen] based on a 390×844 design baseline.
class GameScreenMetrics {
  const GameScreenMetrics(this.scale);

  final double scale;

  double s(double value) => value * scale;

  static const _designWidth = 390.0;
  static const _designHeight = 844.0;

  static GameScreenMetrics of(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final padding = MediaQuery.paddingOf(context);
    final usableHeight = size.height - padding.top - padding.bottom;
    final scaleW = size.width / _designWidth;
    final scaleH = usableHeight / _designHeight;
    final scale = (scaleW < scaleH ? scaleW : scaleH).clamp(0.82, 1.12);
    return GameScreenMetrics(scale);
  }
}

class GameScreenScope extends InheritedWidget {
  const GameScreenScope({
    super.key,
    required this.metrics,
    required super.child,
  });

  final GameScreenMetrics metrics;

  static GameScreenMetrics of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<GameScreenScope>();
    assert(scope != null, 'GameScreenScope not found in context');
    return scope!.metrics;
  }

  static GameScreenMetrics? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<GameScreenScope>()
        ?.metrics;
  }

  @override
  bool updateShouldNotify(GameScreenScope oldWidget) =>
      oldWidget.metrics.scale != metrics.scale;
}
