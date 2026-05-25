import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Shared compass + title block for World Tour splash and home.
class WorldTourBranding extends StatelessWidget {
  const WorldTourBranding({
    super.key,
    this.showSubtitle = true,
    this.compact = false,
  });

  final bool showSubtitle;
  final bool compact;

  static const titleBlue = Color(0xFF1B3A6E);
  static const accentBlue = Color(0xFF4A90D9);

  @override
  Widget build(BuildContext context) {
    final titleSize = compact ? 20.0 : 22.0;
    final journeySize = compact ? 24.0 : 26.0;

    return Column(
      children: [
        const WorldTourCompassLogo(),
        SizedBox(height: compact ? 10 : 14),
        Text(
          'WORD SEARCH',
          textAlign: TextAlign.center,
          style: GoogleFonts.cinzel(
            fontSize: titleSize,
            fontWeight: FontWeight.w700,
            color: titleBlue,
            letterSpacing: 2.5,
            height: 1.1,
          ),
        ),
        Text(
          'JOURNEY',
          textAlign: TextAlign.center,
          style: GoogleFonts.cinzel(
            fontSize: journeySize,
            fontWeight: FontWeight.w800,
            color: titleBlue,
            letterSpacing: 4,
            height: 1.05,
          ),
        ),
        if (showSubtitle) ...[
          const SizedBox(height: 6),
          Text(
            'WORLD TOUR',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: accentBlue,
              letterSpacing: 4,
            ),
          ),
        ],
      ],
    );
  }
}

class WorldTourCompassLogo extends StatelessWidget {
  const WorldTourCompassLogo({super.key});

  static const _gold = Color(0xFFFFC107);
  static const _goldDark = Color(0xFFE6A800);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 76,
      height: 76,
      child: CustomPaint(
        painter: _CompassRosePainter(),
        child: const Center(
          child: Icon(
            Icons.explore_rounded,
            size: 22,
            color: WorldTourBranding.titleBlue,
          ),
        ),
      ),
    );
  }
}

class _CompassRosePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final fill = Paint()
      ..color = WorldTourCompassLogo._gold
      ..style = PaintingStyle.fill;
    final stroke = Paint()
      ..color = WorldTourCompassLogo._goldDark
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawCircle(center, size.width * 0.36, stroke);

    for (var i = 0; i < 8; i++) {
      final angle = i * math.pi / 4;
      final long = i.isEven;
      final length = size.width * (long ? 0.34 : 0.2);
      final width = size.width * (long ? 0.11 : 0.07);
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(angle);
      final path = Path()
        ..moveTo(0, -length)
        ..lineTo(-width, 10)
        ..lineTo(width, 10)
        ..close();
      canvas.drawPath(path, fill);
      canvas.drawPath(path, stroke);
      canvas.restore();
    }

    canvas.drawCircle(center, 7, fill);
    canvas.drawCircle(center, 7, stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
