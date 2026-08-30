import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Animated neon border with lights that travel around the outline.
class MovingLightBorder extends StatefulWidget {
  const MovingLightBorder({
    super.key,
    required this.child,
    required this.lightColors,
    this.borderWidth = 2.5,
    this.borderRadius = 18,
    this.glowBlur = 14,
    this.glowSpread = 1,
    this.duration = const Duration(seconds: 3),
    this.reverse = false,
    this.padding,
    this.chaseColor,
    this.softGlow = false,
  });

  final Widget child;
  final List<Color> lightColors;
  final double borderWidth;
  final double borderRadius;
  final double glowBlur;
  final double glowSpread;
  final Duration duration;
  final bool reverse;
  final EdgeInsetsGeometry? padding;
  final Color? chaseColor;
  final bool softGlow;

  @override
  State<MovingLightBorder> createState() => _MovingLightBorderState();
}

class _MovingLightBorderState extends State<MovingLightBorder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void didUpdateWidget(MovingLightBorder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = widget.lightColors;
    if (colors.isEmpty) return widget.child;

    final primaryGlow = colors.first;
    final spotColor = widget.chaseColor ??
        Color.lerp(Colors.white, colors.first, 0.28) ??
        Colors.white;
    final glowAlpha = widget.softGlow ? 0.28 : 0.45;
    final looped = [...colors, colors.first];
    final stops = List<double>.generate(
      looped.length,
      (i) => i / (looped.length - 1),
    );

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = widget.reverse ? 1 - _controller.value : _controller.value;
        final angle = t * 2 * math.pi;
        final spotAngle = (t + 0.5) % 1.0 * 2 * math.pi;

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: [
              BoxShadow(
                color: primaryGlow.withValues(alpha: glowAlpha),
                blurRadius: widget.glowBlur,
                spreadRadius: widget.glowSpread,
              ),
              BoxShadow(
                color: colors[colors.length > 1 ? 1 : 0]
                    .withValues(alpha: widget.softGlow ? 0.16 : 0.28),
                blurRadius: widget.glowBlur * 1.8,
              ),
            ],
          ),
          child: CustomPaint(
            foregroundPainter: _ChasingSpotPainter(
              color: spotColor.withValues(alpha: 0.95),
              borderWidth: widget.borderWidth,
              borderRadius: widget.borderRadius,
              rotation: spotAngle,
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                gradient: SweepGradient(
                  colors: looped,
                  stops: stops,
                  transform: GradientRotation(angle),
                ),
              ),
              padding: EdgeInsets.all(widget.borderWidth),
              child: child,
            ),
          ),
        );
      },
      child: widget.child,
    );
  }
}

class _ChasingSpotPainter extends CustomPainter {
  _ChasingSpotPainter({
    required this.color,
    required this.borderWidth,
    required this.borderRadius,
    required this.rotation,
  });

  final Color color;
  final double borderWidth;
  final double borderRadius;
  final double rotation;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(
      rect.deflate(borderWidth / 2),
      Radius.circular(borderRadius),
    );
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth * 1.35
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        colors: [
          Colors.transparent,
          color,
          Colors.transparent,
        ],
        stops: const [0.0, 0.06, 0.14],
        transform: GradientRotation(rotation),
      ).createShader(rect);
    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant _ChasingSpotPainter oldDelegate) =>
      oldDelegate.rotation != rotation ||
      oldDelegate.color != color ||
      oldDelegate.borderWidth != borderWidth;
}
