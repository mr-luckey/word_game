import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:word_game/core/constants/asset_paths.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:word_game/features/splash/presentation/widgets/world_tour_splash_content.dart';
import 'package:word_game/injection.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final preset = context.themePreset;
    return BlocProvider(
      create: (_) => getIt<SplashCubit>(),
      child: BlocListener<SplashCubit, SplashState>(
        listenWhen: (p, c) => c.status == SplashStatus.complete,
        listener: (context, state) => context.go('/home'),
        child: Scaffold(
          body: preset == AppThemePreset.worldTour
              ? const WorldTourSplashContent()
              : Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      AssetPaths.themeSplash(preset),
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => DecoratedBox(
                        decoration:
                            BoxDecoration(gradient: colors.primaryGradient),
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
                    SafeArea(
                      child: Column(
                        children: [
                          const Spacer(flex: 2),
                          Icon(
                            Icons.explore_rounded,
                            size: 80,
                            color: colors.gold,
                          )
                              .animate()
                              .fadeIn(duration: 700.ms)
                              .scale(
                                begin: const Offset(0.75, 0.75),
                                end: const Offset(1, 1),
                                curve: Curves.elasticOut,
                              ),
                          const SizedBox(height: 18),
                          Text(
                            'WORD SEARCH',
                            style: AppTextStyles.gameTitle(context).copyWith(
                              fontSize: 26,
                              letterSpacing: 4,
                              color: colors.gold,
                            ),
                          ).animate(delay: 250.ms).fadeIn(),
                          Text(
                            'JOURNEY',
                            style: AppTextStyles.gameTitle(context).copyWith(
                              fontSize: 28,
                              letterSpacing: 10,
                              color: colors.onScenic,
                            ),
                          ).animate(delay: 350.ms).fadeIn(),
                          const SizedBox(height: 6),
                          Text(
                            preset.subtitle,
                            style: AppTextStyles.gameSubtitle(context).copyWith(
                              letterSpacing: 3,
                              fontSize: 11,
                            ),
                          ).animate(delay: 450.ms).fadeIn(),
                          const Spacer(flex: 3),
                          BlocBuilder<SplashCubit, SplashState>(
                            builder: (context, state) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 40),
                                child: Column(
                                  children: [
                                    Text(
                                      preset.splashTagline,
                                      style: AppTextStyles.subtitle(context)
                                          .copyWith(
                                        fontSize: 13,
                                        fontStyle: FontStyle.italic,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 16),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(2),
                                      child: LinearProgressIndicator(
                                        value: state.progress,
                                        minHeight: 3,
                                        backgroundColor: colors.onScenicMuted
                                            .withValues(alpha: 0.35),
                                        valueColor: AlwaysStoppedAnimation(
                                            colors.gold),
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
                          const SizedBox(height: 36),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
