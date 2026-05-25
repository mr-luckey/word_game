import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:word_game/core/constants/asset_paths.dart';
import 'package:word_game/features/home/presentation/widgets/world_tour/world_tour_branding.dart';

/// Current journey card — matches World Tour home mockup.
class WorldTourJourneyCard extends StatelessWidget {
  const WorldTourJourneyCard({
    super.key,
    required this.title,
    required this.level,
    required this.completed,
    required this.total,
    required this.onContinue,
  });

  final String title;
  final int level;
  final int completed;
  final int total;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final pct = total > 0 ? ((completed / total) * 100).round() : 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Material(
        color: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: SizedBox(
            height: 420,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  AssetPaths.worldTourHomeCardBg,
                  fit: BoxFit.cover,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
                      child: _CurrentJourneyBadge(),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: GoogleFonts.cinzel(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: WorldTourBranding.titleBlue,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Level $level',
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: WorldTourBranding.accentBlue,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _PathDots(),
                        ],
                      ),
                    ),
                    const Spacer(),
                    _ProgressPanel(
                      completed: completed,
                      total: total,
                      pct: pct,
                      onContinue: onContinue,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CurrentJourneyBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF2B6CB0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.location_on_rounded, size: 14, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            'CURRENT JOURNEY',
            style: GoogleFonts.montserrat(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

class _PathDots extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.circle, size: 6, color: WorldTourBranding.accentBlue),
        ...List.generate(
          4,
          (_) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Icon(
              Icons.circle,
              size: 4,
              color: WorldTourBranding.accentBlue.withValues(alpha: 0.45),
            ),
          ),
        ),
        Icon(
          Icons.close_rounded,
          size: 12,
          color: WorldTourBranding.titleBlue.withValues(alpha: 0.7),
        ),
      ],
    );
  }
}

class _ProgressPanel extends StatelessWidget {
  const _ProgressPanel({
    required this.completed,
    required this.total,
    required this.pct,
    required this.onContinue,
  });

  final int completed;
  final int total;
  final int pct;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF1B3A6E).withValues(alpha: 0.92),
            const Color(0xFF0D2347).withValues(alpha: 0.96),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Progress',
            style: GoogleFonts.montserrat(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: total > 0 ? completed / total : 0,
                    minHeight: 8,
                    backgroundColor: Colors.white.withValues(alpha: 0.25),
                    valueColor: const AlwaysStoppedAnimation(Color(0xFFFFC107)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '$pct%',
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.star_rounded, size: 14, color: Color(0xFFFFC107)),
              const SizedBox(width: 6),
              Text(
                '$completed/$total Levels Completed',
                style: GoogleFonts.montserrat(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.95),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFFFE566), Color(0xFFFFC107), Color(0xFFE6A800)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFC107).withValues(alpha: 0.45),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onContinue,
                  borderRadius: BorderRadius.circular(14),
                  child: Center(
                    child: Text(
                      'Continue Journey  >',
                      style: GoogleFonts.montserrat(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: WorldTourBranding.titleBlue,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
