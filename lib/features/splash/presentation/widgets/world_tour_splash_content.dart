import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:word_game/core/constants/asset_paths.dart';
import 'package:word_game/features/home/presentation/widgets/world_tour/world_tour_branding.dart';
import 'package:word_game/features/splash/presentation/cubit/splash_cubit.dart';

/// Splash layout for [AppThemePreset.worldTour] — matches design world tour mockup.
class WorldTourSplashContent extends StatelessWidget {
  const WorldTourSplashContent({super.key});

  static const _gold = Color(0xFFFFC107);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          AssetPaths.worldTourSplashBg,
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
        SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 28),
              const WorldTourBranding()
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .scale(
                    begin: const Offset(0.85, 0.85),
                    end: const Offset(1, 1),
                    curve: Curves.easeOutBack,
                  ),
              const Spacer(),
              BlocBuilder<SplashCubit, SplashState>(
                builder: (context, state) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(48, 0, 48, 36),
                    child: Column(
                      children: [
                        Text(
                          'Exploring the world, one word at a time...',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w500,
                            color: WorldTourBranding.titleBlue
                                .withValues(alpha: 0.9),
                          ),
                        ),
                        const SizedBox(height: 14),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: SizedBox(
                            height: 6,
                            child: LinearProgressIndicator(
                              value: state.progress,
                              backgroundColor: WorldTourBranding.titleBlue
                                  .withValues(alpha: 0.15),
                              valueColor: const AlwaysStoppedAnimation(_gold),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${state.progressPercent}%',
                          style: GoogleFonts.montserrat(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: WorldTourBranding.titleBlue,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
