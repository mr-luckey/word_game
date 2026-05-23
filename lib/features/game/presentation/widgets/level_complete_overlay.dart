import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:word_game/core/services/ad_service.dart';
import 'package:word_game/core/theme/app_colors.dart';
import 'package:word_game/core/theme/app_sizes.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/core/widgets/gradient_button.dart';
import 'package:word_game/features/wallet/presentation/cubit/coin_cubit.dart';
import 'package:word_game/injection.dart';

class LevelCompleteOverlay extends StatelessWidget {
  const LevelCompleteOverlay({
    super.key,
    required this.stars,
    required this.coinsEarned,
    required this.time,
    required this.hintsUsed,
    required this.levelId,
    this.wordsFound,
    this.wordsTotal,
  });

  final int stars;
  final int coinsEarned;
  final Duration time;
  final int hintsUsed;
  final int levelId;
  final int? wordsFound;
  final int? wordsTotal;

  String _formatTime(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(AppSizes.paddingMd),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingLg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('LEVEL COMPLETE!', style: AppTextStyles.levelName),
              const SizedBox(height: AppSizes.paddingMd),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) {
                  return Icon(
                    i < stars ? Icons.star : Icons.star_border,
                    color: AppColors.gold,
                    size: 40,
                  );
                }),
              ),
              const SizedBox(height: AppSizes.paddingMd),
              Text('Time: ${_formatTime(time)}', style: AppTextStyles.wordList),
              if (wordsTotal != null)
                Text(
                  'Words: ${wordsFound ?? wordsTotal}/$wordsTotal',
                  style: AppTextStyles.wordList,
                ),
              Text('Hints: $hintsUsed used', style: AppTextStyles.wordList),
              const SizedBox(height: AppSizes.paddingMd),
              Text('+ $coinsEarned coins', style: AppTextStyles.coinsScore),
              const SizedBox(height: AppSizes.paddingMd),
              OutlinedButton(
                onPressed: () async {
                  final ad = getIt<AdService>();
                  await ad.showRewardedAd(
                    onReward: (bonus) {
                      context.read<CoinCubit>().add(bonus + coinsEarned);
                    },
                    onFail: () {},
                  );
                },
                child: const Text('Watch ad for 2x coins'),
              ),
              const SizedBox(height: AppSizes.paddingMd),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        context.go('/home');
                      },
                      child: const Text('Home'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        context.pushReplacement('/game?levelId=$levelId');
                      },
                      child: const Text('Replay'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GradientButton(
                      label: 'Next',
                      expanded: true,
                      onPressed: () {
                        Navigator.of(context).pop();
                        context.pushReplacement(
                          '/game?levelId=${levelId + 1}',
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
