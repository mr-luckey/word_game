import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:word_game/core/constants/asset_paths.dart';
import 'package:word_game/core/theme/app_sizes.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/core/widgets/coin_display.dart';
import 'package:word_game/core/widgets/scenic_background.dart';
import 'package:word_game/features/wallet/presentation/cubit/coin_cubit.dart';

/// Shared scenic layout for secondary screens (settings, level select, etc.).
class ScenicPage extends StatelessWidget {
  const ScenicPage({
    super.key,
    required this.title,
    required this.child,
    this.backgroundAsset,
    this.showBack = true,
    this.showCoins = true,
    this.blurSigma = 1.5,
    this.darken = 0.4,
  });

  final String title;
  final Widget child;
  final String? backgroundAsset;
  final bool showBack;
  final bool showCoins;
  final double blurSigma;
  final double darken;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final bg = backgroundAsset ?? AssetPaths.themeSplash(context.themePreset);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: ScenicBackground(
        imageAsset: bg,
        blurSigma: blurSigma,
        darken: darken,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingSm,
                ),
                child: Row(
                  children: [
                    if (showBack)
                      IconButton(
                        icon: Icon(Icons.arrow_back_rounded, color: colors.onScenic),
                        onPressed: () {
                          if (context.canPop()) {
                            context.pop();
                          } else {
                            context.go('/home');
                          }
                        },
                      )
                    else
                      const SizedBox(width: 48),
                    Expanded(
                      child: Text(
                        title,
                        style: AppTextStyles.appBarTitle(context),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    if (showCoins)
                      BlocBuilder<CoinCubit, CoinState>(
                        builder: (context, state) =>
                            CoinDisplay(coins: state.coins, light: true),
                      )
                    else
                      const SizedBox(width: 48),
                  ],
                ),
              ),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}
