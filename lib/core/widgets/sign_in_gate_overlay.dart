import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/features/auth/presentation/widgets/auth_sheet.dart';

/// Blurred overlay prompting sign-in to view profile content.
class SignInGateOverlay extends StatelessWidget {
  const SignInGateOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final spec = context.themePreset.homeSpec;

    return Positioned.fill(
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colors.scrim.withValues(alpha: 0.55),
            ),
            child: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 16,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight - 32,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colors.glassSurface,
                              border: Border.all(color: colors.gold, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: spec.playButtonGlow
                                      .withValues(alpha: 0.35),
                                  blurRadius: 18,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.lock_person_rounded,
                              color: colors.gold,
                              size: 36,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Sign in to view profile',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.cinzel(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: colors.onScenic,
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Play as a guest — progress saves on this device. Sign in or create an account to sync coins & levels to the cloud and join the ranking.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              fontSize: 13,
                              height: 1.45,
                              color: colors.onScenicMuted,
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              onPressed: () => showAuthSheet(
                                context,
                                initialMode: AuthSheetMode.login,
                              ),
                              icon: const Icon(Icons.login_rounded),
                              label: const Text('LOG IN'),
                              style: FilledButton.styleFrom(
                                backgroundColor: colors.gold,
                                foregroundColor: colors.scrim,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () => showAuthSheet(
                                context,
                                initialMode: AuthSheetMode.signUp,
                              ),
                              icon: const Icon(Icons.person_add_alt_1_rounded),
                              label: const Text('CREATE ACCOUNT'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: colors.onScenic,
                                side: BorderSide(color: colors.glassBorder),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 13),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 350.ms);
  }
}
