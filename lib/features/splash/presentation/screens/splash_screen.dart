import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:word_game/core/constants/asset_paths.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/core/widgets/app_logo.dart';
import 'package:word_game/core/widgets/journey_theme_kit.dart';
import 'package:word_game/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:word_game/injection.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final preset = context.themePreset;
    final spec = preset.homeSpec;
    return BlocProvider(
      create: (_) => getIt<SplashCubit>(),
      child: BlocListener<SplashCubit, SplashState>(
        listenWhen: (p, c) => c.status == SplashStatus.complete,
        listener: (context, state) => context.go('/home'),
        child: Scaffold(
          body: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                AssetPaths.themeSplash(preset),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => DecoratedBox(
                  decoration: BoxDecoration(gradient: colors.primaryGradient),
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      colors.scrim.withValues(alpha: 0.25),
                      colors.scrim.withValues(alpha: 0.7),
                    ],
                  ),
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 0.82,
                    colors: [
                      spec.playButtonGlow.withValues(alpha: 0.2),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              SafeArea(
                child: JourneyContentWidth(
                  child: Padding(
                    padding: JourneyThemeKit.pagePadding(context),
                    child: Column(
                      children: [
                        const Spacer(flex: 2),
                        AppLogo(size: 156, borderRadius: 28, elevation: 12)
                            .animate()
                            .fadeIn(duration: 700.ms)
                            .scale(
                              begin: const Offset(0.75, 0.75),
                              end: const Offset(1, 1),
                              curve: Curves.elasticOut,
                            ),
                        const SizedBox(height: 20),
                        Text(
                          'WORD',
                          style: GoogleFonts.cinzel(
                            fontSize: 32,
                            height: 0.98,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2,
                            color: colors.onScenic,
                            shadows: JourneyThemeKit.textGlow(context),
                          ),
                        ).animate(delay: 200.ms).fadeIn(),
                        Text(
                          'SEARCH',
                          style: GoogleFonts.cinzel(
                            fontSize: 32,
                            height: 0.98,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2,
                            color: colors.onScenic,
                            shadows: JourneyThemeKit.textGlow(context),
                          ),
                        ).animate(delay: 280.ms).fadeIn(),
                        Text(
                          'JOURNEY',
                          style: GoogleFonts.cinzel(
                            fontSize: 32,
                            height: 1.05,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 3,
                            color: colors.onScenic,
                            shadows: JourneyThemeKit.textGlow(context),
                          ),
                        ).animate(delay: 360.ms).fadeIn(),
                        const SizedBox(height: 10),
                        Text(
                          '${preset.label.toUpperCase()} THEME',
                          style: AppTextStyles.gameSubtitle(context).copyWith(
                            color: spec.taglineColor,
                            letterSpacing: 4,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ).animate(delay: 450.ms).fadeIn(),
                        const Spacer(flex: 3),
                        BlocBuilder<SplashCubit, SplashState>(
                          builder: (context, state) {
                            return JourneyPanel(
                              padding:
                                  const EdgeInsets.fromLTRB(18, 14, 18, 16),
                              radius: 20,
                              child: Column(
                                children: [
                                  Text(
                                    preset.splashTagline,
                                    style: AppTextStyles.subtitle(context)
                                        .copyWith(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: colors.onScenic,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 14),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: LinearProgressIndicator(
                                      value: state.progress,
                                      minHeight: 7,
                                      backgroundColor: colors.onScenicMuted
                                          .withValues(alpha: 0.24),
                                      valueColor: AlwaysStoppedAnimation(
                                          spec.playButtonGlow),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${state.progressPercent}%',
                                    style: AppTextStyles.coinsScore(context)
                                        .copyWith(
                                      color: colors.onScenic,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 28),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
