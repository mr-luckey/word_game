import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:word_game/core/theme/app_sizes.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/core/widgets/gradient_button.dart';
import 'package:word_game/core/widgets/journey_theme_kit.dart';
import 'package:word_game/features/game/presentation/bloc/game_state.dart';

class GameTimeoutOverlay extends StatelessWidget {
  const GameTimeoutOverlay({
    super.key,
    required this.state,
    required this.onRetry,
    required this.onQuit,
  });

  final GameInProgress state;
  final VoidCallback onRetry;
  final VoidCallback onQuit;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final found = state.foundWords.length;
    final total = state.wordsToFind.length;

    return Material(
      color: colors.scrim.withValues(alpha: 0.78),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: SafeArea(
          child: JourneyContentWidth(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingLg),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.timer_off_rounded,
                    size: 72,
                    color: colors.timerDanger,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "TIME'S UP!",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cinzel(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: colors.onScenic,
                      shadows: JourneyThemeKit.textGlow(context),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Level ${state.levelId}',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: colors.onScenicMuted,
                    ),
                  ),
                  const SizedBox(height: 20),
                  JourneyPanel(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: Text(
                      'Words found: $found / $total',
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: colors.onScenic,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  GradientButton(
                    label: 'Try Again',
                    onPressed: onRetry,
                    icon: Icons.refresh_rounded,
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: onQuit,
                    child: Text(
                      'Back to levels',
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: colors.onScenicMuted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
