import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:word_game/core/constants/asset_paths.dart';
import 'package:word_game/core/theme/app_colors.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:word_game/injection.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                errorBuilder: (_, __, ___) => Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.darkNavy,
                        AppColors.primaryBlue,
                        AppColors.oceanBlue,
                      ],
                    ),
                  ),
                ),
              ),
              Container(color: Colors.black.withValues(alpha: 0.45)),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 160,
                      height: 160,
                      child: Lottie.asset(
                        AssetPaths.wordLogoLottie,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.travel_explore,
                          size: 120,
                          color: Colors.white.withValues(alpha: 0.95),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text('WORD SEARCH JOURNEY', style: AppTextStyles.gameTitle),
                    const SizedBox(height: 8),
                    Text('Travel the world with words', style: AppTextStyles.subtitle),
                    const SizedBox(height: 48),
                    SizedBox(
                      width: 200,
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.white24,
                        valueColor: const AlwaysStoppedAnimation(AppColors.oceanBlue),
                      ),
                    ),
                  ],
                ),
              ),
              const Positioned(
                bottom: 32,
                left: 0,
                right: 0,
                child: Text(
                  'Word Search Journey Clone',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
