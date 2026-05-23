import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:word_game/core/constants/asset_paths.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:word_game/injection.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
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
                AssetPaths.splashBg,
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
                      colors.scrim.withValues(alpha: 0.3),
                      colors.scrim.withValues(alpha: 0.55),
                    ],
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 180,
                      height: 180,
                      child: Lottie.asset(
                        AssetPaths.wordLogoLottie,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.travel_explore_rounded,
                          size: 120,
                          color: colors.onScenic.withValues(alpha: 0.95),
                        ),
                      ),
                    ).animate().fadeIn(duration: 800.ms).scale(
                          begin: const Offset(0.7, 0.7),
                          end: const Offset(1, 1),
                          curve: Curves.elasticOut,
                        ),
                    const SizedBox(height: 16),
                    Text('WORD SEARCH', style: AppTextStyles.gameTitle(context))
                        .animate(delay: 300.ms)
                        .fadeIn()
                        .slideY(begin: 0.3, end: 0),
                    Text(
                      'JOURNEY',
                      style: AppTextStyles.gameTitle(context).copyWith(
                        fontSize: 30,
                        color: colors.goldLight,
                        letterSpacing: 8,
                      ),
                    )
                        .animate(delay: 450.ms)
                        .fadeIn()
                        .shimmer(
                          duration: 2.seconds,
                          color: colors.onScenic.withValues(alpha: 0.25),
                        ),
                    const SizedBox(height: 8),
                    Text(
                      'Travel the world with words',
                      style: AppTextStyles.subtitle(context),
                    ).animate(delay: 600.ms).fadeIn(),
                    const SizedBox(height: 48),
                    SizedBox(
                      width: 220,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          minHeight: 6,
                          backgroundColor: colors.onScenicMuted,
                          valueColor: AlwaysStoppedAnimation(colors.gold),
                        ),
                      ),
                    ).animate(delay: 700.ms).fadeIn(),
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
